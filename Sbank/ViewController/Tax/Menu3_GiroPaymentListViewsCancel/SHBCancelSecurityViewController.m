//
//  SHBCancelSecurityViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 31..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBCancelSecurityViewController.h"
#import "SHBGiroTaxListService.h"               // 지로 서비스
#import "SHBCancelCompleteViewController.h"     // 다음 view


@interface SHBCancelSecurityViewController ()

@end

@implementation SHBCancelSecurityViewController


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
        
        [secretotpView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretotpView.view.bounds.size.height)];
        [secretView setFrame:CGRectMake(secretView.frame.origin.x, secretView.frame.origin.y, secretotpView.view.frame.size.width, secretotpView.view.frame.size.height)];
        [secretView addSubview:secretotpView.view];
        secretotpView.selfPosY = secretView.frame.origin.y;
        
        secretotpView.delegate = self;
    }
}

- (void) cancelSecretMedia
{
    [self.navigationController fadePopViewController];
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    NSLog(@"didRotateFromInterfaceOrientation:%i",fromInterfaceOrientation);
    [secretcardView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [secretotpView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - SHBSecureDelegate

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
#pragma mark Notifications

- (void)getElectronicSignResult:(NSNotification *)noti
{
    if ([noti userInfo])
    {
        if ([[[noti userInfo] objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"])
        {
            // success의 경우
            SHBCancelCompleteViewController *viewController = [[SHBCancelCompleteViewController alloc] initWithNibName:@"SHBCancelCompleteViewController" bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

// 보안에서 완료 시
- (void)resetFormPosition
{
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
}


#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if ( confirm == YES )
    {
        [self.dicDataDictionary setObject:AppInfo.tran_Date forKey:@"거래일자"];
        [self.dicDataDictionary setObject:AppInfo.tran_Time forKey:@"거래시간"];
        
        // 전자서명
        AppInfo.eSignNVBarTitle = @"지로납부내역 조회취소";
        
        AppInfo.electronicSignCode = @"G0163";
        AppInfo.electronicSignTitle = @"지로납부취소";
        
        [AppInfo addElectronicSign:@"지로납부취소"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", self.dicDataDictionary[@"거래일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", self.dicDataDictionary[@"거래시간"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)지로번호: %@", self.dicDataDictionary[@"이용기관지로번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)청구기관명: %@", self.dicDataDictionary[@"수납기관명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)전자납부번호/고객조회번호: %@", self.dicDataDictionary[@"전자납부번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)납부금액: %@원", self.dicDataDictionary[@"납부금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)납부년월: %@",self.dicDataDictionary[@"납부일자"]]];
        
        OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                @{
                                //@"납부자주민등록번호" : AppInfo.ssn,
                                //@"납부자주민등록번호" : [AppInfo getPersonalPK],
                                @"납부자주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                @"원거래전문번호" : self.dicDataDictionary[@"원거래전문번호"],
                                @"납부일시" : self.dicDataDictionary[@"납부일시"],
                                @"출금계좌번호" : self.dicDataDictionary[@"출금계좌번호"],
                                @"납부금액" : self.dicDataDictionary[@"납부금액"],
                                @"납부형태구분" : self.dicDataDictionary[@"납부형태구분"]
                                }] autorelease];
        
        self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_PAYMENT_CANCEL_RUN viewController: self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    }
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
    
    self.title = @"지로납부내역 조회취소";
    self.strBackButtonTitle = @"지로납부내역 조회취소 2단계";
    
    label1.text = [dicDataDictionary objectForKey:@"납부일자"];
    label2.text = [dicDataDictionary objectForKey:@"출금계좌번호"];
    label3.text = [dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [dicDataDictionary objectForKey:@"이용기관지로번호"];
    label5.text = [NSString stringWithFormat:@"%@원", [dicDataDictionary objectForKey:@"납부금액"]];
    
    [self setSecretView];
    
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    // 전자서명 노티 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    // 보안키패드 완료
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"secureMediaKeyPadClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFormPosition) name:@"secureMediaKeyPadClose" object:nil];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"secureMediaKeyPadClose" object:nil];
    
    [super dealloc];
}

@end
