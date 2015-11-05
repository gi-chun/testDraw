//
//  SHBDeviceRegistServiceCloseInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceCloseInfoViewController.h"
#import "SHBIdentity1ViewController.h" // 추가인증 방법 선택 화면

@interface SHBDeviceRegistServiceCloseInfoViewController () <SHBIdentity1Delegate>

@end

@implementation SHBDeviceRegistServiceCloseInfoViewController
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
    
    [self setTitle:@"이용기기 등록 서비스"];
    self.strBackButtonTitle = @"이용기기 등록 서비스 해지";
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
}

- (void)didReceiveMemoryWarning
{
    [sumLimitLabel release];
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_checkBtn release];
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
                       message:@"이용기기 등록 서비스 해지 주의사항을 읽고 동의하셔야 서비스 해지가 가능합니다."];
        
        return;
    }
    
    AppInfo.transferDic = @{ @"서비스코드" : @"E3012" };
    
    SHBIdentity1ViewController *viewController = [[[SHBIdentity1ViewController alloc] initWithNibName:@"SHBIdentity1ViewController" bundle:nil] autorelease];
    
    [viewController setServiceSeq:SERVICE_DEVICE_REGIST];
    [viewController setNeedsLogin:YES];
    [viewController setDelegate:self];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    [viewController executeWithTitle:@"이용기기 등록 서비스"
                            subTitle:@"추가인증 방법 선택"
                                step:2
                           stepCount:6
                  nextViewController:@"SHBDeviceRegistServiceCloseConfirmViewController"];
}

- (IBAction)cancelButton:(id)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
    
    [_checkBtn setSelected:NO];
}

@end
