//
//  SHBGiftComfirmViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftComfirmViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"
#import "SHBGiftCompleteViewController.h"
#import "SHBGiftService.h"




@interface SHBGiftComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end


@implementation SHBGiftComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
       SHBDataSet *aDataSet = nil;
    
    if (confirm)
    {
        AppInfo.electronicSignCode = @"E1730";
        AppInfo.eSignNVBarTitle = @"모바일 상품권 구매";
        
        
        AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)상품권 종류: %@", AppInfo.commonDic[@"상품권종류"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)계좌번호: %@", AppInfo.commonDic[@"출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)구매금액: %@", AppInfo.commonDic[@"구매금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)캐시백: %@", AppInfo.commonDic[@"캐시백금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)보내는분 성명: %@", AppInfo.commonDic[@"보내는분성명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)받는분 성명: %@", AppInfo.commonDic[@"받는분성명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)받는분 휴대폰번호: %@", AppInfo.commonDic[@"받는분휴대폰"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)보내는분 휴대폰번호: %@", AppInfo.commonDic[@"보내는분휴대폰"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)전달내용: %@", AppInfo.commonDic[@"전달메세지"]]];

        
        
        self.service = [[[SHBGiftService alloc] initWithServiceId:@"E1730" viewController:self] autorelease];
        
        aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                                             @"거래구분" : @"2",  //판매전조회
                                                             @"업무유형" : @"1",
                                                             @"기관코드" : AppInfo.commonDic[@"기관코드"],
                                                             @"판매금액" : AppInfo.commonDic[@"판매금액"],
                                                             @"계좌구분" : AppInfo.commonDic[@"계좌구분"],
                                                             @"지급계좌번호" : AppInfo.commonDic[@"출금계좌번호"],
                                                             @"계좌비밀번호" : AppInfo.commonDic[@"계좌비밀번호"],
                                                             @"센터처리번호" : AppInfo.commonDic[@"대외거래고유번호"],
                                                             @"구매자휴대폰" : AppInfo.commonDic[@"보내는분휴대폰"],
                                                             @"받는분휴대폰" : AppInfo.commonDic[@"받는분휴대폰"],
                                                             @"구매자성명" : AppInfo.commonDic[@"보내는분성명"],
                                                             @"받는분성명" : AppInfo.commonDic[@"받는분성명"],
                                                             @"전달메세지" : AppInfo.commonDic[@"전달메세지"],
                                                             @"취소시구매일자" : @"",
                                                             @"취소시구매승인번호" :@"",
                                                             }];
        
    }
    
    self.service = nil;
    self.service = [[[SHBGiftService alloc] initWithServiceId:GIFT_E1730 viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBGiftCompleteViewController *nextViewController = [[[SHBGiftCompleteViewController alloc] initWithNibName:@"SHBGiftCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = noti.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
    
    [self.navigationController fadePopViewController];
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
        
    }
    else {
        [self.navigationController fadePopViewController];
    }
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
        
    }
    else {
        [self.navigationController fadePopViewController];
    }
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
    [super viewDidLoad];
    
    self.title = @"모바일 상품권 구매";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"상품권 구매 정보확인" maxStep:3 focusStepNumber:2] autorelease]];
    
    _lblData01.text = AppInfo.commonDic[@"상품권종류"];
    _lblData02.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData03.text = AppInfo.commonDic[@"구매금액"];
    _lblData04.text = AppInfo.commonDic[@"캐시백금액"];
    _lblData05.text = AppInfo.commonDic[@"보내는분성명"];
    _lblData06.text = AppInfo.commonDic[@"받는분성명"];
    
    _lblData07.text = AppInfo.commonDic[@"받는분휴대폰"];
    _lblData08.text = AppInfo.commonDic[@"보내는분휴대폰"];
    _lblData09.text = AppInfo.commonDic[@"전달메세지"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 251.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 251 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.nextSVC = @"E1730";
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 251.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 251 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        secretcardView.nextSVC = @"E1730";
        secretcardView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    
    if(self.contentScrollView.frame.size.height < _infoView.frame.size.height)
    {
        self.contentScrollView.contentSize = CGSizeMake(317.0f, _infoView.frame.size.height);
        contentViewHeight = _infoView.frame.size.height;
    }
    
    

    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [secretcardView release];
    [secretotpView release];
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [_infoView release];
    [_secretView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [self setInfoView:nil];
    [self setSecretView:nil];
    [super viewDidUnload];
}

@end
