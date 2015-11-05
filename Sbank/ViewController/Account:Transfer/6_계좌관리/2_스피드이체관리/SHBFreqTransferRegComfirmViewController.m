//
//  SHBFreqTransferRegComfirmViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqTransferRegComfirmViewController.h"
#import "SHBFreqTransferRegCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBFreqTransferRegComfirmViewController ()

@end

@implementation SHBFreqTransferRegComfirmViewController
@synthesize nType;  // 0 : 등록, 1 : 변경, 9 : 등록(이체화면에서 올경우) 
@synthesize service;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            if(nType == 1)
            {
                self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_UPDATE viewController:self] autorelease];
                self.service.previousData = (SHBDataSet *)self.data;
                [self.service start];
            }
            else
            {
                self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_INSERT viewController:self] autorelease];
                self.service.previousData = (SHBDataSet *)self.data;
                [self.service start];
            }
        }
            break;
        case 200:
        {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:NSClassFromString(@"SHBFreqTransferListViewController")]) {
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    NSString *strMessage = @"";
    
    if(nType == 1)
    {
        strMessage = @"스피드이체가 변경되었습니다.";
    }
    else
    {
        strMessage = @"스피드이체가 등록되었습니다.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:strMessage
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if(nType == 9)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
    else
    {
        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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

    self.title = @"계좌관리";
    
    if(nType == 1)
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"스피드이체변경 확인" maxStep:2 focusStepNumber:2] autorelease]];
    }
    else
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"스피드이체등록 확인" maxStep:2 focusStepNumber:2] autorelease]];
    }
    
    NSArray *dataArray = @[
    self.data[@"입금계좌별명"],
    self.data[@"출금계좌번호"],
    self.data[@"입금은행"],
    self.data[@"입금계좌번호"],
    self.data[@"입금자명"],
    [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:self.data[@"이체금액"]]],
    [SHBUtility substring:self.data[@"받는분통장메모"] ToMultiByteLength:14],
    [SHBUtility substring:self.data[@"보내는분통장메모"] ToMultiByteLength:14],
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
