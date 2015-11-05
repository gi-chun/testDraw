//
//  SHBFundAccountListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 12..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundAccountListViewController.h"
#import "SHBFundAccountListCell.h"
#import "SHBFundTransListViewController.h"  // 계좌 거래내역
#import "SHBFundDepositDetailViewController.h"  // 입금 계좌 상세정보
#import "SHBFundTransDetailViewController.h"    // 출금 계좌 상세정보
#import "SHBFundExchangeListViewController.h"   // 선물환 역외펀드 리스트
#import "SHBFundService.h"                      // 펀드 서비스
#import "SHBConstants.h"


@implementation SHBFundAccountListViewController

#pragma mark -
#pragma mark Synthesize

@synthesize fundAcctListTable;


#pragma mark -
#pragma mark Private Method

- (void)refresh
{
    serviceType = 0;
    self.service = [[[SHBFundService alloc] initWithServiceId:FUND_LIST viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
}

// 미성년자 체크
- (BOOL)isAdultCheck
{
    NSString *strBirthYear = [SHBUtility birthYearString];
    
    NSString *basisDate = [[SHBUtility dateStringToMonth:-228 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *basisD = [dateFormatter dateFromString:basisDate];
    NSDate *compD = [dateFormatter dateFromString:strBirthYear];
    
	NSComparisonResult result = [basisD compare:compD];
	
	if (result == NSOrderedAscending) {
        NSLog(@"미성년자");
        
        [dateFormatter release];
        return NO;
    }
    
	if (result == NSOrderedDescending || result == NSOrderedSame)
        NSLog(@"19세 이상");
	
    [dateFormatter release];
    
    return YES;
}


// 상세조회
- (void)inqueryAccount:(int)row
{
    SHBFundTransListViewController *detailViewController = [[SHBFundTransListViewController alloc] initWithNibName:@"SHBFundTransListViewController" bundle:nil];
    
    // 데이터 설정.
    NSDictionary *account = [self.dataList objectAtIndex:row];
    detailViewController.accountInfo = account;
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
}

// 입금
- (void)depositAccount:(int)row
{
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    // 실 서버 시
    if (AppInfo.realServer)
    {
        if (time < 90000 || time > 230000) {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"09:00 ~ 23:00 까지만 이용가능한 서비스입니다."];
            
            return;
        }
    }
    else            // 테스트용
    {
        if ( time < 90000 || time > 230000 )
        {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@"테스트 알림"
                           message:@"09:00 ~ 23:00 까지만 이용가능한 서비스입니다.\n테스트입니다."];
        }
    }
    
    
    NSDictionary *account = [self.dataList objectAtIndex:row];
    
    if ([[account objectForKey:@"계좌번호"] hasPrefix:@"252"] || [[account objectForKey:@"계좌번호"] hasPrefix:@"254"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:[NSString stringWithFormat:@"입금 불가능한 계좌입니다."]
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
    } else {
        serviceType = 1;
        
        // 구계좌도 신계좌로 보낸다
        NSString *tempAccNo = [account objectForKey:@"계좌번호"];
        
//        if ([[account objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
//        {
//            tempAccNo = [account objectForKey:@"계좌번호"];
//            tempBankCode = @"1";
//        }
//        else
//        {
//            tempAccNo = [account objectForKey:@"구계좌번호"];
//            tempBankCode = [account objectForKey:@"은행코드"];
//        }
    
        // D6210
        SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                     @{
                                     @"거래구분" : @"1",
                                     @"계좌번호" : tempAccNo,
                                     @"조회시작일" : @"",
                                     @"조회종료일" : @"",
                                     @"미기장거래" : @"2",
                                     @"직원조회" : @"1",
                                     @"정렬순서" : @"1",
                                     @"출력횟수" : @""
                                     }] autorelease];
        
        self.service = [[[SHBFundService alloc] initWithServiceId: FUND_DEPOSIT_CONTENT viewController: self] autorelease];
        self.service.previousData = previousData;
        [self.service start];
        
    }
}

// 출금
-(void)transAccount:(int)row
{
    NSLog(@"출금 %d", row);
    NSLog(@"출금화면:%@",[self.navigationController viewControllers]);
    
    // 미성년자 체크
    if (![self isAdultCheck]) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"만 19세 미만 미성년자는 영업점을 방문하셔서 펀드 출금(해지)을 해주시기 바랍니다.\n\n※미성년자의 경우 법정대리인 또는 친권자(부 or 모)의 동의에 의한 출금(해지)만 가능합니다.\n\n[필요서류 : 법정대리인 또는 방문한 친권자의 신분증 및 도장(서명도 가능), 자녀기준으로 발급된 기본증명서와 가족관계증명서]"];
        return;
    }
    
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    // 실 서버 시
    if (AppInfo.realServer)
    {
        if (![SHBUtility isOPDate:[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""]] || time < 90000 || time > 160000) {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"09:00 ~ 16:00 까지만 이용가능한 서비스입니다.(토요일, 휴일 불가능)"];
            
            return;
        }
    }
    else            // 테스트용
    {
        if ( time < 90000 || time > 160000 )
        {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@"테스트 알림"
                           message:@"09:00 ~ 16:00 까지만 이용가능한 서비스입니다.(토요일, 휴일 불가능)\n테스트입니다."];
        }
    }
    
    serviceType = 2;
    NSDictionary *account = [self.dataList objectAtIndex:row];
    
    if ([[account objectForKey:@"계좌번호"] hasPrefix:@"252"] || [[account objectForKey:@"계좌번호"] hasPrefix:@"254"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:[NSString stringWithFormat:@"출금 불가능한 계좌입니다."]
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
        return;
    }
    
    // 구계좌도 신계좌로 보낸다
    NSString *tempAccNo = [account objectForKey:@"계좌번호"];
    
//    if ([[account objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
//    {
//        tempAccNo = [account objectForKey:@"계좌번호"];
//        tempBankCode = @"1";
//    }
//    else
//    {
//        tempAccNo = [account objectForKey:@"구계좌번호"];
//        tempBankCode = [account objectForKey:@"은행코드"];
//    }

    // D6310
    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                 @{
                                 @"거래구분" : @"1",
                                 @"계좌번호" : tempAccNo,
                                 @"조회시작일" : @"",
                                 @"조회종료일" : @"",
                                 @"미기장거래" : @"2",
                                 @"직원조회" : @"1",
                                 @"정렬순서" : @"1",
                                 @"출력횟수" : @""
                                 }] autorelease];
    
    self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DRAWING_CONTENT viewController:self] autorelease];
    self.service.previousData = previousData;
    [self.service start];
    
}

// 선물환 역외펀드 리스트
-(void)forwardExchangeList:(int)row
{
    SHBFundExchangeListViewController *detailViewController = [[SHBFundExchangeListViewController alloc] initWithNibName:@"SHBFundExchangeListViewController" bundle:nil];
    
    // 계좌 설정
    NSDictionary *account = [self.dataList objectAtIndex:row];
    detailViewController.accountNo = [account objectForKey:@"계좌번호"];
    detailViewController.accountName = [account objectForKey:@"과목명"];
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            if (aDataSet[@"수익증권납입총액"]) {
                [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"수익증권납입총액"]]
                                forKey:@"수익증권납입총액원"
                               atIndex:0];
            }
            if (aDataSet[@"펀드총잔액"]) {
                [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"펀드총잔액"]]
                                forKey:@"펀드총잔액원"
                               atIndex:0];
            }
            if (aDataSet[@"납입원금총수익률"]) {
                [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"납입원금총수익률"]]
                                forKey:@"납입원금총수익률총"
                               atIndex:0];
            }
            
            self.dataList = [aDataSet arrayWithForKey:@"펀드계좌"];
            
            if ([self.dataList count] > 0) {
                strDataNone = @"";
                footerView.hidden = NO;
            }
            else
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:109 title:@"" message:@"조회된 상품이 없습니다."];
                
                strDataNone = @"조회된 거래내역이 없습니다.";
                footerView.hidden = YES;
            }
            
            [fundAcctListTable reloadData];
        }
            break;
            // 입금
        case 1:
        {
            // 정보 setting
            SHBFundDepositDetailViewController *detailViewController = [[SHBFundDepositDetailViewController alloc] initWithNibName:@"SHBFundDepositDetailViewController" bundle:nil];
            
            //            detailViewController.data_D6010 = [self.dataList objectAtIndex:selectedRow];
            detailViewController.data_D6210 = self.service.responseData;
            detailViewController.needsCert = YES;
            
            // 공인인증확인
            [self checkLoginBeforePushViewController:detailViewController animated:YES];
            [detailViewController release];
            
        }
            break;
            
            // 출금
        case 2:
        {
            NSDictionary *data_D6310 = self.service.responseData;
            
            if([[data_D6310 objectForKey:@"저축종류"] isEqualToString:@"적립식"] &&
               [[data_D6310 objectForKey:@"만기일자"] intValue] >= [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue])
            {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"적립식상품은 만기일 이전에는 출금거래가 되지 않으며, 해지거래(영업점/인터넷뱅킹)만 가능합니다."];
                
                return NO;
            }
            
            if([[data_D6310 objectForKey:@"저축종류"] isEqualToString:@"거치식"] &&
               [[data_D6310 objectForKey:@"만기일자"] intValue] >= [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue])
            {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"거치식상품은 만기일 이전에는 출금거래가 되지 않으며, 해지거래(영업점/인터넷뱅킹)만 가능합니다."];
                
                return NO;
            }
            
            SHBFundTransDetailViewController *detailViewController = [[SHBFundTransDetailViewController alloc] initWithNibName:@"SHBFundTransDetailViewController" bundle:nil];
            
            // 정보 설정
            //            detailViewController.data_D6010 = [self.dataList objectAtIndex:selectedRow];
            detailViewController.data_D6310 = data_D6310;
            [detailViewController.data_D6310 setValue:[[self.dataList objectAtIndex:selectedRow] objectForKey:@"신계좌변환여부"] forKey:@"신계좌변환여부"];
            
            detailViewController.needsCert = YES;
            
            [self checkLoginBeforePushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
            break;
        default:
            break;
    }
    
    return YES;
}


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
//    if (!UIAccessibilityIsVoiceOverRunning())
//    {
//        if(selectedRow == indexPath.row)
//        {
//            return 137;
//        }
//        return 98;
//    }else
//    {
//        return 137;
//    }
    if(selectedRow == indexPath.row)
    {
        return 137;
    }
    return 98;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [cell.textLabel setText:strDataNone];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    SHBFundAccountListCell *cell = (SHBFundAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFundAccountListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFundAccountListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];
    
    
    if ([[dictionary objectForKey:@"상품부기명"] length] > 0)
    {
        cell.titleLabel.text = [dictionary objectForKey:@"상품부기명"];
        if (![[dictionary objectForKey:@"통화코드"] isEqualToString:@"KRW"])
        {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ 통화종류:(%@)", cell.titleLabel.text, [dictionary objectForKey:@"통화코드"]];
        }
    }
    else
    {
        cell.titleLabel.text = [dictionary objectForKey:@"과목명"];
    }
    
    if ([[dictionary objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
    {
        cell.accountLabel.text = [dictionary objectForKey:@"계좌번호"];
    }
    else
    {
        cell.accountLabel.text = [dictionary objectForKey:@"구계좌번호"];
    }
    
    if ([[dictionary objectForKey:@"누적수익율"] isEqualToString:@"0.00"])
    {
        cell.rateLabel.text = @"0%";
    }
    else
    {
        cell.rateLabel.text = [NSString stringWithFormat:@"%@%%", [dictionary objectForKey:@"누적수익율"]];
    }
    
    if([[dictionary objectForKey:@"누적수익율"] floatValue] > 0.0f)
    {
        [cell.rateLabel setTextColor:RGB(209, 75, 75)];

    }
    else if([[dictionary objectForKey:@"누적수익율"] floatValue] == 0.0f)
    {
        cell.rateLabel.textColor = [UIColor blackColor];
    }
    else
    {
        [cell.rateLabel setTextColor:RGB(0, 137, 220)];
    }

    if ([[dictionary objectForKey:@"통화코드"] isEqualToString:@"KRW"])
    {
//        cell.moneyLabel.text = [NSString stringWithFormat:@"평가금액(%@) : %@원", [dictionary objectForKey:@"통화코드"], [dictionary objectForKey:@"평가금액"]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"평가금액 : %@", [dictionary objectForKey:@"평가금액"]];
    }
    else {
        cell.moneyLabel.text = [NSString stringWithFormat:@"평가금액(%@) : %@", [dictionary objectForKey:@"통화코드"], [dictionary objectForKey:@"평가금액"]];
    }

    
    cell.row = indexPath.row;
    cell.target = self;
    cell.openBtnSelector = @selector(openOrCloseCell:);

    cell.leftBtnSelector = @selector(inqueryAccount:);
    cell.centerBtnSelector = @selector(depositAccount:);

    // 선물환역외펀드 계좌를 찾으면
    // 현업의 요청으로 구계좌번호를 가지고 있는 펀드도 기존 계좌번호도 모두 계좌번호로 체크
    if ([[dictionary objectForKey:@"계좌번호"] hasPrefix:@"252"]|| [[dictionary objectForKey:@"계좌번호"] hasPrefix:@"254"])
    {
        [cell.btnRight setTitle:@"선물환조회" forState:UIControlStateNormal];
        cell.rightBtnSelector = @selector(forwardExchangeList:);
    }
    else
    {
        [cell.btnRight setTitle:@"출금" forState:UIControlStateNormal];
        cell.rightBtnSelector = @selector(transAccount:);
    }
    
    
    
    if(selectedRow == indexPath.row)
    {
        cell.bgView.backgroundColor = RGB(244, 244, 244);
        
        if(cell.openBtnSelector != nil)
        {
            cell.btnOpen.hidden = NO;
            [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        }
//        if (!UIAccessibilityIsVoiceOverRunning())
//        {
            cell.btnLeft.hidden = NO;
            cell.btnCenter.hidden = NO;
            cell.btnRight.hidden = NO;
//        }
        
        
        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기닫기";
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, cell.btnLeft);
    }
    else
    {
        cell.bgView.backgroundColor = [UIColor clearColor];
        
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
        
//        if (!UIAccessibilityIsVoiceOverRunning())
//        {
            cell.btnLeft.hidden = YES;
            cell.btnCenter.hidden = YES;
            cell.btnRight.hidden = YES;
//        }
        

        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기열기";
    }
    
//    if (UIAccessibilityIsVoiceOverRunning())
//    {
//        cell.btnLeft.hidden = NO;
//        cell.btnCenter.hidden = NO;
//        cell.btnRight.hidden = NO;
//        cell.btnOpen.hidden = YES;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow != indexPath.row)
    {
        selectedRow = indexPath.row;
        [fundAcctListTable reloadData];
    }
    
    [self inqueryAccount:indexPath.row];
}


#pragma mark -
#pragma Cell Open

- (void)openOrCloseCell:(int)row
{
    if(selectedRow == row)
    {
        selectedRow = -1;
    }
    else
    {
        selectedRow = row;
    }
    
    if (footerView.hidden) {
        footerView.hidden = NO;
    }
        
    [fundAcctListTable reloadData];
}


#pragma mark -
#pragma mark Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if(alertView.tag == 109)
    {
        [self.navigationController fadePopViewController];
    }
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
    self.title = @"펀드조회입금출금";
    
    self.strBackButtonTitle = @"펀드조회입금출금 메인";
    
    // 시작시 Footer를 보이지 않게
    footerView.hidden = YES;
    
    serviceType = 0;
    selectedRow = -1;
    
    strDataNone = @"";
    
    AppInfo.isNeedBackWhenError = YES;
    
    // original
    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                 @{
//                                 @"로그인예금조회구분" : @"1",
//                                 @"보안계좌조회구분" : @"1",
//                                 @"인터넷제한여부" : @"0",
                                 }] autorelease];
    
    self.service = [[[SHBFundService alloc] initWithServiceId: FUND_LIST viewController: self] autorelease];
    self.service.previousData = previousData;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setFundAcctListTable:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    self.fundAcctListTable = nil;
    [footerView release];
    
    [super dealloc];
}


@end
