//
//  SHBCardSSOAgreeDumyViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 18..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBCardSSOAgreeDumyViewController.h"
#import "SHBVersionService.h"
#import "SHBCareAgreeCompleteViewController.h"

@interface SHBCardSSOAgreeDumyViewController ()

@end

@implementation SHBCardSSOAgreeDumyViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.view.hidden = YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"신한카드"];
    [self navigationBackButtonHidden];
    
    //[self navigationViewHidden];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    // 전자서명 확인
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(getElectronicSignResult:)
//                                                 name:@"eSignFinalData"
//                                               object:nil];
//    
//    //전자 서명 취소를 받는다
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
//    
//    // 전자서명 에러
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"신한카드";
//    
    AppInfo.electronicSignCode = @"SSO012";
    AppInfo.electronicSignTitle = @"신한카드 이용약관 동의";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:@"(3)서비스명: 신한카드 이용약관동의"];
    
    //        self.service = nil;
    //        self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:SERVICE_CARDSSO_AGREE viewController:self] autorelease];
    //        //self.service.requestData = aDataSet;
    //        [self.service start];
    
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKSsoService",
                                    TASK_ACTION_KEY : @"insertGroupSsoAgree",
                                    @"deviceId" : [AppDelegate getSSODeviceID],
                                    @"appStatus" : @"MAKE",
                                    @"GROUP_CODE" : @"S012",
                                    //@"COM_SUBCHN_KBN" :@"02",
                                }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:CARD_SSO_AGREE viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
     
     // dealloc bug 관련
     for (UIViewController *viewController in self.navigationController.viewControllers)
     {
         if ([viewController isKindOfClass:[NSClassFromString(@"SHBCardAgreeViewController") class]])
         {
             [[NSNotificationCenter defaultCenter] removeObserver:viewController];
             
             break;
         }
     }
     
     if (!AppInfo.errorType)
     {
        
         SHBCareAgreeCompleteViewController *viewController = [[[SHBCareAgreeCompleteViewController alloc] initWithNibName:@"SHBCareAgreeCompleteViewController" bundle:nil] autorelease];
         [self checkLoginBeforePushViewController:viewController animated:YES];
     }
     
}
// 전자서명 취소시
- (void)getElectronicSignCancel
{
//    [AppDelegate.navigationController fadePopViewController];
//    [AppDelegate.navigationController fadePopViewController];
//    [AppDelegate.navigationController fadePopViewController];
//    [AppDelegate.navigationController fadePopViewController];
//    [AppDelegate.navigationController fadePopViewController];
}
@end
