//
//  SHBGiroTaxPaymentListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxPaymentListViewController.h"
#import "SHBGiroTaxListService.h"                       // 지로서비스
#import "SHBGiroTaxPaymentListCell.h"                   // tableView cell
#import "SHBGiroTaxPaymentDetailViewController.h"       // 다음 view


@interface SHBGiroTaxPaymentListViewController ()

@end

@implementation SHBGiroTaxPaymentListViewController


#pragma mark -
#pragma mark Synthesize

@synthesize arrayData;
@synthesize strSelectedStartDate;
@synthesize strSelectedEndDate;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    NSString *strStartDay   = [self.strSelectedStartDate stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *strEndDay     = [self.strSelectedEndDate stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"조회시작일자" : strStartDay,
                            @"조회종료일자" : strEndDay,
                            @"reservationField1" : @"내역에서재조회",
                            @"reservationField2" : @"3MonthChecnkError"
                            }] autorelease];
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_PAYMENT_LIST viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:            // 1개월
        {
            intMonth = -1;
        }
            break;
            
        case 12:            // 3개월
        {
            intMonth = -3;
        }
            break;
            
        case 13:            // 기간입력
        {
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
            
            return;         // 내려가지 않도록 막는다
        }
            break;
            
        case 21:        // 더 보기 버튼
        {
            intIndex = intIndex + 10;
            
            if (intIndex > [self.arrayData count])
            {
                intIndex = [self.arrayData count];
            }
            
            [tableView1 reloadData];
            
            return;
        }
            break;
            
        default:
            break;
    }
    
    // tableView 초기화
    [self refreshTableView];
    
    self.strSelectedStartDate = [SHBUtility dateStringToMonth:intMonth toDay:0];

    // 3달 전의 경우 날짜 확인
    if ( intMonth == -3 && [AppInfo.tran_Date length] > 2 )
    {
        int intTodayDate = [[AppInfo.tran_Date substringFromIndex:([AppInfo.tran_Date length] - 2)] intValue];
        int int3MonthDate = [[self.strSelectedStartDate substringFromIndex:([self.strSelectedStartDate length] - 2)] intValue];
        // 3달전 선택 시 날짜가 같지 않은 경우
        // ex) 31일의 경우(3달전 달의 일수가 30일까지 밖에 존재하지 않는 경우)나 5월 말의 경우(2월은 27일과 28일까지만 존재)
        if ( intTodayDate != int3MonthDate )
        {
            intMonth = -2;
            self.strSelectedStartDate = [SHBUtility dateStringToMonth:intMonth toDay:-(intTodayDate - 1)];
        }
    }
    
    self.strSelectedEndDate = AppInfo.tran_Date;
    
    [self requestService];
}

- (void)refreshTableView
{
    label1.text = @"조회기간 : ";
    [label2 setHidden:YES];
    
    [self.arrayData removeAllObjects];
    intIndex = 0;
    // tableView 초기화
    [tableView1 reloadData];
    tableView1.tableFooterView = nil;
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL) onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0161"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            self.arrayData = [aDataSet arrayWithForKeyPath:@"지로납부내역.vector.data"];
            
            intIndex = 10;
            
            if (intIndex > [self.arrayData count])
            {
                intIndex = [self.arrayData count];
            }
            
            [tableView1 reloadData];
        }
    }
    
    
    return YES;
}

- (BOOL) onBind:(OFDataSet *)aDataSet
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0161"] )
    {
        if ( [aDataSet[@"내역건수"] isEqualToString:@"0"] )
        {
            [label2 setHidden:NO];
        }
        
        label1.text = [NSString stringWithFormat:@"조회기간 : %@~%@[%@건]", self.strSelectedStartDate, self.strSelectedEndDate, [aDataSet objectForKey:@"내역건수"]];
    }
    
    return YES;
}


#pragma mark -
#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    // tableView 초기화
    [self refreshTableView];
    
    self.strSelectedStartDate   = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strSelectedEndDate     = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self requestService];
}

- (void)popupViewDidCancel
{
    
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return intIndex;
//    return [self.arrayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBGiroTaxPaymentListCell *cell = (SHBGiroTaxPaymentListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBGiroTaxPaymentListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBGiroTaxPaymentListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    if ( intIndex < [self.arrayData count] )
    {
        tableView1.tableFooterView = viewMore;
    }
    else
    {
        tableView1.tableFooterView = nil;
    }
    
    NSDictionary *dictionary = [self.arrayData objectAtIndex:indexPath.row];
    
    cell.label1.text = dictionary[@"납부일자"];                                         // 납부일자
    cell.label2.text = [NSString stringWithFormat:@"%@원", dictionary[@"납부금액"]];     // 납부금액
    cell.label3.text = dictionary[@"수납기관명"];                                        // 수납기관명
    
    return cell;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    SHBGiroTaxPaymentDetailViewController *detailViewController = [[SHBGiroTaxPaymentDetailViewController alloc] initWithNibName:@"SHBGiroTaxPaymentDetailViewController" bundle:nil];
    
    // 정보 setting
    NSMutableDictionary *dicGiroData = [self.arrayData objectAtIndex:indexPath.row];
    
    detailViewController.dicDataDictionary = dicGiroData;
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
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
    self.strBackButtonTitle = @"지로납부내역 조회취소 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    // 진입시 setting
    // 한달 조회
    intMonth = -1;
    self.arrayData = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    self.strSelectedStartDate   = [SHBUtility dateStringToMonth:intMonth toDay:0];
    self.strSelectedEndDate     = [SHBAppInfo sharedSHBAppInfo].tran_Date;
    
    [self requestService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.arrayData = nil;
    
    self.strSelectedStartDate = nil;
    self.strSelectedEndDate = nil;
    
    [super dealloc];
}

@end
