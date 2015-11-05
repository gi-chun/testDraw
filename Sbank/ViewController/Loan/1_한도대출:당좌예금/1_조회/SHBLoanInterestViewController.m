//
//  SHBLoanInterestViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 18..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanInterestViewController.h"
#import "SHBLoanInterestCell.h"
#import "SHBPeriodPopupView.h"
#import "SHBUtility.h"

@interface SHBLoanInterestViewController ()<SHBPopupViewDelegate>
{
    NSString *strStartDate;
    NSString *strEndDate;
}

@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
- (void)sendRequestListData;
@end

@implementation SHBLoanInterestViewController
@synthesize service;
@synthesize accountInfo;
@synthesize strStartDate;
@synthesize strEndDate;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:   // 조회기간 : 1주일
        {
            self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-8];
            self.strEndDate = [SHBUtility dateStringToMonth:0 toDay:-1];

            [self sendRequestListData];
        }
            break;
        case 101:   // 조회기간 : 15일
        {
            self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-16];
            self.strEndDate = [SHBUtility dateStringToMonth:0 toDay:-1];
            
            [self sendRequestListData];
        }
            break;
        case 102:   // 조회기간 : 1개월
        {
            self.strStartDate = [SHBUtility dateStringToMonth:-1 toDay:-1];
            self.strEndDate = [SHBUtility dateStringToMonth:0 toDay:-1];
            
            [self sendRequestListData];
        }
            break;
        case 103:   // 조회기간 : 기간선택
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            
            NSDate *dateMax = [dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:-1]];
            [dateFormatter release];
            
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:dateMax];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSString *s = [[NSString alloc] initWithData:aContent encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
    [s release];
    
    self.dataList = [aDataSet arrayWithForKey:@"조회내역"];
    [_tableView1 reloadData];
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBLoanInterestCell *cell = (SHBLoanInterestCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanInterestCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBLoanInterestCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    cell.lblData01.text = dictionary[@"거래일자"];
    cell.lblData02.text = [NSString stringWithFormat:@"%@원", [dictionary[@"일반대출금액"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
    cell.lblData03.text = [NSString stringWithFormat:@"%@(%@%%)",
                           [dictionary[@"일반대출이자"] stringByReplacingOccurrencesOfString:@"\\" withString:@""],
                           dictionary[@"일반이율"]];
    cell.lblData04.text = [NSString stringWithFormat:@"%@원", [dictionary[@"연체금액"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
    cell.lblData05.text = [NSString stringWithFormat:@"%@(%@%%)",
                           [dictionary[@"연체이자"] stringByReplacingOccurrencesOfString:@"\\" withString:@""],
                           dictionary[@"연체이율"]];
    
    return cell;
}

#pragma mark - SHBPeriodPopupView
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self sendRequestListData];
}

- (void)popupViewDidCancel
{
    
}

- (void)sendRequestListData
{
    self.dataList = nil;
    [_tableView1 reloadData];
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1150" viewController:self] autorelease];
    
    // release 처리
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"계좌번호" : accountInfo[@"대출계좌번호"],
                            @"정렬구분" : @"1",
                            @"조회시작일자" : strStartDate,
                            @"조회종료일자" : strEndDate,
                            }] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
    
    _lblTerm.text = [NSString stringWithFormat:@"조회기간:%@~%@", strStartDate, strEndDate];
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
    
    self.title = @"대출조회";
    self.strBackButtonTitle = @"한도대출 이자계산 내역조회";
    
    _lblAccNo.text = [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"];
    
    self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-8];
    self.strEndDate = [SHBUtility dateStringToMonth:0 toDay:-1];
    
    [self sendRequestListData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblAccNo release];
    [_lblTerm release];
    [_tableView1 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAccNo:nil];
    [self setLblTerm:nil];
    [self setTableView1:nil];
    [super viewDidUnload];
}
@end
