//
//  SHBGiroTaxInputContentViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 10..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxInputContentViewController.h"
#import "SHBGiroTaxListService.h"                           // 지로 서비스
#import "SHBGiroInpuCompleteViewController.h"               // 다음 view


@interface SHBGiroTaxInputContentViewController ()

@end

@implementation SHBGiroTaxInputContentViewController

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
        secretcardView.nextSVC = @"G0123"; // 130819, 보안카드 사고예방 방어코드
        
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
        secretotpView.nextSVC = @"G0123"; // 130819, 보안카드 사고예방 방어코드
        
        [secretotpView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretotpView.view.bounds.size.height)];
        [secretView setFrame:CGRectMake(secretView.frame.origin.x, secretView.frame.origin.y, secretotpView.view.frame.size.width, secretotpView.view.frame.size.height)];
        [secretView addSubview:secretotpView.view];
        secretotpView.selfPosY = secretView.frame.origin.y;
        
        secretotpView.delegate = self;
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation:%i",fromInterfaceOrientation);
    [secretcardView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [secretotpView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
        [self.dicDataDictionary setObject:AppInfo.tran_Date forKey:@"거래일자"];
        [self.dicDataDictionary setObject:AppInfo.tran_Time forKey:@"거래시간"];
        [self.dicDataDictionary setObject:label2.text forKey:@"수납기관명"];
        [self.dicDataDictionary setObject:@"지로납부" forKey:@"서비스명"];
        
        NSString *strForKey = @"납부자확인번호";
        
        // 전자서명
        AppInfo.eSignNVBarTitle = @"지로입력납부";
        
        AppInfo.electronicSignTitle = @"지로납부";
        
        [AppInfo addElectronicSign:@"지로납부"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", self.dicDataDictionary[@"거래일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", self.dicDataDictionary[@"거래시간"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)지로번호: %@", self.dicDataDictionary[@"지로번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)청구기관명: %@", self.dicDataDictionary[@"수납기관명"]]];

        // 장표 종류에 따른 분기
        if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"O"])
        {
            AppInfo.electronicSignCode = @"G0123_A";
            strForKey = @"고객조회번호";
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)%@: %@", strForKey, self.dicDataDictionary[strForKey]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)납부금액: %@원", [SHBUtility normalStringTocommaString:self.dicDataDictionary[@"납부금액"]]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)금액검증번호: %@", self.dicDataDictionary[@"금액검증번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)납부년월: %@", self.dicDataDictionary[@"납부연월"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)출금계좌번호: %@", self.dicDataDictionary[@"출금계좌번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)납부자명: %@", self.dicDataDictionary[@"납부자명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)서비스명: %@", self.dicDataDictionary[@"서비스명"]]];
        }
        else if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"Q"])
        {
            AppInfo.electronicSignCode = @"G0123_B";
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)%@: %@", strForKey, self.dicDataDictionary[@"고객조회번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)납부금액: %@원", [SHBUtility normalStringTocommaString:self.dicDataDictionary[@"납부금액"]]]] ;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)금액검증번호: %@", self.dicDataDictionary[@"금액검증번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)납부년월: %@", self.dicDataDictionary[@"납부연월"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)출금계좌번호: %@", self.dicDataDictionary[@"출금계좌번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)납부자명: %@", self.dicDataDictionary[@"납부자명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)서비스명: %@", self.dicDataDictionary[@"서비스명"]]];
        }
        else if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"M"])
        {
            AppInfo.electronicSignCode = @"G0123_C";
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)%@: %@", strForKey, self.dicDataDictionary[@"고객조회번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)납부금액: %@원", [SHBUtility normalStringTocommaString:self.dicDataDictionary[@"납부금액"]]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)납부년월: %@", self.dicDataDictionary[@"납부연월"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)출금계좌번호: %@", self.dicDataDictionary[@"출금계좌번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)납부자명: %@", self.dicDataDictionary[@"납부자명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)서비스명: %@", self.dicDataDictionary[@"서비스명"]]];
            
//            [viewMove1 setFrame:CGRectMake(viewMove1.frame.origin.x, viewMove1.frame.origin.y, viewMove1.frame.size.width, 0)];
//            [viewMove2 setFrame:CGRectMake(viewMove2.frame.origin.x, viewMove2.frame.origin.y - 18, viewMove2.frame.size.width, viewMove2.frame.size.height)];
        }
        
        OFDataSet   *aDataSet = nil;
        int         intServiceID = 0;
        
        // OCR과 QCR의 전문이 같다 (납부자확인 번호와 고객조회번호가 동)
        if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"O"] || [[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"Q"])
        {
            // 서비스를 실행한다
            aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"이용기관지로번호"    : self.dicDataDictionary[@"지로번호"],
                                    @"고객조회번호"    : self.dicDataDictionary[@"고객조회번호"],     // 납부자 확인 번호와 고객조회번호가 같다
                                    @"부과년월"    : self.dicDataDictionary[@"납부연월"],         // 납부연월이 부과년월로 들어간다
                                    @"수납기관명"    : self.dicDataDictionary[@"수납기관명"],
                                    @"출금계좌번호"    : self.dicDataDictionary[@"출금계좌번호"],
                                    @"출금계좌비밀번호"    : self.dicDataDictionary[@"출금계좌비밀번호"],
                                    @"납부금액"    : self.dicDataDictionary[@"납부금액"],
                                    @"납부일자"    : self.dicDataDictionary[@"거래일자"],
                                    @"금액검증번호"    : self.dicDataDictionary[@"금액검증번호"],
                                    @"납부자성명"    : self.dicDataDictionary[@"납부자명"],
                                    @"연락전화번호"    : self.dicDataDictionary[@"전화번호"],
                                    @"reservationField1"    : @"TypeOCR"
                                    }] autorelease];
            
            intServiceID = TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_OCR;
        
        }
        else if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"M"])
        {
            
            // 서비스를 실행한다
            aDataSet = [[[OFDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호"    : self.dicDataDictionary[@"지로번호"],
                         @"고객조회번호"    : self.dicDataDictionary[@"고객조회번호"],     // 납부자 확인 번호와 고객조회번호가 같다
                         @"부과년월"    : self.dicDataDictionary[@"납부연월"],         // 납부연월이 부과년월로 들어간다
                         @"수납기관명"    : self.dicDataDictionary[@"수납기관명"],
                         @"출금계좌번호"    : self.dicDataDictionary[@"출금계좌번호"],
                         @"출금계좌비밀번호"    : self.dicDataDictionary[@"출금계좌비밀번호"],
                         @"납부금액"    : self.dicDataDictionary[@"납부금액"],
                         @"납부일자"    : self.dicDataDictionary[@"거래일자"],
                         @"납부자성명"    : self.dicDataDictionary[@"납부자명"],
                         @"연락전화번호"    : self.dicDataDictionary[@"전화번호"],
                         @"reservationField1"    : @"TypeMICR"
                         }] autorelease];
            
            intServiceID = TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_MICR;
        }
        
        self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: intServiceID viewController: self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    }
}

- (void) cancelSecretMedia
{
    // 보안 입력에서 취소시
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GiroInputCancelButtonPushed" object:nil];
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
            
            // M만 화면이 약간 상이
            // 뷰만 따로 가져간다
            NSString *strXibName = @"SHBGiroInpuCompleteViewController";
            
            if ( [self.dicDataDictionary[@"장표종류"] isEqualToString:@"M"])
            {
                strXibName = @"SHBGiroInpuCompleteViewControllerForMICR";
            }
            
            SHBGiroInpuCompleteViewController *viewController = [[SHBGiroInpuCompleteViewController alloc] initWithNibName:strXibName bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GiroInputCancelButtonPushed" object:nil];
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
    
    self.title = @"지로입력납부";
    self.strBackButtonTitle = @"지로입력납부 1단계";
    
    NSString *strForKey = @"납부자확인번호";
    
    [viewMove1 setFrame:CGRectMake(viewMove1.frame.origin.x, viewMove1.frame.origin.y, viewMove1.frame.size.width, 19)];
    [viewMove2 setFrame:CGRectMake(viewMove2.frame.origin.x, 207, viewMove2.frame.size.width, viewMove2.frame.size.height)];
    
    // 장표 종류에 따른 분기
    if ([[dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"O"])
    {
        strForKey = @"고객조회번호";
        label6.text = [self.dicDataDictionary objectForKey:@"금액검증번호"];
    }
    else if ([[self.dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"Q"])
    {
        label6.text = [self.dicDataDictionary objectForKey:@"금액검증번호"];
    }
    else if ([[self.dicDataDictionary objectForKey:@"장표종류"] isEqualToString:@"M"])
    {
        [viewMove1 setFrame:CGRectMake(viewMove1.frame.origin.x, viewMove1.frame.origin.y, viewMove1.frame.size.width, 0)];
        [viewMove2 setFrame:CGRectMake(viewMove2.frame.origin.x, viewMove2.frame.origin.y - 28, viewMove2.frame.size.width, viewMove2.frame.size.height)];
    }
    
    labelChanged.text = strForKey;
    
    label1.text = [self.dicDataDictionary objectForKey:@"지로번호"];
    label2.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label3.text = [self.dicDataDictionary objectForKey:@"고객조회번호"];          // 고객조회번호와 납부자확인번호가 같다
    label4.text = [NSString stringWithFormat:@"%@원",  [SHBUtility normalStringTocommaString:[self.dicDataDictionary objectForKey:@"납부금액"]]];
    label5.text = [self.dicDataDictionary objectForKey:@"납부연월"];
    label7.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    label8.text = [self.dicDataDictionary objectForKey:@"납부자명"];
    label9.text = [self.dicDataDictionary objectForKey:@"전화번호"];
    
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
