//
//  SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController ()

@end

@implementation SHBOthersUseAdditionalAuthenticationDevicesLastStepType2ViewController

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
    
    [self navigationBackButtonHidden];
    [self setTitle:@"이용기기 외 추가인증"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용기기 외 추가인증 해제완료" maxStep:5 focusStepNumber:5] autorelease]]; // 서브 타이틀
    
    self.label1.text = AppInfo.commonDic[@"날짜"]; // 해제일
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
