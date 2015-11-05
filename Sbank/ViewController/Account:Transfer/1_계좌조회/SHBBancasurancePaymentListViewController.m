//
//  SHBBancasurancePaymentListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBancasurancePaymentListViewController.h"
#import "SHBListPopupView.h"
#import "SHBPeriodPopupView.h"
#import "SHBAccountService.h"
#import "SHBBancasurancePaymentListCell.h"

@interface SHBBancasurancePaymentListViewController ()<SHBListPopupViewDelegate, SHBPopupViewDelegate>
{
    NSString *strServiceCode;
    BOOL isShowFundDetailInfo;
    BOOL isShowBalance;
    
    NSString *serviceCode;
    NSString *strStartDate;
    NSString *strEndDate;
    
    int serviceNo;
    int serviceType;
}

@property (nonatomic, retain) NSString *strServiceCode;
@property (nonatomic, retain) NSString *serviceCode;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@end

@implementation SHBBancasurancePaymentListViewController
@synthesize serviceCode;
@synthesize strStartDate;
@synthesize strEndDate;
@synthesize bacAccountListTable;
@synthesize strServiceCode;
@synthesize tableTopSubView;

- (void)displayData
{
    // Scroll Label
    [_bancaTickerName initFrame:_bancaTickerName.frame colorType:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1] fontSize:15 textAlign:0];
    [_bancaTickerName setCaptionText:[_detailData objectForKey:@"상품명"]];

    _lblData1.text =  [_detailData objectForKey:@"증권번호"];
    
    if ([[_detailData objectForKey:@"보험사코드"] hasPrefix:@"L"]) {
        if ([[_detailData objectForKey:@"계약자주민번호"] length] > 0) {
            _lblData3.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                              [[_detailData objectForKey:@"계약자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
        } else {
            _lblData3.text = @"";
        }
        _lblData2.text =  [_detailData objectForKey:@"계약자성명"];
        _lblData4.text = [NSString stringWithFormat:@"%@ ~ %@", [SHBUtility getDateWithDash:[_detailData objectForKey:@"계약일자"]], [SHBUtility getDateWithDash:[_detailData objectForKey:@"만기일자"]]];
        _lblData6.text =  [NSString stringWithFormat:@"%@.%@", [[_detailData objectForKey:@"최종납입월"] substringWithRange:NSMakeRange(0, 4)], [[_detailData objectForKey:@"최종납입월"] substringWithRange:NSMakeRange(4, 2)]];
        _lblData10.text =  [NSString stringWithFormat:@"%@(%@)", [SHBUtility normalStringTocommaString:[_detailData objectForKey:@"합계보험료"]], [_detailData objectForKey:@"상품통화코드"]];
        _lblData9.text =  [SHBUtility getDateWithDash:[_detailData objectForKey:@"계약일자"]];

    } else {
        if ([[_detailData objectForKey:@"계약자등록번호"] length] > 0) {
            _lblData3.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                              [[_detailData objectForKey:@"계약자등록번호"] substringWithRange:NSMakeRange(0, 6)]];
        } else {
            _lblData3.text = @"";
        }
        _lblData2.text =  [_detailData objectForKey:@"계약자명"];
        if ([[_detailData objectForKey:@"보험시작일"] length] > 0) {
            _lblData4.text = [NSString stringWithFormat:@"%@ ~ %@", [_detailData objectForKey:@"보험시작일"], [_detailData objectForKey:@"보험종료일"]];
        } else {
            _lblData4.text = @"";
        }
        
        _lblData6.text = [_detailData objectForKey:@"최종납입일자"];
        
        if ([_lblData6.text length] > 7)
        {
            _lblData6.text =  [NSString stringWithFormat:@"%@", [[_detailData objectForKey:@"최종납입일자"] substringWithRange:NSMakeRange(0, 7)]];
        }
        
        if ([[_detailData objectForKey:@"합계보험료"] length] > 0) {
            _lblData10.text = [NSString stringWithFormat:@"%@(%@)", [_detailData objectForKey:@"합계보험료"], [_detailData objectForKey:@"상품통화코드"]];
        } else {
            _lblData10.text = @"";
        }
        _lblData9.text =  [_detailData objectForKey:@"계약일"];

    }
    
    _lblData5.text =  [NSString stringWithFormat:@"%@ / %@", [_detailData objectForKey:@"납입방법"], [_detailData objectForKey:@"납입기간"]];
    _lblData7.text =  [_detailData objectForKey:@"계약상태"];
    _lblData8.text =  [NSString stringWithFormat:@"%@회", [_detailData objectForKey:@"최종납입회차"]];
    _lblData11.text =  [_detailData objectForKey:@"계좌번호"];
    _lblData12.text =  [_detailData objectForKey:@"예금주명"];
    _lblData13.text =  [NSString stringWithFormat:@"%@일", [_detailData objectForKey:@"이체희망일"]];
    _lblData14.text =  [_detailData objectForKey:@"이체불능사유"];
    _lblData15.text =  [_detailData objectForKey:@"지점명"];
    _lblData16.text =  [_detailData objectForKey:@"모집행원"];
}

- (void)sendRequest
{
    NSString *tempRelation;
    
    self.dataList = nil;
    [bacAccountListTable reloadData];
    
    // 생명보험일 경우만 상세정보 버튼 활성화
    if ([[_detailData objectForKey:@"보험사코드"] hasPrefix:@"L"]) {
        _btnDetailInfo.hidden = NO;
        self.strServiceCode = @"B1120";
        tempRelation = @"42";
    } else {
        _btnDetailInfo.hidden = YES;
        self.strServiceCode = @"B1170";
        tempRelation = @"52";
    }
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"업무구분"    : tempRelation,
                            @"증권번호"    : [_detailData objectForKey:@"증권번호"],
                            @"보험사코드"  : [_detailData objectForKey:@"보험사코드"],
                            @"조회기준일자" : strStartDate,
                            }] autorelease];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
    
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    int row = 6;
    
    switch ([sender tag]) {
        case 10:   // 계좌상세
        {
            if(isShowFundDetailInfo)
            {
                isShowFundDetailInfo = NO;
                sender.selected = NO;
                sender.accessibilityLabel = @"상세보기열기";

                [_bacInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, 377.0f - ((15.0f * row) + (10.0f * row)))];
                _bacInfoView.backgroundColor = RGB(244, 244, 244);
            }
            else
            {
                isShowFundDetailInfo = YES;
                sender.selected = YES;
                sender.accessibilityLabel = @"상세보기닫기";
                
                [_bacInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, 377.0f)];
                _bacInfoView.backgroundColor = RGB(244, 244, 244);
            }
            
            [_termSelectView setFrame:CGRectMake(0.0f, _bacInfoView.frame.size.height, 317.0f, 41.0f)];
            [tableTopSubView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _bacInfoView.frame.size.height + _termSelectView.frame.size.height)];
            
            [self.bacAccountListTable setTableHeaderView:tableTopSubView];
            [self.bacAccountListTable setContentOffset:CGPointZero animated:YES];

        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.dataList = [aDataSet arrayWithForKeyPath:@"입금내역.vector.data"];
    
    if ([self.dataList count] > 0){
        _tempLabel = @"";
    } else {
        _tempLabel = @"조회된 거래내역이 없습니다.";
    }
    
    [self.bacAccountListTable reloadData];
    
    NSString *basisDate = [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if(self.strStartDate == nil || [self.strStartDate isEqualToString:@""] || basisDate == nil || [basisDate isEqualToString:@""]) {
        _recordCountLabel.text = [NSString stringWithFormat:@"조회기준일자 : %@ [%d건]", [SHBAppInfo sharedSHBAppInfo].tran_Date, [self.dataList count]];
    } else {
        _recordCountLabel.text = [NSString stringWithFormat:@"조회기준일자 : %@ [%d건]", _dateField.textField.text, [self.dataList count]];
    }
    
    return YES;
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
    
    self.title = @"입금내역조회";
    [self displayData];
    
    strStartDate = @"";
    _tempLabel = @"";
    
    //    [self.binder bind:self dataSet:_detailData];
    
    NSString *tempRelation;
    // 생명보험일 경우만 상세정보 버튼 활성화
    if ([[_detailData objectForKey:@"보험사코드"] hasPrefix:@"L"]) {
        _btnDetailInfo.hidden = NO;
        self.strServiceCode = @"B1120";
        tempRelation = @"42";
    } else {
        _btnDetailInfo.hidden = YES;
        self.strServiceCode = @"B1170";
        tempRelation = @"52";
    }
    
    isShowFundDetailInfo = NO;
    int row = 6;
    [_bacInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, 377.0f - ((15.0f * row) + (10.0f * row)))];
    
    [_termSelectView setFrame:CGRectMake(0.0f, _bacInfoView.frame.size.height, 317.0f, 41.0f)];
    [tableTopSubView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _bacInfoView.frame.size.height+ + _termSelectView.frame.size.height)];
    
    
// 조회기준일
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:13]];
    [_dateField.textField setTextColor:[UIColor whiteColor]];

    _dateField.delegate = self;

    [_dateField setButtonStyle:@"기준일선택"];

    serviceType = 1;
    self.service = nil;
    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"업무구분" : tempRelation,
                                @"증권번호" : [_detailData objectForKey:@"증권번호"],
                                @"보험사코드" : [_detailData objectForKey:@"보험사코드"],
                                }] autorelease];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController: self] autorelease];
    self.service.requestData = previousData;
    [self.service start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.detailData = nil;
    
    [bacAccountListTable release], bacAccountListTable = nil;
    [_bancaTickerName release];
    
    [_lblBacTitle release];
    [_lblData1 release];
    [_lblData2 release];
    [_lblData3 release];
    [_lblData4 release];
    [_lblData5 release];
    [_lblData6 release];
    [_lblData7 release];
    [_lblData8 release];
    [_lblData9 release];
    [_lblData10 release];
    [_lblData11 release];
    [_lblData12 release];
    [_lblData13 release];
    [_lblData14 release];
    [_lblData15 release];
    [_lblData16 release];
    
    [_dateField release];
    [_btnDetailInfo release];
    [_titleView release];
    [_bacInfoView release];
    [tableTopSubView release];
    [_termSelectView release];
    [_btnSort release];
    [_recordCountLabel release];
    
    [super dealloc];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
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
    SHBBancasurancePaymentListCell *cell = (SHBBancasurancePaymentListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBBancasurancePaymentListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBBancasurancePaymentListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        //        cell = self.cell;
        [cell retain];
    } else {
        cell = [[[SHBBancasurancePaymentListCell alloc] init] autorelease];
    }
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];// self.dataList[indexPath.row];
//    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];

//    [cell.codeLabel setTextColor:RGB(40, 91, 412)];
    
    cell.receiptCountMon.text = [NSString stringWithFormat:@"%@년 %@월분 (%@회차/%@)", [[dictionary objectForKey:@"납입년월"] substringWithRange:NSMakeRange(0, 4)], [[dictionary objectForKey:@"납입년월"] substringWithRange:NSMakeRange(4, 2)], [dictionary objectForKey:@"납입회차"], [_detailData objectForKey:@"납입방법"]];
    cell.receiptDate.text = [SHBUtility getDateWithDash:[dictionary objectForKey:@"납입일자"]];
    cell.amount.text = [SHBUtility normalStringTocommaString:[dictionary objectForKey:@"합계보험료"]];
    cell.realReceiptAmount.text = [SHBUtility normalStringTocommaString:[dictionary objectForKey:@"실입금액"]];
    cell.discountType.text = [dictionary objectForKey:@"할인유형"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    if ([_dateField.textField.text length] == 0) {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        [_dateField setDate:[dateFormatter dateFromString:AppInfo.tran_Date]];
    }
}

- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date{
    strStartDate = [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if(self.strStartDate == nil || [self.strStartDate isEqualToString:@""]) {
        _recordCountLabel.text = [NSString stringWithFormat:@"조회기준일자 : %@ [0건]", [SHBAppInfo sharedSHBAppInfo].tran_Date];
    } else {
        _recordCountLabel.text = [NSString stringWithFormat:@"조회기준일자 : %@ [0건]", _dateField.textField.text];
    }

    [self sendRequest];
	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
}

@end
