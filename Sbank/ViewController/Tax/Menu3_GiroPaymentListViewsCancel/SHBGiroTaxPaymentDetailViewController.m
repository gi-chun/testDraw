//
//  SHBGiroTaxPaymentDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 31..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxPaymentDetailViewController.h"
#import "SHBCancelSecurityViewController.h"         // 다음 View


@interface SHBGiroTaxPaymentDetailViewController ()

@end

@implementation SHBGiroTaxPaymentDetailViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:            // 납부취소 버튼
        {
            SHBCancelSecurityViewController *viewController = [[SHBCancelSecurityViewController alloc] initWithNibName:@"SHBCancelSecurityViewController" bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
            
        case 12:            // 조회확인 버튼
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        case 13:            // 오늘 날짜가 아닐 경우 확인 버튼
        {
            [self.navigationController fadePopViewController];
        }
            
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"지로납부내역 조회취소";
    self.strBackButtonTitle = @"지로납부내역 조회취소 1단계";
    
    label1.text = [dicDataDictionary objectForKey:@"납부일자"];
    label2.text = [dicDataDictionary objectForKey:@"출금계좌번호"];
    label3.text = [dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [dicDataDictionary objectForKey:@"이용기관지로번호"];
    label5.text = [NSString stringWithFormat:@"%@원", [dicDataDictionary objectForKey:@"납부금액"]];
    
    if ( [AppInfo.tran_Date isEqualToString:[dicDataDictionary objectForKey:@"납부일자"]] )
    {
        // 취소가 가능한 경우
        viewConfirmView.hidden = YES;
        viewCancelView.hidden = NO;
    }
    else        // 오늘 납부한 것이 아닌 경우 납부 취소가 불가
    {
        viewConfirmView.hidden = NO;
        viewCancelView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
