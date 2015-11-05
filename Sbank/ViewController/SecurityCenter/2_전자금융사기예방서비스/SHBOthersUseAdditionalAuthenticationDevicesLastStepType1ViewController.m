//
//  SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController ()

@end

@implementation SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController
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
    self.label2 = nil;
    
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
    [self setTitle:@"이용기기 외 추가인증"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용기기 외 추가인증 신청완료" maxStep:5 focusStepNumber:5] autorelease]]; // 서브 타이틀
    
    self.label1.text = AppInfo.commonDic[@"날짜"]; // 신청일
    
    // 300만원 관련 안내문구 가변으로 수정
    self.label2.text = [NSString stringWithFormat:@"인터넷뱅킹, 스마트뱅킹으로 %@ 이상 자금 이체시(1일 누적기준) 미 등록된 이용기기에서 추가인증이 진행 됩니다.", AppInfo.versionInfo[@"추가인증한도금액한글"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
