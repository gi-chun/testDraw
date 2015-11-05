//
//  SHBDeviceRegistServiceAddInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceAddInfoViewController.h"
#import "SHBDeviceRegistServiceAddInputViewController.h" // 별명 및 추가인증 방법 선택

@interface SHBDeviceRegistServiceAddInfoViewController ()

@end

@implementation SHBDeviceRegistServiceAddInfoViewController
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
    self.strBackButtonTitle = @"이용기기 등록 주의사항";
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
}

- (void)didReceiveMemoryWarning
{
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
                       message:@"이용기기 등록 서비스 주의사항을 읽고 동의하셔야 등록이 가능합니다."];
        
        return;
    }
    
    SHBDeviceRegistServiceAddInputViewController *viewController = [[[SHBDeviceRegistServiceAddInputViewController alloc] initWithNibName:@"SHBDeviceRegistServiceAddInputViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)cancelButton:(id)sender
{
    [self.navigationController fadePopViewController];
}

@end
