//
//  SHBSurchargeSecurityViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 19..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSurchargeSecurityViewController.h"
#import "SHBPentionService.h"                           // 퇴직연금 서비스
#import "SHBSurchargeCompleteViewController.h"          // 다음 view


@interface SHBSurchargeSecurityViewController ()

@end

@implementation SHBSurchargeSecurityViewController

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
        secretcardView.nextSVC = @"D2033"; // 130819, 보안카드 사고예방 방어코드
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
        secretotpView.nextSVC = @"D2033"; // 130819, 보안카드 사고예방 방어코드
    }
}


#pragma mark -
#pragma mark didRotateFromInterfaceOrientation

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    NSLog(@"didRotateFromInterfaceOrientation:%i",fromInterfaceOrientation);
    [secretcardView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [secretotpView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
            SHBSurchargeCompleteViewController *viewController = [[SHBSurchargeCompleteViewController alloc] initWithNibName:@"SHBSurchargeCompleteViewController" bundle:nil];
            
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"surchargeCancelButtonPushed" object:nil];
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

// 보안에서 완료 시
- (void)resetFormPosition
{
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
}


#pragma mark -
#pragma mark - SHBSecretMediaDelegate

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if ( confirm == YES )
    {
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
        
        [self.dicDataDictionary setObject:AppInfo.tran_Date forKey:@"거래일자"];
        [self.dicDataDictionary setObject:AppInfo.tran_Time forKey:@"거래시간"];

        // 전자서명
        AppInfo.eSignNVBarTitle = @"가입자부담금 입금";
        
        AppInfo.electronicSignCode = @"D2033_A";
        AppInfo.electronicSignTitle = @"가입자부담금 입금";
        
        [AppInfo addElectronicSign:@"가입자부담금 입금"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", self.dicDataDictionary[@"거래일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", self.dicDataDictionary[@"거래시간"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)출금계좌번호: %@", self.dicDataDictionary[@"출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)입금계좌번호: %@", label2.text]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)이체금액: %@원", [SHBUtility normalStringTocommaString:self.dicDataDictionary[@"이체금액"]]]];
        
        
        NSString *strPreNumber = @"";
        
        // DC의 입금 가능의 경우 입금예정번호가 필요하다
        if ( [self.dicDataDictionary[@"제도구분"] isEqualToString:@"2"] )
        {
            strPreNumber = self.dicDataDictionary[@"입금예정번호"];
        }
        
        OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                @{
                                @"고객번호" : AppInfo.customerNo,
                                //@"주민번호" : AppInfo.ssn,
                                //@"주민번호" : [AppInfo getPersonalPK],
                                @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                @"전문구분" : @"1",
                                @"출금계좌번호" : [self.dicDataDictionary[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                @"출금계좌비밀번호" : self.dicDataDictionary[@"출금계좌비밀번호"],
//                                @"출금계좌성명" : @"",
                                @"입금은행코드" : @"88",
                                @"입금계좌번호" : [self.dicDataDictionary[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
//                                @"입금계좌성명" : @"",
//                                @"이체금액" : self.dicDataDictionary[@"이체금액"],
                                @"적요코드" : @"180",
                                @"모바일IC코드" : @"",
                                @"전화번호" : @"",
                                @"출금계좌통장메모" : @"",
                                @"입금계좌통장메모" : @"",
//                                @"출금계좌부기명" : @"",
                                @"CMS코드" : @"",
                                @"출금은행구분" : @"2",
                                @"입금예정번호" : strPreNumber
                                }] autorelease];
        
        self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_SURCHARGE_RUN viewController: self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
        
    }
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"surchargeCancelButtonPushed" object:nil];
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
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 20)];
//    }
    
    self.title = @"가입자 부담금입금";
    self.strBackButtonTitle = @"가입자부담금입금 2단계";
    
    label1.text = self.dicDataDictionary[@"플랜명"];
    
    // 부담금 통합계좌번호가 있는 경우
    if ([self.dicDataDictionary[@"부담금통합계좌번호"] length] > 0)
    {
        label2.text = self.dicDataDictionary[@"부담금통합계좌번호"];
    }
    else
    {
        label2.text = self.dicDataDictionary[@"계좌번호"];
    }
    
    label3.text = self.dicDataDictionary[@"출금계좌번호"];
    label4.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:self.dicDataDictionary[@"이체금액"]]];
    
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
