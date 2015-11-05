//
//  SHBFundDrawingApplySecurityCardViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundDrawingApplySecurityCardViewController.h"
#import "SHBFundDrawingApplyCompleteViewController.h"
#import "SHBFundService.h"

@interface SHBFundDrawingApplySecurityCardViewController ()

@end

@implementation SHBFundDrawingApplySecurityCardViewController

@synthesize data_D6020, data_D6010;
@synthesize dicDataDictionary;
@synthesize basicLabel01;
@synthesize basicLabel02;
@synthesize basicLabel03;
@synthesize basicLabel04;
@synthesize basicLabel05;
@synthesize basicLabel06;
@synthesize basicLabel07;
@synthesize basicLabel08;
@synthesize basicLabel09;

- (void)displayData
{
//    basicLabel01.text = [data_D6010 objectForKey:@"계좌명"];
    // 신구 계좌에 따른 차이로 값 셋팅하여 들어온다
    basicLabel02.text = [data_D6010 objectForKey:@"계좌번호표시"];
    basicLabel03.text = [data_D6020 objectForKey:@"거래일자"];
    basicLabel04.text = [data_D6020 objectForKey:@"거래번호"];
    basicLabel05.text = [data_D6020 objectForKey:@"거래종류"];
    
    if ([[data_D6010 objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel06.text = [[data_D6020 objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[data_D6020 objectForKey:@"거래금액"] rangeOfString:@"."].location)];
    } else {
        basicLabel06.text = [data_D6020 objectForKey:@"거래금액"];
    }

//    basicLabel06.text = [data_D6020 objectForKey:@"거래금액"];
    basicLabel07.text = [data_D6020 objectForKey:@"연동상대계좌번호"];
    basicLabel08.text = [data_D6020 objectForKey:@"신청일자"];
    basicLabel09.text = [data_D6020 objectForKey:@"처리예정일자"];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [data_D6010 release], data_D6010 = nil;
    [data_D6020 release], data_D6020 = nil;
    dicDataDictionary = nil;
    
    secretOTPViewController = nil;
    secretCardViewController = nil;
    
    _encriptedPassword = nil;
    _encriptedNumber1 = nil;
    _encriptedNumber2 = nil;
    
    [basicLabel01 release], basicLabel01 = nil;
    [basicLabel02 release], basicLabel02 = nil;
    [basicLabel03 release], basicLabel03 = nil;
    [basicLabel04 release], basicLabel04 = nil;
    [basicLabel05 release], basicLabel05 = nil;
    [basicLabel06 release], basicLabel06 = nil;
    [basicLabel07 release], basicLabel07 = nil;
    [basicLabel08 release], basicLabel08 = nil;
    [basicLabel09 release], basicLabel09 = nil;
    [_infoLabel release];
    
    [_fundTickerName release];
    [_mainScrollView release];
    [_mainView release];
    [_securityView release];
    [_infoView release];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];

    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"펀드조회";
    self.strBackButtonTitle = @"펀드출금예약 1단계";
    
    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    if ([secutryType intValue] == 1 || [secutryType intValue] == 2 ||
        [secutryType intValue] == 3 || [secutryType intValue] == 4) {
        secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        secretCardViewController.targetViewController = self;
        
        [secretCardViewController setDelegate:self];
        secretCardViewController.nextSVC = @"D6360";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretCardViewController.view.bounds.size.height + 70)];
        
        [secretCardViewController.okButton setFrame:CGRectMake(64.0f, 40.0f, 94.0f, 29.0f)];
        [secretCardViewController.cancelButton setFrame:CGRectMake(164.0f, 40.0f, 94.0f, 29.0f)];

        [secretCardViewController.okButton setTitle:@"예" forState:UIControlStateNormal];
        [secretCardViewController.cancelButton setTitle:@"아니오" forState:UIControlStateNormal];

        [_securityView addSubview:secretCardViewController.view];
        
        secretCardViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretCardViewController.view setFrame:CGRectMake(0,
                                                           1,
                                                           secretCardViewController.view.bounds.size.width,
                                                           secretCardViewController.view.bounds.size.height)];
        [secretCardViewController setMediaCode:[secutryType intValue] previousData:nil];
        [_infoLabel setFrame:CGRectMake(79.0f, 187.0f, 160.0f, 15.0f)];
        _infoLabel.textColor = RGB(74, 74, 74);

        [_securityView setFrame:CGRectMake(0.0f, _infoView.frame.size.height+2, 317.0f, 270.0f)];
    }
    else if ([secutryType intValue] == 5) { // OTP
        secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        secretOTPViewController.targetViewController = self;
        [secretOTPViewController setDelegate:self];
        secretOTPViewController.nextSVC = @"D6360";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretOTPViewController.view.bounds.size.height + 70)];

        [secretOTPViewController.okButton setFrame:CGRectMake(64.0f, 50.0f, 94.0f, 29.0f)];
        [secretOTPViewController.cancelButton setFrame:CGRectMake(164.0f, 50.0f, 94.0f, 29.0f)];
        
        [secretOTPViewController.okButton setTitle:@"예" forState:UIControlStateNormal];
        [secretOTPViewController.cancelButton setTitle:@"아니오" forState:UIControlStateNormal];

        [_securityView addSubview:secretOTPViewController.view];
        
        secretOTPViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretOTPViewController.view setFrame:CGRectMake(0,
                                                          1,
                                                          secretOTPViewController.view.bounds.size.width,
                                                          secretOTPViewController.view.bounds.size.height)];
        [_infoLabel setFrame:CGRectMake(79.0f, 100.0f, 160.0f, 15.0f)];
        _infoLabel.textColor = RGB(74, 74, 74);

        [_securityView setFrame:CGRectMake(0.0f, _infoView.frame.size.height+2, 317.0f, 250.0f)];
    }
    
//    [_securityView setFrame:CGRectMake(0.0f, _infoView.frame.size.height+2, 317.0f, 250.0f)];
    [_mainView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _infoView.frame.size.height + _securityView.frame.size.height)];
    //    [_mainScrollView setFrame:CGRectMake(0.0f, 44.0f+23.0f, 317.0f, _infoView.frame.size.height + _securityView.frame.size.height)];
    //    [_mainScrollView setContentSize:_mainView.frame.size];
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;
    
    // Scroll Label
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[data_D6010 objectForKey:@"계좌명"]];

    dicDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    [self displayData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    NSString *tempStr1;
    
    if([[data_D6010 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
    {
        tempStr1 = [[data_D6010 objectForKey:@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    else
    {
        tempStr1 = [[data_D6010 objectForKey:@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    [dicDataDictionary setObject:[data_D6010 objectForKey:@"계좌명"] forKey:@"펀드명"];
    [dicDataDictionary setObject:tempStr1 forKey:@"계좌번호"];
    
    
    [self.dicDataDictionary setObject:[data_D6010 objectForKey:@"COM_TRAN_DATE"] forKey:@"거래일자"];
    [self.dicDataDictionary setObject:[data_D6020 objectForKey:@"거래번호"] forKey:@"거래번호"];
    [self.dicDataDictionary setObject:[data_D6020 objectForKey:@"거래종류"] forKey:@"거래종류"];
    [self.dicDataDictionary setObject:[data_D6020 objectForKey:@"거래금액"] forKey:@"출금신청금액"];
    [self.dicDataDictionary setObject:[data_D6020 objectForKey:@"처리예정일자"] forKey:@"출금취소일자"];
    
//    [dicDataDictionary setObject:notification.userInfo[@"거래일자"] forKey:@"거래일자"];
//    [dicDataDictionary setObject:notification.userInfo[@"거래번호"] forKey:@"거래번호"];
//    [dicDataDictionary setObject:notification.userInfo[@"거래종류"] forKey:@"거래종류"];
////    [dicDataDictionary setObject:[data_D6020 objectForKey:@"연동상대계좌번호"] forKey:@"출금계좌번호"];
//    [dicDataDictionary setObject:notification.userInfo[@"거래금액"] forKey:@"출금신청금액"];
//    [dicDataDictionary setObject:[data_D6020 objectForKey:@"COM_TRAN_DATE"] forKey:@"출금취소일자"];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    SHBFundDrawingApplyCompleteViewController *detailViewController = [[SHBFundDrawingApplyCompleteViewController alloc] initWithNibName:@"SHBFundDrawingApplyCompleteViewController" bundle:nil];
    
    detailViewController.dicDataDictionary = dicDataDictionary;
    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
}

- (void)getElectronicSignCancel
{
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
    
}

#pragma mark - SHBSecretMedia
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@", confirmData);
    NSLog(@"confirmSecretResult:%i", confirm);
    NSLog(@"confirmSecretMedia:%i", mediaType);
    
    if (confirm) {
        NSString *tempStr1;
        
        if([[data_D6010 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
        {
            tempStr1 = [[data_D6010 objectForKey:@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        else
        {
            tempStr1 = [[data_D6010 objectForKey:@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        
        AppInfo.electronicSignString = @"";
        
        // 타이틀
        AppInfo.eSignNVBarTitle = @"편드조회";
        AppInfo.electronicSignCode = @"D6360";
        AppInfo.electronicSignTitle = @"지급예약 취소";
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)펀드명 : %@", [data_D6010 objectForKey:@"계좌명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)계좌번호 : %@", tempStr1]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)거래일자 : %@", [data_D6010 objectForKey:@"COM_TRAN_DATE"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)거래번호 : %@", [data_D6020 objectForKey:@"거래번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)거래종류 : %@", [data_D6020 objectForKey:@"거래종류"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)출금신청금액 : %@", [data_D6020 objectForKey:@"거래금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)출금취소일자 : %@", [data_D6020 objectForKey:@"처리예정일자"]]];
        
        // D6360 입금취소신청 전문
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"1",
                                @"은행구분" : @"1",
                                @"계좌번호" : tempStr1,
                                @"거래번호" : [data_D6020 objectForKey:@"거래번호"],
                                @"거래일자" : [data_D6020 objectForKey:@"거래일자"],
                                @"거래금액" : [data_D6020 objectForKey:@"거래금액"],
                                @"거래종류" : [data_D6020 objectForKey:@"거래종류"],
                                @"업무구분" : @"61",
                                @"거래구분코드," : @"6111",
                                }] autorelease];
        
        self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DRAWING_CANCEL
                                                   viewController:self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    } else {
        
    }
}

- (void) cancelSecretMedia
{
    [self.navigationController fadePopViewController];
}
@end
