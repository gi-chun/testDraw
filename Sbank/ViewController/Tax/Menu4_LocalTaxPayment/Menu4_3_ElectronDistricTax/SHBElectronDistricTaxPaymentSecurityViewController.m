//
//  SHBElectronDistricTaxPaymentSecurityViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 7..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBElectronDistricTaxPaymentSecurityViewController.h"
#import "SHBGiroTaxListService.h"                   // 지로 지방세 서비스
#import "SHBElectronDistricTaxCompleteViewController.h"         // 다음 view


@interface SHBElectronDistricTaxPaymentSecurityViewController ()

@end

@implementation SHBElectronDistricTaxPaymentSecurityViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Private Method

- (void)setSecretView
{
    // 보안관련
    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    if ([secutryType intValue] == 1 || [secutryType intValue] == 2 || [secutryType intValue] == 3 || [secutryType intValue] == 4)
    {           //보안카드
        
        secretcardView = [[[SHBSecretCardViewController alloc] init] autorelease];
        secretcardView.targetViewController = self;
        secretcardView.nextSVC = @"G1414"; // 130819, 보안카드 사고예방 방어코드
        
        [secretcardView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretcardView.view.bounds.size.height)];
        [secretView setFrame:CGRectMake(secretView.frame.origin.x, secretView.frame.origin.y, secretcardView.view.frame.size.width, secretcardView.view.frame.size.height)];
        [secretView addSubview:secretcardView.view];
        secretcardView.selfPosY = secretView.frame.origin.y;
        
        /* previousData는 이전 전문 파싱값을 넘겨줄 필요가 있을때 넘겨준다
         연속적으로 이체할때 보안 카드 확인값이 변경되므로 값을 알아야됨 - 아직 미구현
         */
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        
    }
    else if ([secutryType intValue] == 5)
    {           //OTP
        
        secretotpView = [[[SHBSecretOTPViewController alloc] init] autorelease];
        secretotpView.targetViewController = self;
        secretotpView.nextSVC = @"G1414"; // 130819, 보안카드 사고예방 방어코드
        
        [secretotpView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretotpView.view.bounds.size.height)];
        [secretView setFrame:CGRectMake(secretView.frame.origin.x, secretView.frame.origin.y, secretotpView.view.frame.size.width, secretotpView.view.frame.size.height)];
        [secretView addSubview:secretotpView.view];
        secretotpView.selfPosY = secretView.frame.origin.y;
        
        secretotpView.delegate = self;
    }
}


#pragma mark -
#pragma mark SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
}


//이전 버튼 클릭
- (void)onPreviousClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    // 필요하면 구현...
    NSLog(@"previous");
}
//다음 버튼 클릭
- (void)onNextClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    // 필요하면 구현...
    NSLog(@"next");
}
- (void)didGetToMaxmum
{
    // 필요하면 구현...
}


#pragma mark -
#pragma mark - SHBSecretMediaDelegate

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if ( confirm == YES )
    {
        // 계좌번호는 이전 view에서 온다
        [self.dicDataDictionary setObject:AppInfo.tran_Date forKey:@"거래일자"];
        [self.dicDataDictionary setObject:AppInfo.tran_Time forKey:@"거래시간"];
        //[self.dicDataDictionary setObject:AppInfo.ssn forKey:@"실명번호"];
        [self.dicDataDictionary setObject:[AppInfo getPersonalPK] forKey:@"실명번호"];
        
        
        // 주민번호 *** 처리
        NSString *strNumber = self.dicDataDictionary[@"실명번호"];
        
        if ([strNumber length] > 6)
        {
            strNumber = [strNumber substringToIndex:6];
        }
        
        // 전자서명
        AppInfo.eSignNVBarTitle = @"지방세납부";
        
        AppInfo.electronicSignCode = @"G1414";
        AppInfo.electronicSignTitle = @"지방세납부";
        
        [AppInfo addElectronicSign:@"지방세납부"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", self.dicDataDictionary[@"거래일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", self.dicDataDictionary[@"거래시간"]]];
        //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)실명번호: %@-*******", strNumber]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)실명번호: %@", @""]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)출금계좌번호: %@", self.dicDataDictionary[@"출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)세목: %@", self.dicDataDictionary[@"세목명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)전자납부번호: %@", self.dicDataDictionary[@"전자납부번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)납부금액: %@원",self.dicDataDictionary[@"납부금액"]]];
        
        NSString *strDate = [self.dicDataDictionary[@"거래일자"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                @{
                                @"이용기관지로번호" : self.dicDataDictionary[@"이용기관지로번호"],
                                @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? self.dicDataDictionary[@"고지주민번호"] : @"",
                                @"납세번호" : self.dicDataDictionary[@"납세번호"],
                                @"전자납부번호" : self.dicDataDictionary[@"전자납부번호"],
                                @"납부금액" : self.dicDataDictionary[@"납부금액"],
                                @"납기내금액" : self.dicDataDictionary[@"납기내금액"],
                                @"납기후금액" : self.dicDataDictionary[@"납기후금액"],
                                @"납부일자" : strDate,
                                @"출금계좌번호" : self.dicDataDictionary[@"출금계좌번호"],
                                @"출금계좌비밀번호" : self.dicDataDictionary[@"출금계좌비밀번호"],
//                                @"납부자주민번호" : AppInfo.ssn,         // 주민번호 미사용
                                }] autorelease];
        
        self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: LOCAL_TAX_RUN viewController: self ] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    }
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ElecDistricCancelButtonPushed" object:nil];
    
    [self.navigationController fadePopViewController];
}

#pragma mark -
#pragma mark Notifications

- (void)getElectronicSignResult:(NSNotification *)noti
{
    if ([noti userInfo])
    {
        if ([[[noti userInfo] objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"])
        {
            // success의 경우
            SHBElectronDistricTaxCompleteViewController *viewController = [[SHBElectronDistricTaxCompleteViewController alloc] initWithNibName:@"SHBElectronDistricTaxCompleteViewController" bundle:nil];
            
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ElecDistricCancelButtonPushed" object:nil];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

#pragma mark -
#pragma mark Xcode Generate

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"지방세납부";
    self.strBackButtonTitle = @"전자납부번호 2단계";
    
    label1.text = [dicDataDictionary objectForKey:@"납부자성명"];
    label2.text = [dicDataDictionary objectForKey:@"세목명"];
    label3.text = [dicDataDictionary objectForKey:@"전자납부번호"];
    label4.text = [NSString stringWithFormat:@"%@원", [dicDataDictionary objectForKey:@"과세표준금액"]];
    label5.text = [dicDataDictionary objectForKey:@"과세대상"];
    label6.text = [dicDataDictionary objectForKey:@"납기내납기일"];
    label7.text = [dicDataDictionary objectForKey:@"납기후납기일"];
    label8.text = [NSString stringWithFormat:@"%@원", [dicDataDictionary objectForKey:@"납부금액"]];
    
    [self setSecretView];
    
    float fltHeight = infoView.frame.size.height;
    
    // 보안관련
    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    // 높이 계산
    if ([secutryType intValue] == 1 || [secutryType intValue] == 2 || [secutryType intValue] == 3 || [secutryType intValue] == 4)
    {           //보안카드
        fltHeight = fltHeight + secretcardView.view.frame.size.height;
    }
    else
    {
        fltHeight = fltHeight + secretotpView.view.frame.size.height;
    }
    
    [realView setFrame:CGRectMake(realView.frame.origin.x, realView.frame.origin.y, realView.frame.size.width, fltHeight)];
    
    [scrollView1 setContentSize:CGSizeMake(realView.frame.size.width, fltHeight)];
    
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    // 전자서명 노티 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    // 납기 내후에 따라 강조 처리
    if ([self.dicDataDictionary[@"납기내후구분"] isEqualToString:@"B"])
    {
        [view1 setHidden:NO];
    }
    else
    {
        [view2 setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    [super dealloc];
}

@end
