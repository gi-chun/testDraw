//
//  SHBEnterTheSecurityMediaViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 8. 20..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBEnterTheSecurityMediaViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBOthersUseAdditionalAuthenticationDevicesViewController.h"
#import "SHBFraudPreventionSMSNotificationViewController.h"
#import "SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController.h"
#import "SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController.h"
#import "SHBFraudPreventionSMSNotificationLastStepType1ViewController.h"
#import "SHBFraudPreventionSMSNotificationLastStepType2ViewController.h"

@interface SHBEnterTheSecurityMediaViewController ()

- (void)popToMainViewController; // 이용기기 외 추가인증, 사기예방 SMS 통지 신청/해제 메인화면으로 이동

@end

@implementation SHBEnterTheSecurityMediaViewController

#pragma mark -
#pragma mark Notification Methods

- (void)getElectronicSignResult:(NSNotification *)notification
{
    if (!AppInfo.errorType) {

        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        // 완료화면으로 이동
        NSString *stringTemp = nil;
        
        if ([self.viewDataSet[D_VIEWCONTROLLER] isEqualToString:@"SHBOthersUseAdditionalAuthenticationDevicesViewController"]) { // 이용기기 외 추가인증
            
            if (![self.viewDataSet[D_IS_SELECTION] boolValue]) {
                
                stringTemp = @"SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController"; // 신청 완료화면
            }
            else {
                
                stringTemp = @"SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController"; // 해제 완료화면
            }
        }
        else if ([self.viewDataSet[D_VIEWCONTROLLER] isEqualToString:@"SHBFraudPreventionSMSNotificationViewController"]) { // 사기예방 SMS 통지
            
            if (![self.viewDataSet[D_IS_SELECTION] boolValue]) {
                
                // 구사기예방서비스 변경동의 여부 체크
                if (AppInfo.isCheatDefanceAgree == NO) {
                    
                    // 변경동의가 가입 완료 된것으로 처리
                    AppInfo.isCheatDefanceAgree = YES;
                }
                
                stringTemp = @"SHBFraudPreventionSMSNotificationLastStepType1ViewController"; // 신청 완료화면
            }
            else {
                
                stringTemp = @"SHBFraudPreventionSMSNotificationLastStepType2ViewController"; // 해제 완료화면
            }
        }
        
        if (stringTemp != nil) {
            
            AppInfo.commonDic = @{ @"날짜" : AppInfo.tran_Date }; // 신청/해제 일자 저장
            
            SHBBaseViewController *viewController = [[NSClassFromString(stringTemp) alloc] initWithNibName:stringTemp bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

- (void)getElectronicSignServerError
{
    // 이용기기 외 추가인증, 사기예방 SMS 통지 신청/해제 메인화면으로 이동
    [self popToMainViewController];
}

- (void)getElectronicSignCancel
{
    // 이용기기 외 추가인증, 사기예방 SMS 통지 신청/해제 메인화면으로 이동
    [self popToMainViewController];
}


#pragma mark -
#pragma mark SHBSecretCardDelegate Methods

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSString *stringTemp1 = nil; // 업무구분 임시값
    NSString *stringTemp2 = nil; // 거래구분 임시값
    
    // 전자서명
    AppInfo.serviceOption = @"전자서명";
    AppInfo.electronicSignString = @"";
    
    if ([self.viewDataSet[D_VIEWCONTROLLER] isEqualToString:@"SHBOthersUseAdditionalAuthenticationDevicesViewController"]) { // 이용기기 외 추가인증
        
        AppInfo.eSignNVBarTitle = @"이용기기 외 추가인증";
        
        if (![self.viewDataSet[D_IS_SELECTION] boolValue]) {
            
            // 신청
            AppInfo.electronicSignCode = @"E4149_C";
            AppInfo.electronicSignTitle = @"다음과 같이 이용기기 외 추가인증을 신청합니다.";
            [AppInfo addElectronicSign:@"신청내용"];
            [AppInfo addElectronicSign:@"(1)이용기기 외 추가인증 신청"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청일시: %@", AppInfo.tran_Date]];
            
            stringTemp1 = @"2"; // 등록
            stringTemp2 = @"1"; // 이용기기 외 추가인증
        }
        else {
            
            // 해제
            AppInfo.electronicSignCode = @"E4149_D";
            AppInfo.electronicSignTitle = @"다음과 같이 이용기기 외 추가인증을 해제합니다.";
            [AppInfo addElectronicSign:@"신청내용"];
            [AppInfo addElectronicSign:@"(1)이용기기 외 추가인증 해제"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)해제일시: %@", AppInfo.tran_Date]];
            
            stringTemp1 = @"9"; // 해제
            stringTemp2 = @"1"; // 이용기기 외 추가인증
        }
    }
    else if ([self.viewDataSet[D_VIEWCONTROLLER] isEqualToString:@"SHBFraudPreventionSMSNotificationViewController"]) { // 사기예방 SMS 통지
        
        AppInfo.eSignNVBarTitle = @"사기예방 SMS 통지";
        
        if (![self.viewDataSet[D_IS_SELECTION] boolValue]) {
            
            // 신청
            AppInfo.electronicSignCode = @"E4149_A";
            AppInfo.electronicSignTitle = @"다음과 같이 사기예방 SMS통지를 신청합니다.";
            [AppInfo addElectronicSign:@"신청내용"];
            [AppInfo addElectronicSign:@"(1)사기예방 SMS 통지 신청"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청일시: %@", AppInfo.tran_Date]];
            
            stringTemp1 = @"2"; // 등록
            stringTemp2 = @"2"; // 사기예방 SMS 통지
        }
        else {
            
            // 해제
            AppInfo.electronicSignCode = @"E4149_B";
            AppInfo.electronicSignTitle = @"다음과 같이 사기예방 SMS통지를 해제합니다.";
            [AppInfo addElectronicSign:@"신청내용"];
            [AppInfo addElectronicSign:@"(1)사기예방 SMS 통지 해제"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)해제일시: %@", AppInfo.tran_Date]];
            
            stringTemp1 = @"9"; // 해제
            stringTemp2 = @"2"; // 사기예방 SMS 통지
        }
    }
    
    // 전문요청
    self.securityCenterService = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E4149_SERVICE viewController:self] autorelease];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"업무구분" : stringTemp1, // 1:조회, 2:등록, 9:해지
                           @"거래구분" : stringTemp2, // 1:이용기기 외 추가인증, 2:사기예방 SMS 통지
                           }];
    self.securityCenterService.requestData = dataSet;
    
    [self.securityCenterService start];
}

- (void) cancelSecretMedia
{
    // 이용기기 외 추가인증, 사기예방 SMS 통지 신청/해제 메인화면으로 이동
    [self popToMainViewController];
}


#pragma mark -
#pragma mark Private Methods

- (void)popToMainViewController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    BOOL isFind = NO;
    UIViewController *viewController = nil;
    
    for (viewController in self.navigationController.childViewControllers) {
        
        if ([NSStringFromClass([viewController class]) isEqualToString:@"SHBOthersUseAdditionalAuthenticationDevicesViewController"] ||
            [NSStringFromClass([viewController class]) isEqualToString:@"SHBFraudPreventionSMSNotificationViewController"]) {
            
            isFind = YES;
            break;
        }
    }
    
    if (isFind) {
        
        [self.navigationController fadePopToViewController:viewController];
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.viewDataSet = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewDataSet = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.viewDataSet = nil;
    self.contentScrollView = nil;
    self.contentView = nil;
    [self.secretCardViewController.view removeFromSuperview];
    self.secretCardViewController = nil;
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
    
    // 데이타셋 초기화 
    [self.viewDataSet setDictionary:AppInfo.commonDic];
    
    // 네비게이션 타이틀 초기화
    if (self.viewDataSet[D_NAVI_TITLE]) {
        
        self.title = self.viewDataSet[D_NAVI_TITLE];
    }
    
    // 서브 타이틀 초기화
    if (self.viewDataSet[D_SUB_TITLE]) {
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:self.viewDataSet[D_SUB_TITLE] maxStep:[self.viewDataSet[D_MAX_STEP] intValue] focusStepNumber:[self.viewDataSet[D_FOCUS_STEP] intValue]] autorelease]];
    }
    
    // 보안매체 뷰컨트롤러 및 뷰 초기화
    self.secretCardViewController.targetViewController = self;
    self.secretCardViewController.delegate = self;
    self.secretCardViewController.nextSVC = @"E4149";
    
    CGRect rectTemp = self.secretCardViewController.view.frame;
    rectTemp.origin.y = 0;
    self.secretCardViewController.view.frame = rectTemp;
    
    [self.contentView addSubview:self.secretCardViewController.view];
    
    [self.secretCardViewController setMediaCode:[AppInfo.userInfo[@"보안매체정보"] integerValue] previousData:nil];
    
    // 스크롤 뷰 컨텐츠 크기 초기화
    self.contentScrollView.contentSize = self.contentView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
