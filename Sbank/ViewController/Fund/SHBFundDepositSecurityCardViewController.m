//
//  SHBFundDepositSecurityCardViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBFundDepositSecurityCardViewController.h"
#import "SHBFundDepositCompleteViewController.h"
#import "SHBFundService.h"

@interface SHBFundDepositSecurityCardViewController ()

@end

@implementation SHBFundDepositSecurityCardViewController

@synthesize accountNo;
@synthesize depositAccountNo;
@synthesize transMoney;
@synthesize dicDataDictionary;
@synthesize basicInfo;
@synthesize fundInfo;
@synthesize accountName, accountNumber, depositAcc, depositMoney, buyStandardDay, buySchDay;

- (void)resetFormPosition
{
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [accountNo release], accountNo = nil;
    [depositAccountNo release], depositAccountNo = nil;
    [transMoney release], transMoney = nil;
    [basicInfo release], basicInfo = nil;
    [fundInfo release], fundInfo = nil;
    dicDataDictionary = nil;
    
    accountName = nil;
    accountNumber = nil;
    depositAcc = nil;
    depositMoney = nil;
    buyStandardDay = nil;
    buySchDay = nil;
    secretOTPViewController = nil;
    secretCardViewController = nil;
    
//    self.exchangeDataInfo = nil;
    _encriptedPassword = nil;
    _encriptedNumber1 = nil;
    _encriptedNumber2 = nil;
    
    [_mainScrollView release];
    [_mainView release];
    [_securityView release];
    [_infoView release];
    [_data_D6230 release];

    [_fundTickerName release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];

    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFormPosition) name:@"secureMediaKeyPadClose" object:nil];

    [super viewDidLoad];

    self.title = @"펀드입금";
    self.strBackButtonTitle = @"펀드입금 3단계";

    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    if ([secutryType intValue] == 1 || [secutryType intValue] == 2 ||
        [secutryType intValue] == 3 || [secutryType intValue] == 4) {
        secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        secretCardViewController.targetViewController = self;
        
        [secretCardViewController setDelegate:self];
        secretCardViewController.nextSVC = @"D6230";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretCardViewController.view.bounds.size.height + 70)];
        
        [_securityView addSubview:secretCardViewController.view];
        
        secretCardViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretCardViewController.view setFrame:CGRectMake(0,
                                                            1,
                                                            secretCardViewController.view.bounds.size.width,
                                                            secretCardViewController.view.bounds.size.height)];
        [secretCardViewController setMediaCode:[secutryType intValue] previousData:nil];
    }
    else if ([secutryType intValue] == 5) { // OTP
        secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        secretOTPViewController.targetViewController = self;
        [secretOTPViewController setDelegate:self];
        secretOTPViewController.nextSVC = @"D6230";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretCardViewController.view.bounds.size.height + 70)];
        
        [_securityView addSubview:secretOTPViewController.view];
        
        secretOTPViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretOTPViewController.view setFrame:CGRectMake(0,
                                                           1,
                                                           secretOTPViewController.view.bounds.size.width,
                                                           secretOTPViewController.view.bounds.size.height)];
    }
    
    [_securityView setFrame:CGRectMake(0.0f, _infoView.frame.size.height+2, 317.0f, 250.0f)];
    [_mainView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _infoView.frame.size.height + _securityView.frame.size.height)];
    
    [_mainScrollView setContentSize:_mainView.frame.size];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;
    
    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[basicInfo objectForKey:@"펀드명"]];

//    accountName.text = [basicInfo objectForKey:@"펀드명"];
    accountNumber.text = [dicDataDictionary objectForKey:@"출금계좌번호"];
    // 실제 입금계좌번호와 표시되는 게 다르다
    depositAcc.text = [dicDataDictionary objectForKey:@"표시입금계좌번호"];
    depositMoney.text = [NSString stringWithFormat:@"%@원", [dicDataDictionary objectForKey:@"납부금액"]];
    buyStandardDay.text = [basicInfo objectForKey:@"매입기준가일"];
    buySchDay.text = [basicInfo objectForKey:@"매입예정일자"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
//    NSLog(@"controlles1:%@",[self.navigationController viewControllers]);
    [dicDataDictionary setObject:notification.userInfo[@"펀드명"] forKey:@"펀드명"];
    [dicDataDictionary setObject:notification.userInfo[@"계좌번호"] forKey:@"계좌번호"];
    [dicDataDictionary setObject:notification.userInfo[@"출금계좌번호"] forKey:@"출금계좌번호"];
    [dicDataDictionary setObject:notification.userInfo[@"신청일자"] forKey:@"신청일자"];
    [dicDataDictionary setObject:notification.userInfo[@"입금방식"] forKey:@"입금방식"];
    [dicDataDictionary setObject:notification.userInfo[@"처리예정일자"] forKey:@"처리예정일자"];
    [dicDataDictionary setObject:notification.userInfo[@"예약금액"] forKey:@"예약금액"];
    [dicDataDictionary setObject:notification.userInfo[@"거래좌수"] forKey:@"거래좌수"];
    [dicDataDictionary setObject:notification.userInfo[@"거래기준가"] forKey:@"거래기준가"];
    [dicDataDictionary setObject:notification.userInfo[@"잔고좌수"] forKey:@"잔고좌수"];
    [dicDataDictionary setObject:notification.userInfo[@"평가금액"] forKey:@"평가금액"];
    [dicDataDictionary setObject:[basicInfo objectForKey:@"매입기준가일"] forKey:@"매입기준가일"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    SHBFundDepositCompleteViewController *detailViewController = [[SHBFundDepositCompleteViewController alloc] initWithNibName:@"SHBFundDepositCompleteViewController" bundle:nil];
    
    detailViewController.dicDataDictionary = dicDataDictionary;
//    detailViewController.data_D6230 = _data_D6230;
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];

}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonReceived" object:nil];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

- (void)setSignData
{
    
}

#pragma mark - TextField
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    [self.contentScrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - SHBSecretMedia
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@", confirmData);
    NSLog(@"confirmSecretResult:%i", confirm);
    NSLog(@"confirmSecretMedia:%i", mediaType);
    
    if (confirm) {
        NSString *tempStr1;
        NSString *tempStr2;
        NSString *tempStr3 = @"";
        
        if([[basicInfo objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
        {
            tempStr1 = [basicInfo objectForKey:@"구계좌번호"];
            tempStr2 = [basicInfo objectForKey:@"은행구분"];
        }
        else
        {
            tempStr1 = [basicInfo objectForKey:@"계좌번호"];
            tempStr2 = @"1";
        }

        AppInfo.electronicSignString = @"";
        
        // code & 타이틀
        AppInfo.eSignNVBarTitle = @"펀드입금";
        AppInfo.electronicSignCode = @"D6230";
        AppInfo.electronicSignTitle = @"펀드입금 신청";
        
        // 전자서명 내용 작성
//        [AppInfo addElectronicSign:@"펀드입금 신청"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", [dicDataDictionary objectForKey:@"COM_TRAN_DATE"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", [dicDataDictionary objectForKey:@"COM_TRAN_TIME"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)펀드계좌번호: %@", tempStr1]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)신청금액: %@원", [dicDataDictionary objectForKey:@"납부금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)펀드명: %@", [basicInfo objectForKey:@"펀드명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)출금계좌번호: %@", [dicDataDictionary objectForKey:@"출금계좌번호"]]];

        // 출금계좌에 해당하는 은행코드 취드
        NSArray *arr = [self outAccountList];
        
        for(int i = 0; i < [arr count]; i ++)
        {
            if ([[[arr objectAtIndex:i] objectForKey:@"출금계좌번호"] isEqualToString:[dicDataDictionary objectForKey:@"출금계좌번호"]])
            {
                tempStr3 = @"1";
                break;
            }
            else if([[[arr objectAtIndex:i] objectForKey:@"구출금계좌번호"] isEqualToString:[dicDataDictionary objectForKey:@"출금계좌번호"]])
            {
                tempStr3 = [[arr objectAtIndex:i] objectForKey:@"은행코드"];
                break;
            }
        }

        // D6230 전자서명 완료후 실행할 전문
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                  @{
                                  @"입금계좌번호" : tempStr1,
                                  @"입금은행구분" : tempStr2,
                                  @"입금계좌번호" : @"",
                                  @"입금은행구분" : @"",
                                  @"납부금액"    : [dicDataDictionary objectForKey:@"납부금액"],
                                  @"납부금액"    : @"",
                                  @"입금구분"    : @"291",
                                  @"출금계좌번호" : [[dicDataDictionary objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                  @"출금은행구분" : tempStr3,
                                  @"출금계좌비밀번호" : [dicDataDictionary objectForKey:@"출금계좌비밀번호"],
                                @"LT거래여부"  : [basicInfo objectForKey:@"엘티거래"],
                                  @"LT승인번호"  : @"",
                                  }] autorelease];
        self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DEPOSIT_INPUT
                                                       viewController:self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
        
    } else {

    }

}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonReceived" object:nil];
    
    [self.navigationController fadePopViewController];
}
@end
