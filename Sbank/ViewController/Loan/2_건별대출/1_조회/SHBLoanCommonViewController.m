//
//  SHBLoanCommonViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanCommonViewController.h"
#import "SHBLoanService.h" // 서비스
#import "SHBLoanCommonCell.h" // cell
#import "SHBPeriodPopupView.h" // 팝업

#import "SHBLoanCommonInterestViewController.h"
#import "SHBLoanRePayInqueryViewController.h"

@interface SHBLoanCommonViewController ()
<SHBPopupViewDelegate>
{
    Boolean _isOrderSearch; // 기간 검색 여부
}

@property (retain, nonatomic) NSString *startDate; // 조회시작일
@property (retain, nonatomic) NSString *endDate; // 조회종료일

@end

@implementation SHBLoanCommonViewController

#pragma mark - main

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
    
    [self setTitle:@"대출조회"];
    self.strBackButtonTitle = @"대출계좌 정보상세";
    
    NSString *strAccName = [_accountInfo[@"대출상품명"] isEqualToString:@""] ? _accountInfo[@"대출과목명"] : _accountInfo[@"대출상품명"];
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:strAccName];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self listDataRequest:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_lblTitle release];
    [_headerView release];
    [_detailView release];
    [_interestDetailInfo release];
    [_loanEndDateView release];
    [_orderView release];
    [_orderInfo release];
    [_dataTable release];
    [_arrow release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblTitle:nil];
    [self setHeaderView:nil];
    [self setDetailView:nil];
    [self setInterestDetailInfo:nil];
    [self setLoanEndDateView:nil];
    [self setOrderView:nil];
    [self setOrderInfo:nil];
    [self setDataTable:nil];
    [self setArrow:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)setHeaderDetail:(Boolean)isDetail
{
    FrameReposition(_loanEndDateView, 0, top(_interestDetailInfo) + height(_interestDetailInfo) + 9);
    
    if (isDetail) {
        
        [_detailView setHidden:NO];
        
        FrameReposition(_detailView, 0, top(_loanEndDateView) + height(_loanEndDateView));
        FrameReposition(_orderView, 0, top(_detailView) + height(_detailView));
        
        FrameResize(_headerView, width(_headerView), top(_orderView) + height(_orderView));
    }
    else {
        
        [_detailView setHidden:YES];
        
        FrameReposition(_orderView, 0, top(_loanEndDateView) + height(_loanEndDateView));
        
        FrameResize(_headerView, width(_headerView), top(_orderView) + height(_orderView));
    }
    
    [_dataTable setTableHeaderView:_headerView];
    [_dataTable setContentOffset:CGPointZero animated:YES];
}

- (void)listDataRequest:(Boolean)isOrder
{
    self.dataList = [NSArray array];
    [_dataTable reloadData];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"고객번호" : AppInfo.customerNo,
                                                                  @"실행번호" : @"0",
                                                                  @"조회구분" : @"1"
                                                                  }];
    
    if ([_accountInfo[@"신계좌변환여부"] isEqualToString:@"1"]) {
        
        [aDataSet insertObject:_accountInfo[@"대출계좌번호"]
                        forKey:@"계좌번호"
                       atIndex:0];
    }
    else {
        
        [aDataSet insertObject:_accountInfo[@"구계좌번호"]
                        forKey:@"계좌번호"
                       atIndex:0];
    }
    
    if (isOrder) {
        
        _isOrderSearch = YES;
        
        [aDataSet insertObject:[_startDate stringByReplacingOccurrencesOfString:@"." withString:@""]
                        forKey:@"조회시작일자"
                       atIndex:0];
        [aDataSet insertObject:[_endDate stringByReplacingOccurrencesOfString:@"." withString:@""]
                        forKey:@"조회종료일자"
                       atIndex:0];
    }
    else {
        
        _isOrderSearch = NO;
    }
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1110" viewController: self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)setReverseData
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataList];
    
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"거래일자" ascending:[_arrow isSelected]];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
    
    self.dataList = (NSArray *)tempArray;
    
    [_dataTable reloadData];
}

#pragma mark - Button

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 이자납입
            
            SHBLoanCommonInterestViewController *nextViewController = [[[SHBLoanCommonInterestViewController alloc] initWithNibName:@"SHBLoanCommonInterestViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
            
        case 200: {
            
            // 상세보기
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [sender setAccessibilityLabel:@"상세닫기"];
            }
            else {
                
                [sender setAccessibilityLabel:@"상세보기"];
            }
            
            [self setHeaderDetail:[sender isSelected]];
        }
            break;
            
        case 300: {
            
            // 상환
            
            SHBLoanRePayInqueryViewController *nextViewController = [[[SHBLoanRePayInqueryViewController alloc] initWithNibName:@"SHBLoanRePayInqueryViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            nextViewController.needsCert = YES;
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
            
        case 400: {
            
            // 1주일
            
            self.startDate = [SHBUtility dateStringToMonth:0 toDay:-7];
            self.endDate = AppInfo.tran_Date;
            
            [self listDataRequest:YES];
        }
            break;
            
        case 500: {
            
            // 1개월
            
            self.startDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            self.endDate = AppInfo.tran_Date;
            
            [self listDataRequest:YES];
        }
            break;
            
        case 600: {
            
            // 기간선택
            
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
            
        case 700: {
            
            // 거래내역 정렬
            
            [sender setSelected:![sender isSelected]];
            
            [self setReverseData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    NSLog(@"%@", aDataSet);
    
    self.dataList = [aDataSet arrayWithForKey:@"여신거래내역"];
    
    if ([_accountInfo[@"신계좌변환여부"] isEqualToString:@"1"]) {
        
        [aDataSet insertObject:_accountInfo[@"대출계좌번호"]
                        forKey:@"_계좌번호"
                       atIndex:0];
    }
    else {
        
        [aDataSet insertObject:_accountInfo[@"구계좌번호"]
                        forKey:@"_계좌번호"
                       atIndex:0];
    }
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"대출누계금액KI"]]
                    forKey:@"_대출원금"
                   atIndex:0];
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"대출잔액KI"]]
                    forKey:@"_대출잔액"
                   atIndex:0];
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"적용이율SI"]]
                    forKey:@"_대출금리"
                   atIndex:0];
    
    NSString *strTemp = aDataSet[@"이자상세조회"];
    
    if ([strTemp isEqualToString:@""]) {
        
        strTemp = @"대출금리 상세정보 없음";
    }
    else {
        
        if ([strTemp rangeOfString:@"+"].location != NSNotFound) {
            
            NSInteger iPos = [strTemp rangeOfString:@"+"].location;
            
            strTemp = [NSString stringWithFormat:@"%@\n%@", [strTemp substringToIndex:iPos], [strTemp substringFromIndex:iPos]];
        }
    }
    
    [aDataSet insertObject:strTemp
                    forKey:@"_이자상세조회"
                   atIndex:0];
    
    if (_isOrderSearch) {
        
        [aDataSet insertObject:[NSString stringWithFormat:@"조회기간:%@~%@[%d건]", _startDate, _endDate, [self.dataList count]]
                        forKey:@"_조회정보"
                       atIndex:0];
    }
    else {
        
        [aDataSet insertObject:[NSString stringWithFormat:@"최근거래내역 %d건이 조회되었습니다.", [self.dataList count]]
                        forKey:@"_조회정보"
                       atIndex:0];
    }
    
    for (NSMutableDictionary *dic in self.dataList) {
        
        NSInteger count = 0;
        
        NSMutableArray *redArray = [NSMutableArray array];
        NSMutableArray *blueArray = [NSMutableArray array];
        
        if ([dic[@"거래종류"] length] > 0) {
            
            [dic setObject:@"거래내용"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"거래종류"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            [redArray addObject:[NSString stringWithFormat:@"%d", count]];
            
            count++;
        }
        
        if ([dic[@"이자종류"] length] > 0) {
            
            [dic setObject:@"이자종류"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"이자종류"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            [redArray addObject:[NSString stringWithFormat:@"%d", count]];
            
            count++;
        }
        
        NSString *tmpStr1 = [dic[@"거래금액"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([tmpStr1 length] > 0 && [tmpStr1 longLongValue] != 0) {
            
            [dic setObject:@"거래금액(원금+이자)"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"거래금액"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            count++;
        }
        
        NSString *tmpStr2 = [dic[@"원금금액"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([tmpStr2 length] > 0 && [tmpStr2 longLongValue] != 0) {
            
            [dic setObject:@"원금"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"원금금액"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            count++;
        }
        
        NSString *tmpStr3 = [dic[@"이자금액"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([tmpStr3 length] > 0 && [tmpStr3 longLongValue] != 0) {
            
            [dic setObject:@"이자"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"이자금액"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            count++;
        }
        
        if ([dic[@"시작일자"] length] > 0 && [dic[@"종료일자"] length] > 0) {
            
            [dic setObject:@"이자기간"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:[NSString stringWithFormat:@"%@~%@", dic[@"시작일자"], dic[@"종료일자"]]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            count++;
        }
        
        NSString *tmpStr4 = [dic[@"거래후대출잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([tmpStr4 length] > 0 && [tmpStr4 longLongValue] != 0) {
            
            [dic setObject:@"대출잔액"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:dic[@"거래후대출잔액"]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            [blueArray addObject:[NSString stringWithFormat:@"%d", count]];
            
            count++;
        }
        
        NSString *tmpStr5 = [dic[@"거래내역이율"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([tmpStr5 length] > 0 && [tmpStr5 doubleValue] != 0.f) {
            
            [dic setObject:@"이율"
                    forKey:[NSString stringWithFormat:@"_Title%d", count]];
            
            [dic setObject:[NSString stringWithFormat:@"%@%%", dic[@"거래내역이율"]]
                    forKey:[NSString stringWithFormat:@"_Data%d", count]];
            
            [blueArray addObject:[NSString stringWithFormat:@"%d", count]];
            
            count++;
        }
        
        [dic setObject:[NSString stringWithFormat:@"%d", count] forKey:@"_Count"];
        [dic setObject:redArray forKey:@"_Red"];
        [dic setObject:blueArray forKey:@"_Blue"];
    }
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, aDataSet[@"_대출원금"]);
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _lblTitle);
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    [_orderInfo setText:aDataSet[@"_조회정보"]];
    
    CGSize labelSize = [_interestDetailInfo.text sizeWithFont:_interestDetailInfo.font
                                            constrainedToSize:CGSizeMake(width(_interestDetailInfo), 999)
                                                lineBreakMode:_interestDetailInfo.lineBreakMode];
    
    FrameResize(_interestDetailInfo, width(_interestDetailInfo), labelSize.height + 2);
    
    [self setHeaderDetail:NO];
    
    [self setReverseData];
    
    return YES;
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
    if ([self.dataList count] == 0) {
        
        return 110;
    }
    
    CGFloat height = 0;
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    if (indexPath.row > 0) {
        
        OFDataSet *dic = self.dataList[indexPath.row - 1];
        
        if (![cellDataSet[@"거래일자"] isEqualToString:dic[@"거래일자"]]) {
            
            height += 35;
        }
    }
    else {
        
        height += 35;
    }
    
    height += (25 * [cellDataSet[@"_Count"] integerValue]) + 10;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.textLabel setText:@"조회된 거래내역이 없습니다."];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }
    
    SHBLoanCommonCell *cell = (SHBLoanCommonCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBLoanCommonCell"];
    
    if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanCommonCell"
                                                       owner:self options:nil];
		cell = (SHBLoanCommonCell *)array[0];
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    CGFloat height = 0;
    
    [cell.transferDate setHidden:YES];
    
    if (indexPath.row > 0) {
        
        OFDataSet *dic = self.dataList[indexPath.row - 1];
        
        if (![cellDataSet[@"거래일자"] isEqualToString:dic[@"거래일자"]]) {
            
            height += 35;
            
            [cell.transferDate setHidden:NO];
        }
    }
    else {
        
        height += 35;
        
        [cell.transferDate setHidden:NO];
    }
    
    FrameReposition(cell.dataView, 0, height);
    
    height += (25 * [cellDataSet[@"_Count"] integerValue]) + 10;
    
    FrameResize(cell.dataView, width(cell.dataView), height);
    
    for (NSString *str in cellDataSet[@"_Red"]) {
        
        NSInteger index = [str integerValue] * 10;
        
        UILabel *label1 = (UILabel *)[cell.dataView viewWithTag:100 + index + 1];
        UILabel *label2 = (UILabel *)[cell.dataView viewWithTag:100 + index + 2];
        
        [label1 setTextColor:RGB(209, 75, 75)];
        [label2 setTextColor:RGB(209, 75, 75)];
    }
    
    for (NSString *str in cellDataSet[@"_Blue"]) {
        
        NSInteger index = [str integerValue] * 10;
        
        UILabel *label1 = (UILabel *)[cell.dataView viewWithTag:100 + index + 1];
        UILabel *label2 = (UILabel *)[cell.dataView viewWithTag:100 + index + 2];
        
        [label1 setTextColor:RGB(0, 137, 220)];
        [label2 setTextColor:RGB(0, 137, 220)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    if ([mDic[@"from"] integerValue] >
        [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        return;
    }
    
    if ([mDic[@"to"] integerValue] >
        [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        return;
    }
    
    self.startDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.endDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self listDataRequest:YES];
}

- (void)popupViewDidCancel
{
    
}

@end
