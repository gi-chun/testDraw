//
//  SHBReservRegDetailViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservRegDetailViewController.h"
#import "SHBReservRegCancelComfirmViewController.h"

@interface SHBReservRegDetailViewController ()

@end

@implementation SHBReservRegDetailViewController
@synthesize infoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 100:   // 예
        {
            SHBReservRegCancelComfirmViewController *nextViewController = [[[SHBReservRegCancelComfirmViewController alloc] initWithNibName:@"SHBReservRegCancelComfirmViewController" bundle:nil] autorelease];
            nextViewController.infoDic = infoDic;
            nextViewController.needsCert = YES;
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 200:   // 아니오
        {
            [self.navigationController fadePopViewController];
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    return NO;
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
    self.strBackButtonTitle = @"예약이체 조회 상세";
    
    _lblData01.text = self.infoDic[@"출금계좌번호"];
    _lblData02.text = [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]];
    _lblData03.text = self.infoDic[@"입금계좌번호"];
    _lblData04.text = self.infoDic[@"입금계좌성명"];
    _lblData05.text = self.infoDic[@"이체금액"];
    _lblData06.text = [NSString stringWithFormat:@"%@ %@", self.infoDic[@"예약처리일자"], self.infoDic[@"예약처리시간"]];
    _lblData07.text = self.infoDic[@"입금계좌통장메모"];
    _lblData08.text = self.infoDic[@"출금계좌통장메모"];
    _lblData09.text = self.infoDic[@"CMS코드"];
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
    [_lblData08 release];
    [_lblData09 release];
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
    [self setLblData08:nil];
    [self setLblData09:nil];
    [super viewDidUnload];
}
@end
