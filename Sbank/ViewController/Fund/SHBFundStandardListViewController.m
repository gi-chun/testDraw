//
//  SHBFundStandardListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundStandardListViewController.h"
#import "SHBFundStandardListCell.h"
#import "SHBFundService.h"
//#import "SHBScrollingTicker.h"

@interface SHBFundStandardListViewController ()

@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@end

@implementation SHBFundStandardListViewController

@synthesize account;
@synthesize fundStandardListTable;
@synthesize accountName;
@synthesize accountNo;
@synthesize accountNameLabel;
@synthesize accountNoLabel;
@synthesize fundCode;

- (void)dealloc
{
    [_titleView release];
    [_fundTickerName release];
    [fundStandardListTable release], fundStandardListTable = nil;
    [accountName release], accountName = nil;
    [accountNo release], accountNo = nil;
    [accountNameLabel release], accountNameLabel = nil;
    [accountNoLabel release], accountNoLabel = nil;
    [fundCode release], fundCode = nil;
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

    [_fundTickerName initFrame:_fundTickerName.frame];
    [_fundTickerName setCaptionText:accountName];

    NSString *strEndDate = [[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *strStartDate = [SHBUtility dateStringToMonth:-1 toDay:0];

    // release 처리
    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"조회구분" : @"8",
                                @"조회시작일" : strStartDate,
                                @"조회종료일" : strEndDate,
                                @"은행구분" : @"1",
                                @"펀드선택" : fundCode,
                                }] autorelease];
    
    
    self.service = [[[SHBFundService alloc] initWithServiceId: FUND_BASIC_LIST viewController: self] autorelease];
    self.service.previousData = previousData; //서비스 실행을 위해 필요한 이전 서비스 정보를 데이터셋으로  넘긴다
    [self.service start];

    self.accountNoLabel.text = accountNo;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
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
    SHBFundStandardListCell *cell = (SHBFundStandardListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFundStandardListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFundStandardListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }

    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];

    if([[cellDataSet objectForKey:@"전일증감"] floatValue] > 0.0f)
    {
        [cell.variationsLabel setTextColor:RGB(209, 75, 75)];
        
    }
    else if([[cellDataSet objectForKey:@"전일증감"] floatValue] == 0.0f)
    {
        cell.variationsLabel.textColor = [UIColor blackColor];
    }
    else
    {
        [cell.variationsLabel setTextColor:RGB(17, 143, 219)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.dataList = [aDataSet arrayWithForKey:@"거래내역"];
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];

    NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"적용시작일" ascending:NO];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
    [sortOrder release];

    self.dataList = (NSArray *)tempArray;

    if ([self.dataList count] > 0) {
        _tempLabel = @"";
    } else {
        _tempLabel = @"조회된 거래내역이 없습니다.";
    }

    [fundStandardListTable reloadData];
    
    return YES;
}

@end
