//
//  SHBAccountInqueryViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 17.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountInqueryViewController.h"

#import "SHBTransferInfoInputViewController.h"
#import "SHBDepositInfoInputViewController.h"
#import "SHBListPopupView.h"
#import "SHBPeriodPopupView.h"
#import "SHBUtility.h"
#import "SHBPushInfo.h"
#import "SHBAccountTaxPreferenceViewController.h"
#import "SHBAccountELDStandardIndexViewController.h"

#import "SHBSearchView.h"

@interface SHBAccountInqueryViewController ()<SHBListPopupViewDelegate, SHBPopupViewDelegate>
{
    NSString *strServiceCode;
    NSString *strStartDate;
    NSString *strEndDate;
    
    BOOL isShowAccountDetailInfo;
    BOOL isShowBalance;
    
    NSArray *infoList;
    NSArray *infoDetailList;
    
    NSArray *tableDataArray;
    
    int cellHeight;
    int totListCnt;
}
@property (nonatomic, retain) NSString *strServiceCode;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (nonatomic, retain) NSArray *infoList;
@property (nonatomic, retain) NSArray *infoDetailList;
@property (nonatomic, retain) NSArray *tableDataArray;
- (void)SendRequestListData;
- (void)calCellHeight;
- (void)displayAccountInfoView;
- (NSDictionary *)accountInfoSet;

- (void)showSearchView;
//- (void)CloseSearchView;
@end

@implementation SHBAccountInqueryViewController
@synthesize service;
@synthesize accountInfo;
@synthesize strServiceCode;
@synthesize strStartDate;
@synthesize strEndDate;
@synthesize infoList;
@synthesize infoDetailList;
@synthesize tableDataArray;
@synthesize btnWidget;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:   // 이체, 입금
        {
            if([self.accountInfo[@"화면이동2"] isEqualToString:@"이체"])
            {  // 이체화면이동
                SHBTransferInfoInputViewController *nextViewController = [[[SHBTransferInfoInputViewController alloc] initWithNibName:@"SHBTransferInfoInputViewController" bundle:nil] autorelease];
                nextViewController.outAccInfoDic = self.accountInfo;
                nextViewController.needsCert = YES;
                [self checkLoginBeforePushViewController:nextViewController animated:YES];
            }
            else
            {  // 입금화면이동
                if([self.accountInfo[@"계좌정보상세"][@"상품코드"] isEqualToString:@"110004601"])
                {
                    SHBPushInfo *pushInfo = [SHBPushInfo instance];
                    [pushInfo requestOpenURL:@"asset://M7002" Parm:nil];
//                    
//                    
//                    BOOL bRet = NO;
//                    bRet = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"asset://com.shinhan.asset"]];
//                    if (!bRet)
//                    {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/kr/app/id498398058?mt=8"]];
//                    }
                    return;
                }
                
                SHBDepositInfoInputViewController *nextViewController = [[[SHBDepositInfoInputViewController alloc] initWithNibName:@"SHBDepositInfoInputViewController" bundle:nil] autorelease];
                nextViewController.inAccInfoDic = self.accountInfo;
                nextViewController.needsCert = YES;
                [self checkLoginBeforePushViewController:nextViewController animated:YES];
            }
        }
            break;
        case 200:   // 계좌상세
        {
            if(isShowAccountDetailInfo)
            {
                isShowAccountDetailInfo = NO;
                sender.selected = NO;
                sender.accessibilityLabel = @"계좌상세보기";
            }
            else
            {
                isShowAccountDetailInfo = YES;
                sender.selected = YES;
                sender.accessibilityLabel = @"계좌상세닫기";
            }
            [self displayAccountInfoView];
            
            [_tableView1 setContentOffset:CGPointZero animated:YES];
        }
            break;
        case 300:   // 구분(전체, 입급, 출금)
        {
            if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
                UIDevice *curDevice = [UIDevice currentDevice];
                curDevice.proximityMonitoringEnabled = NO;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
            }
            
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
        case 400:   // 1주일, 3개월
        {
            if([sender.titleLabel.text isEqualToString:@"1주일"])
            {
                self.strStartDate = [SHBUtility dateStringToMonth:0 toDay:-7];
            }
            else
            {
                self.strStartDate = [SHBUtility dateStringToMonth:-3 toDay:0];
            }
            self.strEndDate = AppInfo.tran_Date;
            
            _lblData03.text = [NSString stringWithFormat:@"조회기간:%@~%@ (0건)", strStartDate, strEndDate];
            
            [self SendRequestListData];
        }
            break;
        case 401:   // 1개월, 6개월
        {
            if([sender.titleLabel.text isEqualToString:@"1개월"])
            {
                self.strStartDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            }
            else
            {
                self.strStartDate = [SHBUtility dateStringToMonth:-6 toDay:0];
            }
            self.strEndDate = AppInfo.tran_Date;

            _lblData03.text = [NSString stringWithFormat:@"조회기간:%@~%@ (0건)", strStartDate, strEndDate];

            [self SendRequestListData];
        }
            break;
        case 402:   // 기간선택
        {
            if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
                UIDevice *curDevice = [UIDevice currentDevice];
                curDevice.proximityMonitoringEnabled = NO;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
            }
            
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 500:   // 잔액보기
        {
            if(isShowBalance)
            {
                isShowBalance = NO;
                sender.selected = NO;
                sender.accessibilityLabel = @"잔액보기";
            }
            else
            {
                isShowBalance = YES;
                sender.selected = YES;
                sender.accessibilityLabel = @"잔액닫기";
            }
            
            [_tableView1 reloadData];
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
        case 800:   // 세금우대조회
        {
            SHBAccountTaxPreferenceViewController *viewController = [[[SHBAccountTaxPreferenceViewController alloc] initWithNibName:@"SHBAccountTaxPreferenceViewController" bundle:nil] autorelease];
            
            viewController.accountNumber = self.accountInfo[@"계좌정보상세"][@"계좌번호"];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 850:   // ELD 기준지수조회
        {
            SHBAccountELDStandardIndexViewController *viewController = [[[SHBAccountELDStandardIndexViewController alloc] initWithNibName:@"SHBAccountELDStandardIndexViewController" bundle:nil] autorelease];
            
            viewController.accountInfo = self.accountInfo;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 860:   //위젯등록
        {
            
            
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1843 title:@"" message:@"홈 화면에 바로가기 아이콘이 생성됩니다.\n등록 하시겠습니까?"];
            

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
    //위젯처리
    
    if ([self.strServiceCode isEqualToString:@"registerWidget"])
    {
        NSLog(@"aDataSet:%@",aDataSet);
        
        self.strServiceCode = @"";
        //SHBDataSet *tmpSet = self.accountInfo[@"계좌정보상세"];
        NSString *nickName = self.accountInfo[@"계좌명"];
        
        nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        
 
        NSString *argStr = [NSString stringWithFormat:@"screenID=D0011&category=01&nickName=%@&speedIndex=%@", nickName,aDataSet[@"CUS_ACNO"]];
 
#ifdef DEVELOPER_MODE
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"dev-m.shinhan.com", WIDGET_SERVICE_URL,argStr];
#else
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"m.shinhan.com", WIDGET_SERVICE_URL,argStr];
#endif
        
        NSLog(@"aaaa:%@",urlStr);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        return NO;
    }
    
    if(infoDetailList == nil){
        self.infoList = [self.service accountDefaultInfo];
        self.infoDetailList = [self.service accountDetailInfo];
        
        [self displayAccountInfoView];

        // 민트의 경우 최초 한번 전문을 한번 더 보낸다. (1120으로 계좌상세정보를 수신하고 1121로 거래내역을 가져오게 되어 있음)
        if([self.strServiceCode isEqualToString:@"D1121"])
        {
            self.service = nil;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"계좌번호" : self.accountInfo[@"계좌번호"],
                                    @"은행구분" : self.accountInfo[@"은행구분"],
                                    @"정렬구분" : @"3",
                                    }] autorelease];
            
            if([strStartDate isEqualToString:@""])
            {
                [aDataSet setObject:@"1" forKey:@"조회기간구분"];
                [aDataSet setObject:@"10" forKey:@"조회건수"];
            }
            else
            {
                [aDataSet setObject:@"0" forKey:@"조회기간구분"];
                [aDataSet setObject:strStartDate forKey:@"조회시작일"];
                [aDataSet setObject:strEndDate forKey:@"조회종료일"];
            }
            self.service.requestData = aDataSet;
            [self.service start];
            
            return NO;
        }
    }
    
    
    if ([self.strServiceCode isEqualToString:@"D1125"])
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.infoList];
        NSMutableArray *array2 = [NSMutableArray arrayWithArray:self.infoDetailList];
        
        [array addObject:@{@"Name" : @"기준지수", @"Value" : @""}];
        [array2 addObject:@{@"Name" : @"기준지수", @"Value" : @""}];
        
        self.infoList = (NSArray *)array;
        self.infoDetailList = (NSArray *)array2;
        
        [self displayAccountInfoView];
    }
    
    _btnSort.selected = NO;

    self.tableDataArray = [self.service accountInqueryListInfo];
    
    if(![_btnDealType.titleLabel.text isEqualToString:@"전체"])
    {
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in tableDataArray) {
            if ([dic[@"구분"] isEqualToString:_btnDealType.titleLabel.text]) {
                [array addObject:dic];
            }
        }
        
        self.tableDataArray = (NSArray *)array;
    }
    
    totListCnt = [self.tableDataArray count];
//
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
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    
    self.strStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.strEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    _lblData03.text = [NSString stringWithFormat:@"조회기간:%@~%@ (0건)", strStartDate, strEndDate];
    
    [self SendRequestListData];
}

- (void)popupViewDidCancel
{
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    
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
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)SendRequestListData
{
    self.infoDetailList = nil;
    self.dataList = nil;
    [_tableView1 setTableFooterView:nil];
    [_tableView1 reloadData];
    
    if([self.strServiceCode isEqualToString:@"D1121"] || [self.strServiceCode isEqualToString:@"D1125"])
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D1120" viewController:self] autorelease];
    }
    else
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
    }
    
    self.service.accountInfoDic = self.accountInfo[@"계좌정보상세"];
    
    // 조회는 무조건 신계좌 번호로 그러므로 은행구분은 항상 1
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"계좌번호" : self.accountInfo[@"계좌정보상세"][@"계좌번호"],
                            @"은행구분" : @"1",         //self.accountInfo[@"은행구분"]
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
    if(isShowBalance){
        return cellHeight + 25;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        float positionY = 8.0f;
        // 거래일자
        UILabel *cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 301.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(133, 87, 35);
        cellLabel.tag = 9001;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        positionY = positionY + 19.0f + 6.0f;
        
        switch ([[self.strServiceCode substringFromIndex:1] intValue]) {
            case 1110:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, 8.0f, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9003;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9004;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
            case 1120:
            case 1125:
            case 1150:
            case 1160:
            case 1180:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(114, 114, 114);
                cellLabel.text = @"적요";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9003;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9004;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
            case 1121:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
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
                cellLabel.text = @"세전지급이자";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9004;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.text = @"적용이율";
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
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
            case 1130:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(209.0f, 8.0f, 35.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(114, 114, 114);
                cellLabel.text = @"";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(239.0f, 8.0f, 70.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
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
                
                positionY = positionY + 19.0f + 6.0f;
                
                if ([self.accountInfo[@"계좌정보상세"][@"과목명"]  rangeOfString:@"신한 월복리 적금"].location != NSNotFound ||
                    [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"S-MORE SHOW적금"].location != NSNotFound ||
                    [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"생활의 지혜 적금"].location != NSNotFound ||
                    [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"Mint(민트) 적금"].location != NSNotFound ||
                    [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"MINT(민트) 적금"].location != NSNotFound ||
                    [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"신한 저축습관만들기"].location != NSNotFound)
                {
                    cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                    cellLabel.backgroundColor = [UIColor clearColor];
                    cellLabel.textColor = RGB(44, 44, 44);
                    cellLabel.text = @"회차별우대금리";
                    cellLabel.font = [UIFont systemFontOfSize:15];
                    cellLabel.textAlignment = UITextAlignmentLeft;
                    [cell.contentView addSubview:cellLabel];
                    
                    cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                    cellLabel.backgroundColor = [UIColor clearColor];
                    cellLabel.textColor = RGB(44, 44, 44);
                    cellLabel.tag = 9006;
                    cellLabel.font = [UIFont systemFontOfSize:15];
                    cellLabel.textAlignment = UITextAlignmentRight;
                    [cell.contentView addSubview:cellLabel];
                    
                    positionY = positionY + 19.0f + 6.0f;
                }
            }
                break;
            case 1140:
            case 1143:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.text = @"거래구분";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.text = @"거래금액";
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
                cellLabel.textColor = RGB(114, 114, 114);
                cellLabel.text = @"내용";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9004;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
            case 1185:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(114, 114, 114);
                cellLabel.text = @"적요";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
                positionY = positionY + 19.0f + 6.0f;

                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
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
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
            default:
            {
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(209.0f, 8.0f, 35.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(114, 114, 114);
                cellLabel.text = @"";
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
                
                cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(239.0f, 8.0f, 70.0f, 19.0f)] autorelease];
                cellLabel.backgroundColor = [UIColor clearColor];
                cellLabel.textColor = RGB(44, 44, 44);
                cellLabel.tag = 9002;
                cellLabel.font = [UIFont systemFontOfSize:15];
                cellLabel.textAlignment = UITextAlignmentRight;
                [cell.contentView addSubview:cellLabel];
                
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
                
                positionY = positionY + 19.0f + 6.0f;
            }
                break;
        }
        
        // 잔액
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 200.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.text = [self.strServiceCode isEqualToString:@"D1121"] ? @"거래후잔액" : @"잔액";
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:cellLabel];
        
        cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(109.0f, positionY, 200.0f, 19.0f)] autorelease];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = RGB(44, 44, 44);
        cellLabel.tag = 9010;
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:cellLabel];
        
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    ((UILabel *)[cell.contentView viewWithTag:9001]).text = dictionary[@"거래일자"];
    
    switch ([[self.strServiceCode substringFromIndex:1] intValue]) {
        case 1110:
        {
            ((UILabel *)[cell.contentView viewWithTag:9001]).text = [NSString stringWithFormat:@"%@ %@", dictionary[@"거래일자"], dictionary[@"적요"]];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"내용"];
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"구분"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];
            
            ((UILabel *)[cell.contentView viewWithTag:9002]).font = [UIFont boldSystemFontOfSize:15];
            ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
            
            if([dictionary[@"구분"] isEqualToString:@"입금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9002]).textColor = RGB(209, 75, 75);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
            }
            else if([dictionary[@"구분"] isEqualToString:@"출금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9002]).textColor = RGB(0, 137, 220);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(0, 137, 220);
            }
        }
            break;
        case 1120:
            
            //NSLog(@"%@", dictionary);
            
            
            
            if([dictionary[@"구분"] isEqualToString:@"입금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).font = [UIFont boldSystemFontOfSize:15];
                ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
                
                
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(209, 75, 75);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
                
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"구분"];
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];
                
            }
            else if([dictionary[@"구분"] isEqualToString:@"출금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).font = [UIFont boldSystemFontOfSize:15];
                ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
                
                
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(0, 137, 220);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(0, 137, 220);
                
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"구분"];
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];
            }
            else
            {
                
                //((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(209, 75, 75);
                //((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
            
            
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = @"지급이자";
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"세후이자"];
            }

            
            
            break;
            
        case 1125:
            //NSLog(@"%@", dictionary);
            
            
            
            if([dictionary[@"구분"] isEqualToString:@"입금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).font = [UIFont boldSystemFontOfSize:15];
                ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
                
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(209, 75, 75);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
                
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"구분"];
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];
                
            }
            else if([dictionary[@"구분"] isEqualToString:@"출금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).font = [UIFont boldSystemFontOfSize:15];
                ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
                
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(0, 137, 220);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(0, 137, 220);
                
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"구분"];
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];
            }
            else
            {
                
                //((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(209, 75, 75);
                //((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
                
                
                ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
                ((UILabel *)[cell.contentView viewWithTag:9003]).text = @"지급이자";
                ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"세후이자"];
            }

        case 1150:
        case 1160:
        case 1180:
        {
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"구분"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"금액"];

            ((UILabel *)[cell.contentView viewWithTag:9003]).font = [UIFont boldSystemFontOfSize:15];
            ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
            
            if([dictionary[@"구분"] isEqualToString:@"입금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(209, 75, 75);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(209, 75, 75);
            }
            else if([dictionary[@"구분"] isEqualToString:@"출금"])
            {
                ((UILabel *)[cell.contentView viewWithTag:9003]).textColor = RGB(0, 137, 220);
                ((UILabel *)[cell.contentView viewWithTag:9004]).textColor = RGB(0, 137, 220);
            }
        }
            break;
        case 1121:
        {
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"회차"];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"거래금액"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"세전지급이자"];
            ((UILabel *)[cell.contentView viewWithTag:9005]).text = dictionary[@"적용이율"];
        }
            break;
        case 1130:
        {
            NSLog(@"%@", dictionary);
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"내용"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"구분"];
            ((UILabel *)[cell.contentView viewWithTag:9005]).text = dictionary[@"금액"];
            
            ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
            ((UILabel *)[cell.contentView viewWithTag:9005]).font = [UIFont boldSystemFontOfSize:15];
            
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
            
            if ([self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"신한 월복리 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"S-MORE SHOW적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"생활의 지혜 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"Mint(민트) 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"MINT(민트) 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"신한 저축습관만들기"].location != NSNotFound)
            {
                ((UILabel *)[cell.contentView viewWithTag:9006]).text = dictionary[@"회차별우대금리"];
            }
        }
            break;
        case 1140:
        case 1143:
        {
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"거래구분"];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"거래금액"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"내용"];
        }
            break;
        default:
        {
            ((UILabel *)[cell.contentView viewWithTag:9002]).text = dictionary[@"적요"];
            ((UILabel *)[cell.contentView viewWithTag:9003]).text = dictionary[@"내용"];
            ((UILabel *)[cell.contentView viewWithTag:9004]).text = dictionary[@"구분"];
            ((UILabel *)[cell.contentView viewWithTag:9005]).text = dictionary[@"금액"];
            
            ((UILabel *)[cell.contentView viewWithTag:9004]).font = [UIFont boldSystemFontOfSize:15];
            ((UILabel *)[cell.contentView viewWithTag:9005]).font = [UIFont boldSystemFontOfSize:15];
            
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
        }
            break;
    }
    
    ((UILabel *)[cell.contentView viewWithTag:9010]).text = dictionary[@"잔액"];
    
    return cell;
}

- (void)calCellHeight
{
    switch ([[self.strServiceCode substringFromIndex:1] intValue]) {
        case 1110:
        {
            cellHeight = 10 + 25 * 2;
        }
            break;
        case 1121:
        case 1140:
        case 1143:
        case 1185:
        {
            cellHeight = 10 + 25 * 4;
        }
            break;
        case 1130:
        {
            cellHeight = 10 + 25 * 3;
            
            if ([self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"신한 월복리 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"S-MORE SHOW적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"생활의 지혜 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"Mint(민트) 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"MINT(민트) 적금"].location != NSNotFound ||
                [self.accountInfo[@"계좌정보상세"][@"과목명"] rangeOfString:@"신한 저축습관만들기"].location != NSNotFound)
            {
                cellHeight = 10 + 25 * 4;
            }
        }
            break;
        default:
        {
            cellHeight = 10 + 25 * 3;
        }
            break;
    }
}

- (void)displayAccountInfoView
{
    [[_accoutInfoView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect viewRect = CGRectMake(0.0f, 0.0f, 317.0f, 0.0f);
    int row = isShowAccountDetailInfo ? [infoDetailList count] : [infoList count];
    
    if(row == 0) return;
    
    NSArray *info;
    
    if(isShowAccountDetailInfo)
    {
        viewRect.size.height = 8.0f + (19.0f * row) + (6.0f * row);
        info = infoDetailList;
    }
    else
    {
        viewRect.size.height = 8.0f + (19.0f * row) + (6.0f * (row - 1));
        info = infoList;
    }
    
    _accoutInfoView.frame = viewRect;
    
    
    _tableHeaderView.frame = CGRectMake(0.0f, 0.0f, 317.0f, viewRect.size.height + _termSelectView.frame.size.height);
    
    
    
    int positionY = 8;
    
    for(NSDictionary *dic in info)
    {
        UILabel *lblName = [[[UILabel alloc] initWithFrame:CGRectMake(8.0f, positionY, 260.0f, 19.0f)] autorelease];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.text = dic[@"Name"];
        lblName.textColor = RGB(74, 74, 74);
        lblName.font = [UIFont systemFontOfSize:15];
        lblName.textAlignment = UITextAlignmentLeft;
        
        UILabel *lblValue = [[[UILabel alloc] initWithFrame:CGRectMake(159.0f, positionY, 150.0f, 19.0f)] autorelease];
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.text = dic[@"Value"];
        if([dic[@"Name"] isEqualToString:@"출금가능잔액"])
        {
            lblValue.textColor = RGB(209, 75, 75);
            lblName.textColor = RGB(209, 75, 75);
        }
        else
        {
            lblValue.textColor = RGB(44, 44, 44);
        }
        lblValue.font = [UIFont systemFontOfSize:15];
        lblValue.textAlignment = UITextAlignmentRight;
        
        // 기준지수의 경우 기준지수조회 버튼 생성
        if ([self.strServiceCode isEqualToString:@"D1125"] && [dic[@"Name"] isEqualToString:@"기준지수"])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:CGRectMake(224.0f, positionY - 2.0f, 85.0f, 25.0f)];
            [button setBackgroundImage:[[UIImage imageNamed:@"btn_standard.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                              forState:UIControlStateNormal];
            [button setAdjustsImageWhenHighlighted:YES];
            [button setTag:850];
            
            [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            [_accoutInfoView addSubview:button];
        }
        
      //  NSLog(@" DIC %@",dic[@"Name"]);
      //  NSLog(@" DIC %@",dic[@"Value"]);
        
        // D1120인 경우 일반과세가 아닌경우 세금우대조회 버튼
        // D1120외는 세금우대, 비과세인 경우 세금우대조회 버튼
//        if ([dic[@"Name"] isEqualToString:@"과세적용방식"] &&
//            ([dic[@"Value"] isEqualToString:@"세금우대"] || [dic[@"Value"] isEqualToString:@"비과세"]))
//        {

         if (
             ([dic[@"Name"] isEqualToString:@"과세적용방식"] &&
             ![dic[@"Value"] isEqualToString:@"일반과세"] &&
             ([self.accountInfo[@"서비스코드"] isEqualToString:@"D1120"] ||
             [self.accountInfo[@"서비스코드"] isEqualToString:@"D1121"] ||
             [self.accountInfo[@"서비스코드"] isEqualToString:@"D1125"] )) ||
             ([dic[@"Name"] isEqualToString:@"과세적용방식"] &&
             ([dic[@"Value"] isEqualToString:@"세금우대"] || [dic[@"Value"] isEqualToString:@"비과세"]))
             )
         
        {

           
            CGSize size = [lblName.text sizeWithFont:lblName.font
                                   constrainedToSize:CGSizeMake(260.0f, 19.0f)
                                       lineBreakMode:lblName.lineBreakMode];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:CGRectMake(7.0f + size.width + 5.0f, positionY - 2.0f, 85.0f, 25.0f)];
            [button setBackgroundImage:[[UIImage imageNamed:@"btn_tax.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                              forState:UIControlStateNormal];
            [button setAdjustsImageWhenHighlighted:YES];
            [button setTag:800];
            
            [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            [_accoutInfoView addSubview:button];
        }
        
        if ([dic[@"Name"] isEqualToString:@"특기사항"] && (![dic[@"Value"] isEqualToString:@"연금신탁"] ))
        {
             lblValue.text = @"";
        }
        
       if ([dic[@"Name"] isEqualToString:@"특기사항"] && ([dic[@"Value"] isEqualToString:@"연금신탁"] ))
       {
           
           CGSize size = [lblName.text sizeWithFont:lblName.font
                                  constrainedToSize:CGSizeMake(260.0f, 19.0f)
                                      lineBreakMode:lblName.lineBreakMode];
           
           UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
           
           [button setFrame:CGRectMake(7.0f + size.width + 5.0f, positionY - 2.0f, 85.0f, 25.0f)];
           [button setBackgroundImage:[[UIImage imageNamed:@"btn_tax.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                             forState:UIControlStateNormal];
           [button setAdjustsImageWhenHighlighted:YES];
           [button setTag:800];
           
           [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
           
           lblValue.text = @"";
           
           [_accoutInfoView addSubview:button];
         
       }
        
        
      
        [_accoutInfoView addSubview:lblName];
        [_accoutInfoView addSubview:lblValue];
        
        positionY = positionY + 19.0f + 6.0f;
    }
    
    [_tableView1 setTableHeaderView:_tableHeaderView];

}

- (NSDictionary *)accountInfoSet
{
	Debug(@"%@", self.data);
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                    @"계좌명" : ([self.data[@"상품부기명"] length] > 0) ? self.data[@"상품부기명"] : self.data[@"과목명"],
                                    @"계좌번호" : ([self.data[@"신계좌변환여부"] isEqualToString:@"1"]) ? self.data[@"계좌번호"] : self.data[@"구계좌번호"],
                                    @"잔액" : [NSString stringWithFormat:@"%@원", self.data[@"잔액"]],
                                    @"수익률" : @"",
                                    @"은행구분" : ([self.data[@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : (self.data[@"은행코드"] != nil ? self.data[@"은행코드"] : self.data[@"은행구분"]),
                                    @"계좌정보상세" : self.data
                                    }];
    
    NSString *accountNumber = [self.data[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    int accountCode = 999;
    
    if (accountNumber != nil)
    {
        accountCode = [[accountNumber substringWithRange:NSMakeRange(0, 3)] intValue];
    }
    
    infoDic[@"거래구분"] = @"0";
    
    if((accountCode >= 100 && accountCode <= 149) || accountCode == 164)		//요구불
    {
        infoDic[@"서비스코드"] = @"D1110";
        infoDic[@"거래구분"] = @"1";
    }
    else if(accountCode >= 150 && accountCode <= 159)	//당좌
    {
        infoDic[@"서비스코드"] = @"D1170";
    }
    else if(accountCode >= 200 && accountCode <= 208)	//고정성 - 정기예금
    {
        if ([infoDic[@"계좌명"] hasPrefix:@"Mint(민트) 정기예금" ])
        {
            infoDic[@"서비스코드"] = @"D1121";
        }
        else
        {
            infoDic[@"서비스코드"] = @"D1120";
        }
    }
    else if(accountCode == 209)	//세이프지수연동예금
    {
        infoDic[@"서비스코드"] = @"D1125";
    }
    else if(accountCode >= 210 && accountCode <= 214)	//고정성 - 양도성예금, 표지어음 환매체
    {
        infoDic[@"서비스코드"] = @"D1150";
    }
    else if(accountCode >= 215 && accountCode <= 216)	//고정성 - 국공채, 금융체
    {
        infoDic[@"서비스코드"] = @"D1160";
    }
    else if(accountCode == 220)	//고정성 - 주택청약부금
    {
        infoDic[@"서비스코드"] = @"D1180";
    }
    else if(accountCode == 221 || accountCode == 223)	//고정성 - 정기적립식
    {
        infoDic[@"서비스코드"] = @"D1185";
    }
    else if(accountCode >= 230 && accountCode <= 240)	//CMA계좌
    {
        infoDic[@"서비스코드"] = @"D1130";
    }
    else if(accountCode >= 260 && accountCode <= 299)	//신탁
    {
        if(accountCode >= 291 && accountCode <= 293)	//재정신탁
        {
            infoDic[@"서비스코드"] = @"D1143";
        }
        else
        {
            infoDic[@"서비스코드"] = @"D1140";
        }
    }
    else
    {
        infoDic[@"서비스코드"] = @"";
    }
    
    // 조회기간 버튼 설정
    if([infoDic[@"서비스코드"] isEqualToString:@"D1110"] || [infoDic[@"서비스코드"] isEqualToString:@"D1170"])
    {
        infoDic[@"조회기간1"] = @"1주일";
        infoDic[@"조회기간2"] = @"1개월";
    }
    else
    {
        infoDic[@"조회기간1"] = @"3개월";
        infoDic[@"조회기간2"] = @"6개월";
    }
    
    if([self.data[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [self.data[@"계좌번호"] characterAtIndex:0] == '1')
    {
        infoDic[@"화면이동1"] = @"조회";
        infoDic[@"화면이동2"] = @"이체";
        infoDic[@"화면이동3"] = @"이체결과조회";
    }
    else if([self.data[@"예금종류"] characterAtIndex:0] != '1' && [self.data[@"입금가능여부"] isEqualToString:@"1"] )
    {
        if (accountCode == 299)
        {
            infoDic[@"화면이동1"] = @"조회";
            infoDic[@"화면이동2"] = @"입금";
            infoDic[@"화면이동3"] = @"출금";
            
            if(!([infoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁"] ||
                 [infoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁(개인용)"] ||
                 [infoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁-법인용(5등급)"] ||
                 [infoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁-개인용(5등급)"]))
            {
                infoDic[@"화면이동3"] = @"";
            }
            
            if(!([self.data[@"예금종류"] isEqualToString:@"3"] && [self.data[@"입금가능여부"] isEqualToString:@"1"]))
            {
                infoDic[@"화면이동2"] = @"출금";
                infoDic[@"화면이동3"] = @"";
            }
        }
        else if (accountCode == 260 || accountCode == 289 || (accountCode >= 291 && accountCode <= 294))
        {
            infoDic[@"화면이동1"] = @"";
            infoDic[@"화면이동2"] = @"";
            infoDic[@"화면이동3"] = @"";
        }
        else
        {
            infoDic[@"화면이동1"] = @"조회";
            infoDic[@"화면이동2"] = @"입금";
            infoDic[@"화면이동3"] = @"";
        }
    }
    else if([self.data[@"상품코드"] isEqualToString:@"110004601"])
    {
        infoDic[@"화면이동1"] = @"조회";
        infoDic[@"화면이동2"] = @"입금";
        infoDic[@"화면이동3"] = @"";
    }
    else
    {
        infoDic[@"화면이동1"] = @"";
        infoDic[@"화면이동2"] = @"";
        infoDic[@"화면이동3"] = @"";
    }
    
    return (NSDictionary *)infoDic;
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
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [_tableView1 setFrame:CGRectMake(_tableView1.frame.origin.x, _tableView1.frame.origin.y, _tableView1.frame.size.width, _tableView1.frame.size.height - 20)];
//    }
    
    self.title = @"계좌조회";
    self.strBackButtonTitle = @"계좌조회 상세";
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.strStartDate = @"";
    self.strEndDate = @"";

    isShowAccountDetailInfo = NO;
    isShowBalance = NO;
    
    if(accountInfo == nil)
    {
		NSDictionary *dicSettingData = AppInfo.commonDic;
		
		//for (NSDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
        for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
		{
			NSString *strAccountNo = ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"];
			if ([dicSettingData[@"2"]isEqualToString:strAccountNo]) {
				self.data = dic;
				
				break;
			}
		}
		
		if (self.data) {
			self.accountInfo = [[self accountInfoSet] retain];
		}
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"간편조회로 등록된 계좌가 없습니다."
//                                                           delegate:self
//                                                  cancelButtonTitle:@"확인"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//
//            [self.navigationController fadePopViewController];
//            
//            return;
//        }
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_0)
    {
        UIButton *tmpBtn = (UIButton*)[self.view viewWithTag:860];
        tmpBtn.hidden = YES;
    }
    _lblData02.text = self.accountInfo[@"계좌번호"];
    _lblData03.hidden = YES;

    self.btnShowDetail.accessibilityLabel = [NSString stringWithFormat:@"%@ 계좌 상세보기",_lblData02.text];
    self.strServiceCode = self.accountInfo[@"서비스코드"];

    // 테이블셀의 높이를 구한다.
    [self calCellHeight];
    
    // 조회기간 버튼 설정
    UIButton *btn = (UIButton *)[self.view viewWithTag:400];
    [btn setTitle:self.accountInfo[@"조회기간1"] forState:UIControlStateNormal];
    btn = (UIButton *)[self.view viewWithTag:401];
    [btn setTitle:self.accountInfo[@"조회기간2"] forState:UIControlStateNormal];
    
    // 잔액보기 버튼은 감추고 잔액은 표시해 준다.
    if([self.strServiceCode isEqualToString:@"D1120"] || [self.strServiceCode isEqualToString:@"D1121"] || [self.strServiceCode isEqualToString:@"D1125"] || [self.strServiceCode isEqualToString:@"D1143"])
    {
        _btnShowDetail.hidden = YES;
        isShowBalance = YES;
    }

    if([self.accountInfo[@"거래구분"] intValue] == 0)
    {
        _btnDealType.hidden = YES;
        _btnBalance.hidden = YES;
        isShowBalance = YES;
    }
    else
    {
        _btnDealType.hidden = NO;
        _btnBalance.hidden = NO;
    }
    
    if([self.accountInfo[@"화면이동2"] isEqualToString:@""])
    {
        _btnTransfer.hidden = YES;
        [self.btnWidget setFrame:CGRectMake(_btnTransfer.frame.origin.x, self.btnWidget.frame.origin.y, self.btnWidget.frame.size.width, self.btnWidget.frame.size.height)];
        //_lblTitle.frame = CGRectMake(8, 8, 301, 19);
        _lblTitle.frame = CGRectMake(8, 8, 224, 19);
    }
    else if([self.accountInfo[@"화면이동2"] isEqualToString:@"출금"])
    {
        _btnTransfer.hidden = YES;
        [self.btnWidget setFrame:CGRectMake(_btnTransfer.frame.origin.x, self.btnWidget.frame.origin.y, self.btnWidget.frame.size.width, self.btnWidget.frame.size.height)];
        //_lblTitle.frame = CGRectMake(8, 8, 301, 19);
        _lblTitle.frame = CGRectMake(8, 8, 224, 19);
    }
    else
    {
        [_btnTransfer setTitle:self.accountInfo[@"화면이동2"] forState:UIControlStateNormal];
        _btnTransfer.hidden = NO;
        
        // 한달애통장의 경우 전체계좌에서 접근 시 입금 버튼이 없어야 한다
        if([self.accountInfo[@"계좌정보상세"][@"상품코드"] isEqualToString:@"110004601"]
           && [self.accountInfo[@"계좌정보상세"][@"전체계좌한달애통장"] isEqualToString:@"1"])   // 전체 계좌에서 온 경우
        {
            _btnTransfer.hidden = YES;
            [self.btnWidget setFrame:CGRectMake(_btnTransfer.frame.origin.x, self.btnWidget.frame.origin.y, self.btnWidget.frame.size.width, self.btnWidget.frame.size.height)];
            //_lblTitle.frame = CGRectMake(8, 8, 301, 19);
            _lblTitle.frame = CGRectMake(8, 8, 224, 19);
        }
    }
    
    [_lblTitle initFrame:_lblTitle.frame];
    [_lblTitle setCaptionText:self.accountInfo[@"계좌명"]];
    
    if([self.strServiceCode isEqualToString:@"D1121"] || [self.strServiceCode isEqualToString:@"D1125"])
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D1120" viewController:self] autorelease];
    }
    else
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:self.strServiceCode viewController:self] autorelease];
    }
    self.service.accountInfoDic = self.accountInfo[@"계좌정보상세"];
    self.infoList = [self.service initAccountInfo];

//    2013.01.16 정상교과장의 요청으로 계좌번호는 신계좌번호로, 은행구분은 1로 변경
//    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
//                            @{
//                            @"계좌번호" : self.accountInfo[@"계좌번호"],
//                            @"은행구분" : self.accountInfo[@"은행구분"],
//                            @"정렬구분" : @"1",
//                            @"조회기간구분" : @"1",
//                            @"조회건수" : @"10",
//                            }] autorelease];

    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"계좌번호" : self.accountInfo[@"계좌정보상세"][@"계좌번호"],
                             @"은행구분" : @"1",
                             @"정렬구분" : @"1",
                             @"조회기간구분" : @"1",
                             @"조회건수" : @"10",
                             }] autorelease];
    
    
    self.service.requestData = aDataSet;
    [self.service start];
    
    // 계좌정보 표시
    [self displayAccountInfoView];
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
    [btnWidget release];
    [strServiceCode release];
    [infoList release];
    [infoDetailList release];
    
    [_btnTransfer release];
    [_tableView1 release];
    [_accoutInfoView release];
    [_termSelectView release];
    [_lblData02 release];
    [_lblData03 release];
    [_tableHeaderView release];
    [_btnSort release];
    [_btnDealType release];
    [_btnBalance release];
    [_btnShowDetail release];
    [_lblTitle release];

    [_lblNoData release];
    [_tableFooterView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setBtnTransfer:nil];
    [self setTableView1:nil];
    [self setAccoutInfoView:nil];
    [self setTermSelectView:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setTableHeaderView:nil];
    [self setBtnSort:nil];
    [self setBtnDealType:nil];
    [self setBtnBalance:nil];
    [self setBtnShowDetail:nil];
    [self setLblTitle:nil];

    [self setLblNoData:nil];
    [self setTableFooterView:nil];
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

//- (void)CloseSearchView
//{
//    UIDevice *curDevice = [UIDevice currentDevice];
//    curDevice.proximityMonitoringEnabled = YES;
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 1843 && buttonIndex == 0)
    {
        //위젯전문을 날린다.
        self.strServiceCode = @"registerWidget";
        self.service = nil;
        NSLog(@"data:%@",self.accountInfo[@"계좌정보상세"]);
        SHBDataSet *accSet = self.accountInfo[@"계좌정보상세"];
        NSString *accNO = ([[accSet objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [accSet objectForKey:@"계좌번호->originalValue"] : [accSet objectForKey:@"구계좌번호->originalValue"];
        NSLog(@"abcd:%@",accNO);
        self.service = [[[SHBAccountService alloc] initWithServiceId:ECHE_WIDGET_ITEM viewController:self] autorelease];
        self.service.previousData = [SHBDataSet dictionaryWithDictionary:@{
                                                                           @"KEY" : accNO,
                                                                           //@"DATE" : self.data[@"updt"],
                                                                           }];
        [self.service start];
    }
}
@end
