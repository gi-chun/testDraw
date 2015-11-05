//
//  SHBAutoTransferCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferCompleteViewController.h"
#import "SHBAutoTransferInqueryViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"
#import "SHBAutoTransferAgreeViewController.h"

@interface SHBAutoTransferCompleteViewController ()

@end

@implementation SHBAutoTransferCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            SHBAutoTransferInqueryViewController *nextViewController = [[[SHBAutoTransferInqueryViewController alloc] initWithNibName:@"SHBAutoTransferInqueryViewController" bundle:nil] autorelease];
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 200:
        {
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"자동이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체등록 완료" maxStep:4 focusStepNumber:4] autorelease]];
    
    [self navigationBackButtonHidden];
    
    self.contentScrollView.contentSize = CGSizeMake(317, 400);
    
    NSArray *dataArray = @[
    AppInfo.commonDic[@"출금계좌번호"],
    AppInfo.commonDic[@"입금은행"],
    AppInfo.commonDic[@"입금계좌번호"],
    AppInfo.commonDic[@"입금계좌예금주"],
    AppInfo.commonDic[@"이체금액"],
    [NSString stringWithFormat:@"%@ ~ %@", AppInfo.commonDic[@"이체시작일"], AppInfo.commonDic[@"이체종료일"]],
    AppInfo.commonDic[@"이체주기"],
    AppInfo.commonDic[@"받는통장메모"],
    AppInfo.commonDic[@"내통장메모"],
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
    if(![AppInfo.commonDic[@"입금은행"] isEqualToString:@"신한은행"])
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        btn.hidden = YES;
    }

    // 개인정보동의 여부 전송
    
    for (SHBAutoTransferAgreeViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[SHBAutoTransferAgreeViewController class]]) {
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2316" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:viewController.marketingAgreeDic] autorelease];
            [self.service start];
            
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [_lblData release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblData:nil];
    [super viewDidUnload];
}

@end
