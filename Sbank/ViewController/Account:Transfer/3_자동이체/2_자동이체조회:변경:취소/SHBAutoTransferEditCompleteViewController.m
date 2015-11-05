//
//  SHBAutoTransferEditCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferEditCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferEditCompleteViewController ()

@end

@implementation SHBAutoTransferEditCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
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
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체 변경 완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
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
