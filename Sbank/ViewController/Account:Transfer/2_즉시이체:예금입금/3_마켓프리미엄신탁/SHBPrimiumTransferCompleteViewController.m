//
//  SHBPrimiumTransferCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPrimiumTransferCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBPrimiumTransferCompleteViewController ()

@end

@implementation SHBPrimiumTransferCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:
        {
            NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
            if([strController isEqualToString:@"SHBAccountMenuListViewController"]
               || [strController isEqualToString:@"SHBAccountListViewController"])
            {
                [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self.navigationController fadePopToRootViewController];
            }
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

    self.title = @"즉시이체/예금입금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"출금완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData02.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData03.text = AppInfo.commonDic[@"거래일자"];
    
    _lblData04.text = self.data[@"이자계산시작일자"];
    _lblData05.text = self.data[@"이자계산종료일자"];
    
    int amount = [[self.data[@"해지금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    amount = amount + [[self.data[@"세후만기지급금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
    
    _lblData06.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", amount]]];
    _lblData07.text = [NSString stringWithFormat:@"%@원", self.data[@"수탁잔액"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    
    [super viewDidUnload];
}
@end
