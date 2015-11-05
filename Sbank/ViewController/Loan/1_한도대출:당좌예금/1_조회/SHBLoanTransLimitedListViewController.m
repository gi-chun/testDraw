//
//  SHBLoanTransLimitedListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanTransLimitedListViewController.h"
#import "SHBLoanInterestViewController.h"
#import "SHBInterestInqueryViewController.h"
#import "SHBListPopupView.h"
#import "SHBPeriodPopupView.h"
#import "SHBUtility.h"


@interface SHBLoanTransLimitedListViewController ()<SHBListPopupViewDelegate, SHBPopupViewDelegate>
{
    NSString *strServiceCode;
    NSString *strStartDate;
    NSString *strEndDate;
    
    BOOL isShowAccountDetailInfo;
    
    NSArray *tableDataArray;
    
    int cellHeight;
    int totListCnt;
}
@property (nonatomic, retain) NSString *strServiceCode;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (nonatomic, retain) NSArray *tableDataArray;
- (void)SendRequestListData;
- (void)displayAccountInfoView;
@end

@implementation SHBLoanTransLimitedListViewController
@synthesize service;
@synthesize accountInfo;
@synthesize strServiceCode;
@synthesize strStartDate;
@synthesize strEndDate;
@synthesize tableDataArray;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:   // 이자
        {
            SHBInterestInqueryViewController *nextViewController = [[[SHBInterestInqueryViewController alloc] initWithNibName:@"SHBInterestInqueryViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 200:   // 계좌상세
        {
            if(isShowAccountDetailInfo)
            {
                isShowAccountDetailInfo = NO;
                sender.selected = NO;
                sender.accessibilityLabel = @"계좌상세보기";
                
                for (int i  = 3000; i < 3013; i++)
                {
                    [[self.view viewWithTag:i] setIsAccessibilityElement:NO];
                }
            }
            else
            {
                isShowAccountDetailInfo = YES;
                sender.selected = YES;
                sender.accessibilityLabel = @"계좌상세닫기";
                for (int i  = 3000; i < 3013; i++)
                {
                    UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:i];
                    if ([tmpLabel.text length] > 0)
                    {
                        [[self.view viewWithTag:i] setIsAccessibilityElement:YES];
                    }else
                    {
                        [[self.view viewWithTag:i] setIsAccessibilityElement:NO];
                    }
                    
                }
            }
            [self displayAccountInfoView];
            
            [_tableView1 setContentOffset:CGPointZero animated:YES];
        }
            break;
        case 300:   // 구분(전체, 입급, 출금)
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"전체"},
                                     @{@"1" : @"입금"},
                                     @{@"1" : @"출금"},
                                     ]];
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"조회기준"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:3
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 400:   // 1주일
        {
            self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];
            self.strEndDate = AppInfo.tran_Date;
            
            [self SendRequestListData];
        }
            break;
        case 401:   // 1개월
        {
            self.strStartDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            self.strEndDate = AppInfo.tran_Date;
            
            [self SendRequestListData];
        }
            break;
        case 402:   // 기간선택
        {
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 600:   // 정렬
        {
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
            
            if(sender.isSelected)
            {
                sender.selected = NO;
                sender.accessibilityLabel = @"과거 거래순 정렬";
            }
            else
            {
                sender.selected = YES;
                sender.accessibilityLabel = @"최근 거래순 정렬";
            }
            NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:sender.isSelected];
            [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
            [sortOrder release];
            
            self.dataList = (NSArray *)tempArray;
            
            [_tableView1 reloadData];
        }
            break;
        case 700:
        {
            SHBLoanInterestViewController *nextViewController = [[[SHBLoanInterestViewController alloc] initWithNibName:@"SHBLoanInterestViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
//        case 800:
//        {
//            if([self.dataList count] == 500)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:@"해당기간의 거래내역이 500건 이상입니다. 신한S뱅크에서 해당계좌의 거래내역조회는 500건까지 가능합니다. 500건이상 내역 조회는 인터넷(폰)뱅킹에서 조회하시기 바랍니다."
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"확인"
//                                                      otherButtonTitles:nil];
//                
//                [alert show];
//                [alert release];
//            }
//            else if ([self.dataList count] + 50 > totListCnt)
//            {
//                NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.tableDataArray] autorelease];
//                
//                NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:_btnSort.isSelected];
//                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
//                [sortOrder release];
//                
//                self.dataList = (NSArray *)tempArray;
//                
//                [_tableView1 setTableFooterView:nil];
//                [_tableView1 reloadData];
//            }
//            else
//            {
//                NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:[self.tableDataArray subarrayWithRange:NSMakeRange(0, [self.dataList count] + 50)]] autorelease];
//                
//                NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:_btnSort.isSelected];
//                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
//                [sortOrder release];
//                
//                self.dataList = (NSArray *)tempArray;
//                [_tableView1 reloadData];
//            }
//        }
//            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if([self.strServiceCode isEqualToString:@"L1160"])
    {
        NSString *strTemp = aDataSet[@"이율상세정보"];
        if([strTemp isEqualToString:@""])
        {
            strTemp = @"대출금리 상세정보 없음";
        }
        else
        {
            if([strTemp rangeOfString:@"+"].location != NSNotFound)
            {
                int iPos = [strTemp rangeOfString:@"+"].location;
                
                strTemp = [NSString stringWithFormat:@"%@\n%@", [strTemp substringToIndex:iPos], [strTemp substringFromIndex:iPos]];
            }
        }
        
        ((UILabel *)_lblAccountInfoL1120[4]).text = strTemp;
        ((UILabel *)_lblAccountInfoL1120[4]).accessibilityLabel = strTemp;
        self.strServiceCode = @"L1120";
        
        self.service = nil;
        
        self.service = [[[SHBLoanService alloc] initWithServiceCode:self.strServiceCode viewController: self] autorelease];
        
        SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : accountInfo[@"대출계좌번호"],
                                @"은행구분" : @"1",
                                @"정렬구분" : @"1",
                                @"조회건수" : @"10",
                                @"조회기간구분" : @"1",
                                }];
        
        self.service.requestData = aDataSet;
        [self.service start];
        return NO;
    }
    
    if([self.strServiceCode isEqualToString:@"L1120"])
    {
        // 이율 추가
        ((UILabel *)_lblAccountInfoL1120[3]).text = [NSString stringWithFormat:@"%@%%", aDataSet[@"대출이율"]];
        
        if([((UILabel *)_lblAccountInfoL1120[6]).text isEqualToString:@""])
        {
            NSString *strComment = @"";
            if([aDataSet[@"인감분실여부"] intValue] == 1)
            {
                strComment = @"인감분실";
            }
            if([aDataSet[@"통장분실여부"] intValue] == 1)
            {
                if([strComment length] == 0)
                {
                    strComment = @"통장분실";
                }
                else
                {
                    strComment = [NSString stringWithFormat:@"%@, 통장분실", strComment];
                }
            }
            if([aDataSet[@"지급정지여부"] intValue] == 1)
            {
                if([strComment length] == 0)
                {
                    strComment = @"지급정지";
                }
                else
                {
                    strComment = [NSString stringWithFormat:@"%@, 지급정지", strComment];
                }
            }
            
            NSArray *dataArray = @[
            [NSString stringWithFormat:@"%@원", aDataSet[@"계좌잔액"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"출금가능금액"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"대출승인액"]],
            ((UILabel *)_lblAccountInfoL1120[3]).text,
            ((UILabel *)_lblAccountInfoL1120[4]).text,
            aDataSet[@"대출만기일"],
            aDataSet[@"고객명"],
            [SHBUtility getDateWithDash:aDataSet[@"최종거래일->originalValue"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"수표금액"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"한도초과미수이자"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"대출이자"]],
            strComment,
            ];
            
            for(int i = 0; i < [_lblAccountInfoL1120 count]; i ++)
            {
                UILabel *lblData = _lblAccountInfoL1120[i];
                lblData.text = dataArray[i];
            }
            
            [self displayAccountInfoView];
        }
    }
    else
    {
        if([((UILabel *)_lblAccountInfoD1170[6]).text isEqualToString:@""])
        {
            NSArray *dataArray = @[
            [NSString stringWithFormat:@"%@원", aDataSet[@"계좌잔액"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"출금가능금액"]],
            [NSString stringWithFormat:@"%@원", aDataSet[@"대출승인액"]],
            [NSString stringWithFormat:@"%@%%", aDataSet[@"대출이율"]],
            aDataSet[@"대출만기일"],
            aDataSet[@"고객명"],
            aDataSet[@"신규일자"],
            aDataSet[@"최종거래일"],
            [NSString stringWithFormat:@"%@원", aDataSet[@"수표금액"]],
            ];
            
            for(int i = 0; i < [_lblAccountInfoD1170 count]; i ++)
            {
                UILabel *lblData = _lblAccountInfoD1170[i];
                lblData.text = dataArray[i];
            }
            
            [self displayAccountInfoView];
        }
    }
    
    _btnSort.selected = NO;
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    if([[aDataSet arrayWithForKey:@"거래내역"] count] == 1 && [[aDataSet arrayWithForKey:@"거래내역"][0][@"내용"] isEqualToString:@"***거래내역 없음***"])
    {
        
    }
    else
    {
        NSArray *list = [aDataSet arrayWithForKey:@"거래내역"];
        
        for(NSDictionary *dic in list)
        {
            NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
            
            infoDic[@"거래일자"] = [NSString stringWithFormat:@"%@ %@", dic[@"거래일자"],  dic[@"시간"] != nil ? dic[@"시간"] : dic[@"거래시간"]];
            infoDic[@"잔액"] = [NSString stringWithFormat:@"%@원", dic[@"잔액"]];
            
            NSString *tmp = dic[@"입지구분"];
            
            if(tmp == nil || [tmp isEqualToString:@""])
            {
                tmp = [dic[@"입금"] isEqualToString:@"0"] ? @"2" : @"1";
            }
            
            if([tmp isEqualToString:@"1"])
            {
                infoDic[@"구분"] = @"입금";
                infoDic[@"금액"] = [NSString stringWithFormat:@"%@원", dic[@"입금"]];
            }
            else if([tmp isEqualToString:@"2"])
            {
                if([dic[@"출금"] isEqualToString:@"0"])
                {
                    infoDic[@"구분"] = @"";
                    infoDic[@"금액"] = @"";
                }
                else
                {
                    infoDic[@"구분"] = @"출금";
                    infoDic[@"금액"] = [NSString stringWithFormat:@"%@원", dic[@"출금"]];
                }
            }
            else
            {
                infoDic[@"구분"] = @"";
                infoDic[@"금액"] = @"";
            }
            
            infoDic[@"적요"] = dic[@"적요"];
            infoDic[@"내용"] = dic[@"내용"];
            
            if(![_btnDealType.titleLabel.text isEqualToString:@"전체"])
            {
                if ([infoDic[@"구분"] isEqualToString:_btnDealType.titleLabel.text]) {
                    [dataArray addObject:infoDic];
                }
            }
            else
            {
                [dataArray addObject:infoDic];
            }
        }
    }
    
    self.tableDataArray = (NSArray *)dataArray;
    
    totListCnt = [self.tableDataArray count];

//    if(totListCnt > 50)
//    {
//        self.dataList = [self.tableDataArray subarrayWithRange:NSMakeRange(0, 50)];
//        [_tableView1 setTableFooterView:_tableFooterView];
//    }
//    else
//    {
//        self.dataList = self.tableDataArray;
//        [_tableView1 setTableFooterView:nil];
//    }

    self.dataList = self.tableDataArray;
    [_tableView1 setTableFooterView:nil];
    
    if([self.strStartDate isEqualToString:@""]){
        _lblData03.text = [NSString stringWithFormat:@"최근거래내역 %d건이 조회되었습니다.", totListCnt];
    }else{
        if(totListCnt >= 500)
        {
            _lblData03.text = [NSString stringWithFormat:@"조회기간:%@~%@ (500건 이상)", strStartDate, strEndDate];
        }
        else
        {
            _lblData03.text = [NSString stringWithFormat:@"조회기간:%@~%@ (%d건)", strStartDate, strEndDate, totListCnt];
        }
    }
    
    if([self.dataList count] == 0)
    {
        _tableView1.separatorStyle = 0;
        _lblNoData.hidden = NO;
    }
    else
    {
        _tableView1.separatorStyle = 1;
        _lblNoData.hidden = YES;
    }
    
    _lblData03.hidden = NO;
    
    [_tableView1 reloadData];
    
    [_tableView1 setContentOffset:CGPointZero animated:YES];
    
    self.service = nil;
    
    return NO;
}

#pragma mark - SHBPeriodPopupView
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self SendRequestListData];
}

- (void)popupViewDidCancel
{
    
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    _btnSort.Selected = NO;
    
    switch (anIndex) {
        case 0:
            [_btnDealType setTitle:@"전체" forState:UIControlStateNormal];
//            self.dataList = tableDataArray;
            
            break;
        case 1:
        {
            [_btnDealType setTitle:@"입금" forState:UIControlStateNormal];
//            NSMutableArray *array = [NSMutableArray array];
//            
//            for (NSDictionary *dic in tableDataArray) {
//                if ([dic[@"구분"] isEqualToString:@"입금"]) {
//                    [array addObject:dic];
//                }
//            }
//            
//            self.dataList = (NSArray *)array;
        }
            break;
        case 2:
        {
            [_btnDealType setTitle:@"출금" forState:UIControlStateNormal];
//            NSMutableArray *array = [NSMutableArray array];
//            
//            for (NSDictionary *dic in tableDataArray) {
//                if ([dic[@"구분"] isEqualToString:@"출금"]) {
//                    [array addObject:dic];
//                }
//            }
//            
//            self.dataList = (NSArray *)array;
        }
            break;
            
        default:
            break;
    }
    
    [_tableView1 reloadData];
}

- (void)listPopupViewDidCancel
{
    
}

- (void)SendRequestListData
{
    self.dataList = nil;
    [_tableView1 reloadData];
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:self.strServiceCode viewController: self] autorelease];
    
    // release 처리
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"계좌번호" : accountInfo[@"대출계좌번호"],
                            @"은행구분" : @"1",
                            @"정렬구분" : @"1",
                            @"조회기간구분" : @"0",
                            @"조회시작일" : strStartDate,
                            @"조회종료일" : strEndDate,
                            }] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        float positionY = 8.0f;
        // 거래일자
        UILabel *cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 301.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(133, 87, 35);
        cellLabel.tag = 9001;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(209.0f, positionY, 35.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(114, 114, 114);
        cellLabel.text = @"적요";
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(239.0f, positionY, 70.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.tag = 9002;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:cellLabel];
        
        positionY = positionY + 19.0f + 6.0f;

        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 35.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(114, 114, 114);
        cellLabel.text = @"내용";
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.tag = 9003;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:cellLabel];
        
        positionY = positionY + 19.0f + 6.0f;
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.tag = 9004;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.tag = 9005;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:cellLabel];
        
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    ((UILabel *)[cell.contentView viewWithTag:9001]).text = dictionary[@"거래일자"];
    
    ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
    ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"내용"];
    ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"구분"];
    ((UILabel *)[cell.contentView viewWithTag:9005]).text = dictionary[@"금액"];
    
    if([dictionary[@"구분"] isEqualToString:@"입금"])
    {
        ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
        ((UILabel *)[cell.contentView viewWithTag:9005]).textColor = RGB(209, 75, 75);
    }
    else if([dictionary[@"구분"] isEqualToString:@"출금"])
    {
        ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(0, 137, 220);
        ((UILabel *)[cell.contentView viewWithTag:9005]).textColor = RGB(0, 137, 220);
    }
    
    return cell;
}

- (void)displayAccountInfoView
{
    CGRect viewRect;
    if([self.strServiceCode isEqualToString:@"L1120"])
    {
        viewRect = _accountInfoL1120View.frame;
        
        if(isShowAccountDetailInfo)
        {
            viewRect.size.height = 334;
            _lineView.backgroundColor = RGB(209, 209, 209);
        }
        else
        {
            viewRect.size.height = 185;
            _lineView.backgroundColor = [UIColor clearColor];
        }
        
        _accountInfoL1120View.frame = viewRect;
    }
    else
    {
        [_accountInfoL1120View removeFromSuperview];
        [_tableHeaderView addSubview:_accountInfoD1170View];
        
        viewRect = _accountInfoD1170View.frame;
        
        if(isShowAccountDetailInfo)
        {
            viewRect.size.height = 236;
            _lineView.backgroundColor = RGB(209, 209, 209);
        }
        else
        {
            viewRect.size.height = 135;
            _lineView.backgroundColor = [UIColor clearColor];
        }
        
        _accountInfoD1170View.frame = viewRect;
    }
    _tableHeaderView.frame = CGRectMake(0.0f, 0.0f, 317.0f, viewRect.size.height + _termSelectView.frame.size.height);
    
    [_tableView1 setTableHeaderView:_tableHeaderView];
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

    self.title = @"대출조회";
    self.strBackButtonTitle = @"대출조회 상세";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.strStartDate = @"";
    self.strEndDate = @"";
    
    isShowAccountDetailInfo = NO;
    
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:[accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"]];
    
    _lblData02.text = [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"];
    _lblData03.hidden = YES;
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        for (int i  = 3000; i < 3013; i++)
        {
            [[self.view viewWithTag:i] setIsAccessibilityElement:NO];
        }
    }
    
    if ([[accountInfo[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] < 150)
    {
        _btnDealType.hidden = NO;
        
        self.strServiceCode = @"L1160";
        NSArray *dataArray = @[
        [NSString stringWithFormat:@"%@원", accountInfo[@"대출잔액"]],
        @"0원",
        @"0원",
        [NSString stringWithFormat:@"%@%%", accountInfo[@"대출적용이율->originalValue"]],
        @"",
        accountInfo[@"대출만기일"],
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        ];
        
        for(int i = 0; i < [_lblAccountInfoL1120 count]; i ++)
        {
            UILabel *lblData = _lblAccountInfoL1120[i];
            lblData.text = dataArray[i];
        }
        
        self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1160" viewController: self] autorelease];
        
        SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : accountInfo[@"대출계좌번호"],
                                @"은행구분" : @"1",
                                @"업무구분" : @"1",
                                @"직원조회" : @"1",
                                @"증서번호" : @"1",
                                @"거래점용은행구분" : @"1",
                                }];
        
        self.service.requestData = aDataSet;
        [self.service start];
        [aDataSet release];
        return;
    }
    else
    {
        _btnDealType.hidden = YES;
        
        self.strServiceCode = @"D1170";

        NSArray *dataArray = @[
        [NSString stringWithFormat:@"%@원", accountInfo[@"대출잔액"]],
        @"0원",
        @"0원",
        [NSString stringWithFormat:@"%@%%", accountInfo[@"대출적용이율->originalValue"]],
        accountInfo[@"대출만기일"],
        @"",
        @"",
        @"",
        @"",
        ];
        
        for(int i = 0; i < [_lblAccountInfoD1170 count]; i ++)
        {
            UILabel *lblData = _lblAccountInfoD1170[i];
            lblData.text = dataArray[i];
        }
    }
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:self.strServiceCode viewController: self] autorelease];
    
    SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"계좌번호" : accountInfo[@"대출계좌번호"],
                            @"은행구분" : @"1",
                            @"정렬구분" : @"1",
                            @"조회건수" : @"10",
                            @"조회기간구분" : @"1",
                            }];
    
    self.service.requestData = aDataSet;
    [self.service start];
    [aDataSet release];
    
    
    
    // 계좌정보 표시
    [self displayAccountInfoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [strServiceCode release];
    
    [_btnInterest release];
    [_tableView1 release];
    [_accountInfoL1120View release];
    [_accountInfoD1170View release];
    [_termSelectView release];
    [_tableHeaderView release];
    [_lineView release];
    [_btnSort release];
    [_btnDealType release];
    [_lblData02 release];
    [_lblData03 release];

    [_lblAccountInfoL1120 release];
    [_lblAccountInfoD1170 release];
    [_lblTitle release];
    [_lblNoData release];
    [_tableFooterView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setBtnInterest:nil];
    [self setTableView1:nil];
    [self setAccountInfoL1120View:nil];
    [self setAccountInfoD1170View:nil];
    [self setTermSelectView:nil];
    [self setTableHeaderView:nil];
    [self setLineView:nil];
    [self setBtnSort:nil];
    [self setBtnDealType:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    
    [self setLblAccountInfoL1120:nil];
    [self setLblAccountInfoD1170:nil];
    [self setLblTitle:nil];
    [self setLblNoData:nil];
    [self setTableFooterView:nil];
    [super viewDidUnload];
}

@end
