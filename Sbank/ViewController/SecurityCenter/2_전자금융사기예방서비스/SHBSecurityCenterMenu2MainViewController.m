//
//  SHBSecurityCenterMenu2MainViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 26..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSecurityCenterMenu2MainViewController.h"
#import "SHBOthersUseAdditionalAuthenticationDevicesViewController.h"
#import "SHBFraudPreventionSMSNotificationViewController.h"

@interface SHBSecurityCenterMenu2MainViewController ()

@end

@implementation SHBSecurityCenterMenu2MainViewController
@synthesize sumLimitLabel;

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    NSString *stringTemp = nil;
    
    switch ([sender tag]) {
        case 0:
        {
//            NSLog(@"이용기기 외 추가인증 버튼");
            stringTemp = @"SHBOthersUseAdditionalAuthenticationDevicesViewController";
        }   break;
        case 1:
        {
//            NSLog(@"사기예방 SMS 통지 버튼");
            stringTemp = @"SHBFraudPreventionSMSNotificationViewController";
        }   break;
            
        default:
            break;
    }
    
    if (stringTemp != nil) {
        
        SHBBaseViewController *viewController = [[NSClassFromString(stringTemp) alloc] initWithNibName:stringTemp bundle:nil];
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
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
    self.scrollView1 = nil;
    self.contentView = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //ios7 + xcode5 대응
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.scrollView1 setFrame:CGRectMake(self.scrollView1.frame.origin.x, self.scrollView1.frame.origin.y + 20, self.scrollView1.frame.size.width, self.scrollView1.frame.size.height - 20)];
    }
   // self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
    [self setTitle:@"전자금융 사기예방 서비스"]; // 네비게이션 바 타이틀
    self.scrollView1.contentSize = self.contentView.frame.size; // 스크롤 뷰의 컨텐츠 사이즈 지정
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
