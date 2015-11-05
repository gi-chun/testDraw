//
//  SHBCallCenterListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCallCenterListViewController.h"

@interface SHBCallCenterListViewController ()

@end

@implementation SHBCallCenterListViewController


- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSString *strNumber = @"";
    
    switch ([sender tag])
    {
        case 10: // 각종상담 문의
        {
            strNumber = @"telprompt://1577-8000";
        }
            break;
            
        case 20: // 스마트금융 문의
        {
            strNumber = @"telprompt://1588-8641";
        }
            break;
            
        case 30: // 스마트 펀드센터
        {
            strNumber = @"telprompt://1599-7100";
        }
            break;
            
        case 40: // 스마트 론센터
        {
            strNumber = @"telprompt://1588-8641,1";
        }
            break;
            
        case 50: // 스마일
        {
            strNumber = @"telprompt://1588-8641,2";
        }
            break;
            
        case 60: // 미션플러스
        {
            strNumber = @"telprompt://1588-8641,3";
        }
            break;
            
        case 70: // 패밀리뱅킹
        {
            strNumber = @"telprompt://1588-8641,4";
        }
            break;
            
        case 80: // 머니멘토
        {
            strNumber = @"telprompt://1588-8641,5";
        }
            break;
            
        case 90: // 신한카드 문의
        {
            strNumber = @"telprompt://1544-7000";
        }
            break;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"전화상담/문의";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
