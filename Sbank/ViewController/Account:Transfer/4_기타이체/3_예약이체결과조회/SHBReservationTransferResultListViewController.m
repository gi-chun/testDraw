//
//  SHBReservationTransferResultListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservationTransferResultListViewController.h"
#import "SHBReservResultCell.h"
#import "SHBPeriodPopupView.h"
#import "SHBAccountService.h"
#import "SHBUtility.h"

@interface SHBReservationTransferResultListViewController ()<SHBPopupViewDelegate>
{
    NSString *strStartDate;
    NSString *strEndDate;
}
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
- (void)sendTransResultRequest;
@end

@implementation SHBReservationTransferResultListViewController
@synthesize strStartDate;
@synthesize strEndDate;

- (IBAction)buttonTouchupInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:   // 조회기간 : 1주일
        {
            self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];
            self.strEndDate = AppInfo.tran_Date;
            
            [self sendTransResultRequest];
        }
            break;
        case 101:   // 조회기간 : 1개월
        {
            self.strStartDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            self.strEndDate = AppInfo.tran_Date;
            
            [self sendTransResultRequest];
        }
            break;
        case 102:   // 조회기간 : 기간선택
        {
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 200:   // 정렬
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
            NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"이체신청일자" ascending:!sender.isSelected];
            
            [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
            [sortOrder release];
            
            self.dataList = (NSArray *)tempArray;
            
            [_tableView1 reloadData];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    _btnSort.selected = NO;
    self.dataList = [aDataSet arrayWithForKey:@"이체내역"];
    [_tableView1 reloadData];
    
    self.service = nil;
    
    _lblInqueryTrem.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (%d건)", self.strStartDate, self.strEndDate, [self.dataList count]];
    
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
    return 185;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBReservResultCell *cell = (SHBReservResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBReservResultCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBReservResultCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    NSString *strDate = @"";
    
    if([dictionary[@"결과코드"] isEqualToString:@"정상"])
    {
        strDate = dictionary[@"이체일자"];
    }
    cell.lblData01.text = dictionary[@"출금계좌번호"];
    cell.lblData02.text = [AppInfo.codeList bankNameFromCode:dictionary[@"입금은행코드"]];
    if([cell.lblData02.text isEqualToString:@"한미은행"])
    {
        cell.lblData02.text = @"씨티은행";
    }
    cell.lblData03.text = dictionary[@"입금계좌번호"];
    cell.lblData04.text = dictionary[@"입금계좌성명"];
    cell.lblData05.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
    cell.lblData06.text = [NSString stringWithFormat:@"%@원", dictionary[@"수수료"]];

    if(![dictionary[@"결과코드"] isEqualToString:@"정상"] && ![dictionary[@"결과코드"] isEqualToString:@""])
    {
        cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[오류]"];
        cell.lblData07.textColor = RGB(0, 137, 220);
        cell.lblData08.textColor = RGB(0, 137, 220);
    }
    
    switch ([dictionary[@"처리상태"] intValue]) {
        case 0:
        {
            cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[미처리]"];
            cell.lblData07.textColor = RGB(209, 75, 75);
            cell.lblData08.textColor = RGB(209, 75, 75);
        }
            break;
        case 1:
        {
            cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[처리중]"];
            cell.lblData07.textColor = RGB(209, 75, 75);
            cell.lblData08.textColor = RGB(209, 75, 75);
        }
            break;
        case 2:
        {
            cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[완료]"];
            cell.lblData07.textColor = RGB(74, 74, 74);
            cell.lblData08.textColor = RGB(74, 74, 74);
        }
            break;
        case 4:
        {
            cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[불능]"];
            cell.lblData07.textColor = RGB(0, 137, 220);
            cell.lblData08.textColor = RGB(0, 137, 220);
        }
            break;
        case 9:
        {
            cell.lblData07.text = [NSString stringWithFormat:@"%@ %@", strDate, @"[취소]"];
            cell.lblData07.textColor = RGB(0, 137, 220);
            cell.lblData08.textColor = RGB(0, 137, 220);
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)sendTransResultRequest
{
    self.dataList = nil;
    [_tableView1 reloadData];
    
    _lblInqueryTrem.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (0건)", self.strStartDate, self.strEndDate];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2113" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                 @"조회시작일" : self.strStartDate,
                                 @"조회종료일" : self.strEndDate,
                                 @"조회결과순서" : @"1",
                                 }] autorelease];
    [self.service start];
}

#pragma mark - SHBPeriodPopupView
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
    
    [self sendTransResultRequest];
}

- (void)popupViewDidCancel
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
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

    self.title = @"기타이체";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];
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
    [_lblInqueryTrem release];
    [_tableView1 release];
    
    [_btnSort release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblInqueryTrem:nil];
    [self setTableView1:nil];
    
    [self setBtnSort:nil];
    [super viewDidUnload];
}
@end
