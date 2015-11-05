//
//  SHBTransferLimitStep3ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 9. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBTransferLimitStep3ViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBTransferLimitStep3ViewController ()

@end

@implementation SHBTransferLimitStep3ViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            // 확인버튼 선택 시
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
    
    [self navigationBackButtonHidden];
    [self setTitle:@"이체한도감액"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이체한도감액 완료" maxStep:3 focusStepNumber:3] autorelease]]; // 서브 타이틀
    
    self.label1.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"a감액할1일이체한도"]]; // 1일 이체한도
    self.label2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"a감액할1회이체한도"]]; // 1회 이체한도
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
