//
//  SHBFundExchangeListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 1..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundExchangeListViewController.h"
#import "SHBFundExchangeListCell.h"
#import "SHBFundService.h"

@interface SHBFundExchangeListViewController ()

@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@end

@implementation SHBFundExchangeListViewController

@synthesize accountNo;
@synthesize accountName;
@synthesize fundExchangeListTable;

- (void)dealloc
{
    [fundExchangeListTable release], fundExchangeListTable = nil;
    [_fundTickerName release];
    [accountName release], accountName = nil;
    [accountNo release], accountNo = nil;
    [_accountNameLabel release];
    [_accountNoLabel release];
    [_recordCountLabel release];
    [_currentDateLabel release];
    [_tempLabel release];
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"펀드조회";
    self.strBackButtonTitle = @"펀드조회 상세";
    AppInfo.isNeedBackWhenError = YES;
    
    _tempLabel = @"";
    
//    LPScrollingTickerLabelItem *label = [[[LPScrollingTickerLabelItem alloc] initWithLabelStyle:accountName FontSize:15 TextColor:[UIColor whiteColor]] autorelease];
//    [_fundTickerName initFrame:_fundTickerName.frame];
//    [_fundTickerName executeSlideAnimation:label Direction:LPScrollingDirection_FromRight];

    [_fundTickerName initFrame:_fundTickerName.frame];
    [_fundTickerName setCaptionText:accountName];

    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : self.accountNo,
                                @"은행구분" : @"1",
                                @"조회시작일" : @"",
                                @"조회종료일" : @"",
                                @"거래구분" : @"1",
                                }] autorelease];
    
    
    self.service = [[[SHBFundService alloc] initWithServiceId: FUND_FORWARD_EXCHANGE_LIST viewController: self] autorelease];
    
    self.service.previousData = previousData; //서비스 실행을 위해 필요한 이전 서비스 정보를 데이터셋으로  넘긴다
//    [self.service setTableView: self.fundExchangeListTable tableViewCellName: @"SHBFundExchangeListCell" dataSetList: @"선물환거래내역.vector.data"];
    [self.service start];

//    self.accountNameLabel.text = accountName;
    self.accountNoLabel.text = accountNo;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.dataList = [aDataSet arrayWithForKey:@"선물환거래내역.vector.data"];

    _recordCountLabel.text = [NSString stringWithFormat:@"선물환 거래내역 %d건이 조회되었습니다.", [self.dataList count]];
    
    NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
	_currentDateLabel.text = [NSString stringWithFormat:@"현재 [%@]", [dateFormatter stringFromDate:today]];
    
    if ([self.dataList count] > 0) {
        _tempLabel = @"";
    } else {
        _tempLabel = @"조회된 거래내역이 없습니다.";
    }

    [fundExchangeListTable reloadData];

    return YES;
}

- (BOOL)onBind:(OFDataSet*)aDataSet
{
    return YES;
}

#pragma mark - Table view delegate
#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
        
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [cell.textLabel setText:_tempLabel];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    SHBFundExchangeListCell *cell = (SHBFundExchangeListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFundExchangeListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFundExchangeListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];

    cell.amountLabel.text = [NSString stringWithFormat:@"%@원", [cellDataSet objectForKey:@"차액예상금액"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
