//
//  SHBFraudPreventionSMSNotificationLastStepType2ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBFraudPreventionSMSNotificationLastStepType2ViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBFraudPreventionSMSNotificationLastStepType2ViewController ()

@end

@implementation SHBFraudPreventionSMSNotificationLastStepType2ViewController
@synthesize sumLimitLabel;

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
//            NSLog(@"확인");
            [self.navigationController fadePopToRootViewController];
        }   break;
            
        default:
            break;
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
    self.label1 = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
    [self navigationBackButtonHidden];
    [self setTitle:@"사기예방 SMS 통지"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"사기예방 SMS 통지 해제완료" maxStep:5 focusStepNumber:5] autorelease]]; // 서브 타이틀
    
    self.label1.text = AppInfo.commonDic[@"날짜"]; // 해제일
    
    // 안심거래 예방서비스 가입 여부에 대한 예외처리
    AppInfo.userInfo[@"사기예방SMS통지여부"] = @""; // 공백 : 미가입
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

