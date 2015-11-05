//
//  SHBTransferResultListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTransferResultListViewController.h"
#import "SHBTransferResultViewController.h"
#import "SHBTransferResultCell.h"
#import "SHBAccountService.h"
#import "SHBPeriodPopupView.h"
#import "SHBUtility.h"

@interface SHBTransferResultListViewController ()<SHBPopupViewDelegate>
{
    NSMutableArray *accountListArray;
    NSString *strStartDate;
    NSString *strEndDate;

    NSArray *tableDataArray;
    
    int totListCnt;
}
@property (nonatomic, retain) NSMutableArray *accountListArray;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (nonatomic, retain) NSArray *tableDataArray;
- (void)sendTransResultRequest;
@end

@implementation SHBTransferResultListViewController
@synthesize accountListArray;
@synthesize strStartDate;
@synthesize strEndDate;
@synthesize strAccountNo;
@synthesize tableDataArray;

- (IBAction)buttonTouchupInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:   // 조회계좌선택
        {
            SHBTransferResultListPopupView *popupView = [[SHBTransferResultListPopupView alloc] initWithTitle:@"조회계좌번호" options:accountListArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView setTableViewDataSource];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 200:   // 조회기간 : 1주일
        {
            self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];
            self.strEndDate = AppInfo.tran_Date;
            
            [self sendTransResultRequest];
        }
            break;
        case 201:   // 조회기간 : 1개월
        {
            self.strStartDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            self.strEndDate = AppInfo.tran_Date;
            
            [self sendTransResultRequest];
        }
            break;
        case 202:   // 조회기간 : 3개월
        {
            self.strStartDate = [SHBUtility dateStringToMonth:-3 toDay:0];
            self.strEndDate = AppInfo.tran_Date;
            
            [self sendTransResultRequest];
        }
            break;
        case 203:   // 조회기간 : 기간선택
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
            NSSortDescriptor *sortOrder1 = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:sender.isSelected];
            NSSortDescriptor *sortOrder2 = [[NSSortDescriptor alloc] initWithKey:@"거래시간" ascending:sender.isSelected];
            
            [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder1, sortOrder2, nil]];
            [sortOrder1 release];
            [sortOrder2 release];
            
            self.dataList = (NSArray *)tempArray;
            
            [_tableView1 reloadData];
        }
            break;
            
//        case 700:   // 더보기
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
//                NSSortDescriptor *sortOrder1 = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:_btnSort.isSelected];
//                NSSortDescriptor *sortOrder2 = [[NSSortDescriptor alloc] initWithKey:@"거래시간" ascending:_btnSort.isSelected];
//                
//                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder1, sortOrder2, nil]];
//                [sortOrder1 release];
//                [sortOrder2 release];
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
//                NSSortDescriptor *sortOrder1 = [[NSSortDescriptor alloc] initWithKey:@"거래일자" ascending:_btnSort.isSelected];
//                NSSortDescriptor *sortOrder2 = [[NSSortDescriptor alloc] initWithKey:@"거래시간" ascending:_btnSort.isSelected];
//                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder1, sortOrder2, nil]];
//                [sortOrder1 release];
//                [sortOrder2 release];
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
    _btnSort.selected = NO;
    self.tableDataArray = [aDataSet arrayWithForKey:@"이체내역"];
    
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
    
    [_tableView1 reloadData];
    
    if(totListCnt >= 500)
    {
        _lblInqueryTrem.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (500건 이상)", self.strStartDate, self.strEndDate];
    }
    else
    {
        _lblInqueryTrem.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (%d건)", self.strStartDate, self.strEndDate, totListCnt];
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBTransferResultCell *cell = (SHBTransferResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBTransferResultCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBTransferResultCell *)currentObject;
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }

    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    cell.lblTranDateTime.text = [NSString stringWithFormat:@"%@ %@", dictionary[@"거래일자"], dictionary[@"거래시간"]];
    
    if([dictionary[@"처리상태"] length] != 0)
    {
        int tmp = [dictionary[@"처리상태"] intValue];

        switch (tmp) {
            case 1:
            {
                cell.lblState.text = @"[처리중]";
                cell.lblState.textColor = RGB(209, 75, 75);
            }
                break;
            case 2:
            {
                cell.lblState.text = @"[정상]";
                cell.lblState.textColor = RGB(0, 137, 220);
            }
                break;
            case 3:
            case 4:
            case 5:
            {
                cell.lblState.text = @"[오류]";
                cell.lblState.textColor = RGB(209, 75, 75);
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        if([dictionary[@"처리상태"] isEqualToString:@"정상"])
        {
            cell.lblState.text = @"[정상]";
            cell.lblState.textColor = RGB(0, 137, 220);
        }
        else
        {
            cell.lblState.text = @"";
        }
    }
    
    cell.lblRecvName.text = dictionary[@"입금계좌성명"];
    cell.lblTranAmount.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = self.dataList[indexPath.row];
    SHBTransferResultViewController *nextViewController = [[[SHBTransferResultViewController alloc] initWithNibName:@"SHBTransferResultViewController" bundle:nil] autorelease];
    nextViewController.infoDic = dictionary;
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void)sendTransResultRequest
{
    self.dataList = nil;
    [_tableView1 reloadData];
    
    _lblInqueryTrem.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@", self.strStartDate, self.strEndDate];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D4110" viewController:self] autorelease];
    
    NSString *accountNumber = @"";
    
    if (![self.strAccountNo isEqualToString:@"전체"]) {
        accountNumber = [self.strAccountNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"출금계좌번호" : accountNumber,
                            @"조회결과순서" : @"1",
                            @"조회시작일" : self.strStartDate,
                            @"조회종료일" : self.strEndDate,
                            }] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - SHBPeriodPopupView
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:203];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
    
    [self sendTransResultRequest];
}

- (void)popupViewDidCancel
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:203];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
}

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    _btnOutAccNo.selected = NO;

    self.strAccountNo = accountListArray[anIndex][@"2"];
    [_btnOutAccNo setTitle:self.strAccountNo forState:UIControlStateNormal];
    
    _btnOutAccNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 조회계좌번호는 %@ 입니다", _btnOutAccNo.titleLabel.text];
    _btnOutAccNo.accessibilityHint = @"조회계좌번호를 바꾸시려면 이중탭 하십시오";
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnOutAccNo);
    
    [self sendTransResultRequest];
}

- (void)listPopupViewDidCancel{
    _btnOutAccNo.selected = NO;
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnOutAccNo);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.strAccountNo = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"이체결과조회";
    self.strBackButtonTitle = @"이체결과조회";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.accountListArray = [self outAccountList];

    if([self.accountListArray count] == 0)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"조회가능한 계좌가 존재하지 않습니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        [self.navigationController fadePopViewController];
        return;
    }
    
    NSDictionary *dic = @{
                          @"1" : @"",
                          @"2" : @"전체",
                          @"은행코드" : @"",
                          @"신계좌변환여부" : @"",
                          @"은행구분" : @"",
                          @"출금계좌번호" : @"",
                          @"구출금계좌번호" : @"",
                          };
    
    [self.accountListArray insertObject:dic atIndex:0];
    
    if(![self.strAccountNo isEqualToString:@""])
    {
        [_btnOutAccNo setTitle:self.strAccountNo forState:UIControlStateNormal];
    }
    else
    {
        self.strAccountNo = accountListArray[0][@"2"];
        [_btnOutAccNo setTitle:self.strAccountNo forState:UIControlStateNormal];
    }
    
    _btnOutAccNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 조회계좌번호는 %@ 입니다", _btnOutAccNo.titleLabel.text];
    _btnOutAccNo.accessibilityHint = @"조회계좌번호를 바꾸시려면 이중탭 하십시오";
    
    self.strStartDate = AppInfo.tran_Date;
    self.strEndDate = AppInfo.tran_Date;

    [self sendTransResultRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [accountListArray release];

    [_btnOutAccNo release];
    [_lblInqueryTrem release];
    [_tableView1 release];
    [_tableFooterView release];

    [_btnSort release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnOutAccNo:nil];
    [self setLblInqueryTrem:nil];
    [self setTableView1:nil];
    [self setTableFooterView:nil];

    [self setBtnSort:nil];
    [super viewDidUnload];
}

@end
