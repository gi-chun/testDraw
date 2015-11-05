//
//  SHBEasyCloseInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseInfoViewController.h"
#import "SHBEasyCloseListViewController.h" // 신한e-간편해지 계좌 목록

@interface SHBEasyCloseInfoViewController ()

@end

@implementation SHBEasyCloseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"신한e-간편해지"];
    self.strBackButtonTitle = @"신한e-간편해지 안내";
    
    [self.contentScrollView addSubview:_mainV];
    [self.contentScrollView setContentSize:_mainV.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainV:nil];
    [super viewDidUnload];
}

#pragma mark - 

- (IBAction)buttonPressed:(id)sender
{
    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger time = [[SHBUtility getCurrentTime] integerValue];
        
    if (![SHBUtility isOPDate:date] || time < 90000 || 213000 < time) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"예금해지 가능시간은 평일 09:00 ~ 21:30 입니다."];
        return;
    }
    
    SHBEasyCloseListViewController *viewController = [[[SHBEasyCloseListViewController alloc] initWithNibName:@"SHBEasyCloseListViewController" bundle:nil] autorelease];
    
    [viewController setNeedsCert:YES];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
