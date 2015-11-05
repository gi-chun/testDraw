//
//  SHBTransferLimitStep2ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 9. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBTransferLimitStep2ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBTransferLimitStep3ViewController.h"

@interface SHBTransferLimitStep2ViewController ()

- (void)popToMainViewController; // 이체한도감액 메인화면으로 이동

@end

@implementation SHBTransferLimitStep2ViewController

#pragma mark -
#pragma mark Notification Methods

- (void)getElectronicSignResult:(NSNotification *)notification
{
    if (!AppInfo.errorType) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        // 완료화면으로 이동
        SHBTransferLimitStep3ViewController *viewController = [[SHBTransferLimitStep3ViewController alloc] initWithNibName:@"SHBTransferLimitStep3ViewController" bundle:nil];
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
}

- (void)getElectronicSignServerError
{
    // 이체한도감액 메인화면으로 이동
    [self popToMainViewController];
}

- (void)getElectronicSignCancel
{
    // 이체한도감액 메인화면으로 이동
    [self popToMainViewController];
}


#pragma mark -
#pragma mark SHBSecretCardDelegate Methods

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    // 전자서명
    AppInfo.serviceOption = @"전자서명";
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"이체한도감액";
    AppInfo.electronicSignCode = @"C2142";
    AppInfo.electronicSignTitle = @"이체한도를 변경 신청합니다.";
    [AppInfo addElectronicSign:@"신청내용"];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)성명: %@", AppInfo.userInfo[@"고객성명"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)1일 이체한도: %@(원)", AppInfo.commonDic[@"a감액할1일이체한도"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)1회 이체한도: %@(원)", AppInfo.commonDic[@"a감액할1회이체한도"]]];
    
    // 전문요청
    self.securityCenterService = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_C2142_SERVICE viewController:self] autorelease];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"변경전1일이체한도" : AppInfo.commonDic[@"변경전1일이체한도"],
                           @"변경후1일이체한도" : AppInfo.commonDic[@"a감액할1일이체한도"],
                           @"변경전1회이체한도" : AppInfo.commonDic[@"변경전1회이체한도"],
                           @"변경후1회이체한도" : AppInfo.commonDic[@"a감액할1회이체한도"],
                           }];
    self.securityCenterService.requestData = dataSet;
    
    [self.securityCenterService start];
}

- (void) cancelSecretMedia
{
    // 이전화면으로 이동
    [self popToMainViewController];
}


#pragma mark -
#pragma mark Private Methods

- (void)popToMainViewController
{
    BOOL isFind = NO;
    UIViewController *viewController = nil;
    
    for (viewController in self.navigationController.childViewControllers) {
        
        if ([NSStringFromClass([viewController class]) isEqualToString:@"SHBTransferLimitViewController"]) {
            
            isFind = YES;
            break;
        }
    }
    
    if (isFind) {
        
        // 이전 뷰컨트롤러의 입력필드를 초기화함
        AppInfo.commonDic = @{@"INPUT_VALUE_INIT" : @"YES"};
        
        [self.navigationController fadePopToViewController:viewController];
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_secretCardViewController.view removeFromSuperview];
    [_secretCardViewController release]; _secretCardViewController = nil;
    [_secretOTPViewController.view removeFromSuperview];
    [_secretOTPViewController release]; _secretOTPViewController = nil;
    
    self.secretView = nil;
    self.contentView = nil;
    self.view1 = nil;
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.securityCenterService = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 전자서명에서 사용하는 옵저버 초기화 및 등록
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"notiESignError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 네비게이션 바 타이틀 초기화
    [self setTitle:@"이체한도감액"];
    
    // 서브 타이틀 초기화
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이체한도감액" maxStep:3 focusStepNumber:2] autorelease]];
    
    // 보안매체정보 체크
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5) {
    
        // OTP 보안매체 뷰컨트롤러 및 뷰 초기화
        _secretOTPViewController = [[[SHBSecretOTPViewController alloc] initWithNibName:@"SHBSecretOTPViewController" bundle:nil] autorelease];
        _secretOTPViewController.targetViewController = self;
        _secretOTPViewController.delegate = self;
        _secretOTPViewController.selfPosY = -30;
        _secretOTPViewController.nextSVC = @"C2142";
        
//        CGRect rectTemp = _secretOTPViewController.view.frame;
//        rectTemp.origin.y = self.view1.frame.size.height;
//        _secretOTPViewController.view.frame = rectTemp;
//
//        [self.contentView addSubview:_secretOTPViewController.view];
        [_secretView addSubview:_secretOTPViewController.view];
    }
    else {
        
        // 보안카드 보안매체 뷰컨트롤러 및 뷰 초기화
        _secretCardViewController = [[[SHBSecretCardViewController alloc] initWithNibName:@"SHBSecretCardViewController" bundle:nil] autorelease];
        _secretCardViewController.targetViewController = self;
        _secretCardViewController.delegate = self;
        //_secretCardViewController.selfPosY = -30;
        _secretCardViewController.selfPosY = 200;
        _secretCardViewController.nextSVC = @"C2142";

        
        [_secretView addSubview:_secretCardViewController.view];
        [_secretCardViewController setMediaCode:[AppInfo.userInfo[@"보안매체정보"] integerValue] previousData:nil];
    }
    
    // 스크롤 뷰 컨텐츠 크기 초기화
    //self.contentScrollView.contentSize = self.contentView.frame.size;
    [self.contentScrollView setContentSize:CGSizeMake(0, self.contentView.frame.size.height + self.secretView.frame.size.height)];
    // 화면 초기화
    self.label1.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"변경전1일이체한도"]];     // 현재 1일 이체한도
    self.label2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"변경전1회이체한도"]];     // 현재 1회 이체한도
    self.label3.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"a감액할1일이체한도"]];    // 감액할 1일 이체한도
    self.label4.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"a감액할1회이체한도"]];    // 감액할 1회 이체한도
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
