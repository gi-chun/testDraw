//
//  SHBInterestInqueryViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBInterestInqueryViewController.h"
#import "SHBLoanInterestPayViewController.h"

@interface SHBInterestInqueryViewController ()
{
    BOOL isNotNeed;
    NSString *strAccName;
}
@property (nonatomic, retain) NSString *strAccName;
@end

@implementation SHBInterestInqueryViewController
@synthesize service;
@synthesize accountInfo;
@synthesize strAccName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            if(isNotNeed)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"납부하실 이자 금액이 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            if([self.data[@"한도초과미수이자"] intValue] != 0 || 
               [self.data[@"한도미사용수수료"] intValue] != 0 ||
               [self.data[@"카드론미수수수료"] intValue] != 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"한도초과미수이자, 한도미사용수수료, 카드론미수수수료는 영업점에서만 납입 가능 합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            SHBLoanInterestPayViewController *nextViewController = [[[SHBLoanInterestPayViewController alloc] initWithNibName:@"SHBLoanInterestPayViewController" bundle:nil] autorelease];
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

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.data = aDataSet;
    
    isNotNeed = [aDataSet[@"이자합계금액"] intValue] == 0 ? YES : NO;
    
    NSArray *dataArray = @[
    aDataSet[@"한도대출계좌번호"],
    [NSString stringWithFormat:@"%@원", aDataSet[@"이자금액"]],
    [NSString stringWithFormat:@"%@원", aDataSet[@"한도초과미수이자"]],
    [NSString stringWithFormat:@"%@원", aDataSet[@"한도미사용수수료"]],
    [NSString stringWithFormat:@"%@원", aDataSet[@"카드론미수수수료"]],
    [NSString stringWithFormat:@"%@원", aDataSet[@"이자합계금액"]],
    ];
    
    for(int i = 1; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
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
    
    self.title = @"이자조회/납입";
    self.strBackButtonTitle = @"대출이자 조회";
    
    // Push, SMS, Smart Letter등으로 실행된 경우
    if(self.isPushAndScheme)
    {
        
    }
    
    isNotNeed = NO;
    
    self.strAccName = [accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"];
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:self.strAccName];
    
    NSArray *dataArray = @[
    [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
    @"0원",
    @"0원",
    @"0원",
    @"0원",
    @"0원",
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1230" viewController: self] autorelease];
    
    SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"한도대출계좌번호" : accountInfo[@"대출계좌번호"],
                            }];
    
    self.service.requestData = aDataSet;
    [self.service start];
    [aDataSet release];
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
