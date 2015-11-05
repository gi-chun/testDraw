//
//  SHBOldSecurityChangeViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOldSecurityChangeViewController.h"
#import "SHBOldSecurityChangeEndViewController.h"
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBUtilFile.h" // 유틸

@interface SHBOldSecurityChangeViewController ()

@end

@implementation SHBOldSecurityChangeViewController

@synthesize sumLimitLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
    
    [self setTitle:@"구 사기예방서비스 변경"];
    self.strBackButtonTitle = @"구 사기예방서비스 변경";
    [self initNotification];
    
//    [_infoLabel1 setText:[NSString stringWithFormat:@"인터넷뱅킹, 스마트뱅킹으로 %@ 이상 자금이체시(1일 누적기준) 추가인증이 생략되고 고객정보의 휴대폰번호로 SMS가 통보되는 서비스입니다.",
//                          AppInfo.versionInfo[@"추가인증한도금액한글"]]];
//    
//    [_infoLabel2 setText:[NSString stringWithFormat:@"대상거래 : 인터넷뱅킹, 스마트뱅킹으로 1일 누적 %@ 이상 자금 이체시",
//                          AppInfo.versionInfo[@"추가인증한도금액한글"]]];
//    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_checkBtn release];
    [_infoLabel1 release];
    [_infoLabel2 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCheckBtn:nil];
    [super viewDidUnload];
}



#pragma mark - Button

- (IBAction)checkButton:(id)sender
{
    [sender setSelected:![sender isSelected]];
}

- (IBAction)okButton:(id)sender
{
    if (![_checkBtn isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"구 사기예방서비스 변경에 동의하신 후, 진행하실 수 있습니다."];
        
        return;
    }
    
    
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"구 사기예방서비스 변경";
    
    AppInfo.electronicSignCode = @"E3025";
    AppInfo.electronicSignTitle = @"구 사기예방서비스 변경에 동의하며, 사기예방SMS통지서비스를 신청합니다.";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"신청내용"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)등록일시: %@", AppInfo.tran_Date]];

    self.service = nil;
    self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3025_SERVICE viewController:self] autorelease];
    
    [self.service start];
    
}



- (IBAction)cancelButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController fadePopToRootViewController];
}




#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    if (!AppInfo.errorType) {
        NSLog(@"!!%@", self.service.requestData);
        NSLog(@"!!%@", self.service.responseData);
        
        
        SHBOldSecurityChangeEndViewController *viewController = [[[SHBOldSecurityChangeEndViewController alloc] initWithNibName:@"SHBOldSecurityChangeEndViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
        AppInfo.isCheatDefanceAgree = YES;
    }
}

- (void)getElectronicSignCancel
{
//    [self initNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 
    
    [self.navigationController fadePopViewController];
     _checkBtn.selected = NO;
    

}

#pragma mark -

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}
@end