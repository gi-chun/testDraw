//
//  SHBOthersUseAdditionalAuthenticationDevicesViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOthersUseAdditionalAuthenticationDevicesViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBIdentity1ViewController.h"
#import "SHBOldSecurityViewController.h"

@interface SHBOthersUseAdditionalAuthenticationDevicesViewController ()

- (void)alertViewShow:(NSString *)aMessage; // 알럿뷰 호출

@end

@implementation SHBOthersUseAdditionalAuthenticationDevicesViewController

#pragma mark -
#pragma mark Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E4149"]) {
        
        // 신청여부 조회, 신청대상체크 - 서비스 신청 버튼을 눌렀을 경우
        if (_isSelection == NO &&
            [aDataSet[@"거래구분"] isEqualToString:@"1"]) {
            
            // 신청여부
            if ([aDataSet[@"추가인증상태"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"이용기기 외 추가인증 서비스 신청 되어있습니다."];
                return NO;
            }
            
            // 신청대상체크 - (1) OTP사용자
            if (![aDataSet[@"보안매체정보"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"보안카드 사용고객만 신청 가능합니다."];
                return NO;
            }
            
            // 신청대상체크 - (2) 이용기기 등록 서비스 미 가입자
            if (![aDataSet[@"이용기기신청여부"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"이용기기 등록서비스 가입 및 보안카드 사용고객만 신청 가능합니다."];
                return NO;
            }
            
            // 신청대상체크 - (3) 사기예방 SMS 통지 서비스 가입 고객
            if ([aDataSet[@"SMS통지상태"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"사기예방 SMS 통지 서비스 해제 후 이용기기 등록 및 이용기기외 추가인증 신청이 가능합니다."];
                return NO;
            }
            
            // 신청대상체크 - (4) 구PC지정서비스 가입고객 중 서비스 변경동의를 안 한 경우
            if (AppInfo.isOldPCRegister == NO) {
            
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1 title:@"" message:@"구 이용PC 사전등록 변경동의 대상 고객입니다. 변경동의 후 서비스를 이용하실 수 있습니다."];
                return NO;
            }
            
            AppInfo.transferDic = @{ @"서비스코드" : @"E4149" };
            
            // 추가인증 화면으로 이동
            SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
            
            viewController.needsLogin = YES;
            [viewController setServiceSeq:SERVICE_DEVICE_REGIST_ADD];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            [viewController executeWithTitle:@"이용기기 외 추가인증" Step:1 StepCnt:5 NextControllerName:@"SHBEnterTheSecurityMediaViewController"];
            [viewController subTitle:@"이용기기 외 추가인증 신청"];
            
            [viewController release];
            
            // 보안매체에서 사용할 데이타셋 초기화
            AppInfo.commonDic = @{@"NAVI_TITLE" : @"이용기기 외 추가인증",
                                  @"SUB_TITLE" : @"이체비밀번호 및 보안매체 입력",
                                  @"VIEWCONTROLLER" : @"SHBOthersUseAdditionalAuthenticationDevicesViewController",
                                  @"IS_SELECTION" : @"NO",
                                  @"FOCUS_STEP" : @"4",
                                  @"MAX_STEP" : @"5"};
            
//            NSLog(@"서비스 신청 - 추가인증 화면으로 이동");
        }
        // 신청여부 조회 - 서비스 해지 버튼을 눌렀을 경우
        else if (_isSelection == YES &&
                 [aDataSet[@"거래구분"] isEqualToString:@"1"]) {
            
            // 신청여부
            if (![aDataSet[@"추가인증상태"] isEqualToString:@"1"]) {
                
                [self alertViewShow:@"이용기기 외 추가인증 서비스 미신청 되어있습니다."];
                return NO;
            }
            
            AppInfo.transferDic = @{ @"서비스코드" : @"E4149" };
            
            // 추가인증 화면으로 이동
            SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
            
            viewController.needsLogin = YES;
            [viewController setServiceSeq:SERVICE_DEVICE_REGIST_ADD];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            [viewController executeWithTitle:@"이용기기 외 추가인증" Step:1 StepCnt:5 NextControllerName:@"SHBEnterTheSecurityMediaViewController"];
            [viewController subTitle:@"이용기기 외 추가인증 해제"];
            
            [viewController release];
            
            // 보안매체에서 사용할 데이타셋 초기화
            AppInfo.commonDic = @{@"NAVI_TITLE" : @"이용기기 외 추가인증",
                                  @"SUB_TITLE" : @"이체비밀번호 및 보안매체 입력",
                                  @"VIEWCONTROLLER" : @"SHBOthersUseAdditionalAuthenticationDevicesViewController",
                                  @"IS_SELECTION" : @"YES",
                                  @"FOCUS_STEP" : @"4",
                                  @"MAX_STEP" : @"5"};
            
//            NSLog(@"서비스 해제 - 추가인증 화면으로 이동");
        }
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
        case 2:
        {
            // 안내문구에 대한 동의 확인에 대한 예외처리
            if (!self.button1.selected) {
                
                [self alertViewShow:@"주의사항을 읽고 동의하셔야 신청 또는 해제가 가능합니다."];
                return;
            }
            
            
            // 안심거래 예방서비스 가입 여부에 대한 예외처리
            if ([sender tag] == 1 && [AppInfo.userInfo[@"안심거래가입여부"] isEqualToString:@"1"] && ![AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"] && [AppInfo.userInfo[@"안심거래서비스사용여부"] isEqualToString:@"Y"]) {
                
                [self alertViewShow:@"안심거래 서비스 신청 고객님은 이용기기 외 추가 인증 신청이 불가합니다."];
                return;
            }

            
            
            
            // 신청, 해지 여부 플래그 초기화
            _isSelection = [sender tag] - 1;
            
            // 이용기기외 추가인증 신청여부 조회
            self.securityCenterService = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E4149_SERVICE viewController:self] autorelease];
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"업무구분" : @"1", // 1:조회
                                   @"거래구분" : @"1", // 1:이용기기 외 추가인증
                                   }];
            self.securityCenterService.requestData = dataSet;
            
            [self.securityCenterService start];
            
        }   break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        
        // 구 이용PC 사전등록 변경동의화면으로 이동
        SHBOldSecurityViewController *viewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
        
        [self.navigationController pushFadeViewController:viewController];
        
        [viewController release];
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
    
    [self setTitle:@"이용기기 외 추가인증"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용기기 외 추가인증 신청/해제" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
