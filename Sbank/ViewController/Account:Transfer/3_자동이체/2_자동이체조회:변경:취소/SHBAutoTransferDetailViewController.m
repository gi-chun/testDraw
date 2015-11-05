//
//  SHBAutoTransferDetailViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferDetailViewController.h"
#import "SHBAutoTransferEditViewController.h"
#import "SHBAutoTransferCancelComfirmViewController.h"

@interface SHBAutoTransferDetailViewController ()

@end

@implementation SHBAutoTransferDetailViewController
@synthesize nType;
@synthesize strAccNo;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:
        {
            SHBAutoTransferEditViewController *nextViewController = [[[SHBAutoTransferEditViewController alloc] initWithNibName:@"SHBAutoTransferEditViewController" bundle:nil] autorelease];
            nextViewController.data = self.data;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 200:
        {
            SHBAutoTransferCancelComfirmViewController *nextViewController = [[[SHBAutoTransferCancelComfirmViewController alloc] initWithNibName:@"SHBAutoTransferCancelComfirmViewController" bundle:nil] autorelease];
            nextViewController.data = self.data;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 300:
        {
            [self.navigationController fadePopViewController];
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
    self.strBackButtonTitle = @"자동이체 조회 상세";
    
    if(nType == 0 && ![self.data[@"이체금액"] isEqualToString:@"0"])
    {
        _lblTitle.text = @"자동이체 조회/변경/취소";
    }
    else
    {
        _lblTitle.text = @"자동이체 조회 상세";
        
        _changeView.hidden = YES;
        _comfirmView.frame = _changeView.frame;
        
        if(nType == 0) _infoView.hidden = NO;
    }
    
    NSString *strAccName = self.data[@"입금계좌상품명"];
    NSString *strBankName = [AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]];

    [_lblAccInfo initFrame:_lblAccInfo.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    
    if ([SHBUtility isFindString:strBankName find:@"신한은행"]) {
        [_lblAccInfo setCaptionText:[NSString stringWithFormat:@"%@ %@", self.data[@"입금계좌번호표시용"], strAccName]];
    }
    else {
        [_lblAccInfo setCaptionText:self.data[@"입금계좌번호"]];
    }
    
    NSArray *dataArray = @[
    strBankName,
    self.data[@"입금계좌성명"],
    [NSString stringWithFormat:@"%@원", self.data[@"이체금액"]],
    [NSString stringWithFormat:@"%@ ~ %@", self.data[@"이체시작일자"], self.data[@"이체종료일자"] != nil ? self.data[@"이체종료일자"] : @""],
    self.data[@"해지일자"] != nil ? self.data[@"해지일자"] : @"",
    self.data[@"이체일자"],
    self.data[@"이체주기->display"] != nil ? self.data[@"이체주기->display"] : @"1개월",
    self.data[@"입금계좌통장메모"],
    self.data[@"타행수취인명"],
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
    [_lblTitle release];
    [_lblData release];
    [_lblAccInfo release];
    [_changeView release];
    [_comfirmView release];
    [_infoView release];

    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblTitle:nil];
    [self setLblData:nil];
    [self setChangeView:nil];
    [self setComfirmView:nil];
    [self setInfoView:nil];

    [super viewDidUnload];
}
@end
