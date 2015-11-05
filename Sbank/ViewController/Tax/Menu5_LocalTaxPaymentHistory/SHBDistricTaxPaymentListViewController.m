//
//  SHBDistricTaxPaymentListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 11..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBDistricTaxPaymentListViewController.h"
#import "SHBDistricTaxPaymentListCell.h"                        // tableView cell
#import "SHBGiroTaxListService.h"                               // 지로 service
#import "SHBDistricTaxPaymentDetailViewController.h"            // 다음 view


@interface SHBDistricTaxPaymentListViewController ()

@end

@implementation SHBDistricTaxPaymentListViewController

#pragma mark -
#pragma mark Synthesize

@synthesize tableView1;
@synthesize arrayData;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    OFDataSet *aDataSet = nil;
    // 신, 구 서비스 분기를 위한 int
    int intServiceID = LOCAL_TAX_LIST_OLD;
    
    [tableView1 reloadData];
    
    if (isNew == YES)
    {
        intServiceID = LOCAL_TAX_LIST_NEW;
        
        if ( intIndex == 1 )
        {
            aDataSet = [[[OFDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드" : @"0200",
                         @"거래구분코드" : @"533011",
                         @"이용기관지로번호" : @"000000000",
                         @"거래조회구분" : @"A",
                         @"조회계좌번호" : account,
                         @"조회시작일자" : strSelectedStartDate,
                         @"조회종료일자" : strSelectedEndDate,
                         @"데이터건수" : @"",
                         @"지정번호" : [NSString stringWithFormat:@"%d", intIndex]
                         }] autorelease];
        }
        else
        {
            aDataSet = [[[OFDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드" : @"0200",
                         @"거래구분코드" : @"533011",
                         @"이용기관지로번호" : @"000000000",
                         @"거래조회구분" : @"A",
                         @"조회계좌번호" : account,
                         @"조회시작일자" : strSelectedStartDate,
                         @"조회종료일자" : strSelectedEndDate,
                         @"지정번호" : [NSString stringWithFormat:@"%d", intIndex],
                         @"데이터건수" : @"",
                         @"reservationField9" : @"재호출"
                         }] autorelease];
        }
    }
    else // 2011.03.02이전 서울지방세 납부내역 조회
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : @"0200",
                     @"거래구분코드" : @"523005",
                     @"이용기관지로번호" : @"111000135",
                     //@"이용기관지로번호" : @"",
                     @"거래조회구분" : @"A",
                     @"조회계좌번호" : account,
                     @"조회시작일자" : strSelectedStartDate,
                     @"조회종료일자" : strSelectedEndDate,
                     @"데이터건수" : @"",
                     @"지정번호" : @"1"
                     }] autorelease];
    }
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: intServiceID viewController: self] autorelease];
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
            
        case 21:            // 더 보기 버튼
        {
            if (isNew)
            {
                intIndex = intIndex + 10;
                [self requestService];
            }
            else
            {
                // 구 지방세의 경우 데이터가 한번에 내려온다
                // 따라서 잘라서 보여주는 부분 필요
                intOldIndex = intOldIndex + 10;
                
                // 10개가 안되는 경우(마지막)
                if (intOldCount < intOldIndex)
                {
                    intOldIndex = intOldIndex - (10 - intOldCount%10);
                }
                
                [tableView1 reloadData];
            }
            
            return;
        }
            
        default:
            break;
    }

    strSelectedStartDate = [SHBUtility dateStringToMonth:intMonth toDay:0];
    strSelectedEndDate = AppInfo.tran_Date;
    
    // tableView 초기화
    [self refreshTableView];
                   
    [self requestService];
}

- (void)refreshTableView
{
    intIndex = 1;
    [self.arrayData removeAllObjects];
    label1.text = @"조회기간 : ";
    [label2 setHidden:YES];
    tableView1.tableFooterView = nil;
}

#pragma mark -
#pragma setData Method

// 이전 view로부터 data를 받는다
- (void)setData:(NSDictionary *)data
{
    account = [[NSString alloc] initWithFormat:@"%@",[data objectForKey:@"계좌번호"]];
    
    if ([[data objectForKey:@"조회구분선택"] isEqualToString:@"NEW"]) {  //신규지방세 납부조회
        
        isNew = YES;
	}
	else //기존 지방세 납부조회
    {
        isNew = NO;
    }
}


#pragma mark -
#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    // tableView 초기화
    [self refreshTableView];
    
    strSelectedStartDate    = [SHBUtility getDateWithDash:mDic[@"from"]];
    strSelectedEndDate      = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self requestService];
}

- (void)popupViewDidCancel
{
    
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSArray      *array = [aDataSet arrayWithForKey:@"지방세납부내역"];
    
    // 구지방세의 경우
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0321"] )
    {
        // 구 지방세의 경우 이용기관이 하나로 내려와서 각각에 수납기관명 추가
        for (NSMutableDictionary *dic in array)
        {
            [dic setObject:[aDataSet objectForKey:@"이용기관지로번호->display"] forKey:@"수납기관명"];
        }
    }
    
    for (NSDictionary *dic in array)
    {
        [self.arrayData addObject:dic];
    }
    
    // 마지막 경우 footer를 없앤다
    int intCompareValue = [aDataSet[@"지정번호"] intValue] + 10;
    
    if (!isNew)
    {
        // 구 지방세의 경우 데이터가 한번에 내려온다
        // 따라서 잘라서 보여주는 부분 필요
        intOldCount = [aDataSet[@"총건수"] intValue];
        intCompareValue = intOldIndex;
    }
    
    if ( [aDataSet[@"총건수"] intValue] < intCompareValue )
    {
        tableView1.tableFooterView = nil;
    }
    else
    {
        tableView1.tableFooterView = viewMore;
    }
    
    [tableView1 reloadData];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ( !aDataSet[@"총건수"] )
    {
        [label2 setHidden:NO];
        label1.text = [NSString stringWithFormat:@"조회기간 : %@~%@[%@건]", strSelectedStartDate, strSelectedEndDate, aDataSet[@"내역건수"]];
    }
    else
    {
        label1.text = [NSString stringWithFormat:@"조회기간 : %@~%@[%@건]", strSelectedStartDate, strSelectedEndDate, aDataSet[@"총건수"]];
    }
    
    return YES;
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int intCount = [self.arrayData count];
    
    // 구 지방세의 경우 데이터가 한번에 내려온다
    // 따라서 잘라서 보여주는 부분 필요
    if (!isNew)
    {
        if ([self.arrayData count] > intOldIndex)
        {
            intCount = intOldIndex;
        }
    }
    
    return intCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBDistricTaxPaymentListCell *cell = (SHBDistricTaxPaymentListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBDistricTaxPaymentListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBDistricTaxPaymentListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.arrayData objectAtIndex:indexPath.row];
    
    if (isNew)
    {
        cell.label1.text = [SHBUtility nilToString:dictionary[@"납부일자"]];
        cell.label2.text = [SHBUtility nilToString:dictionary[@"이용기관지로번호1->display"]];
        cell.label3.text = [SHBUtility nilToString:dictionary[@"세목명"]];
        cell.label4.text = [NSString stringWithFormat:@"%@원", dictionary[@"납부금액"]];
        
        if (dictionary[@"수납은행점별코드1->display"] && dictionary[@"납부이용시스템->display"]) {
            cell.label5.text = [NSString stringWithFormat:@"%@/%@",
                                [SHBUtility nilToString:dictionary[@"수납은행점별코드1->display"]],
                                [SHBUtility nilToString:dictionary[@"납부이용시스템->display"]]];
        }
        else if (!dictionary[@"수납은행점별코드1->display"]) {
            cell.label5.text = [SHBUtility nilToString:dictionary[@"납부이용시스템->display"]];
        }
        else if (!dictionary[@"납부이용시스템->display"]) {
            cell.label5.text = [SHBUtility nilToString:dictionary[@"수납은행점별코드1->display"]];
        }
        else {
            cell.label5.text = @"";
        }
    }
    else
    {
        int intBankCode = [dictionary[@"수납은행점별코드1"] intValue];
        NSString *strBank = AppInfo.codeList.bankCodeReverse[[NSString stringWithFormat:@"%d", intBankCode]];
        
        NSString *strPathString = @"";
        
        if (strBank && dictionary[@"납부이용시스템->display"]) {
            strPathString = [NSString stringWithFormat:@"%@/%@",
                             [SHBUtility nilToString:strBank],
                             [SHBUtility nilToString:dictionary[@"납부이용시스템->display"]]];
        }
        else if (!strBank) {
            strPathString = [SHBUtility nilToString:dictionary[@"납부이용시스템->display"]];
        }
        else if (!dictionary[@"납부이용시스템->display"]) {
            strPathString = [SHBUtility nilToString:strBank];
        }
        
        cell.label1.text = [SHBUtility nilToString:dictionary[@"납부일자"]];
        cell.label2.text = [SHBUtility nilToString:dictionary[@"수납기관명"]];
        cell.label3.text = [SHBUtility nilToString:dictionary[@"과목->display"]];
        cell.label4.text = [NSString stringWithFormat:@"%@원", dictionary[@"납부금액"]];
        cell.label5.text = strPathString;
    }
    
    return cell;
}


#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    SHBDistricTaxPaymentDetailViewController *detailViewController = [[SHBDistricTaxPaymentDetailViewController alloc] initWithNibName:@"SHBDistricTaxPaymentDetailViewController" bundle:nil];
    
    // 신, 구 구분
    NSString *strNewOROld = isNew ? @"NEW" : @"OLD";
    
    // 정보 setting
    NSMutableDictionary *dicDistricData = [self.arrayData objectAtIndex:indexPath.row];
    
    [dicDistricData setObject:strNewOROld forKey:@"신구구분"];
    detailViewController.dicDataDictionary = dicDistricData;
    
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
    
    self.title = @"지방세납부내역조회";
    self.strBackButtonTitle = @"지방세 납부내역 조회";
    
    //AppInfo.isNeedBackWhenError = YES;
    
    // 최초 진입시 setting
    // 초기값 설정
    intIndex = 1;
    intOldIndex = 10;
    intMonth = -1;
    strSelectedStartDate    = [SHBUtility dateStringToMonth:intMonth toDay:0];
    strSelectedEndDate      = [SHBAppInfo sharedSHBAppInfo].tran_Date;
    
    self.arrayData = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    // 서비스 호출
    [self requestService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    SafeRelease(account);
    
    self.tableView1 = nil;
    self.arrayData = nil;
    
    [super dealloc];
}

@end
