//
//  SHBFraudPreventionSMSNotificationViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBFraudPreventionSMSNotificationViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBMobileCertificateViewController.h"
#import "SHBIdentity1ViewController.h"
#import "SHBMobileCertificateService.h"

@interface SHBFraudPreventionSMSNotificationViewController ()

- (void)alertViewShow:(NSString *)aMessage; // 알럿뷰 호출

@end

@implementation SHBFraudPreventionSMSNotificationViewController
@synthesize sumLimitLabel;

#pragma mark -
#pragma mark Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E4149"]) {
        
        // 신청대상체크 - 서비스 신청 버튼을 눌렀을 경우
        if (_isSelection == NO &&
            [aDataSet[@"거래구분"] isEqualToString:@"2"]) {
            
            // 신청대상체크 - (1) OTP사용자
            if (![aDataSet[@"보안매체정보"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"보안카드 사용고객만 신청 가능합니다."];
                return NO;
            }
            
            // 신청대상체크 - (2) 사기예방 SMS 통지 서비스 가입고객
            if ([aDataSet[@"SMS통지상태"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"이미 신청한 고객입니다."];
                return NO;
            }
            
            // 신청대상체크 - (3) 이용기기 등록 서비스 미 가입자 / 구PC지정 서비스 가입고객 중 서비스 변경동의를 한 경우
            if ([aDataSet[@"이용기기신청여부"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"이용기기 등록서비스 가입 고객님은 사기예방 SMS 통지 신청이 불가합니다."];
                return NO;
            }
            
            // 신청대상체크 - (4) 구PC이용사전등록 서비스 가입고객이 서비스 변경동의를 하지 않은 경우
            if (AppInfo.isOldPCRegister == NO) {
                
                [self alertViewShow:@"이용기기 등록서비스 가입 고객님은 사기예방 SMS 통지 신청이 불가합니다."];
                return NO;
            }
            
            // 전문요청 - 추가인증 시 휴대폰 번호 받아오는 부분에 E2114전문 데이타가 필요함
            self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
            
            [self.service start];
        }
        // 신청여부 조회 - 서비스 해지 버튼을 눌렀을 경우
        else if (_isSelection == YES &&
                 [aDataSet[@"거래구분"] isEqualToString:@"2"]) {
            
            // 신청여부
            if (![aDataSet[@"SMS통지상태"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"사기예방 SMS 통지서비스 미신청 고객입니다."];
                return NO;
            }
            
            AppInfo.transferDic = @{ @"서비스코드" : @"E4149" };
            
            // 추가인증 화면으로 이동
            SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
            
            viewController.needsLogin = YES;
            [viewController setServiceSeq:SERVICE_FRAUD_PREVENTION_SMS];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            [viewController executeWithTitle:@"사기예방 SMS 통지" Step:1 StepCnt:5 NextControllerName:@"SHBEnterTheSecurityMediaViewController"];
            [viewController subTitle:@"사기예방 SMS 통지 해제"];
            
            [viewController release];
            
            // 보안매체에서 사용할 데이타셋 초기화
            AppInfo.commonDic = @{@"NAVI_TITLE" : @"사기예방 SMS 통지",
                                  @"SUB_TITLE" : @"이체비밀번호 및 보안매체 입력",
                                  @"VIEWCONTROLLER" : @"SHBFraudPreventionSMSNotificationViewController",
                                  @"IS_SELECTION" : @"YES",
                                  @"FOCUS_STEP" : @"4",
                                  @"MAX_STEP" : @"5"};
            
//            NSLog(@"서비스 해제 - 추가인증 화면으로 이동");
        }
    }
    else if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E2114"]) {
        
        // 추가인증 화면으로 이동
        SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
        
        [viewController setServiceSeq:SERVICE_FRAUD_PREVENTION_SMS];
        viewController.data = aDataSet;
        
        [self.navigationController pushFadeViewController:viewController];
        
        [viewController executeWithTitle:@"사기예방 SMS 통지" Step:1 StepCnt:4 NextControllerName:@"SHBEnterTheSecurityMediaViewController"];
        [viewController subTitle:@"사기예방 SMS 통지 신청 - 추가인증" infoViewCount:MOBILE_INFOVIEW_1];
        
        [viewController release];
        
        // 보안매체에서 사용할 데이타셋 초기화
        AppInfo.commonDic = @{@"NAVI_TITLE" : @"사기예방 SMS 통지",
                              @"SUB_TITLE" : @"이체비밀번호 및 보안매체 입력",
                              @"VIEWCONTROLLER" : @"SHBFraudPreventionSMSNotificationViewController",
                              @"IS_SELECTION" : @"NO",
                              @"FOCUS_STEP" : @"3",
                              @"MAX_STEP" : @"4"};
        
//            NSLog(@"서비스 신청 - 추가인증 화면으로 이동");
    }
    
    return NO;
}


#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
//            NSLog(@"예, 동의합니다.");
            self.button1.selected = !self.button1.selected;
        }   break;
        case 1:
        {
            [self alertViewShow:@"전자금융 사기예방을 위하여 사기예방 SMS 통지 신청이 불가합니다.(서비스 해제만 가능)"];
            return;
        }
            break;
        case 2:
        {
            // 안내문구에 대한 동의 확인에 대한 예외처리
            if (!self.button1.selected) {
                
                [self alertViewShow:@"주의사항을 읽고 동의하셔야 신청 또는 해제가 가능합니다."];
                return;
            }
            
            // 안심거래 예방서비스 가입 여부에 대한 예외처리
            if ([sender tag] == 1 && [AppInfo.userInfo[@"안심거래가입여부"] isEqualToString:@"1"] && ![AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"] && [AppInfo.userInfo[@"안심거래서비스사용여부"] isEqualToString:@"Y"]) {
                
                [self alertViewShow:@"안심거래 서비스 신청 고객님은 사기예방 SMS 통지서비스 신청이 불가 합니다."];
                return;
            }
            
            // 신청, 해지 여부 플래그 초기화
            _isSelection = [sender tag] - 1;
            
            // 사기예방 SMS통지 신청여부 조회
            self.securityCenterService = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E4149_SERVICE viewController:self] autorelease];
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"업무구분" : @"1", // 1:조회
                                   @"거래구분" : @"2", // 2:사기예방 SMS 통지
                                   }];
            self.securityCenterService.requestData = dataSet;
            
            [self.securityCenterService start];
            
        }   break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Private Methods

- (void)alertViewShow:(NSString *)aMessage
{
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:aMessage];
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
    self.button1 = nil;
    self.securityCenterService = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 체크박스 선택 해제
    self.button1.selected = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
    [self setTitle:@"사기예방 SMS 통지"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"사기예방 SMS 통지 신청/해제" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
