//
//  SHBLoanCommonInterestInqueryViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanCommonInterestInqueryViewController.h"
#import "SHBLoanCommonInterestPayViewController.h"

@interface SHBLoanCommonInterestInqueryViewController ()
{
    NSString *strAccName;
}
@property (nonatomic, retain) NSString *strAccName;
@end

@implementation SHBLoanCommonInterestInqueryViewController
@synthesize accountInfo;
@synthesize strAccName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            SHBLoanCommonInterestPayViewController *nextViewController = [[[SHBLoanCommonInterestPayViewController alloc] initWithNibName:@"SHBLoanCommonInterestPayViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            nextViewController.data = self.data;
            nextViewController.needsCert = YES;
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 200:
        {
            AppInfo.isNeedClearData = YES;
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
    
    self.title = @"이자조회/납입";
    self.strBackButtonTitle = @"이자조회";
    
    self.strAccName = [accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"];
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:self.strAccName];
    
    NSArray *dataArray = @[
    self.data[@"계좌번호"],
    [SHBUtility getDateWithDash:self.data[@"이자수입종료일자"]],
    [NSString stringWithFormat:@"%@원", self.data[@"정상이자합계금액"]],
    [NSString stringWithFormat:@"%@원", self.data[@"연체이자합계금액"]],
    [NSString stringWithFormat:@"%@원", self.data[@"합계금액"]],
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
    [_lblTitle release];

    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblData:nil];
    [self setLblTitle:nil];
    
    [super viewDidUnload];
}
@end
