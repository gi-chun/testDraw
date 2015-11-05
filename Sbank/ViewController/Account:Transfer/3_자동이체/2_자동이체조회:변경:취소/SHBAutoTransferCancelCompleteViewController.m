//
//  SHBAutoTransferCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferCancelCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferCancelCompleteViewController ()

@end

@implementation SHBAutoTransferCancelCompleteViewController

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
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체 취소 완료" maxStep:2 focusStepNumber:2] autorelease]];
    
    [self navigationBackButtonHidden];
    
    NSString *strBankName = [AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]];
    
    NSArray *dataArray = @[
    self.data[@"출금계좌번호"],
    strBankName,
    self.data[@"_입금계좌번호"],
    self.data[@"입금계좌성명"],
    [NSString stringWithFormat:@"%@원", self.data[@"이체금액"]],
    [NSString stringWithFormat:@"%@ ~ %@", self.data[@"이체시작일자"], self.data[@"이체종료일자"]],
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
