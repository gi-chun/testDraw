//
//  SHBAccountMenuListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountMenuListViewController.h"
#import "SHBAccountListCell.h"
#import "SHBAccountService.h"
#import "SHBPushInfo.h"
#import "SHBAccountInqueryViewController.h"   // 예금 거래내역 조회
#import "SHBTransferInfoInputViewController.h"
#import "SHBDepositInfoInputViewController.h"
#import "SHBTransferResultListViewController.h"
#import "SHBPrimiumTransferViewController.h"
// 대출
#import "SHBLoanCommonViewController.h"
#import "SHBLoanTransLimitedListViewController.h"
#import "SHBLoanInterestViewController.h"   // 이자조회
#import "SHBLoanCommonInterestViewController.h"
#import "SHBInterestInqueryViewController.h"
#import "SHBLoanRePayInqueryViewController.h"
#import "SHBLoanCancelViewController.h"

// 펀드
#import "SHBFundTransListViewController.h"  // 펀드 상세조회
#import "SHBFundDepositDetailViewController.h"  // 펀드입금 1스텝
#import "SHBFundTransDetailViewController.h"    // 펀드출금 1스텝
#import "SHBFundService.h"

// 방카슈방스
#import "SHBBancasuranceListCell.h"
#import "SHBBancasurancePaymentListViewController.h"    // 입급내역 조회
#import "SHBBancasuranceBaseInfoViewController.h"       // 방카슈랑스 생명보험조회
#import "SHBBancasuranceDemageInfoViewController.h"     // 방카슈랑스 손해보험조회

// 선물환 역외펀드
#import "SHBFundExchangeListViewController.h"

// 외화골드
#import "SHBForexGoldListCell.h"
#import "SHBForexGoldListViewController.h" // 외화골드예금조회
#import "SHBForexDetailListViewController.h" // 외화예금조회
#import "SHBForexGoldDetailListViewController.h" // 골드리슈예금조회
#import "SHBGoldDepositInfoViewController.h"  // 골드입금안내
#import "SHBGoldPaymentInfoViewController.h"  // 골드출금안내

// 전체계좌
#import "SHBAllAccountListCell.h"

// 펀드
#import "SHBAccountFundListCell.h"

// 만기예정 및 경과상품 안내
#import "SHBAccountExpiryDateView.h"

#import "SHBSearchView.h"

// 휴면예금
#import "SHBAccountDormantCell.h"

@interface SHBAccountMenuListViewController () <AccountExpiryDateDelegate>
{
    int accountType, accountTypePre;
    NSString *strServiceCode;
    int openedRow;
    
    NSArray *infoList;
    
    int serviceType;
    NSString *strTargetAccNo;
    NSMutableDictionary *pushDic;
    
    NSInteger menuIndex;
}
@property (nonatomic, retain) NSString *strServiceCode;
@property (nonatomic, retain) NSArray *infoList;
@property (nonatomic, retain) SHBAccountExpiryDateView *expiryPopupView;

@property (retain, nonatomic) NSArray *foreignAccountNumberList; // 외화출금 계좌번호
@property (retain, nonatomic) NSArray *foreignAccountNumberList2; // 외화입금 계좌번호


- (void)displayFooterView;
- (void)showSearchView;
@end

@implementation SHBAccountMenuListViewController

#pragma mark -
#pragma mark Synthesize

@synthesize service;
@synthesize strServiceCode;
@synthesize infoList;
@synthesize array1;        // 입/출금
@synthesize array2;        // 정기적금신탁
@synthesize array3;        // 펀드
@synthesize array4;        // 대출
@synthesize array5;        // 외화
@synthesize array6;        // 골드


#pragma mark -
#pragma mark Gesture

- (void)handleGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
	if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        
        if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            
            if (!_btnNextMenu.enabled) return;
            
            [self changeMenu:_btnPrevMenu];
        }
        
        if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            
            if (_btnNextMenu.enabled) return;
            
            [self changeMenu:_btnNextMenu];
        }
	}
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)changeMenu:(UIButton *)sender
{
    if (_menuView.frame.origin.x == 0) {
        
        menuIndex = 0;
    }
    else if (_menuView.frame.origin.x == -246) {
        
        menuIndex = 1;
    }
    else if (_menuView.frame.origin.x == -492) {
        
        menuIndex = 2;
    }
    
    if (sender == _btnPrevMenu) {
        
        // <
        
        menuIndex--;
    }
    else {
        
        // >
        
        menuIndex++;
    }
    
    CGFloat x = 0;
    
    switch (menuIndex) {
            
        case 0: {
            
            x = 0;
            
            [_btnPrevMenu setEnabled:NO];
            [_btnPrevMenu setAccessibilityHint:@"비활성화"];
            [_btnPrevMenu setIsAccessibilityElement:NO];
            
            [_btnNextMenu setEnabled:YES];
            [_btnNextMenu setAccessibilityHint:@"활성화"];
        }
            break;
            
        case 1: {
            
            x = -246;
            
            [_btnPrevMenu setEnabled:YES];
            [_btnPrevMenu setAccessibilityHint:@"활성화"];
            [_btnPrevMenu setIsAccessibilityElement:YES];
            
            [_btnNextMenu setEnabled:YES];
            [_btnNextMenu setAccessibilityHint:@"활성화"];
        }
            break;
            
        case 2: {
            
            x = -492;
            
            [_btnPrevMenu setEnabled:YES];
            [_btnPrevMenu setAccessibilityHint:@"활성화"];
            [_btnPrevMenu setIsAccessibilityElement:YES];
            
            [_btnNextMenu setEnabled:NO];
            [_btnNextMenu setAccessibilityHint:@"비활성화"];
        }
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        FrameReposition(_menuView, x, top(_menuView));
    }];
}

- (IBAction)selectMenu:(UIButton *)sender
{
    accountType = [sender tag] - 200;
    
    openedRow = -1;
    
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    for(UIButton *btn in _btnMenu)
    {
        btn.enabled = YES;
        btn.accessibilityHint = @"선택 가능";
        
        [btn setBackgroundImage:[UIImage imageNamed:@"menutab_normal.png"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (accountType != accountTypePre)
    {
        sender.accessibilityHint = @"선택됨";
        accountTypePre = accountType;
        [sender setBackgroundImage:[UIImage imageNamed:@"menutab_select.png"] forState:UIControlStateNormal];
        [sender setTitleColor:RGB(59, 70, 133) forState:UIControlStateNormal];
    }else
    {
        sender.accessibilityHint = @"선택됨";
        [sender setBackgroundImage:[UIImage imageNamed:@"menutab_select.png"] forState:UIControlStateNormal];
        [sender setTitleColor:RGB(59, 70, 133) forState:UIControlStateNormal];
        return;
        
    }
    //sender.accessibilityHint = @"선택됨";
    //sender.enabled = NO;
    
    /*
     //이헹안함
    //알림바로가기 버튼 우선 리무브
    UIButton *tagBtn = (UIButton*)[self.view viewWithTag:15600];
    [tagBtn removeFromSuperview];
    */
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] init] autorelease];
    
    switch (accountType) {
        case 0: // 예금신탁
        {
            self.strServiceCode = @"D0011";
        }
            break;
        case 1: // 펀드
        {
            self.strServiceCode = @"D6010";
        }
            break;
        case 2: // 대출
        {
            self.strServiceCode = @"L0010";
        }
            break;
        case 3: // 외환골드
        {
            self.strServiceCode = @"F0010";
        }
            break;
        case 4: // 방카슈랑스
        {
            self.strServiceCode = @"B0010";
        }
            break;
        case 5: // 전체계좌
        {
            self.strServiceCode = @"C2010";
            
            self.array1 = nil;
            self.array2 = nil;
            self.array3 = nil;
            self.array4 = nil;
            self.array5 = nil;
            self.array6 = nil;
            
            // 전체 계좌에서 사용될 data array
            self.array1 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            self.array2 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            self.array3 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            self.array4 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            self.array5 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            self.array6 = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
        }
            break;
        case 6: // 휴면예금
        {
            self.strServiceCode = @"C2010";
            
            [aDataSet insertObject:@"9"
                            forKey:@"거래구분"
                           atIndex:0];
            
            [aDataSet insertObject:@"2"
                            forKey:@"해지거래구분"
                           atIndex:0];
            
            [aDataSet insertObject:@"2"
                            forKey:@"보안계좌조회구분"
                           atIndex:0];
            
            [aDataSet insertObject:@"1"
                            forKey:@"계좌감추기여부"
                           atIndex:0];
        }
            break;
            
        default:
            break;
    }
    
    // refresh 효과를 준다
    view2.hidden = YES;
    [labelNoAccount setHidden:YES];
    [scrollView1 setContentOffset:CGPointMake(0, 0)];
    
    self.dataList = nil;
    [_tableView1 setTableHeaderView:nil];
    [_tableView1 setTableFooterView:nil];
    [_tableView1 reloadData];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (IBAction)showAccount6:(id)sender
{
    // 휴면예금조회
    
    FrameReposition(_menuView, -246, top(_menuView));
    
    [self changeMenu:_btnNextMenu];
    [self selectMenu:_btnMenu[6]];
}

- (void)setAllAccountList
{
    view1.hidden = NO;
    self.tableView1.hidden = YES;
    
    // 정상케이스의 경우
    int intHeight1 = [self tableView:table1 heightForRowAtIndexPath:0];
    int intHeight2 = [self tableView:table2 heightForRowAtIndexPath:0];
    int intHeight3 = [self tableView:table3 heightForRowAtIndexPath:0];
    int intHeight4 = [self tableView:table4 heightForRowAtIndexPath:0];
    int intHeight5 = [self tableView:table5 heightForRowAtIndexPath:0];
    int intHeight6 = [self tableView:table6 heightForRowAtIndexPath:0];
    
    int intView1Height = (([self.array1 count]) * intHeight1) + table1.tableHeaderView.frame.size.height + table1.tableFooterView.frame.size.height;
    int intView2Height = (([self.array2 count]) * intHeight2) + table2.tableHeaderView.frame.size.height + table2.tableFooterView.frame.size.height;
    int intView3Height = (([self.array3 count]) * intHeight3) + table3.tableHeaderView.frame.size.height + table3.tableFooterView.frame.size.height;
    int intView4Height = (([self.array4 count]) * intHeight4) + table4.tableHeaderView.frame.size.height + table4.tableFooterView.frame.size.height;
    int intView5Height = (([self.array5 count]) * intHeight5) + table5.tableHeaderView.frame.size.height + table5.tableFooterView.frame.size.height;
    int intView6Height = (([self.array6 count]) * intHeight6) + table6.tableHeaderView.frame.size.height + table6.tableFooterView.frame.size.height;
    
    int intArray1Count = [self.array1 count];
    int intArray2Count = [self.array2 count];
    int intArray3Count = [self.array3 count];
    int intArray4Count = [self.array4 count];
    int intArray5Count = [self.array5 count];
    int intArray6Count = [self.array6 count];
    
    int intAllCount = intArray1Count + intArray2Count + intArray3Count + intArray4Count + intArray5Count + intArray6Count;
    
    if ( intArray1Count == 0 )
        intView1Height = 0;
    
    if ( intArray2Count == 0 )
        intView2Height = 0;
    
    if ( intArray3Count == 0 )
        intView3Height = 0;
    
    if ( intArray4Count == 0 )
        intView4Height = 0;
    
    if ( intArray5Count == 0 )
        intView5Height = 0;
    
    if ( intArray6Count == 0 )
        intView6Height = 0;
    
    if (intAllCount == 0)
    {
        [labelNoAccount setHidden:NO];
    }
    
    [viewTable1 setFrame:CGRectMake(0, 0,
                                    viewTable1.frame.size.width,
                                    intView1Height)];
    [viewTable2 setFrame:CGRectMake(0,
                                    viewTable1.frame.size.height,
                                    viewTable2.frame.size.width,
                                    intView2Height)];
    [viewTable3 setFrame:CGRectMake(0,
                                    viewTable1.frame.size.height + viewTable2.frame.size.height,
                                    viewTable3.frame.size.width,
                                    intView3Height)];
    [viewTable4 setFrame:CGRectMake(0,
                                    viewTable1.frame.size.height + viewTable2.frame.size.height + viewTable3.frame.size.height,
                                    viewTable4.frame.size.width,
                                    intView4Height)];
    [viewTable5 setFrame:CGRectMake(0,
                                    viewTable1.frame.size.height + viewTable2.frame.size.height + viewTable3.frame.size.height + viewTable4.frame.size.height,
                                    viewTable5.frame.size.width,
                                    intView5Height)];
    [viewTable6 setFrame:CGRectMake(0,
                                    viewTable1.frame.size.height + viewTable2.frame.size.height + viewTable3.frame.size.height + viewTable4.frame.size.height + viewTable5.frame.size.height,
                                    viewTable6.frame.size.width,
                                    intView6Height)];
    
    float fltAllHeight = viewTable1.frame.size.height + viewTable2.frame.size.height + viewTable3.frame.size.height + viewTable4.frame.size.height + viewTable5.frame.size.height + viewTable6.frame.size.height;
    
    [view2 setFrame:CGRectMake(view2.frame.origin.x, view2.frame.origin.y, view2.frame.size.width, fltAllHeight)];
    
    [view2 addSubview:viewTable1];
    [view2 addSubview:viewTable2];
    [view2 addSubview:viewTable3];
    [view2 addSubview:viewTable4];
    [view2 addSubview:viewTable5];
    [view2 addSubview:viewTable6];
    
    [scrollView1 setContentSize:CGSizeMake(view2.frame.size.width, view2.frame.size.height)];
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    view1.hidden = YES;
    self.tableView1.hidden = NO;
    
    switch (serviceType) {
        case 1:
        {
            NSDictionary *dictionary = self.service.responseData;
            
            SHBFundDepositDetailViewController *nextViewController = [[[SHBFundDepositDetailViewController alloc] initWithNibName:@"SHBFundDepositDetailViewController" bundle:nil] autorelease];
            nextViewController.data_D6210 = dictionary;

            nextViewController.needsCert = YES;
            
            // 공인인증확인
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
            
        case 2:
        {
            //            NSDictionary *dictionary = self.service.responseData;
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
            
            detailViewController.needsCert = YES;
            
            // 공인인증확인
            [self checkLoginBeforePushViewController:detailViewController animated:YES];
            [detailViewController release];
            
        }
            break;
            // 방카슈랑스 조회
        case 6:
        {
            // 생명보험 조회
            if ([self.strServiceCode isEqualToString:@"B1110"]) {
                SHBBancasuranceBaseInfoViewController *nextViewController = [[SHBBancasuranceBaseInfoViewController alloc] initWithNibName:@"SHBBancasuranceBaseInfoViewController" bundle:nil];
                nextViewController.detailData = aDataSet;
                
                [self.navigationController pushViewController:nextViewController animated:YES];
                [nextViewController release];
            // 손해보험 조회
            } else if ([self.strServiceCode isEqualToString:@"B1160"]) {
                SHBBancasuranceDemageInfoViewController *nextViewController = [[SHBBancasuranceDemageInfoViewController alloc] initWithNibName:@"SHBBancasuranceDemageInfoViewController" bundle:nil];
                nextViewController.detailData = aDataSet;
                
                [self.navigationController pushViewController:nextViewController animated:YES];
                [nextViewController release];
            }
        }
            break;
            // 방카슈랑스 입금내역조회
        case 7:
        {
            SHBBancasurancePaymentListViewController *nextViewController = [[SHBBancasurancePaymentListViewController alloc] initWithNibName:@"SHBBancasurancePaymentListViewController" bundle:nil];
            nextViewController.detailData = aDataSet;
            
            [self.navigationController pushViewController:nextViewController animated:YES];
            [nextViewController release];
        }
            break;
        case 8:
        {
            //위젯전문 결과 받음
            strTargetAccNo = aDataSet[@"계좌번호"] == nil ? @"" : [aDataSet[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSLog(@"strTargetAccNo:%@",strTargetAccNo);
            accountType = 0;
            serviceType = 0;
            AppInfo.isD0011Start = YES;
            self.service = nil;
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
            self.service.responseData = AppInfo.accountD0011;
            
            [self onParse:AppInfo.accountD0011 string:nil];
           
        }
            break;
        default:
        {
            // 전체 계좌 조회의 경우
            if ( accountType == 5 )
            {
                // refresh 효과를 준다
                view2.hidden = NO;
                [labelNoAccount setHidden:YES];
                [self.array1 removeAllObjects];
                [self.array2 removeAllObjects];
                [self.array3 removeAllObjects];
                [self.array4 removeAllObjects];
                [self.array5 removeAllObjects];
                [self.array6 removeAllObjects];
                
                NSMutableArray *arrayData = [aDataSet arrayWithForKey:@"예금내역.vector.data"];
                
                for (NSDictionary *dic in arrayData)
                {
                    switch ([dic[@"예금종류"] intValue])
                    {
                        case 1:     // 입/출금
                        {
                            [self.array1 addObject:dic];
                        }
                            break;
                            
                        case 2:
                        case 3:     // 정기적금신탁
                        {
                            [self.array2 addObject:dic];
                        }
                            break;
                            
                        case 4:     // 펀드
                        {
                            [self.array3 addObject:dic];
                        }
                            break;
                            
                        case 7:     // 대출
                        {
                            [self.array4 addObject:dic];
                        }
                            break;
                            
                        case 5:     // 외화
                        {
                            [self.array5 addObject:dic];
                        }
                            break;
                            
                        case 6:     // 골드
                        {
                            [self.array6 addObject:dic];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                
                long long int intSum1 = 0;
                long long int intSum2 = 0;
                NSString *strSumString1 = @"";
                NSString *strSumString2 = @"";
                
                // 입/출금 총액 계산
                for (NSDictionary *dic in self.array1)
                {
                    intSum1 = intSum1 + [dic[@"잔액->originalValue"] longLongValue];
                }
                
                // 정기적금신탁 총액 계산
                for (NSDictionary *dic in self.array2)
                {
                    intSum2 = intSum2 + [dic[@"잔액->originalValue"] longLongValue];
                }
   
                [self setAllAccountList];
                
                strSumString1 = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", intSum1]];
                strSumString2 = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", intSum2]];
                
                // 총 잔액들 표시
                label1.text = [NSString stringWithFormat:@"%@원", strSumString1];
                label2.text = [NSString stringWithFormat:@"%@원", strSumString2];
                label3.text = [NSString stringWithFormat:@"%@원", aDataSet[@"수익증권총금액"]];
                label4.text = [NSString stringWithFormat:@"%@원", aDataSet[@"대출총금액"]];
                
                return NO;
            }
            
            if (accountType == 6) {
                
                // 휴면예금
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"예금내역.vector.data"]) {
                    
                    if ([dic[@"상태"] isEqualToString:@"68"] ||
                        [dic[@"상태"] isEqualToString:@"72"] ||
                        [dic[@"상태"] isEqualToString:@"76"] ||
                        [dic[@"상태"] isEqualToString:@"78"]) {
                        
                        if ([dic[@"상품부기명"] length] > 0) {
                            
                            [dic setObject:dic[@"상품부기명"] forKey:@"_예금명"];
                        }
                        else {
                            
                            [dic setObject:dic[@"과목명"] forKey:@"_예금명"];
                        }
                        
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"잔액"]]
                                forKey:@"_예금잔액"];
                        
                        NSString *account = ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"];
                        
                        if ([dic[@"상태"] isEqualToString:@"78"]) {
                            
                            [dic setObject:[NSString stringWithFormat:@"%@(재단출연)", account]
                                    forKey:@"_계좌번호"];
                        }
                        else {
                            
                            [dic setObject:account forKey:@"_계좌번호"];
                        }
                        
                        [array addObject:dic];
                    }
                }
                
                self.dataList = (NSArray *)array;
                
                if ([self.dataList count] <= 1) {
                    
                    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
                else {
                    
                    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                }
                
                [_tableView1 setTableHeaderView:dormantAccountHeaderView];
                [_tableView1 reloadData];
                [_tableView1 setContentOffset:CGPointZero animated:YES];
                
                return NO;
            }
            
            
            //NSLog(@"accountType:%i",accountType);
            NSDictionary *dic = [self.service accountListInfo:accountType];
            //NSLog(@"dic:%@",dic);
            self.infoList = dic[@"FooterInfo"];
            self.dataList = dic[@"계좌리스트"];
            
            if (accountType == 3) {
                
                self.foreignAccountNumberList = dic[@"외환출금계좌리스트"];
                self.foreignAccountNumberList2 = dic[@"외환입금계좌리스트"];
            }
            
            if([self.dataList count] == 1 && [self.dataList[0][@"계좌번호"] isEqualToString:@""])
            {
                _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            else
            {
                _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            
            [self displayFooterView];
            
            [_tableView1 reloadData];
            
            [_tableView1 setContentOffset:CGPointZero animated:YES];
            
            
            // 만기예정 및 경과상품 안내 팝업 -----------
            
            // 예금/신탁, 대출의 경우
            if (accountType == 0 || accountType == 2) {
                
                NSLog(@"%@", AppInfo.tran_Date);
                NSLog(@"%@", [SHBUtility dateStringToMonth:0 toDay:7]);
                
                NSMutableArray *expiryArray = [NSMutableArray array];
                
                if (accountType == 0) {
                    
                    // 예금/신탁
                    
                    NSString *saveExpiryDate = [[[NSUserDefaults standardUserDefaults] expiryDateValue] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    NSString *checkDate = [[SHBUtility dateStringToMonth:0 toDay:7] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    // 저장된 날짜가 있는지 확인
                    if (![[NSUserDefaults standardUserDefaults] expiryDateValue] ||
                        [checkDate integerValue] <= [saveExpiryDate integerValue]) {
                        
                        for (NSMutableDictionary *dictionary in self.dataList) {
                            
                            // 만기일자 존재여부 확인
                            if ([dictionary[@"계좌번호"] length] > 0) {
                                
                                if ([dictionary[@"계좌정보상세"][@"만기일자"] length] != 0 && dictionary[@"계좌정보상세"][@"계좌번호"]) {
                                    
                                    if ([[dictionary[@"계좌정보상세"][@"계좌번호"] substringToIndex:3] integerValue] >= 200 &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"260"] &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"270"] &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"271"] &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"280"] &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"281"] &&
                                        ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"290"]) {
                                        
                                        NSString *endDate = [[SHBUtility dateStringToMonth:1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                        NSString *expiryDate = [dictionary[@"계좌정보상세"][@"만기일자"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                        
                                        // 오늘기준 1개월까지 만기예정 및 경과여부 확인
                                        if ([expiryDate integerValue] <= [endDate integerValue]) {
                                            
                                            [dictionary setObject:dictionary[@"계좌정보상세"][@"만기일자"] forKey:@"_만기일자"];
                                            [expiryArray addObject:dictionary];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (accountType == 2) {
                    
                    // 대출
                    
                    NSString *saveExpiryDate = [[[NSUserDefaults standardUserDefaults] expiryDateValue2] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    NSString *checkDate = [[SHBUtility dateStringToMonth:0 toDay:7] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    // 저장된 날짜가 있는지 확인
                    if (![[NSUserDefaults standardUserDefaults] expiryDateValue2] ||
                        [checkDate integerValue] <= [saveExpiryDate integerValue]) {
                        
                        for (NSMutableDictionary *dictionary in self.dataList) {
                            
                            // 만기일자 존재여부 확인
                            if ([dictionary[@"계좌번호"] length] > 0) {
                                
                                if ([dictionary[@"계좌정보상세"][@"대출만기일"] length] != 0) {
                                    
                                    NSString *endDate = [[SHBUtility dateStringToMonth:1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                    NSString *expiryDate = [dictionary[@"계좌정보상세"][@"대출만기일"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                    
                                    // 오늘기준 1개월까지 만기예정 및 경과여부 확인
                                    if ([expiryDate integerValue] <= [endDate integerValue]) {
                                        
                                        [dictionary setObject:dictionary[@"계좌정보상세"][@"대출만기일"] forKey:@"_만기일자"];
                                        [expiryArray addObject:dictionary];
                                    }
                                }
                            }
                        }
                    }
                }
                
                if ([expiryArray count] > 0) {
                    
                    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]) {
                        
                        UIDevice *curDevice = [UIDevice currentDevice];
                        curDevice.proximityMonitoringEnabled = NO;
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
                    }
                    
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:expiryArray];
                    
                    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"_만기일자" ascending:NO];
                    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
                    
                    expiryArray = tempArray;
                    
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountExpiryDateView"
                                                                   owner:self options:nil];
                    self.expiryPopupView = (SHBAccountExpiryDateView *)array[0];
                    _expiryPopupView.delegate = self;
                    _expiryPopupView.dataList = expiryArray;
                    [_expiryPopupView showInView:self.navigationController.view animated:YES];
                }
            }
            
            // -----------------------------------
            
            /*
             //이행안함
            if (accountType == 0) {
                
                //2014.08 월로 이행 연기
                //계좌조회, 예금/신탁목록 에서만 알림 바로 가기버튼 제공.(2014. 07.14 추가)
                UIButton *notiButton = [[UIButton alloc] initWithFrame:CGRectMake(6, self.view.frame.size.height - (48 + 15), 47, 48)];
                //notiButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
                //[notiButton setTitle:@"알림가기" forState:UIControlStateNormal];
                
                //if (AppInfo.noticeState == 2)
                //{
                //    [notiButton setBackgroundImage:[UIImage imageNamed:@"btn_btype1.png"] forState:UIControlStateNormal];
                //}else
                //{
                [notiButton setBackgroundImage:[UIImage imageNamed:@"btn_update_list.png"] forState:UIControlStateNormal];
                [notiButton setBackgroundImage:[UIImage imageNamed:@"btn_update_list_focus.png"] forState:UIControlStateHighlighted];
                //}
                [notiButton setTag:15600];
                [notiButton addTarget:self action:@selector(notiButtonPressed) forControlEvents: UIControlEventTouchUpInside];
                [self.view addSubview:notiButton];
                [self performSelector:@selector(notiButtonRemove) withObject:nil afterDelay:5];
            }
            */
            NSLog(@"strTargetAccNo:%@",strTargetAccNo);
            if(self.isPushAndScheme && ![strTargetAccNo isEqualToString:@""])
            {
                BOOL isFind = NO;
                for(NSDictionary *dictionary in self.dataList)
                {
                    if([[dictionary[@"계좌정보상세"][@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strTargetAccNo] ||
                       [[dictionary[@"계좌정보상세"][@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strTargetAccNo])
                    {
                        self.isPushAndScheme = NO;
                        
                        SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
                        nextViewController.accountInfo = dictionary;
                        
                        [self.navigationController pushViewController:nextViewController animated:YES];
                        [nextViewController release];
                        
                        self.service = nil;
                        serviceType = 0;
                        isFind = YES;
                        return NO;
                    }
                }
                
                if (isFind == NO)
                {
                    
                    [UIAlertView showAlertCustome:nil type:ONFAlertTypeOneButtonServer tag:0 title:0 buttonTitle:nil message:@"저장된 정보가 없습니다.\n신한S뱅크에서 다시 확인\n부탁드립니다."];
                    [AppDelegate.navigationController fadePopToRootViewController];
                }
                
            }else if(self.isPushAndScheme && [strTargetAccNo length] == 0)
            {
                
                [UIAlertView showAlertCustome:nil type:ONFAlertTypeOneButtonServer tag:0 title:0 buttonTitle:nil message:@"저장된 정보가 없습니다.\n신한S뱅크에서 다시 확인\n부탁드립니다."];
                
                [AppDelegate.navigationController fadePopToRootViewController];
            }
        }
            break;
    }
    
    self.service = nil;
    serviceType = 0;
    
    return NO;
}
/*
- (void)notiButtonRemove
{
    UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:15600];
    [tmpBtn removeFromSuperview];
}
*/

// 입금
- (void)depositAccount:(int)row
{
    NSLog(@"입금 %d", row);
    
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    if (time < 90000 || time > 230000) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"09:00 ~ 23:00 까지만 이용가능한 서비스입니다."];
        
        return;
    }
    
    NSDictionary *account = [self.dataList objectAtIndex:row];
    
    if ([[[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"] hasPrefix:@"252"] || [[[account objectForKey:@"계좌정보상세"]  objectForKey:@"계좌번호"] hasPrefix:@"254"]) {
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
        NSString *tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"];
        
//        if ([[[account objectForKey:@"계좌정보상세"] objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
//        {
//            tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"];
//            tempBankCode = @"1";
//        }
//        else
//        {
//            tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"구계좌번호"];
//            tempBankCode = [[account objectForKey:@"계좌정보상세"] objectForKey:@"은행코드"];
//        }
        
        self.service = nil;
        
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
        
        self.service = (SHBAccountService*)[[[SHBFundService alloc] initWithServiceId: FUND_DEPOSIT_CONTENT viewController: self] autorelease];
        self.service.previousData = previousData;
        [self.service start];
        
    }
}

// 출금
-(void)transAccount:(int)row
{
    NSLog(@"출금 %d", row);
    
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    if (![SHBUtility isOPDate:[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""]] || time < 90000 || time > 160000) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"09:00 ~ 16:00 까지만 이용가능한 서비스입니다.(토요일, 휴일 불가능)"];
        
        return;
    }
    
    serviceType = 2;
    NSDictionary *account = [self.dataList objectAtIndex:row];
    
    if ([[[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"] hasPrefix:@"252"] || [[[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"] hasPrefix:@"254"]) {
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
    NSString *tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"];
    
//    if ([[[account objectForKey:@"계좌정보상세"] objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
//    {
//        tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"];
//        tempBankCode = @"1";
//    }
//    else
//    {
//        tempAccNo = [[account objectForKey:@"계좌정보상세"] objectForKey:@"구계좌번호"];
//        tempBankCode = [[account objectForKey:@"계좌정보상세"] objectForKey:@"은행코드"];
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
    
    self.service = (SHBAccountService*)[[[SHBFundService alloc] initWithServiceId:FUND_DRAWING_CONTENT viewController:self] autorelease];
    self.service.previousData = previousData; //서비스 실행을 위해 필요한 이전 서비스 정보를 데이터셋으로  넘긴다
    [self.service start];
    
}

// 선물환 역외펀드 리스트
-(void)forwardExchangeList:(int)row
{
    NSLog(@"선물환 역외펀드 리스트 %d", row);
    
    SHBFundExchangeListViewController *detailViewController = [[SHBFundExchangeListViewController alloc] initWithNibName:@"SHBFundExchangeListViewController" bundle:nil];
    
    // 계좌 설정
    NSDictionary *dictionary = [self.dataList objectAtIndex:row];
    detailViewController.accountNo = [[dictionary objectForKey:@"계좌정보상세"] objectForKey:@"계좌번호"];
    detailViewController.accountName = [[dictionary objectForKey:@"계좌정보상세"] objectForKey:@"과목명"];
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
}

// 방카슈랑스 조회
- (void)banInquiry:(int)row selectJob:(NSString *)selectJob
{
    NSDictionary *account = [self.dataList objectAtIndex:row];
    NSString *tempRelation;

//    AppInfo.commonDic = [NSMutableDictionary dictionaryWithDictionary:account];

    if ([selectJob isEqualToString:@"L"]) {
        // B1110
        self.strServiceCode = @"B1110";
        tempRelation = @"41";
    } else {
        // B1160
        self.strServiceCode = @"B1160";
        tempRelation = @"52";
    }
    
    self.service = nil;
    SHBDataSet *previousData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"업무구분" : tempRelation,
                                @"증권번호" : [account objectForKey:@"증권번호"],
                                @"보험사코드" : [account objectForKey:@"제휴보험사코드"],
                                }] autorelease];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController: self] autorelease];
    self.service.requestData = previousData;
    [self.service start];
    
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == table1 )
    {
        return [self.array1 count];
    }
    else if( tableView == table2 )
    {
        return [self.array2 count];
    }
    else if( tableView == table3 )
    {
        return [self.array3 count];
    }
    else if( tableView == table4 )
    {
        return [self.array4 count];
    }
    else if( tableView == table5 )
    {
        return [self.array5 count];
    }
    else if( tableView == table6 )
    {
        return [self.array6 count];
    }
    else
    {
        if (accountType == 6) {
            
            if ([self.dataList count] == 0 && _tableView1.tableHeaderView) {
                
                return 1;
            }
        }
        
        return [self.dataList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float tempHeight = 0;
    if(openedRow == indexPath.row){
        if (accountType == 4) tempHeight = 189;
        else if (accountType == 3) {
            
            OFDataSet *cellDataSet = self.dataList[indexPath.row];
            
            if ([cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186] ||
                [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_187] ||
                [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_188]) {
                
                tempHeight = 124;
            }
            else {
                
                tempHeight = 85;
            }
        }
        else if (accountType == 1) tempHeight = 137;
        else tempHeight = 124;
        return tempHeight;
    }
    if (accountType != 4)
    {
        // 전체 계좌의 경우
        if( accountType == 5 )
        {
            if ( tableView == table1 || tableView == table6 )          // 입출금, 골드
            {
                tempHeight = 85;
            }
            else if( tableView == table2 || tableView == table3 || tableView == table4 || tableView == table5 )
            {           // 정기적금신탁, 펀드, 대출, 외화
                tempHeight = 143;
            }
        }
        else
        {
            // 펀드
            if (accountType == 1) tempHeight = 98;
            else if (accountType == 6) tempHeight = 135;
            else tempHeight = 85;
        }
    }
    else tempHeight = 150;
    
    return tempHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";

    NSDictionary *dictionary = nil;
    
    switch (accountType) {
        case 0: // 예금신탁
        case 1: // 펀드
        case 2: // 대출
        {
            SHBAccountListCell *cell = (SHBAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (accountType == 1) {
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountFundListCell" owner:self options:nil];
                    
                    for (id currentObject in topLevelObjects)
                    {
                        if ([currentObject isKindOfClass:[UITableViewCell class]])
                        {
                            cell =  (SHBAccountFundListCell *)currentObject;
                            break;
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                }
            } else {
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountListCell" owner:self options:nil];
                    
                    for (id currentObject in topLevelObjects)
                    {
                        if ([currentObject isKindOfClass:[UITableViewCell class]])
                        {
                            cell =  (SHBAccountListCell *)currentObject;
                            break;
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                }
            }
            
            dictionary = self.dataList[indexPath.row];
            
            if([dictionary[@"계좌번호"] isEqualToString:@""])
            {
                cell.accountName.frame = CGRectMake(8, 8, 301, 19);
                cell.accountName.textAlignment = UITextAlignmentCenter;
            }

            cell.accountName.text = dictionary[@"계좌명"];
            cell.accountNo.text = dictionary[@"계좌번호"];
            cell.rate.text = dictionary[@"수익률"];
            cell.amount.text = dictionary[@"잔액"];
            
            switch (accountType) {
                case 0:
                {
                    if (![dictionary[@"계좌명"] isEqualToString:@"예금신탁 계좌가 없습니다."]) {
                        
                        cell.balanceCaption.text = @"잔액";
                    }
                    
                    [cell.expiryDate setHidden:YES];
                    [cell.accountNo setHidden:NO];
                    
                    if ([dictionary[@"계좌번호"] length] > 0) {
                        
                        if ([dictionary[@"계좌정보상세"][@"만기일자"] length] != 0 && dictionary[@"계좌정보상세"][@"계좌번호"]) {
                            
                            if ([[dictionary[@"계좌정보상세"][@"계좌번호"] substringToIndex:3] integerValue] >= 200 &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"260"] &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"270"] &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"271"] &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"280"] &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"281"] &&
                                ![dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:@"290"]) {
                                
                                NSString *today = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
                                NSString *expiryDate = [dictionary[@"계좌정보상세"][@"만기일자"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                
                                if ([expiryDate integerValue] <= [today integerValue]) {
                                    
                                    [cell.expiryDate setHidden:NO];
                                    [cell.accountNo setHidden:YES];
                                    
                                    [cell.expiryDate initFrame:cell.expiryDate.frame];
                                    [cell.expiryDate setText:[NSString stringWithFormat:@"<midBoldGray_15>%@</midBoldGray_15><midLightBlue_15> (만기경과)</midLightBlue_15>", dictionary[@"계좌번호"]]];
                                }
                            }
                        }
                    }
                }
                    break;
                case 1:
                {
                    if([dictionary[@"수익률"] floatValue] > 0.0f)
                    {
                        [cell.rate setTextColor:RGB(209, 75, 75)];
                        
                    }
                    else if([dictionary[@"수익률"] floatValue] == 0.0f)
                    {
                        cell.rate.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        [cell.rate setTextColor:RGB(0, 137, 220)];
                    }
                }
                    break;
                case 2:
                {
                    cell.amount.textColor = RGB(44, 44, 44);
                    
                    [cell.expiryDate setHidden:YES];
                    [cell.accountNo setHidden:NO];
                    
                    if ([dictionary[@"계좌번호"] length] > 0) {
                        
                        if ([dictionary[@"계좌정보상세"][@"대출만기일"] length] != 0) {
                            
                            NSString *today = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
                            NSString *expiryDate = [dictionary[@"계좌정보상세"][@"대출만기일"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                            
                            if ([expiryDate integerValue] <= [today integerValue]) {
                                
                                [cell.expiryDate setHidden:NO];
                                [cell.accountNo setHidden:YES];
                                
                                [cell.expiryDate initFrame:cell.expiryDate.frame];
                                [cell.expiryDate setText:[NSString stringWithFormat:@"<midBoldGray_15>%@</midBoldGray_15><midLightBlue_15> (만기경과)</midLightBlue_15>", dictionary[@"계좌번호"]]];
                            }
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }

            if([dictionary[@"화면이동1"] isEqualToString:@""])
            {
                cell.btnOpen.hidden = YES;
            }
            else
            {
                cell.btnOpen.hidden = NO;
            }
            
            cell.row = indexPath.row;
            cell.target = self;
            cell.pSelector = @selector(cellButtonClick:);
            
            if(openedRow == indexPath.row)
            {
                cell.bgView.backgroundColor = RGB(244, 244, 244);
                [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
                cell.btnOpen.accessibilityLabel = @"펼쳐보기 닫기";
                cell.btnLeft.hidden = NO;
                [cell.btnLeft setTitle:dictionary[@"화면이동1"] forState:UIControlStateNormal];
                cell.btnCenter.hidden = NO;
                [cell.btnCenter setTitle:dictionary[@"화면이동2"] forState:UIControlStateNormal];
                
                if([dictionary[@"화면이동3"] isEqualToString:@""])
                {
                    cell.btnRight.hidden = YES;
                }
                else
                {
                    cell.btnRight.hidden = NO;
                    [cell.btnRight setTitle:dictionary[@"화면이동3"] forState:UIControlStateNormal];
                }
                
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, cell.btnLeft);
            }
            else
            {
                cell.bgView.backgroundColor = [UIColor clearColor];
                [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
                cell.btnOpen.accessibilityLabel = @"펼쳐보기 열기";
                
                cell.btnLeft.hidden = YES;
                cell.btnCenter.hidden = YES;
                cell.btnRight.hidden = YES;
            }
            
            if(accountType != 1)
            {
                cell.btnOpen.frame = CGRectMake(275, 9, 42, 42);
                cell.amount.frame =  CGRectMake(8, 58, 301, 19);
            }
            
            return cell;
        }
            break;
        case 3: // 외환골드
        {
            SHBForexGoldListCell *cell = (SHBForexGoldListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexGoldListCell"];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexGoldListCell"
                                                               owner:self options:nil];
                cell = (SHBForexGoldListCell *)array[0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            cell.row = indexPath.row;
            cell.pTarget = self;
            cell.pSelector = @selector(cellButtonClick:);
            
            [cell.moreBtn addTarget:cell
                             action:@selector(buttonTouchUpInside:)
                   forControlEvents:UIControlEventTouchUpInside];
            [cell.btn1 addTarget:cell
                          action:@selector(buttonTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.btn2 addTarget:cell
                          action:@selector(buttonTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.btn3 addTarget:cell
                          action:@selector(buttonTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.btn4 addTarget:cell
                          action:@selector(buttonTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
            
            OFDataSet *cellDataSet = self.dataList[indexPath.row];
            
            [cell.accountName setText:cellDataSet[@"계좌명"]];
            [cell.accountNumber setText:cellDataSet[@"계좌번호"]];
            [cell.money setText:cellDataSet[@"잔액"]];
            
            [cell.line setHidden:YES];
            [cell.moreBtn setHidden:YES];
            
            if ([cell.accountNumber.text length] == 0) {
                [cell.accountName setTextAlignment:NSTextAlignmentCenter];
                [cell.accountName setFrame:CGRectMake(0,
                                                      cell.accountName.frame.origin.y,
                                                      317,
                                                      cell.accountName.frame.size.height)];
                return cell;
            }
            
            if (openedRow == indexPath.row) {
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                
                if ([cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186] ||
                    [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_187] ||
                    [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_188]) {
                    [cell.moreBtn setSelected:YES];
                    [cell.moreBtn setHidden:NO];
                    [cell.moreBtn setAccessibilityLabel:@"펼쳐보기닫기"];
                    
                    if ([cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186]) {
                        [cell.btn1 setHidden:NO];
                        [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
                        
                        if ([cellDataSet[@"계좌정보상세"][@"추가적립가능여부"] isEqualToString:@"1"]) {
                            [cell.btn2 setHidden:NO];
                            [cell.btn2 setTitle:@"적립" forState:UIControlStateNormal];
                        }
                    }else{
                        [cell.btn1 setHidden:NO];
                        [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
                        [cell.btn2 setHidden:NO];
                        [cell.btn2 setTitle:@"입금" forState:UIControlStateNormal];
                        [cell.btn3 setHidden:NO];
                        [cell.btn3 setTitle:@"출금" forState:UIControlStateNormal];
                    }
                    
                }else{
                    [cell.moreBtn setHidden:YES];
                    
                }
            }
            else {
                if ([cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186] ||
                    [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_187] ||
                    [cellDataSet[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_188]) {
                    [cell.moreBtn setSelected:NO];
                    [cell.moreBtn setHidden:NO];
                    [cell.moreBtn setAccessibilityLabel:@"펼쳐보기열기"];
                    
                }else{
                    [cell.moreBtn setHidden:YES];
                    
                }
            }
            
            return cell;
        }
            break;
        case 4: // 방카슈랑스
        {
            SHBBancasuranceListCell *cell = (SHBBancasuranceListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBBancasuranceListCell" owner:self options:nil];
                
                for (id currentObject in topLevelObjects)
                {
                    if ([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell =  (SHBBancasuranceListCell *)currentObject;
                        break;
                    }
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            dictionary = self.dataList[indexPath.row];
            
            cell.bacName.text = dictionary[@"상품명"];
            cell.bacNo.text = dictionary[@"증권번호"];
            cell.insuranceName.text = dictionary[@"제휴보험사명"];
            cell.contractDate.text = [NSString stringWithFormat:@"%@/%@", [SHBUtility  getDateWithDash:dictionary[@"계약일자"]],  [SHBUtility getDateWithDash:dictionary[@"만기일자"]]];
            cell.amount.text = [NSString stringWithFormat:@"%@(%@)", [SHBUtility normalStringTocommaString:dictionary[@"합계보험료"]], dictionary[@"상품통화코드"]];
            
            if([dictionary[@"화면이동1"] isEqualToString:@""])
            {
                cell.btnOpen.hidden = YES;
            }
            else
            {
                cell.btnOpen.hidden = NO;
            }
            
            // 방카슈랑스 계좌가 없을 경우
            // 코딩 스타일을 통일하기 위해서 ㅠㅠ
            if([dictionary[@"계좌번호"] isEqualToString:@""])
            {
                for (UIView *subViews in cell.contentView.subviews)
                {
                    if ([subViews isKindOfClass:[UILabel class]])
                    {
                        [(UILabel*)subViews setHidden:YES];
                    }
                }
                
                [cell.bacName setHidden:NO];
                cell.bacName.text = dictionary[@"계좌명"];
                
                cell.bacName.frame = CGRectMake(8, 8, 301, 19);
                cell.bacName.textAlignment = UITextAlignmentCenter;
            }
            
            cell.row = indexPath.row;
            cell.target = self;
            cell.pSelector = @selector(cellButtonClick:);
            
            if(openedRow == indexPath.row){
                cell.bgView.backgroundColor = RGB(244, 244, 244);
                
                [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
                cell.btnOpen.accessibilityLabel = @"펼쳐보기 닫기";
                cell.btnLeft.hidden = NO;
                [cell.btnLeft setTitle:dictionary[@"화면이동1"] forState:UIControlStateNormal];
                cell.btnRight.hidden = NO;
                [cell.btnRight setTitle:dictionary[@"화면이동2"] forState:UIControlStateNormal];
            }else{
                cell.bgView.backgroundColor = [UIColor clearColor];
                [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
                cell.btnOpen.accessibilityLabel = @"펼쳐보기 열기";
                cell.btnLeft.hidden = YES;
                cell.btnRight.hidden = YES;
            }
            
            return cell;
        }
            break;
        case 5: // 전체계좌
        {
            SHBAllAccountListCell *cell = (SHBAllAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAllAccountListCell" owner:self options:nil];
                
                for (id currentObject in topLevelObjects)
                {
                    if ([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell =  (SHBAllAccountListCell *)currentObject;
                        break;
                    }
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            [cell.label5 setHidden:NO];
            [cell.label6 setHidden:NO];
            [cell.label7 setHidden:NO];
            [cell.label8 setHidden:NO];
            
            [cell.label4 setTextColor:RGB(209, 75, 75)];
            [cell.label8 setTextColor:RGB(209, 75, 75)];
            
            if ( tableView == table1 )          // 입/출금
            {
                dictionary = self.array1[indexPath.row];
                cell.label3.text = @"잔액";
                cell.label4.text = [NSString stringWithFormat:@"%@원", dictionary[@"잔액"]];
            }
            else if( tableView == table2 )      // 정기적금신탁
            {
                dictionary = self.array2[indexPath.row];
                [cell.label4 setTextColor:RGB(44, 44, 44)];
                cell.label3.text = @"신규일";
                cell.label4.text = dictionary[@"신규일"];
                cell.label5.text = @"만기일";
                cell.label6.text = dictionary[@"만기일"];
                cell.label7.text = @"잔액";
                cell.label8.text = [NSString stringWithFormat:@"%@원", dictionary[@"잔액"]];
            }
            else if( tableView == table3 )      // 펀드
            {
                dictionary = self.array3[indexPath.row];
                [cell.label4 setTextColor:RGB(44, 44, 44)];
                cell.label3.text = @"신규일";
                cell.label4.text = dictionary[@"신규일"];
                cell.label5.text = @"만기일";
                cell.label6.text = dictionary[@"만기일"];
                cell.label7.text = @"평가금액";
                cell.label8.text = [NSString stringWithFormat:@"%@원", dictionary[@"평가금액"]];
            }
            else if( tableView == table4 )      // 대출
            {
                dictionary = self.array4[indexPath.row];
                [cell.label4 setTextColor:RGB(44, 44, 44)];
                [cell.label8 setTextColor:RGB(44, 44, 44)];
                cell.label1.text = ([dictionary[@"대출상품명"] length] > 0) ? dictionary[@"대출상품명"] : dictionary[@"과목명"];
                cell.label3.text = @"대출일자";
                cell.label4.text = dictionary[@"신규일"];
                cell.label5.text = @"대출만기일";
                cell.label6.text = dictionary[@"만기일"];
                cell.label7.text = @"대출잔액";
                cell.label8.text = [NSString stringWithFormat:@"%@원", dictionary[@"잔액"]];
            }
            else if( tableView == table5 )      // 외화
            {
                dictionary = self.array5[indexPath.row];
                [cell.label4 setTextColor:RGB(44, 44, 44)];
                cell.label3.text = @"신규일";
                cell.label4.text = dictionary[@"신규일"];
                cell.label5.text = @"만기일";
                cell.label6.text = dictionary[@"만기일"];
                cell.label7.text = @"잔액(통화)";
                cell.label8.text = [NSString stringWithFormat:@"%@(%@)", dictionary[@"외화잔액->originalValue"], dictionary[@"통화코드"]];
            }
            else if( tableView == table6 )      // 골드
            {
                dictionary = self.array6[indexPath.row];
                cell.label3.text = @"잔량";
                cell.label4.text = [NSString stringWithFormat:@"잔량:%@(g)", dictionary[@"외화잔액->originalValue"]];
            }
            
            // 입출금과 골드의 경우
            if (tableView == table1 || tableView == table6)
            {
                [cell.label5 setHidden:YES];
                [cell.label6 setHidden:YES];
                [cell.label7 setHidden:YES];
                [cell.label8 setHidden:YES];
            }
            
            if (tableView != table4) {
                
                cell.label1.text = ([[dictionary objectForKey:@"상품부기명"] length] > 0) ? [dictionary objectForKey:@"상품부기명"] : [dictionary objectForKey:@"과목명"];
            }
            
            cell.label2.text = ([[dictionary objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dictionary objectForKey:@"계좌번호"] : [dictionary objectForKey:@"구계좌번호"];
            
//            cell.label1.text = dictionary[@"과목명"];
//            cell.label2.text = dictionary[@"계좌번호"];
            
            return cell;
        }
            break;
            
        case 6: {
            
            // 휴면예금
            
            if ([self.dataList count] == 0 && _tableView1.tableHeaderView) {
                
                UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHBAccountDormantCell1"] autorelease];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                
                [cell.textLabel setText:@"고객님 명의로 조회되는 휴면예금이 없습니다."];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
                [cell.textLabel setTextColor:RGB(44, 44, 44)];
                
                return cell;
            }
            
            SHBAccountDormantCell *cell = (SHBAccountDormantCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBAccountDormantCell"];
            
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountDormantCell" owner:self options:nil];
                
                for (id currentObject in topLevelObjects)
                {
                    if ([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell =  (SHBAccountDormantCell *)currentObject;
                        break;
                    }
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            OFDataSet *cellDataSet = self.dataList[indexPath.row];
            [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
            
            [cell.accountName initFrame:cell.accountName.frame
                          colorType:RGB(44, 44, 44)
                           fontSize:15
                          textAlign:2];
            [cell.accountName setCaptionText:cellDataSet[@"_예금명"]];
            
            return cell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (accountType == 6) {
        
        return;
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    if([dictionary[@"계좌번호"] isEqualToString:@""]) return;
    
    if(!(indexPath.row == openedRow))
    {
        openedRow = -1;
    }
    [_tableView1 reloadData];
    
    switch (accountType) {
        case 0:
        {
            SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
            nextViewController.accountInfo = dictionary;
            
            [self.navigationController pushViewController:nextViewController animated:YES];
            [nextViewController release];
        }
            break;
        case 1: // 펀드 상세조회
        {
            SHBFundTransListViewController *nextViewController = [[SHBFundTransListViewController alloc] initWithNibName:@"SHBFundTransListViewController" bundle:nil];
            nextViewController.accountInfo = dictionary[@"계좌정보상세"];
            
            [self.navigationController pushViewController:nextViewController animated:YES];
            [nextViewController release];
        }
            break;
        case 2:
        {
            if([dictionary[@"서비스코드"] isEqualToString:@"L1110"])
            {
                SHBLoanCommonViewController *nextViewController = [[[SHBLoanCommonViewController alloc] initWithNibName:@"SHBLoanCommonViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                [self.navigationController pushFadeViewController:nextViewController];
            }
            else
            {
                SHBLoanTransLimitedListViewController *nextViewController = [[[SHBLoanTransLimitedListViewController alloc] initWithNibName:@"SHBLoanTransLimitedListViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 3: // 외화골드
        {
            if ([dictionary[@"계좌정보상세"][@"옵셋여부"] isEqualToString:@"1"]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"Multiple 외화정기예금 기본계좌는 예금조회가 되지 않습니다."];
                return;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"계좌정보상세"]];
            
            dic[@"외환출금계좌리스트"] = self.foreignAccountNumberList;
            dic[@"외환입금계좌리스트"] = self.foreignAccountNumberList2;
            
            if ([dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186] ||
                [dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_187] ||
                [dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_188]) {
                SHBForexGoldDetailListViewController *viewController = [[[SHBForexGoldDetailListViewController alloc] initWithNibName:@"SHBForexGoldDetailListViewController" bundle:nil] autorelease];
                [viewController setAccountInfo:dic];
                [viewController setIsAllAccountList:NO];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            else {
                SHBForexDetailListViewController *viewController = [[[SHBForexDetailListViewController alloc] initWithNibName:@"SHBForexDetailListViewController" bundle:nil] autorelease];
                [viewController setAccountInfo:dic];
                [viewController setIsAllAccountList:NO];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
            break;
        case 4: // 방카슈 조회
        {
            serviceType = 6;
            if ([[dictionary objectForKey:@"제휴보험사코드"] hasPrefix:@"L"]) {
                [self banInquiry:indexPath.row selectJob:@"L"];
            } else {
                [self banInquiry:indexPath.row selectJob:@"N"];
            }
        }
            break;
        case 5: // 전체 계좌의 경우
        {
            NSMutableDictionary *dicData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
            NSString *strClassName = @"";
            SHBBaseViewController *viewController = nil;
            
            if ( tableView == table1 )              // 입/출금
            {
                SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
                
                // 한달애통장의 경우 전체계좌에서 접근 시 입금 버튼이 없어야 한다
                if([[self.array1[indexPath.row] objectForKey:@"상품코드"] isEqualToString:@"110004601"])
                {
                    [self.array1[indexPath.row] setObject:@"1" forKey:@"전체계좌한달애통장"];
                }
                
                nextViewController.data = self.array1[indexPath.row];
                
                [self.navigationController pushViewController:nextViewController animated:YES];
                [nextViewController release];
                return;
            }
            else if( tableView == table2 )          // 정기적금신탁
            {
                SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
                nextViewController.data = self.array2[indexPath.row];
                
                [self.navigationController pushViewController:nextViewController animated:YES];
                [nextViewController release];
                return;
            }
            else if( tableView == table3 )          // 펀드
            {
                dicData = self.array3[indexPath.row];
                strClassName = @"SHBFundTransListViewController";
            }
            else if( tableView == table4 )          // 대출
            {
                dicData = self.array4[indexPath.row];
                
                // 전체계좌에서 대출의 경우 상세 페이지로
                strClassName = @"SHBLoanTransLimitedListViewController";
                
                // 특정계좌의 경우
                if ([[dicData[@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
                {
                    strClassName = @"SHBLoanCommonViewController";
                }
                
                // 전체계좌에서 가는 경우 해당 정보가 달라서 이전에 set 된 정보에 맞춰서
                [dicData setObject:dicData[@"잔액"] forKey:@"대출잔액"];
                [dicData setObject:@"0" forKey:@"대출적용이율->originalValue"];
                [dicData setObject:dicData[@"계좌번호"] forKey:@"대출계좌번호"];
                [dicData setObject:dicData[@"만기일"] forKey:@"대출만기일"];
                [dicData setObject:dicData[@"신규일"] forKey:@"대출신규일"];
                [dicData setObject:dicData[@"과목명"] forKey:@"대출과목명"];
                
            }
            else if( tableView == table5 )          // 외화
            {
                dicData = self.array5[indexPath.row];
                
                if ( [dicData[@"옵셋여부"] isEqualToString:@"1"] )
                {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"Multiple 외화정기예금 기본계좌는 예금조회가 되지 않습니다."];
                    return;
                }
                strClassName = @"SHBForexDetailListViewController";
            }
            else if( tableView == table6 )          // 골드
            {
                dicData = self.array6[indexPath.row];
                strClassName = @"SHBForexGoldDetailListViewController";
            }
            
            viewController = [[NSClassFromString(strClassName) alloc]initWithNibName:strClassName bundle:nil];
            ((SHBAccountInqueryViewController *)viewController).accountInfo = dicData;      // data 전달 문제로 casting
            
            if ([strClassName isEqualToString:@"SHBForexDetailListViewController"]) {
                [(SHBForexDetailListViewController *)viewController setIsAllAccountList:YES];
            }
            else if ([strClassName isEqualToString:@"SHBForexGoldDetailListViewController"]) {
                [(SHBForexGoldDetailListViewController *)viewController setIsAllAccountList:YES];
            }
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - AccountExpiryDateDelegate

- (void)accountExpiryDateSelected:(NSDictionary *)selectData withIndex:(NSInteger)index
{
    switch (accountType) {
        case 0:
        {
            SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
            nextViewController.accountInfo = selectData;
            
            [self.navigationController pushViewController:nextViewController animated:YES];
            [nextViewController release];
        }
            break;
        case 1: // 펀드 상세조회
        {
            SHBFundTransListViewController *nextViewController = [[SHBFundTransListViewController alloc] initWithNibName:@"SHBFundTransListViewController" bundle:nil];
            nextViewController.accountInfo = selectData[@"계좌정보상세"];
            
            [self.navigationController pushViewController:nextViewController animated:YES];
            [nextViewController release];
        }
            break;
        case 2:
        {
            if([selectData[@"서비스코드"] isEqualToString:@"L1110"])
            {
                SHBLoanCommonViewController *nextViewController = [[[SHBLoanCommonViewController alloc] initWithNibName:@"SHBLoanCommonViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = selectData[@"계좌정보상세"];
                [self.navigationController pushFadeViewController:nextViewController];
            }
            else
            {
                SHBLoanTransLimitedListViewController *nextViewController = [[[SHBLoanTransLimitedListViewController alloc] initWithNibName:@"SHBLoanTransLimitedListViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = selectData[@"계좌정보상세"];
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -

- (void)cellButtonClick:(NSDictionary *)dic
{
    int row = [dic[@"Index"] intValue];
    
    NSDictionary *dictionary = self.dataList[row];
    
    switch ([dic[@"Button"] tag]) {
        case 2000:
        {
            if(openedRow == row)
            {
                openedRow = -1;
            }
            else
            {
                openedRow = row;
            }
            [_tableView1 reloadData];
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:openedRow inSection:0];
//            UITableViewCell *cell = [_tableView1 cellForRowAtIndexPath:indexPath];
//            
//            if (openedRow == row) {
//                [cell.contentView setBackgroundColor:RGB(244, 244, 244)];
//            }
//            else {
//                [cell.contentView setBackgroundColor:[UIColor clearColor]];
//            }
//            
        }
            break;
        case 2001:
        {
            switch (accountType) {
                case 0:
                {
                    SHBAccountInqueryViewController *nextViewController = [[SHBAccountInqueryViewController alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
                    nextViewController.accountInfo = dictionary;
                    
                    [self.navigationController pushViewController:nextViewController animated:YES];
                    [nextViewController release];
                }
                    break;
                case 1: // 펀드 조회 버튼 클릭시
                {
                    SHBFundTransListViewController *nextViewController = [[SHBFundTransListViewController alloc] initWithNibName:@"SHBFundTransListViewController" bundle:nil];
                    nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                    
                    [self.navigationController pushViewController:nextViewController animated:YES];
                    [nextViewController release];
                }
                    break;
                case 2:
                {
                    if([dictionary[@"서비스코드"] isEqualToString:@"L1110"])
                    {
                        SHBLoanCommonViewController *nextViewController = [[[SHBLoanCommonViewController alloc] initWithNibName:@"SHBLoanCommonViewController" bundle:nil] autorelease];
                        nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                        [self.navigationController pushFadeViewController:nextViewController];
                    }
                    else
                    {
                        SHBLoanTransLimitedListViewController *nextViewController = [[[SHBLoanTransLimitedListViewController alloc] initWithNibName:@"SHBLoanTransLimitedListViewController" bundle:nil] autorelease];
                        nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                        [self.navigationController pushFadeViewController:nextViewController];
                    }
                }
                    break;
                case 3: // 외화골드
                {
                    if ([dictionary[@"계좌정보상세"][@"옵셋여부"] isEqualToString:@"1"]) {
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"Multiple 외화정기예금 기본계좌는 예금조회가 되지 않습니다."];
                        return;
                    }
                    if ([dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_186] ||
                        [dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_187] ||
                        [dictionary[@"계좌정보상세"][@"계좌번호"] hasPrefix:GOLD_188]) {
                        SHBForexGoldDetailListViewController *viewController = [[[SHBForexGoldDetailListViewController alloc] initWithNibName:@"SHBForexGoldDetailListViewController" bundle:nil] autorelease];
                        [viewController setAccountInfo:(NSMutableDictionary *)dictionary[@"계좌정보상세"]];
                        [self checkLoginBeforePushViewController:viewController animated:YES];
                    }
                    else {
                        SHBForexDetailListViewController *viewController = [[[SHBForexDetailListViewController alloc] initWithNibName:@"SHBForexDetailListViewController" bundle:nil] autorelease];
                        [viewController setAccountInfo:(NSMutableDictionary *)dictionary[@"계좌정보상세"]];
                        [self checkLoginBeforePushViewController:viewController animated:YES];
                    }
                }
                    break;
                case 4: // 방카슈랑스 조회버튼 클릭시
                {
                    serviceType = 6;
                    if ([[dictionary objectForKey:@"제휴보험사코드"] hasPrefix:@"L"]) {
                        [self banInquiry:row selectJob:@"L"];
                    } else {
                        [self banInquiry:row selectJob:@"N"];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2002:
        case 2003:
        {
            NSString *strTitle = ((UIButton *)dic[@"Button"]).titleLabel.text;
            
            switch (accountType) {
                case 0:
                {
                    if([strTitle isEqualToString:@"이체"])
                    {  // 이체화면이동
                        SHBTransferInfoInputViewController *nextViewController = [[[SHBTransferInfoInputViewController alloc] initWithNibName:@"SHBTransferInfoInputViewController" bundle:nil] autorelease];
                        nextViewController.outAccInfoDic = dictionary;
                        nextViewController.needsCert = YES;
                        [self checkLoginBeforePushViewController:nextViewController animated:YES];
                    }
                    else if ([strTitle isEqualToString:@"입금"])
                    {  // 입금화면이동
                        if([dictionary[@"계좌정보상세"][@"상품코드"] isEqualToString:@"110004601"])
                        {
                            SHBPushInfo *pushInfo = [SHBPushInfo instance];
                            [pushInfo requestOpenURL:@"asset://" Parm:nil];
                            
//                            BOOL bRet = NO;
//                            bRet = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"asset://com.shinhan.asset"]];
//                            if (!bRet)
//                            {
//                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/kr/app/id498398058?mt=8"]];
//                            }
                            return;
                        }
                        
                        SHBDepositInfoInputViewController *nextViewController = [[[SHBDepositInfoInputViewController alloc] initWithNibName:@"SHBDepositInfoInputViewController" bundle:nil] autorelease];
                        nextViewController.inAccInfoDic = dictionary;
                        nextViewController.needsCert = YES;
                        [self checkLoginBeforePushViewController:nextViewController animated:YES];
                    }
                    else if ([strTitle isEqualToString:@"출금"])
                    {  // 출금화면이동
                        SHBPrimiumTransferViewController *nextViewController = [[[SHBPrimiumTransferViewController alloc] initWithNibName:@"SHBPrimiumTransferViewController" bundle:nil] autorelease];
                        nextViewController.outAccInfoDic = dictionary;
                        nextViewController.needsCert = YES;
                        [self checkLoginBeforePushViewController:nextViewController animated:YES];
                    }
                    else if ([strTitle isEqualToString:@"이체결과조회"])
                    {   // 이체결과조회
                        SHBTransferResultListViewController *nextViewController = [[[SHBTransferResultListViewController alloc] initWithNibName:@"SHBTransferResultListViewController" bundle:nil] autorelease];
                        nextViewController.strAccountNo = dictionary[@"계좌번호"];
                        [self.navigationController pushViewController:nextViewController animated:YES];
                    }
                }
                    break;
                case 1: // 펀드 입출금 버튼 클릭시
                {
                    if ([strTitle isEqualToString:@"입금"])
                    {  // 펀드 입금화면이동
                        [self depositAccount:row];
                    }
                    else if ([strTitle isEqualToString:@"출금"])
                    {  // 펀드 출금화면이동
                        [self transAccount:row];
                    }
                    else if ([strTitle isEqualToString:@"선물환조회"])
                    {
                        [self forwardExchangeList:row];
                    }
                    
                }
                    break;
                case 2:
                {
                    if([strTitle isEqualToString:@"이자납입"])
                    {
                        if ([[dictionary[@"계좌정보상세"][@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
                        {
                            SHBLoanCommonInterestViewController *nextViewController = [[[SHBLoanCommonInterestViewController alloc] initWithNibName:@"SHBLoanCommonInterestViewController" bundle:nil] autorelease];
                            nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                            [self.navigationController pushFadeViewController:nextViewController];
                        }
                        else
                        {
                            SHBInterestInqueryViewController *nextViewController = [[[SHBInterestInqueryViewController alloc] initWithNibName:@"SHBInterestInqueryViewController" bundle:nil] autorelease];
                            nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                            [self.navigationController pushFadeViewController:nextViewController];
                        }
                    }
                    else if ([strTitle isEqualToString:@"상환"])
                    {
                        SHBLoanRePayInqueryViewController *nextViewController = [[[SHBLoanRePayInqueryViewController alloc] initWithNibName:@"SHBLoanRePayInqueryViewController" bundle:nil] autorelease];
                        nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                        nextViewController.needsCert = YES;
                        [self checkLoginBeforePushViewController:nextViewController animated:YES];
                    }
                    else if ([strTitle isEqualToString:@"한도해지"]) {
                        
                        SHBLoanCancelViewController *nextViewController = [[[SHBLoanCancelViewController alloc] initWithNibName:@"SHBLoanCancelViewController" bundle:nil] autorelease];
                        nextViewController.accountInfo = dictionary[@"계좌정보상세"];
                        nextViewController.needsCert = YES;
                        [self checkLoginBeforePushViewController:nextViewController animated:YES];
                    }
                }
                    break;
                case 3:
                {
                    [self forexGoldMoreBtn:dictionary btnName:strTitle];
                }
                    break;
                    // 방카슈랑스 입금내역 클릭시 
                case 4:
                {
                    serviceType = 7;
                    if ([strTitle isEqualToString:@"입금내역"])
                    {  // 입금내역화면이동
                        if ([[dictionary objectForKey:@"제휴보험사코드"] hasPrefix:@"L"]) {
                            [self banInquiry:row selectJob:@"L"];
                        } else {
                            [self banInquiry:row selectJob:@"N"];
                        }
                    }
                }
                    break;
                case 5:
                {

                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 2004:
        {
            NSString *strTitle = ((UIButton *)dic[@"Button"]).titleLabel.text;
            
            switch (accountType) {
                case 3:
                {
                    [self forexGoldMoreBtn:dictionary btnName:strTitle];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)forexGoldMoreBtn:(NSDictionary *)accountDic btnName:(NSString *)senderTitle
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:accountDic[@"계좌정보상세"]];
    
    dic[@"외환출금계좌리스트"] = self.foreignAccountNumberList;
    dic[@"외환입금계좌리스트"] = self.foreignAccountNumberList2;
    
    if ([senderTitle isEqualToString:@"입금"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.needsCert = YES;
        viewController.accountInfo = (NSDictionary *)dic;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }
    else if ([senderTitle isEqualToString:@"출금"]) {
        SHBGoldPaymentInfoViewController *viewController = [[[SHBGoldPaymentInfoViewController alloc] initWithNibName:@"SHBGoldPaymentInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = (NSDictionary *)dic;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }
    else if ([senderTitle isEqualToString:@"적립"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = (NSDictionary *)dic;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }
}

- (void)displayFooterView
{
    [_tableFooterView removeFromSuperview];
    [_tableView1 setTableFooterView:nil];
    
    if([self.strServiceCode isEqualToString:@"F0010"] || [self.strServiceCode isEqualToString:@"B0010"] || [self.strServiceCode isEqualToString:@"C2010"])
    {
        return;
    }
    
    if([self.dataList[0][@"계좌번호"] isEqualToString:@""])
    {
        return;
    }
    for(UIView *views in [_tableFooterView subviews])
    {
        if([views isKindOfClass:[UILabel class]])
        {
            [views removeFromSuperview];
        }
    }
    
    CGRect viewRect = CGRectMake(0.0f, 0.0f, 317.0f, 0.0f);
    int row = [self.infoList count];
    
    viewRect.size.height = 8.0f + (19.0f * row) + 6.0f * row;
    
    _tableFooterView.frame = CGRectMake(0.0f, 0.0f, 317.0f, viewRect.size.height);
    _tableFooterView.backgroundColor = RGB(241, 229, 213);

    int positionY = 8;
    
    for(NSDictionary *dic in self.infoList)
    {
        UILabel *lblName = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.text = dic[@"Name"];
        lblName.textColor = RGB(74, 74, 74);
        lblName.font = [UIFont systemFontOfSize:15];
        lblName.textAlignment = UITextAlignmentLeft;
        
        UILabel *lblValue = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.text = dic[@"Value"];
        if(accountType == 0)
        {
            lblValue.textColor = RGB(209, 75, 75);
        }
        else
        {
            lblValue.textColor = RGB(44, 44, 44);
        }
        lblValue.font = [UIFont systemFontOfSize:15];
        lblValue.textAlignment = UITextAlignmentRight;
        
        [_tableFooterView addSubview:lblName];
        [_tableFooterView addSubview:lblValue];
        
        positionY = positionY + 19.0f + 6.0f;
    }
    
    // 휴면예금조회 ------------------------
    [dormantAccountView removeFromSuperview];
    
    if (accountType == 0) {
        
        // 예금/신탁 하단에 표시
        // 휴면예금보유여부, 재단출연보유여부 중 1개라도 1인 경우 보임
        if ([AppInfo.userInfo[@"휴면예금보유여부"] isEqualToString:@"1"] ||
            [AppInfo.userInfo[@"재단출연보유여부"] isEqualToString:@"1"] ||
            [AppInfo.accountD0011[@"휴면예금보유여부"] isEqualToString:@"1"] ||
            [AppInfo.accountD0011[@"재단출연보유여부"] isEqualToString:@"1"]) {
            
            [_tableFooterView addSubview:dormantAccountView];
            
            FrameReposition(dormantAccountView, 0, height(_tableFooterView));
            FrameResize(_tableFooterView, width(_tableFooterView), top(dormantAccountView) + height(dormantAccountView));
        }
    }
    // ----------------------------------
    
    [_tableView1 setTableFooterView:_tableFooterView];
}

- (void)refresh
{
    openedRow = -1;
    
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    self.dataList = nil;
    [_tableView1 setTableFooterView:nil];
    [_tableView1 reloadData];
    
    if ([self.strServiceCode isEqualToString:@"D0011"])
    {
        if (AppInfo.isD0011Start)
        {
            self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }else
        {
            accountType = 0;
            
            self.service = nil;
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
            self.service.responseData = AppInfo.accountD0011;
            
            [self onParse:AppInfo.accountD0011 string:nil];
            AppInfo.isD0011Start = YES;
        }
    }else
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
        self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
        [self.service start];
    }
    
}

- (void)refreshWidget
{
    serviceType = 8;
    NSLog(@"data:%@",pushDic);

    NSLog(@"abcd:%@",pushDic[@"speedIndex"]);
    self.service = [[[SHBAccountService alloc] initWithServiceId:ECHE_WIDGET_QUERY viewController:self] autorelease];
    self.service.previousData = [SHBDataSet dictionaryWithDictionary:@{
                                                                       @"KEY" : pushDic[@"speedIndex"],
                                                                       //@"DATE" : self.data[@"updt"],
                                                                       }];
    [self.service start];
}

- (void)expiryPopupClose
{
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    
    if (_expiryPopupView) {
        [_expiryPopupView fadeOut];
    }
}

#pragma mark - Push
- (void)executeWithDic:(NSMutableDictionary *)mDic	// 푸쉬로 왔으면
{
	[super executeWithDic:mDic];
	if (mDic) {
        strTargetAccNo = mDic[@"accNo"] == nil ? @"" : [mDic[@"accNo"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if (mDic[@"speedIndex"] && mDic[@"category"])
        {
            pushDic = mDic;
        }
	}
}

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
    //장차법대응
    self.btnNextMenu.accessibilityLabel = @"외환/골드 방카슈랑스 전체계좌 보기 이동";
    self.btnPrevMenu.accessibilityLabel = @"예금/신탁 펀드 대출계좌 보기 이동";
    //[self.btnPrevMenu setIsAccessibilityElement];
    
    self.title = @"계좌조회";
    self.strBackButtonTitle = @"계좌조회";

    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    accountType = 0;
    accountTypePre = 0;
    self.strServiceCode = @"D0011";
    openedRow = -1;
    
	// 제스쳐 등록
	UISwipeGestureRecognizer* recognizer;
	recognizer											= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    recognizer.direction                                = UISwipeGestureRecognizerDirectionLeft;
	recognizer.delegate									= self;
	[_menuView addGestureRecognizer:recognizer];
	[recognizer release];
    
	recognizer											= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    recognizer.direction                                = UISwipeGestureRecognizerDirectionRight;
	recognizer.delegate									= self;
	[_menuView addGestureRecognizer:recognizer];
	[recognizer release];
    
    if (pushDic && self.isPushAndScheme)
    {
        [self refreshWidget];
    }else
    {
        [self refresh];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView1 release];
    [_menuView release];
    [_btnNextMenu release];
    
    [infoList release];
    [_expiryPopupView release];
    
    self.array1 = nil;        // 입/출금
    self.array2 = nil;        // 정기적금신탁
    self.array3 = nil;        // 펀드
    self.array4 = nil;        // 대출
    self.array5 = nil;        // 외화
    self.array6 = nil;        // 골드
    
    self.foreignAccountNumberList = nil;
    self.foreignAccountNumberList2 = nil;
    
    [_tableFooterView release];
    
    [_btnPrevMenu release];
    [_btnMenu release];
    [dormantAccountView release];
    [dormantAccountHeaderView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView1:nil];
    [self setMenuView:nil];
    [self setBtnNextMenu:nil];
    [self setTableFooterView:nil];
    [self setBtnPrevMenu:nil];
    [self setBtnMenu:nil];
    [dormantAccountView release];
    dormantAccountView = nil;
    [dormantAccountHeaderView release];
    dormantAccountHeaderView = nil;
    [super viewDidUnload];
}

- (void)proximityChanged:(NSNotification *)notification {
    UIDevice *curDevice = [UIDevice currentDevice];
    curDevice.proximityMonitoringEnabled = NO;
    
    [self showSearchView];
}

- (void)showSearchView
{
    if(AppInfo.isShowSearchView)
    {
        return;
    }
    AppInfo.isShowSearchView = YES;
    
    SHBSearchView *searchView = [[[SHBSearchView alloc] init] autorelease];
    searchView = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchView" owner:self options:nil][0];
    searchView.frame = AppInfo.isiPhoneFive ? CGRectMake(0, 0, 320, 568) : CGRectMake(0, 0, 320, 480);
    searchView.navi = self.navigationController;
    [self.view.window addSubview:searchView];
    [searchView refresh];
}



@end
