//
//  SHBSecurityCardViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSecurityCardViewController.h"
#import "SHBGiroTaxListService.h"               // 지로 서비스
#import "SHBGiroTaxCompleteViewController.h"    // 완료 화면


@interface SHBSecurityCardViewController ()

@end

@implementation SHBSecurityCardViewController


#pragma makr -
#pragma Synthesize

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
        secretcardView.nextSVC = @"G0113"; // 130819, 보안카드 사고예방 방어코드
        
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
        secretotpView.nextSVC = @"G0113"; // 130819, 보안카드 사고예방 방어코드
        
        [secretotpView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretotpView.view.bounds.size.height)];
        [secretView setFrame:CGRectMake(secretView.frame.origin.x, secretView.frame.origin.y, secretotpView.view.frame.size.width, secretotpView.view.frame.size.height)];
        [secretView addSubview:secretotpView.view];
        secretotpView.selfPosY = secretView.frame.origin.y;
        
        secretotpView.delegate = self;
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
#pragma mark - SHBSecretMediaDelegate

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm == YES)
    {
        [self.dicDataDictionary setObject:AppInfo.tran_Date forKey:@"거래일자"];
        [self.dicDataDictionary setObject:AppInfo.tran_Time forKey:@"거래시간"];
        
        // 전자서명
        AppInfo.eSignNVBarTitle = @"지로조회납부";
        
        AppInfo.electronicSignTitle = @"지로납부";
        AppInfo.electronicSignCode = @"G0113";
        
        [AppInfo addElectronicSign:@"지로납부"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", self.dicDataDictionary[@"거래일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", self.dicDataDictionary[@"거래시간"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)지로번호: %@", self.dicDataDictionary[@"지로번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)청구기관명: %@", self.dicDataDictionary[@"수납기관명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)전자납부번호: %@", self.dicDataDictionary[@"전자납부번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)고객조회번호: %@", self.dicDataDictionary[@"고객조회번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)납부자명: %@", self.dicDataDictionary[@"납부자성명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)납부금액: %@원", self.dicDataDictionary[@"납부금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)부과년월: %@",self.dicDataDictionary[@"부과년월"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)출금계좌번호: %@",self.dicDataDictionary[@"출금계좌번호"]]];
        
        // 최종전문
        
        SHBDataSet     *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                                       @{
                                       @"이용기관지로번호"          : self.dicDataDictionary[@"지로번호"],
                                       @"전자납부번호"            : self.dicDataDictionary[@"전자납부번호"],
                                       @"고객조회번호"              : self.dicDataDictionary[@"고객조회번호"],
                                       @"수납기관명"              : self.dicDataDictionary[@"수납기관명"],
                                       @"부과년월"    : self.dicDataDictionary[@"부과년월"],
                                       @"납부기한"    : self.dicDataDictionary[@"납부기한"],
                                       @"고지형태"    : self.dicDataDictionary[@"고지형태"],
                                       @"발행형태"    : self.dicDataDictionary[@"발행형태"],
                                       @"납기내후구분"    : self.dicDataDictionary[@"납기내후구분"],
                                       @"납부금액"    : self.dicDataDictionary[@"납부금액"],
                                       @"납부일자"    : self.dicDataDictionary[@"납부일자"],
                                       @"출금계좌번호"    : self.dicDataDictionary[@"출금계좌번호"],
                                       @"출금계좌비밀번호"    : self.dicDataDictionary[@"출금계좌비밀번호"],
                                       @"연락전화번호"    : self.dicDataDictionary[@"연락전화번호"],
                                       @"납부자성명"    : self.dicDataDictionary[@"납부자성명"],
                                       @"기타"    : self.dicDataDictionary[@"기타"],
                                       }] autorelease];
        
        self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_PAYMENT_RUN  viewController: self] autorelease];
        self.service.previousData = dicDataDic;
        [self.service start];
        
        // 이후 전자서명으로 넘어가며 노티로 날라온다
    }
}

- (void)cancelSecretMedia
{
    // 보안 취소시
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonDidPushFromSummit" object:@"0"];
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
            
            SHBGiroTaxCompleteViewController *viewController = [[SHBGiroTaxCompleteViewController alloc] initWithNibName:@"SHBGiroTaxCompleteViewController" bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [self cancelSecretMedia];
    [self.navigationController fadePopViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonDidPushFromSummit" object:@"1"];
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
    
    self.title = @"지로조회납부";
    self.strBackButtonTitle = @"지로조회납부 2단계";
    
    label1.text = [self.dicDataDictionary objectForKey:@"지로번호"];
    label2.text = [self.dicDataDictionary objectForKey:@"전자납부번호"];
    label3.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [self.dicDataDictionary objectForKey:@"고객조회번호"];
    label5.text = [self.dicDataDictionary objectForKey:@"납부자성명"];
    label6.text = [self.dicDataDictionary objectForKey:@"납부금액원"];
    label7.text = [self.dicDataDictionary objectForKey:@"고지형태->display"];
    label8.text = [self.dicDataDictionary objectForKey:@"부과년월"];
    label9.text = [self.dicDataDictionary objectForKey:@"납부기한"];
    label10.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    
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
