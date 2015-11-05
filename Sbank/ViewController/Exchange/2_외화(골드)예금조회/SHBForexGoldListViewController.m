//
//  SHBForexGoldListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexGoldListViewController.h"
#import "SHBForexGoldListCell.h" // cell
#import "SHBExchangeService.h" // 서비스
#import "SHBPushInfo.h" // 푸시

#import "SHBForexDetailListViewController.h" // 외화예금조회
#import "SHBForexGoldDetailListViewController.h" // 골드리슈예금조회

#import "SHBGoldDepositInfoViewController.h"  // 골드입금안내
#import "SHBGoldPaymentInfoViewController.h"  // 골드출금안내

#define TABLEVIEW_MORE_CLOSE    86 // 닫힘 상태
#define TABLEVIEW_MORE_OPEN     125 // 펼침 상태


@interface SHBForexGoldListViewController ()
{
    NSInteger _selectedRow;
    NSMutableArray *foreignAccountNumberList; // 외화출금 계좌번호
    NSMutableArray *foreignAccountNumberList2; // 외화입금 계좌번호
}

@property (retain, nonatomic) NSMutableArray *foreignAccountNumberList; // 외화출금 계좌번호
@property (retain, nonatomic) NSMutableArray *foreignAccountNumberList2; // 외화입금 계좌번호

/**
 테이블뷰 더보기 버튼
 @param sender UIButton.
 */
- (void)tableViewMoreBtn:(UIButton *)sender;

/// 테이블뷰 버튼1
- (void)tableViewBtn1:(UIButton *)sender;

/// 테이블뷰 버튼2, 3, 4
- (void)tableViewBtn234:(UIButton *)sender;

@end

@implementation SHBForexGoldListViewController
@synthesize foreignAccountNumberList;
@synthesize foreignAccountNumberList2;

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
    
    [self setTitle:@"외화골드예금조회"];
    self.strBackButtonTitle = @"외화골드예금조회";
    
    _selectedRow = -1;
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_dataTable release];
    [foreignAccountNumberList release];
    [foreignAccountNumberList2 release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
	[super viewDidUnload];
}

- (void)refresh
{
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F0010_SERVICE
                                                   viewController:self] autorelease];
    [self.service start];
}

#pragma mark - UITableView Button

- (void)tableViewMoreBtn:(UIButton *)sender
{
    if (_selectedRow == [sender tag]) {
        _selectedRow = -1;
    }
    else {
        _selectedRow = [sender tag];
    }
    
    [_dataTable reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    UITableViewCell *cell = [_dataTable cellForRowAtIndexPath:indexPath];
    
    if (_selectedRow == [sender tag]) {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)tableViewBtn1:(UIButton *)sender
{
    NSInteger tag = [sender tag];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    UITableViewCell *cell = [_dataTable cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataList[tag]];
    
    dic[@"외환출금계좌리스트"] = (NSArray *)self.foreignAccountNumberList;
    dic[@"외환입금계좌리스트"] = (NSArray *)self.foreignAccountNumberList2;
    
    if ([sender.titleLabel.text isEqualToString:@"입금"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.needsCert = YES;
        viewController.accountInfo = dic;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }
    else if ([sender.titleLabel.text isEqualToString:@"출금"]) {
        SHBGoldPaymentInfoViewController *viewController = [[[SHBGoldPaymentInfoViewController alloc] initWithNibName:@"SHBGoldPaymentInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = dic;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }
    else if ([sender.titleLabel.text isEqualToString:@"적립"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = dic;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        return;
    }

    
    if ([dic[@"옵셋여부"] isEqualToString:@"1"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"Multiple 외화정기예금 기본계좌는 예금조회가 되지 않습니다."];
        return;
    }
    
    if ([dic[@"계좌번호"] hasPrefix:GOLD_186] ||
        [dic[@"계좌번호"] hasPrefix:GOLD_187] ||
        [dic[@"계좌번호"] hasPrefix:GOLD_188]) {
        SHBForexGoldDetailListViewController *viewController = [[[SHBForexGoldDetailListViewController alloc] initWithNibName:@"SHBForexGoldDetailListViewController" bundle:nil] autorelease];
        [viewController setAccountInfo:(NSMutableDictionary *)dic];
        [viewController setIsAllAccountList:NO];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    else {
        SHBForexDetailListViewController *viewController = [[[SHBForexDetailListViewController alloc] initWithNibName:@"SHBForexDetailListViewController" bundle:nil] autorelease];
        [viewController setAccountInfo:(NSMutableDictionary *)dic];
        [viewController setIsAllAccountList:NO];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)tableViewBtn234:(UIButton *)sender
{
    /*
     변경시 SHBAccountMenuListViewController.m 파일의
     - (void)forexGoldMoreBtn:(NSString *)accountNumber btnName:(NSString *)senderTitle 도 함께 수정
     */
    
    NSString *openBanking = @"";
    
    if (!AppInfo.realServer) {
        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold", URL_M_TEST];
    }
    else {
        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold", URL_M];
    }
    
    OFDataSet *dataSet = self.dataList[sender.tag];
    
    if ([dataSet[@"계좌번호"] hasPrefix:GOLD_186] ||
        [dataSet[@"계좌번호"] hasPrefix:GOLD_187] ||
        [dataSet[@"계좌번호"] hasPrefix:GOLD_188]) {
        if ([sender.titleLabel.text isEqualToString:@"입금"]) {
            openBanking = [NSString stringWithFormat:@"%@/gold/gold_deposit.jsp?EQUP_CD=SI", openBanking];
        }
        else if ([sender.titleLabel.text isEqualToString:@"출금"]) {
            openBanking = [NSString stringWithFormat:@"%@/gold/gold_withdraw.jsp?EQUP_CD=SI", openBanking];
        }
        else if ([sender.titleLabel.text isEqualToString:@"적립"]) {
            openBanking = [NSString stringWithFormat:@"%@/gold/gold_save.jsp?EQUP_CD=SI", openBanking];
        }
    }
    else {
        if ([sender.titleLabel.text isEqualToString:@"입금"]) {
            openBanking = [NSString stringWithFormat:@"%@/forex/ex_transfer_purchase.jsp?EQUP_CD=SI", openBanking];
        }
        else if ([sender.titleLabel.text isEqualToString:@"이체"]) {
            openBanking = [NSString stringWithFormat:@"%@/forex/ex_transfer_account.jsp?EQUP_CD=SI", openBanking];
        }
        else if ([sender.titleLabel.text isEqualToString:@"매도"]) {
            openBanking = [NSString stringWithFormat:@"%@/forex/ex_transfer_sale.jsp?EQUP_CD=SI", openBanking];
        }
    }
    
    [[SHBPushInfo instance] requestOpenURL:openBanking SSO:YES];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    NSArray *arr = [aDataSet arrayWithForKey:@"외화계좌"];
    
    if ([arr count] == 0) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:333
                         title:@""
                       message:@"보유하신 외화골드계좌가 존재하지 않습니다."];
        
        return NO;
    }
    
    foreignAccountNumberList = [[NSMutableArray alloc] initWithCapacity:0];
    foreignAccountNumberList2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSMutableDictionary *dic in arr) {
        
        if ([dic[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [dic[@"통화코드"] isEqualToString:@"USD"]) {
            
            if ([dic[@"계좌번호"] hasPrefix:@"180"] || [dic[@"계좌번호"] hasPrefix:@"181"]) {
                
                if ([dic[@"상품부기명"] length] > 0) {
                    [dic setObject:dic[@"상품부기명"]
                            forKey:@"1"];
                }
                else {
                    [dic setObject:dic[@"과목명"]
                            forKey:@"1"];
                }
                
                if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                    [dic setObject:dic[@"계좌번호"]
                            forKey:@"2"];
                }
                else {
                    [dic setObject:dic[@"구계좌번호"]
                            forKey:@"2"];
                }
                
                if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                    [dic[@"계좌번호"] hasPrefix:@"187"] ||
                    [dic[@"계좌번호"] hasPrefix:@"188"]) {
                    [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                            forKey:@"3"];
                }
                else {
                    [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                            forKey:@"3"];
                }
                [foreignAccountNumberList addObject:dic];
            }
        }
        if ([dic[@"입금가능여부"] isEqualToString:@"1"] && [dic[@"통화코드"] isEqualToString:@"USD"]) {
            
            if ([dic[@"계좌번호"] hasPrefix:@"180"] || [dic[@"계좌번호"] hasPrefix:@"181"]) {
                
                if ([dic[@"상품부기명"] length] > 0) {
                    [dic setObject:dic[@"상품부기명"]
                            forKey:@"1"];
                }
                else {
                    [dic setObject:dic[@"과목명"]
                            forKey:@"1"];
                }
                
                if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                    [dic setObject:dic[@"계좌번호"]
                            forKey:@"2"];
                }
                else {
                    [dic setObject:dic[@"구계좌번호"]
                            forKey:@"2"];
                }
                
                if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                    [dic[@"계좌번호"] hasPrefix:@"187"] ||
                    [dic[@"계좌번호"] hasPrefix:@"188"]) {
                    [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                            forKey:@"3"];
                }
                else {
                    [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                            forKey:@"3"];
                }
                [foreignAccountNumberList2 addObject:dic];
            }
        }
    }

    for (NSMutableDictionary *dic in arr) {
        if ([dic[@"옵셋여부"] isEqualToString:@"1"]) {
            if ([dic[@"상품부기명"] length] > 0) {
                [dic setObject:[NSString stringWithFormat:@"%@(기본계좌)", dic[@"상품부기명"]]
                        forKey:@"_계좌이름"];
            }
            else {
                [dic setObject:[NSString stringWithFormat:@"%@(기본계좌)", dic[@"과목명"]]
                        forKey:@"_계좌이름"];
            }
            
            if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                [dic setObject:dic[@"계좌번호"]
                        forKey:@"_계좌번호"];
            }
            else {
                [dic setObject:dic[@"구계좌번호"]
                        forKey:@"_계좌번호"];
            }
            
            if ([dic[@"계좌번호"] hasPrefix:GOLD_186] ||
                [dic[@"계좌번호"] hasPrefix:GOLD_187] ||
                [dic[@"계좌번호"] hasPrefix:GOLD_188]) {
                [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                        forKey:@"_통화잔액"];
            }
            else {
                [dic setObject:@"-"
                        forKey:@"_통화잔액"];
            }
        }
        else {
            if ([dic[@"상품부기명"] length] > 0) {
                [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"상품부기명"], dic[@"통화코드"]]
                        forKey:@"_계좌이름"];
            }
            else {
                [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"과목명"], dic[@"통화코드"]]
                        forKey:@"_계좌이름"];
            }
            
            if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                [dic setObject:dic[@"계좌번호"]
                        forKey:@"_계좌번호"];
            }
            else {
                [dic setObject:dic[@"구계좌번호"]
                        forKey:@"_계좌번호"];
            }
            
            if ([dic[@"계좌번호"] hasPrefix:GOLD_186] ||
                [dic[@"계좌번호"] hasPrefix:GOLD_187] ||
                [dic[@"계좌번호"] hasPrefix:GOLD_188]) {
                [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                        forKey:@"_통화잔액"];
            }
            else {
                [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                        forKey:@"_통화잔액"];
            }
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet*)aDataSet
{
    self.dataList = [aDataSet arrayWithForKey:@"외화계좌"];
    
    [_dataTable reloadData];
	
    return NO;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 333) {
        [self.navigationController fadePopViewController];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // !@#$ 외환 임시 설정
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    if (indexPath.row == _selectedRow && ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_186] ||
                                          [cellDataSet[@"계좌번호"] hasPrefix:GOLD_187] ||
                                          [cellDataSet[@"계좌번호"] hasPrefix:GOLD_188])) {
        return TABLEVIEW_MORE_OPEN;
    }
    return TABLEVIEW_MORE_CLOSE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    [cell.moreBtn setTag:indexPath.row];
    [cell.btn1 setTag:indexPath.row];
    [cell.btn2 setTag:indexPath.row];
    [cell.btn3 setTag:indexPath.row];
    [cell.btn4 setTag:indexPath.row];
    
    [cell.moreBtn addTarget:self
                     action:@selector(tableViewMoreBtn:)
           forControlEvents:UIControlEventTouchUpInside];
    [cell.btn1 addTarget:self
                  action:@selector(tableViewBtn1:)
        forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self
                  action:@selector(tableViewBtn1:)
        forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self
                  action:@selector(tableViewBtn1:)
        forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self
                  action:@selector(tableViewBtn1:)
        forControlEvents:UIControlEventTouchUpInside];
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];

    if (_selectedRow == indexPath.row) {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
        if ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_186] ||
            [cellDataSet[@"계좌번호"] hasPrefix:GOLD_187] ||
            [cellDataSet[@"계좌번호"] hasPrefix:GOLD_188]) {
            [cell.moreBtn setSelected:YES];
            [cell.moreBtn setHidden:NO];
            [cell.moreBtn setAccessibilityLabel:@"펼쳐보기닫기"];

            if ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_186]) {
                [cell.btn1 setHidden:NO];
                [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
                
                if ([cellDataSet[@"추가적립가능여부"] isEqualToString:@"1"]) {
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
    }else{
        if ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_186] ||
            [cellDataSet[@"계좌번호"] hasPrefix:GOLD_187] ||
            [cellDataSet[@"계좌번호"] hasPrefix:GOLD_188]) {
            [cell.moreBtn setSelected:NO];
            [cell.moreBtn setHidden:NO];
            [cell.moreBtn setAccessibilityLabel:@"펼쳐보기열기"];
            
        }else{
            [cell.moreBtn setHidden:YES];
            
        }
    }
    
//    if (_selectedRow == indexPath.row) {
//        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
//        
//        [cell.moreBtn setSelected:YES];
//        [cell.moreBtn setHidden:NO];
//        [cell.moreBtn setAccessibilityLabel:@"펼쳐보기닫기"];
//        
//        // !@#$ 외환 임시 설정
//        [cell.line setFrame:CGRectMake(0,
//                                       TABLEVIEW_MORE_OPEN - 1,
//                                       cell.line.frame.size.width,
//                                       cell.line.frame.size.height)];
//        //
//        
//        if ([cellDataSet[@"계좌번호"] hasPrefix:FOREX_180]) {
//            
//            if ([cellDataSet[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"]) {
//                [cell.btn1 setHidden:NO];
//                [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//                [cell.btn2 setHidden:NO];
//                [cell.btn2 setTitle:@"이체" forState:UIControlStateNormal];
//                [cell.btn3 setHidden:NO];
//                [cell.btn3 setTitle:@"매도" forState:UIControlStateNormal];
//                [cell.btn4 setHidden:NO];
//                [cell.btn4 setTitle:@"입금" forState:UIControlStateNormal];
//            }
//            else {
//                [cell.btn1 setHidden:NO];
//                [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//                [cell.btn2 setHidden:NO];
//                [cell.btn2 setTitle:@"입금" forState:UIControlStateNormal];
//            }
//        }
//        else if ([cellDataSet[@"계좌번호"] hasPrefix:FOREX_182] ||
//                 [cellDataSet[@"계좌번호"] hasPrefix:FOREX_184] ||
//                 [cellDataSet[@"계좌번호"] hasPrefix:FOREX_185]) {
//            [cell.moreBtn setHidden:YES];
//            
//            [cell.line setFrame:CGRectMake(0,
//                                           TABLEVIEW_MORE_CLOSE - 1,
//                                           cell.line.frame.size.width,
//                                           cell.line.frame.size.height)];
//        }
//        else if ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_186]) {
//            [cell.btn1 setHidden:NO];
//            [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//            
//            if ([cellDataSet[@"추가적립가능여부"] isEqualToString:@"1"]) {
//                [cell.btn2 setHidden:NO];
//                [cell.btn2 setTitle:@"적립" forState:UIControlStateNormal];
//            }
//        }
//        else if ([cellDataSet[@"계좌번호"] hasPrefix:FOREX_181] ||
//                 [cellDataSet[@"계좌번호"] hasPrefix:FOREX_327]) {
//            [cell.btn1 setHidden:NO];
//            [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//            [cell.btn2 setHidden:NO];
//            [cell.btn2 setTitle:@"입금" forState:UIControlStateNormal];
//        }
//        else if ([cellDataSet[@"계좌번호"] hasPrefix:GOLD_187] ||
//                 [cellDataSet[@"계좌번호"] hasPrefix:GOLD_188]) {
//            [cell.btn1 setHidden:NO];
//            [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//            [cell.btn2 setHidden:NO];
//            [cell.btn2 setTitle:@"입금" forState:UIControlStateNormal];
//            [cell.btn3 setHidden:NO];
//            [cell.btn3 setTitle:@"출금" forState:UIControlStateNormal];
//        }
//    }
//    else {
//        [cell.contentView setBackgroundColor:[UIColor clearColor]];
//        
//        [cell.moreBtn setSelected:NO];
//        [cell.moreBtn setHidden:NO];
//        [cell.moreBtn setAccessibilityLabel:@"펼쳐보기열기"];
//        
//        [cell.line setFrame:CGRectMake(0,
//                                       TABLEVIEW_MORE_CLOSE - 1,
//                                       cell.line.frame.size.width,
//                                       cell.line.frame.size.height)];
//        
//        [cell.btn1 setHidden:YES];
//        [cell.btn1 setTitle:@"조회" forState:UIControlStateNormal];
//        [cell.btn2 setHidden:YES];
//        [cell.btn2 setTitle:@"" forState:UIControlStateNormal];
//        [cell.btn3 setHidden:YES];
//        [cell.btn3 setTitle:@"" forState:UIControlStateNormal];
//        [cell.btn4 setHidden:YES];
//        [cell.btn4 setTitle:@"" forState:UIControlStateNormal];
//        
//        if ([cellDataSet[@"계좌번호"] hasPrefix:FOREX_182] ||
//            [cellDataSet[@"계좌번호"] hasPrefix:FOREX_184] ||
//            [cellDataSet[@"계좌번호"] hasPrefix:FOREX_185]) {
//            [cell.moreBtn setHidden:YES];
//        }
//    }
    
    // !@#$ 외환 임시 설정
//    [cell.moreBtn setHidden:YES];
//    [cell.btn1 setHidden:YES];
//    [cell.btn2 setHidden:YES];
//    [cell.btn3 setHidden:YES];
//    [cell.btn4 setHidden:YES];
//    [cell.line setFrame:CGRectMake(0,
//                                   TABLEVIEW_MORE_CLOSE - 1,
//                                   cell.line.frame.size.width,
//                                   cell.line.frame.size.height)];
    //
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:indexPath.row];
    
    if (_selectedRow != indexPath.row) {
        _selectedRow = indexPath.row;
        [tableView reloadData];
    }
    
	[self tableViewBtn1:btn];
}

@end
