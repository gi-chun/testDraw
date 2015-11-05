//
//  SHBReservRegCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservRegCancelCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBReservRegCancelCompleteViewController ()

@end

@implementation SHBReservRegCancelCompleteViewController
@synthesize infoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            [AppDelegate.navigationController fadePopToRootViewController];
//            [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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

    self.title = @"기타이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예약이체 취소완료" maxStep:2 focusStepNumber:2] autorelease]];
    
    [self navigationBackButtonHidden];
    
    NSArray *dataArray = @[
    self.infoDic[@"예약처리일자"],
    self.infoDic[@"예약처리시간"],
    self.infoDic[@"출금계좌번호"],
    [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]],
    self.infoDic[@"입금계좌번호"],
    self.infoDic[@"입금계좌성명"],
    self.infoDic[@"이체금액"],
    self.infoDic[@"입금계좌통장메모"],
    self.infoDic[@"출금계좌통장메모"],
    self.infoDic[@"CMS코드"],
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

- (void)dealloc {
    [_lblData release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData:nil];
    [super viewDidUnload];
}

@end
