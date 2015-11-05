//
//  SHBForexRequestListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestListViewController.h"
#import "SHBUtility.h" // 유틸
#import "SHBExchangeService.h" // 서비스

#import "SHBPeriodPopupView.h" // 기간 popup

#import "SHBForexRequestDetailViewController.h" // 환전신청내역상세

enum FOREXREQUEST_ORDERBTN_TAG {
    FOREXREQUEST_WEEK = 100,
    FOREXREQUEST_MONTH
};

@interface SHBForexRequestListViewController ()
<SHBPopupViewDelegate>

@property (retain, nonatomic) NSString *startDate; // 조회시작일
@property (retain, nonatomic) NSString *endDate; // 조회종료일

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

/// 데이터 요청
- (void)listDataRequest;

@end

@implementation SHBForexRequestListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"환전신청내역조회"];
    self.strBackButtonTitle = @"환전신청내역조회";
    
    self.startDate = AppInfo.tran_Date;
    self.endDate = [SHBUtility dateStringToMonth:0 toDay:7];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self listDataRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.startDate = nil;
    self.endDate = nil;
    
    [_dataTable release];
    [_orderView release];
    [_orderInfo release];
    [_noData release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setOrderView:nil];
    [self setOrderInfo:nil];
    [self setNoData:nil];
	[super viewDidUnload];
}

#pragma mark - 

- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.2lf", number];
    }
    else {
        string = [NSString stringWithFormat:@"%.lf", number];
    }
    
    NSString *str = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumber *num = [NSNumber numberWithDouble:[str doubleValue]];
    
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setAllowsFloats:YES];
    
    NSString *commaString = [numberFormatter stringForObjectValue:num];
    
    if (isPoint) {
        NSRange range = [commaString rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
            commaString = [NSString stringWithFormat:@"%@.00", commaString];
        }
        else {
            if ([commaString length] - 1 == range.location + 1) {
                commaString = [NSString stringWithFormat:@"%@0", commaString];
            }
        }
    }
    
    return commaString;
}

- (void)listDataRequest
{
    self.service.dataList = [NSArray array];
    [_dataTable reloadData];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"조회시작일" : _startDate,
                            @"조회종료일" : _endDate,
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3120_SERVICE
                                                   viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBForexRequestListCell"
                   dataSetList:@"조회내역.vector.data"];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Button

/// 1주일, 1개월
- (IBAction)orderBtn:(UIButton *)sender
{
    self.startDate = AppInfo.tran_Date;
    
    switch ([sender tag]) {
        case FOREXREQUEST_WEEK:
            self.endDate = [SHBUtility dateStringToMonth:0 toDay:7];
            
            break;
        case FOREXREQUEST_MONTH:
            self.endDate = [SHBUtility dateStringToMonth:1 toDay:0];
            
            break;
            
        default:
            break;
    }
    
    [self listDataRequest];
}

/// 기간선택
- (IBAction)orderSelectBtn:(UIButton *)sender
{
    SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
    [popupView setDelegate:self];
    [popupView periodModeForDate:YES];
    [popupView showInView:self.navigationController.view animated:YES];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"조회내역"]) {
        [dic setObject:[self addComma:[dic[@"거래환율1->originalValue"] doubleValue] isPoint:YES]
                forKey:@"_적용환율1"];
        [dic setObject:[self addComma:[dic[@"거래환율2->originalValue"] doubleValue] isPoint:YES]
                forKey:@"_적용환율2"];
        [dic setObject:[self addComma:[dic[@"거래환율3->originalValue"] doubleValue] isPoint:YES]
                forKey:@"_적용환율3"];
    }
    
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    [_orderInfo setText:[NSString stringWithFormat:@"조회기간:%@~%@[%d건]", _startDate, _endDate, [[aDataSet arrayWithForKey:@"조회내역"] count]]];
    
    [_orderInfo setHidden:NO];
    
    if ([self.service.dataList count] == 0) {
        [_noData setHidden:NO];
    }
    else {
        [_noData setHidden:YES];
    }
    
    return YES;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFDataSet *cellDataSet = self.service.dataList[indexPath.row];
    
    NSMutableArray *array = [NSMutableArray array];
    
    OFDataSet *dataSet1 = [OFDataSet dictionaryWithDictionary:
                           @{
                           @"_환전번호" : cellDataSet[@"REFNO"],
                           @"_신청일" : cellDataSet[@"신청일"],
                           @"_수령일" : cellDataSet[@"수령일"],
                           @"_수령점" : cellDataSet[@"수령점명"],
                           @"_환전구분" : cellDataSet[@"환전구분1"],
                           @"_통화" : cellDataSet[@"통화1"],
                           @"_외화금액" : cellDataSet[@"거래외화금액1"],
                           @"_적용환율" : cellDataSet[@"거래환율1"],
                           @"_원화금액" : cellDataSet[@"원화금액1"],
                           @"_구분" : cellDataSet[@"수령교부"],
                           }];
    
    [array addObject:dataSet1];
    
    if (![cellDataSet[@"통화2"] isEqualToString:@""] && cellDataSet[@"통화2"]) {
        OFDataSet *dataSet2 = [OFDataSet dictionaryWithDictionary:
                               @{
                               @"_환전구분" : cellDataSet[@"환전구분2"],
                               @"_통화" : cellDataSet[@"통화2"],
                               @"_외화금액" : cellDataSet[@"거래외화금액2"],
                               @"_적용환율" : cellDataSet[@"거래환율2"],
                               @"_원화금액" : cellDataSet[@"원화금액2"],
                               }];
        
        [array addObject:dataSet2];
    }
    
    if (![cellDataSet[@"통화3"] isEqualToString:@""] && cellDataSet[@"통화3"]) {
        OFDataSet *dataSet3 = [OFDataSet dictionaryWithDictionary:
                               @{
                               @"_환전구분" : cellDataSet[@"환전구분3"],
                               @"_통화" : cellDataSet[@"통화3"],
                               @"_외화금액" : cellDataSet[@"거래외화금액3"],
                               @"_적용환율" : cellDataSet[@"거래환율3"],
                               @"_원화금액" : cellDataSet[@"원화금액3"],
                               }];
        
        [array addObject:dataSet3];
    }
    
    if (![cellDataSet[@"통화4"] isEqualToString:@""] && cellDataSet[@"통화4"]) {
        OFDataSet *dataSet4 = [OFDataSet dictionaryWithDictionary:
                               @{
                               @"_환전구분" : cellDataSet[@"환전구분4"],
                               @"_통화" : cellDataSet[@"통화4"],
                               @"_외화금액" : cellDataSet[@"거래외화금액4"],
                               @"_적용환율" : cellDataSet[@"거래환율4"],
                               @"_원화금액" : cellDataSet[@"원화금액4"],
                               }];
        
        [array addObject:dataSet4];
    }
    
    if (![cellDataSet[@"통화5"] isEqualToString:@""] && cellDataSet[@"통화5"]) {
        OFDataSet *dataSet5 = [OFDataSet dictionaryWithDictionary:
                               @{
                               @"_환전구분" : cellDataSet[@"환전구분5"],
                               @"_통화" : cellDataSet[@"통화5"],
                               @"_외화금액" : cellDataSet[@"거래외화금액5"],
                               @"_적용환율" : cellDataSet[@"거래환율5"],
                               @"_원화금액" : cellDataSet[@"원화금액5"],
                               }];
        
        [array addObject:dataSet5];
    }
    
	SHBForexRequestDetailViewController *viewController = [[[SHBForexRequestDetailViewController alloc] initWithNibName:@"SHBForexRequestDetailViewController" bundle:nil] autorelease];
    [viewController setDetailData:array];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.startDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.endDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self listDataRequest];
}

- (void)popupViewDidCancel
{
    
}

@end
