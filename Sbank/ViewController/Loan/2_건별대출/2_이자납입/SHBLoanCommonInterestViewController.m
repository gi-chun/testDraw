//
//  SHBLoanCommonInterestViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanCommonInterestViewController.h"
#import "SHBLoanCommonInterestInqueryViewController.h"

@interface SHBLoanCommonInterestViewController ()
{
    NSString *strAccName;
}
@property (nonatomic, retain) NSString *strAccName;
@end

@implementation SHBLoanCommonInterestViewController
@synthesize service;
@synthesize accountInfo;
@synthesize strAccName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1210" viewController: self] autorelease];
            
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"계좌번호" : accountInfo[@"대출계좌번호"],
                                    @"이자수입종료일자" : [_standardDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                                    }];
            
            self.service.requestData = aDataSet;
            [self.service start];
            [aDataSet release];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.data = aDataSet;
    
    SHBLoanCommonInterestInqueryViewController *nextViewController = [[[SHBLoanCommonInterestInqueryViewController alloc] initWithNibName:@"SHBLoanCommonInterestInqueryViewController" bundle:nil] autorelease];
    nextViewController.accountInfo = self.accountInfo;
    nextViewController.data = self.data;
    [self.navigationController pushFadeViewController:nextViewController];
    
    return NO;
}

#pragma mark - Delegate : SHBDateFieldDelegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
{
	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
}

- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date
{
	NSLog(@"=====>>>>>>> [11] DatePicker 데이터 변경시");
}

- (void)didPrevButtonTouchWithdateField:(SHBDateField*)dateField
{
	NSLog(@"=====>>>>>>> [12] DatePicker 이전버튼");
}

- (void)didNextButtonTouchWithdateField:(SHBDateField*)dateField
{
	NSLog(@"=====>>>>>>> [13] DatePicker 다음버튼");
}

- (void)currentDateField:(SHBDateField *)dateField
{
	NSLog(@"=====>>>>>>> [14] 현재 데이트 피커 : 데이트 피커의 위치이동이 필요할시 작성");
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
    
    self.strBackButtonTitle = @"이자납입 기준일";
    
    self.strAccName = [accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"];
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:self.strAccName];
    
    _lblAccNo.text = [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"];
    
	[_standardDate initFrame:_standardDate.frame];
    _standardDate.textField.font = [UIFont systemFontOfSize:15];
    _standardDate.textField.textAlignment = UITextAlignmentLeft;
    _standardDate.delegate = self;

    _standardDate.textField.text = [SHBUtility dateStringToMonth:0 toDay:-1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        _standardDate.textField.text = [SHBUtility dateStringToMonth:0 toDay:-1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_lblAccNo release];
    [_lblTitle release];
    [_standardDate release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblAccNo:nil];
    [self setLblTitle:nil];
    [self setStandardDate:nil];

    [super viewDidUnload];
}
@end
