//
//  SHBFundTransListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundTransListViewController.h"
#import "SHBFundStandardListViewController.h"   // 상세조회
#import "SHBFundTransListCell.h" //
#import "SHBFundService.h"
#import "SHBFundDetailViewController.h" // 펀드입금상세조회
#import "SHBDrawingDetailViewController.h"  // 펀드출금상세조회
#import "SHBFundReInvestmentDetailViewController.h"   // 펀드재투자상세조회
#import "SHBFundDepositApplyViewController.h"   // 펀드입금예약취소
#import "SHBFundDrawingApplyViewController.h"   // 펀드출금예약취소
#import "SHBUtility.h"
#import "SHBPeriodPopupView.h"
#import "SHBScrollingTicker.h"

@interface SHBFundTransListViewController () <SHBPopupViewDelegate>
{
    BOOL isShowFundDetailInfo;
    BOOL isShowBalance;
    
    NSString *serviceCode;
    NSString *strStartDate;
    NSString *strEndDate;

    int serviceNo;
    
    SHBScrollingTicker *scrollingTicker;
}

@property (nonatomic, retain) NSString *serviceCode;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@end

@implementation SHBFundTransListViewController

//@synthesize account;
//@synthesize fundCode;
@synthesize fundTransListTable;
@synthesize accountNameLabel;
@synthesize accountNoLabel;
@synthesize issueDateLabel;
@synthesize balanceLabel;
@synthesize availableBalanceLabel;
@synthesize previousData;
@synthesize serviceCode;
@synthesize strStartDate;
@synthesize strEndDate;
@synthesize dicDataDictionary;
@synthesize accountInfo;

- (void)dealloc
{
    [accountInfo release];
    [dicDataDictionary release];
    [_fundTickerName release];
    [fundTransListTable release], fundTransListTable = nil;
    [accountNameLabel release], accountNameLabel = nil;
    [accountNoLabel release], accountNoLabel = nil;
    [issueDateLabel release], issueDateLabel = nil;
    [balanceLabel release], balanceLabel = nil;
    [availableBalanceLabel release], availableBalanceLabel = nil;
    [previousData release];
    [_titleView release];
    [_fundInfoView release];
    [_tableTopSubView release];
    [_lineView release];
    [_termSelectView release];
    [_btnSort release];
    [super dealloc];
}

- (void)refresh
{
    previousData = [[SHBDataSet alloc] initWithDictionary:
                    @{
                    @"거래구분" : @"2",
                    @"계좌번호" : [accountInfo objectForKey:@"계좌번호"],//self.account.accountNo,
                    @"은행구분" : @"1",
                    @"조회시작일" : @"",
                    @"조회종료일" : @"",
                    @"미기장거래" : @"",
                    @"직원조회" : @"1",
                    @"정렬구분" : @"2",
                    @"출력횟수" : @"10",
                    @"계좌비밀번호" : @""
                    }];
    
    serviceNo = FUND_DETAIL_LIST;
    self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DETAIL_LIST viewController: self] autorelease];
    
    self.service.previousData = previousData; //서비스 실행을 위해 필요한 이전 서비스 정보를 데이터셋으로  넘긴다
    [self.service start];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.account = [[SHBAccount alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"펀드조회";
    
    self.strBackButtonTitle = @"펀드조회 메인";
    
    AppInfo.isNeedBackWhenError = YES;

    _tempLabel = @"";
    
    [_fundTickerName initFrame:_fundTickerName.frame];
    [_fundTickerName setCaptionText:[accountInfo objectForKey:@"과목명"]];

    isShowFundDetailInfo = NO;
    int row = 5;
    [_fundInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, (387.0f + 2.0f) - ((15.0f * row) + (10.0f * row)))];

    [_termSelectView setFrame:CGRectMake(0.0f, _fundInfoView.frame.size.height, 317.0f, 80.0f)];
    [_tableTopSubView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _fundInfoView.frame.size.height + _termSelectView.frame.size.height)];

    if (UIAccessibilityIsVoiceOverRunning())
    {
        for (int i  = 3000; i < 3010; i++)
        {
            [[self.view viewWithTag:i] setIsAccessibilityElement:NO];
        }
        
    }
    [self refresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest
{
    self.dataList = nil;
    [fundTransListTable reloadData];

    serviceNo = FUND_DETAIL_LIST;
    SHBDataSet *aDataSet = [SHBDataSet dictionary];
    
    [aDataSet insertObject:[accountInfo objectForKey:@"계좌번호"] forKey:@"계좌번호" atIndex:0];
    [aDataSet insertObject:self.strStartDate forKey:@"조회시작일" atIndex:0];
    [aDataSet insertObject:self.strEndDate forKey:@"조회종료일" atIndex:0];
    
    self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DETAIL_LIST
                                               viewController:self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    int row = 5;
    
    switch ([sender tag]) {
        case 10:   // 계좌상세
        {
            if(isShowFundDetailInfo)
            {
                if (UIAccessibilityIsVoiceOverRunning())
                {
                    for (int i  = 3000; i < 3010; i++)
                    {
                        [[self.view viewWithTag:i] setIsAccessibilityElement:NO];
                    }
                    
                }
                isShowFundDetailInfo = NO;
                sender.selected = NO;
                sender.accessibilityLabel = @"상세보기열기";
                
                [_fundInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, (387.0f + 2.0f) - ((15.0f * row) + (10.0f * row)))];
                _fundInfoView.backgroundColor = RGB(244, 244, 244);
   
            }
            else
            {
                if (UIAccessibilityIsVoiceOverRunning())
                {
                    for (int i  = 3000; i < 3010; i++)
                    {
                        [[self.view viewWithTag:i] setIsAccessibilityElement:YES];
                    }
                    
                }
                
                isShowFundDetailInfo = YES;
                sender.selected = YES;
                sender.accessibilityLabel = @"상세보기닫기";

                [_fundInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, 387.0f)];
                _fundInfoView.backgroundColor = RGB(244, 244, 244);
            }
            
            [_termSelectView setFrame:CGRectMake(0.0f, _fundInfoView.frame.size.height, 317.0f, 80.0f)];
            [_tableTopSubView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, _fundInfoView.frame.size.height + _termSelectView.frame.size.height)];

            [fundTransListTable setTableHeaderView:_tableTopSubView];
            [fundTransListTable setContentOffset:CGPointZero animated:YES];
            
        }
            break;
        case 20:   // 기준가조회
        {
            SHBFundStandardListViewController *detailViewController = [[SHBFundStandardListViewController alloc] initWithNibName:@"SHBFundStandardListViewController" bundle:nil];
            
            NSString *strAccount = [accountInfo objectForKey:@"계좌번호"];
            // 구계좌의 경우
            if ([[accountInfo objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[accountInfo objectForKey:@"구계좌사용여부"] isEqualToString:@"1"] )
            {
                strAccount = [accountInfo objectForKey:@"구계좌번호"];
            }
            
//            detailViewController.accountNo = [accountInfo objectForKey:@"계좌번호"]; //self.account.accountNo;
            // 구계좌경우 문제로 수정
            detailViewController.accountNo = strAccount;
            detailViewController.accountName = [accountInfo objectForKey:@"과목명"]; //self.account.accountName;
            detailViewController.fundCode = [accountInfo objectForKey:@"펀드코드"]; //fundCode;
            
            [self.navigationController pushFadeViewController:detailViewController];
            [detailViewController release];
        }
            break;

            // 일주일전
        case 30:
        {
            strEndDate = [[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];//AppInfo.tran_Date;
            strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];

            [self sendRequest];
        }
            break;

            // 3개월전
        case 40:
        {
            strEndDate = [[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
            strStartDate = [SHBUtility dateStringToMonth:-3 toDay:0];
            
            [self sendRequest];
        }
            break;
        case 50:
        {
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
            
            if(sender.isSelected)
            {
                sender.selected = NO;
                [_btnSort setIsAccessibilityElement:YES];
                _btnSort.accessibilityLabel = @"과거거래순정렬";
            }
            else
            {
                sender.selected = YES;
                [_btnSort setIsAccessibilityElement:YES];
                _btnSort.accessibilityLabel = @"최근거래순정렬";
            }
            NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:sender.isSelected];
            [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
            [sortOrder release];
            
            self.dataList = (NSArray *)tempArray;
            
            [fundTransListTable reloadData];

        }
            break;
            // 기간선택
        case 60:
        {
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - SHBPeriodPopupView
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    _btnSort.selected = NO;
    
    _recordCountLabel.text =[NSString stringWithFormat:@"조회기간:%@~%@ [0건]", self.strStartDate, self.strEndDate];

    [self sendRequest];
}

- (void)popupViewDidCancel
{
    
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
    return 110;
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
    SHBFundTransListCell *cell = (SHBFundTransListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFundTransListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFundTransListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];
    
    cell.transTitleLabel.text = [NSString stringWithFormat:@"%@ %@", [dictionary objectForKey:@"거래종류"], [dictionary objectForKey:@"취소여부"]];
 
    NSString* balanceCount = [[dictionary objectForKey:@"잔고좌수"] substringWithRange:NSMakeRange(0, [[dictionary objectForKey:@"잔고좌수"] rangeOfString:@"."].location)];
    NSString* TransCount = [[dictionary objectForKey:@"거래좌수"] substringWithRange:NSMakeRange(0, [[dictionary objectForKey:@"거래좌수"] rangeOfString:@"."].location)];

    NSString *transAmount = @"";
    if ([[self.service.responseData objectForKey:@"통화종류"] isEqualToString:@"KRW"] || [[dictionary objectForKey:@"통화종류"] isEqualToString:@"JPY"]) {
        transAmount = [[dictionary objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[dictionary objectForKey:@"거래금액"] rangeOfString:@"."].location)];
    } else {
        transAmount = [dictionary objectForKey:@"거래금액"];
    }
    
    cell.transDateLabel.text = [dictionary objectForKey:@"거래일자"];
    cell.transMoneyLabel.text = transAmount;
    cell.accountMoneyLabel.text = balanceCount;
    cell.acountCountLabel.text = TransCount;
    
    NSRange range = [[dictionary objectForKey:@"취소여부"] rangeOfString:@"정정"];
    
    // 취소여부 내용중 정정 찾으면
    if(range.location != NSNotFound) {
//        cell.btnOpen.hidden = YES;
        cell.imgOpen.hidden = YES;
    } else {
//        cell.btnOpen.hidden = NO;
        cell.imgOpen.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dicData = [self.dataList objectAtIndex:indexPath.row];

    NSRange range = [[dicData objectForKey:@"취소여부"] rangeOfString:@"정정"];
    
    // 취소여부 내용중 정정 찾으면
    if(range.location != NSNotFound) {
        return;
    }

    // 입금
    if ([[dicData objectForKey:@"거래종류"] isEqualToString:@"일반신규"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"일반입금"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"전환입금"]) {

        SHBFundDetailViewController *detailViewController = [[SHBFundDetailViewController alloc] initWithNibName:@"SHBFundDetailViewController" bundle:nil];
        
        //
        detailViewController.basicInfo = self.service.responseData;
        detailViewController.fundInfo = dicData;
        
        [self.navigationController pushFadeViewController:detailViewController];
        [detailViewController release];

    // 출금
    } else if ([[dicData objectForKey:@"거래종류"] isEqualToString:@"일반지급"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"전환지급"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"배당금지급"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"배당금"]|| [[dicData objectForKey:@"거래종류"] isEqualToString:@"일반해지"]) {
        
        SHBDrawingDetailViewController *detailViewController = [[SHBDrawingDetailViewController alloc] initWithNibName:@"SHBDrawingDetailViewController" bundle:nil];
        
        //
        detailViewController.basicInfo = self.service.responseData;
        detailViewController.fundInfo = dicData;
        
        [self.navigationController pushFadeViewController:detailViewController];
        [detailViewController release];
        
    // 재투자
    } else if ([[dicData objectForKey:@"거래종류"] isEqualToString:@"재투자"]) {
        
        SHBFundReInvestmentDetailViewController *detailViewController = [[SHBFundReInvestmentDetailViewController alloc] initWithNibName:@"SHBFundReInvestmentDetailViewController" bundle:nil];
        
        //
        detailViewController.basicInfo = self.service.responseData;
        detailViewController.fundInfo = dicData;
        
        [self.navigationController pushFadeViewController:detailViewController];
        [detailViewController release];
        
    // 입금신청
    } else if ([[dicData objectForKey:@"거래종류"] isEqualToString:@"신규예약"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"입금예약"]) {

        SHBFundDepositApplyViewController *detailViewController = [[SHBFundDepositApplyViewController alloc] initWithNibName:@"SHBFundDepositApplyViewController" bundle:nil];
        
        //
        detailViewController.basicInfo = self.service.responseData;
        detailViewController.fundInfo = dicData;
        
        [self.navigationController pushFadeViewController:detailViewController];
        [detailViewController release];

    // 출금신청
    } else if ([[dicData objectForKey:@"거래종류"] isEqualToString:@"지급예약"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"전환예약"] || [[dicData objectForKey:@"거래종류"] isEqualToString:@"해지예약"]) {

        SHBFundDrawingApplyViewController *detailViewController = [[SHBFundDrawingApplyViewController alloc] initWithNibName:@"SHBFundDrawingApplyViewController" bundle:nil];
        
        //
        detailViewController.basicInfo = self.service.responseData;
        detailViewController.fundInfo = dicData;
        
        [self.navigationController pushFadeViewController:detailViewController];
        [detailViewController release];
        
    }

}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceNo) {
        case FUND_DETAIL_LIST: {
            _btnSort.selected = NO;
            
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"거래내역"]) {
                if ([dic objectForKey:@"거래종류"]) {
                    [aDataSet insertObject:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"거래종류"], [dic objectForKey:@"취소여부"]]
                                    forKey:@"거래종류타이틀"
                                   atIndex:0];
                }
            }
            if ([[aDataSet objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
                [aDataSet insertObject:[NSString stringWithFormat:@"원(%@)", [aDataSet objectForKey:@"통화종류"]] forKey:@"통화종류구분" atIndex:0];
            } else {
                [aDataSet insertObject:[NSString stringWithFormat:@"%@", [aDataSet objectForKey:@"통화종류"]] forKey:@"통화종류구분" atIndex:0];
            }

            // 납입원금잔액, 평가금액
            if ([[aDataSet objectForKey:@"통화종류"] isEqualToString:@"KRW"] || [[aDataSet objectForKey:@"통화종류"] isEqualToString:@"JPY"]) {
                NSString *evalAmount = [[aDataSet objectForKey:@"평가금액"] substringWithRange:NSMakeRange(0, [[aDataSet objectForKey:@"평가금액"] rangeOfString:@"."].location)];
                NSString *basicAmount = [[aDataSet objectForKey:@"납입원금잔액"] substringWithRange:NSMakeRange(0, [[aDataSet objectForKey:@"납입원금잔액"] rangeOfString:@"."].location)];
                
                // 0.00 일때 예외처리
                if ([evalAmount isEqualToString:@"0.00"])
                {
                    evalAmount = @"0";
                }
                if ([basicAmount isEqualToString:@"0.00"])
                {
                    basicAmount = @"0";
                }
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@", evalAmount] forKey:@"평가금액원" atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@", basicAmount] forKey:@"납입원금잔액원" atIndex:0];
            } else {
                
                NSString *strString1 = [aDataSet objectForKey:@"평가금액"];
                NSString *strString2 = [aDataSet objectForKey:@"납입원금잔액"];
                
                // 0.00 일때 예외처리
                if ([strString1 isEqualToString:@"0.00"])
                {
                    strString1 = @"0";
                }
                if ([strString2 isEqualToString:@"0.00"])
                {
                    strString2 = @"0";
                }
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@", strString1] forKey:@"평가금액원" atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@", strString2] forKey:@"납입원금잔액원" atIndex:0];
            }
            
            // 연결계좌번호 없을 시 처리
            if ([[aDataSet objectForKey:@"연결계좌번호"] isEqualToString:@""])
            {
                [aDataSet insertObject:@"미등록" forKey:@"연결계좌번호" atIndex:0];
            }
            
            // 잔고좌수
            NSString *balanceAcount = [[aDataSet objectForKey:@"잔고좌수"] substringWithRange:NSMakeRange(0, [[aDataSet objectForKey:@"잔고좌수"] rangeOfString:@"."].location)];

            [aDataSet insertObject:[NSString stringWithFormat:@"%@", balanceAcount] forKey:@"잔고좌수편집" atIndex:0];
            
            // 납입원가수익률
            [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", [aDataSet objectForKey:@"납입원금수익률"]] forKey:@"납입원금수익률기호" atIndex:0];

            // 목표수익률
            if ([[aDataSet objectForKey:@"목표수익률"] floatValue] > 0.0f) {
                [aDataSet insertObject:[NSString stringWithFormat:@"+%@.00%%", [aDataSet objectForKey:@"목표수익율"]] forKey:@"목표수익율기호" atIndex:0];
            } else if ([[aDataSet objectForKey:@"목표수익률"] floatValue] < 0.0f) {
                [aDataSet insertObject:[NSString stringWithFormat:@"-%@.00%%", [aDataSet objectForKey:@"목표수익율"]] forKey:@"목표수익율기호" atIndex:0];
            } else {
                [aDataSet insertObject:[NSString stringWithFormat:@"%@.00%%", [aDataSet objectForKey:@"목표수익율"]] forKey:@"목표수익율기호" atIndex:0];
            }
            
            // 위험수익률
            [aDataSet insertObject:[NSString stringWithFormat:@"%@.00%%", [aDataSet objectForKey:@"위험수익률"]] forKey:@"위험수익률기호" atIndex:0];
            
            self.dataList = [aDataSet arrayWithForKey:@"거래내역"];
            
            if ([self.dataList count] > 0) {
                _tempLabel = @"";
            } else {
                _tempLabel = @"조회된 거래내역이 없습니다.";
            }
            
            NSString *strAccount = [aDataSet objectForKey:@"계좌번호"];
            // 구계좌의 경우
            if ([[aDataSet objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[aDataSet objectForKey:@"구계좌사용여부"] isEqualToString:@"1"] )
            {
                strAccount = [aDataSet objectForKey:@"구계좌번호"];
            }
            // 신구 계좌에 따른 차이로 값 셋팅
            [aDataSet insertObject:strAccount forKey:@"계좌번호표시" atIndex:0];
            
            [fundTransListTable reloadData];
            
        }
            break;
        default:
            break;
    }
    
    if(self.strStartDate == nil || [self.strStartDate isEqualToString:@""]){
        _recordCountLabel.text =[NSString stringWithFormat:@"최근거래내역 %d건이 조회되었습니다.", [self.dataList count]];
    }else{
        NSRange range1 = [self.strEndDate rangeOfString:@"."];
        if (range1.location == NSNotFound) {
            self.strEndDate = [SHBUtility getDateWithDash:self.strEndDate];
        }
        _recordCountLabel.text =[NSString stringWithFormat:@"조회기간:%@~%@ [%d건]", self.strStartDate, self.strEndDate, [self.dataList count]];
    }

    return YES;
}

- (BOOL)onBind:(OFDataSet*)aDataSet
{
    return YES;
}

@end
