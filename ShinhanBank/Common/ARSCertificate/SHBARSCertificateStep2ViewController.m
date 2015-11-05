//
//  SHBARSCertificateStep2ViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBARSCertificateStep2ViewController.h"
#import "SHBMobileCertificateService.h"
#import "SHBOldSecurityViewController.h"
#import "SHBNoCertForCertLogInViewController.h"

@interface SHBARSCertificateStep2ViewController ()

- (void)confirmARSCert;
- (void)serverErrorOccure;

- (IBAction)cancelBtn:(id)sender;
@end

@implementation SHBARSCertificateStep2ViewController
@synthesize realNumber, certCode, arsType, serviceCode;
@synthesize serviceSeq;
@synthesize isAllidentity;
@synthesize arsStartTime;
@synthesize arsCancelTime;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [serviceCode release];
    [arsType release];
    [realNumber release];
    [certCode release];
	[_nextViewControlName release];
	
    [agreeButton release];
    [_stepView release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)navigationButtonPressed:(id)sender
{
 
    self.arsCancelTime = [[NSDate date] timeIntervalSince1970];
    
    self.arsDifferTime = self.arsCancelTime - self.arsStartTime;
    NSLog(@"aaaa:%f", self.arsDifferTime);
    
    if (self.arsDifferTime < AppInfo.arsLimtTime)
    {
        int limtTime = (int)AppInfo.arsLimtTime / 60;
        
        NSString *msg = [NSString stringWithFormat:@"ARS 신청중입니다.\n신청후 %i분 이후에\n이전으로 이동이 가능합니다.",limtTime];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:17456 title:nil message:msg];
        return;
    }
    [super navigationButtonPressed:sender];
    
    if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
    {
        UIButton *btnSender = (UIButton*)sender;
        switch (btnSender.tag)
        {
            case NAVI_CLOSE_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
            case QUICK_HOME_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arsStartTime = [[NSDate date] timeIntervalSince1970];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverErrorOccure) name:@"notiServerError" object:nil];
    
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER)
    {
        [self navigationBackButtonHidden];
        [self quickMenuHidden];
        self.subTitleLabel.text = @"의심거래 방지를 위한 본인 확인 절차 강화";
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_NOTI_BTN_TAG];
        [tmpBtn setHidden:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [agreeButton release];
    agreeButton = nil;
    [_stepView release];
    _stepView = nil;
    [super viewDidUnload];
}

#pragma mark - 

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName Info:(NSDictionary *)info
{
	
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
    
	infoDic = [info copy];
    
    [self.binder bind:self dataSet:[OFDataSet dictionaryWithDictionary:infoDic]];
	
	if (nextCtrlName) {
		SafeRelease(_nextViewControlName);
		_nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
	
	[self setTitle:aTitle];
	
	// Max 10개까지만 Step 단계표시
    if (!self.isAllidentity)
    {
        if (stepCnt < 11) {
            UIButton	*stepButtn;
            
            for (int i=stepCnt; i>=1; i --) {
                // step button setting
                stepButtn = (UIButton*)[self.view viewWithTag:i];
                float stepWidth = stepButtn.frame.size.width;
                float stepX = 311 - ((stepWidth+2) * ((stepCnt+1) - i));
                [stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
                [stepButtn setHidden:NO];
                
                if (step >= i){
                    stepButtn.selected = YES;
                }else{
                    stepButtn.selected = NO;
                }
            }
        }
    }
	
}

#pragma mark - Button

- (IBAction)agreeBtn:(id)sender
{
    [sender setSelected:![sender isSelected]];
}

- (IBAction)okBtn:(id)sender
{
    //NSLog(@"appinfo.userinfo:%@",AppInfo.userInfo);
    if (![agreeButton isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"ARS 추가인증 완료여부에 체크하셔야 합니다."];
        return;
    }
    [self confirmARSCert];
    
    
}

- (IBAction)cancelBtn:(id)sender
{
    
    self.arsCancelTime = [[NSDate date] timeIntervalSince1970];
    
    self.arsDifferTime = self.arsCancelTime - self.arsStartTime;
    NSLog(@"aaaa:%f", self.arsDifferTime);
    
    if (self.arsDifferTime < AppInfo.arsLimtTime)
    {
        int limtTime = (int)AppInfo.arsLimtTime / 60;
        
        NSString *msg = [NSString stringWithFormat:@"ARS 신청중입니다.\n신청후 %i분 이후에\n이전으로 이동이 가능합니다.",limtTime];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:17456 title:nil message:msg];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(ARSCertificateStep2Back)]) {
        [_delegate ARSCertificateStep2Back];
    }
    
    [AppDelegate.navigationController fadePopViewController];
}

- (void)confirmARSCert
{
    
    //NSString *taskType = [NSString stringWithFormat:@"0%i",self.serviceSeq];
    NSString *taskType = self.arsType;
    
    AppInfo.serviceCode = @"ARS_VERFY_CERT";
    
    if (AppInfo.isLogin == LoginTypeNo)
    {
        NSString *goodsCode = AppInfo.transferDic[@"계좌번호_상품코드"];
        NSString *amount = AppInfo.transferDic[@"거래금액"];
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"구분" : self.certCode,
                               @"거래구분" : taskType,
                               @"인증구분" : @"02",
                               @"신청번호" : self.realNumber,
                               @"고객번호" : [SHBUtility nilToString:AppInfo.customerNo],
                               //@"주민번호" : [SHBUtility nilToString:[AppInfo getPersonalPK]],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               //ARS 인증전문 추가
                               @"계좌번호_상품코드" : [SHBUtility nilToString:goodsCode],
                               @"거래금액" : [SHBUtility nilToString:amount],
                               @"서비스코드" : self.serviceCode,
                               }];
        
        SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_VERIFY_GUEST_URL, self, dataSet);
        Debug(@"request : %@", dataSet);
        
    }else
    {
        NSString *goodsCode = AppInfo.transferDic[@"계좌번호_상품코드"];
        NSString *amount = AppInfo.transferDic[@"거래금액"];
        NSLog(@"aaa:%@",self.certCode);
        NSLog(@"bbb:%@",taskType);
        NSLog(@"ccc:%@",self.realNumber);
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"구분" : self.certCode,
                               @"거래구분" : taskType,
                               @"인증구분" : @"02",
                               @"신청번호" : self.realNumber,
                               @"고객번호" : [SHBUtility nilToString:AppInfo.customerNo],
                               //@"주민번호" : [SHBUtility nilToString:[AppInfo getPersonalPK]],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               //ARS 인증전문 추가
                               @"계좌번호_상품코드" : [SHBUtility nilToString:goodsCode],
                               @"거래금액" : [SHBUtility nilToString:amount],
                               @"서비스코드" : self.serviceCode,
                               }];
        
        SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_VERIFY_URL, self, dataSet);
        Debug(@"request : %@", dataSet);
    }
    
    
    
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    
    if (AppInfo.errorType) {
        return;
    }
    
    NSString *result = dataSet[@"처리결과"];
    if ([result isEqualToString:@"01"])
    {
        
        if (self.serviceSeq == SERVICE_IP_CHECK)
        {
            //전자금융 의심거래 ARS 인증 처리
            NSString *msg = @"본인확인 추가인증이\n완료되었습니다.\n감사합니다.";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:4765 title:nil message:msg];
            return;
        }
        
        if (self.serviceSeq == SERVICE_2MONTH_OVER)
        {
            //2개월 이상 이체안한 ARS 인증 처리
            NSString *msg = @"본인확인 추가인증이\n완료되었습니다.\n감사합니다.";
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:nil message:msg];
            [AppDelegate.navigationController fadePopToRootViewController];
            SHBBaseViewController *viewController = [[[[NSClassFromString(@"SHBAccountMenuListViewController") class] alloc] initWithNibName:@"SHBAccountMenuListViewController" bundle:nil] autorelease];
            //[AppDelegate.navigationController pushFadeViewController:viewController];
            viewController.needsLogin = YES;
            [AppDelegate.navigationController.viewControllers[0] checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];
            return;
        }
        
        if (AppInfo.isAllIdenty && AppInfo.isSMSIdenty)
        {
            AppInfo.isAllIdenty = NO;
            AppInfo.isSMSIdenty = NO;
            AppInfo.isARSIdenty = NO;
            AppInfo.isAllIdentyDone = YES;
        }
        
        [agreeButton setSelected:NO];
        
        if (_nextViewControlName) {
            // 다음에 열릴 클래스 오픈
            
            SHBBaseViewController *viewController = [[[[NSClassFromString(_nextViewControlName) class] alloc] initWithNibName:_nextViewControlName bundle:nil] autorelease];
            
            viewController.needsLogin = NO;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
        } else {
            int objectIndex = [[AppDelegate.navigationController viewControllers] count] - 4;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:objectIndex] viewControllerDidSelectDataWithDic:nil];
        }
    }else if ([result isEqualToString:@"02"])
    {
        NSString *msg = @"고객확인을 위한 ARS 추가인증 진행됩니다. 인증이 완료될때까지 현재화면을 유지하여 주십시요.";
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"처리가 완료되지 않았습니다."];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:msg];
        
    }else if ([result isEqualToString:@"03"])
    {
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"오류가 발생했습니다."];
        NSString *msg = @"고객확인을 위한 추가인증결과 오류 입니다. 확인 후 거래하여 주시기 바랍니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:msg];
    }
    
}

- (void)serverErrorOccure
{
    //NSLog(@"error messgae:%@",AppInfo.serverErrorMessage);
//    if ([SHBUtility isFindString:AppInfo.serverErrorMessage find:@"추가인증 결과 오류"])
//    {
//        
//        [AppDelegate.navigationController fadePopViewController];
//    }
}

#pragma mark - 얼럿뷰 델리게이트
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4765)
    {
        //[AppInfo logout];
        [AppDelegate.navigationController fadePopToRootViewController];
        AppInfo.isCheatDefanceAgree = YES;
        AppInfo.isOldPCRegister = YES;
        
        if ([AppInfo.userInfo[@"구PC등록동의여부"] isEqualToString:@"0"])
        {
            AppInfo.isOldPCRegister = NO;
            if (AppInfo.isLogin == LoginTypeIDPW )
            {
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:4767 title:nil message:@"구 서비스(구 사기예방서비스 또는 구 이용PC사전등록 서비스) 변경동의 대상 고객입니다. 변경동의를 위해서 공인인증서 로그인이 필요합니다. 공인인증서 로그인을 하시겠습니까?"];
                
            }else
            {
                
                //구PC등록동의여부
                
                SHBOldSecurityViewController *regPwViewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
                
                [AppDelegate.navigationController pushFadeViewController:regPwViewController];
                [regPwViewController release];
            }
        }
        
    }else if (alertView.tag == 4767)
    {
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        if (buttonIndex == 0)
        {
            if (AppInfo.certificateCount < 1)
            {
                SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                return;
            }
            
            if (AppInfo.certificateCount == 1)
            {
                
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                UIViewController *certController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:certController];
                [certController release];
                
            }else
            {
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                UIViewController *certController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:certController];
                [certController release];
            }
            
        }
    }else if (alertView.tag == 17456)
    {
        
    }
}
@end
