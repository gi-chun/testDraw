//
//  SHBRetirementReserveListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReserveListViewController.h"
#import "SHBRetirementReserveListCell.h"        // cell name
#import "SHBPentionService.h"                   // 퇴직연금 서비스
#import "SHBRetirementConfirmViewController.h"                  // 정보동의 화면
#import "SHBSurchargeReqViewController.h"                       // 입금 view
#import "SHBRetirementReserveDetailViewController.h"            // 다음 view


@interface SHBRetirementReserveListViewController ()

@end

@implementation SHBRetirementReserveListViewController


#pragma mark -
#pragma mark Private Method

- (void)pushNextViewWithDataListIndex:(int)anIndex
{
    SHBRetirementReserveDetailViewController *viewController = [[SHBRetirementReserveDetailViewController alloc] initWithNibName:@"SHBRetirementReserveDetailViewController" bundle:nil];
    viewController.dicDataDictionary = [self.dataList objectAtIndex:anIndex];
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

#pragma mark -
#pragma mark SHBCellActionProtocol

- (void)cellButtonActionisOpen:(int)aRow
{
    if( intSelectedRow == aRow )        // 같은 cell의 경우
    {
        intSelectedRow = -1;
    }
    else                                // 다른 cell의 경우
    {
        intSelectedRow = aRow;
    }
    
    [tableView1 reloadData];
}

- (void)cellButtonAction:(int)aTag
{
    switch (aTag) {
            
        case 21:        // 상세보기
        {
            [self pushNextViewWithDataListIndex:intSelectedRow];
        }
            break;
            
        case 22:        // 입금의 경우
        {
            SHBSurchargeReqViewController *viewController = [[SHBSurchargeReqViewController alloc] initWithNibName:@"SHBSurchargeReqViewController" bundle:nil];
            viewController.dicDataDictionary = [self.dataList objectAtIndex:intSelectedRow];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark PopupView Delegate Protocol

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary*)mDic
{
    
}
- (void)popupViewDidCancel          // 닫기 버튼의 경우
{
    if ( buttonCheck.selected == YES )
    {
        // 오늘 하루 열지 않기 체크된 경우
        //정보를 저장한다.
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"RetirementNoticePopupOffStatus"];
        [[NSUserDefaults standardUserDefaults] setObject:AppInfo.tran_Date forKey:@"RetirementNoticePopupDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 1001:            // 체크 박스
        {
            if ( buttonCheck.selected == YES )
            {
                [buttonCheck setSelected:NO];
            }
            else
            {
                [buttonCheck setSelected:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3946"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            
            self.dataList = [aDataSet arrayWithForKey:@"LIST"];
            [tableView1 reloadData];
            
            BOOL isNeedPopup = NO;
            
            if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"RetirementNoticePopupOffStatus"] isEqualToString:@"Y"] )
            {
                // 체크 된 경우
                NSString *strDate = AppInfo.tran_Date;
                NSString *strSavedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"RetirementNoticePopupDate"];
                
                if ( !([strDate isEqualToString:strSavedDate]) )        // 날짜가 다른 경우
                {
                    isNeedPopup = YES;
                }
            }
            else        // 최초 실행 시
            {
                isNeedPopup = YES;
            }
            
            if (isNeedPopup)
            {
                //팝업뷰 오픈
                SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"안내" subView:viewPopup];
                [popupView setDelegate:self];
                [popupView showInView:self.navigationController.view animated:YES];
                [popupView release];
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(intSelectedRow == indexPath.row)
    {
        return 177;
    }
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBRetirementReserveListCell *cell = (SHBRetirementReserveListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBRetirementReserveListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBRetirementReserveListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // 버튼 델리게이트 설정
    cell.cellButtonActionDelegate = self;
    
    // cell 내용 설정
    NSDictionary    *dicDataDic = [self.dataList objectAtIndex:indexPath.row];
    
    cell.label1.text = dicDataDic[@"플랜명"];
    cell.label2.text = dicDataDic[@"계좌번호"];
    cell.label3.text = dicDataDic[@"계약일"];
    cell.label4.text = dicDataDic[@"제도구분명"];
    cell.label5.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dicDataDic[@"적립금예상수급액"]]];
    cell.row = indexPath.row;
    
    cell.button1.hidden = NO;
    
    // 제도구분코드 1 DB
    // 제도구분코드 2 DC
    // 제도구분코드 3 기업형IRP
    // 제도구분코드 4 개인형IRP
    
//    // DB, IRP의 경우 버튼 안보이게 설정
    // DB의 경우만 상세 버튼이 보이지 않게 수정됨 2013.02.05
    if ( [dicDataDic[@"제도구분코드"] isEqualToString:@"1"] )
    {
        cell.button1.hidden = YES;
    }
    
    cell.selected = NO;
    [cell.button2 setHidden:YES];
    [cell.button3 setHidden:YES];
    
    // 선택된 경우 cell 색상 변경
    if(intSelectedRow == indexPath.row)
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.button1 setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        cell.selected = YES;
        [cell.button2 setHidden:NO];
        [cell.button3 setHidden:NO];
        cell.button1.accessibilityLabel = @"기능펼침";
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
        [cell.button1 setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
        cell.button1.accessibilityLabel = @"기능접기";
    }
    
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    // 선택된 row
    intSelectedRow = indexPath.row;
    
    NSDictionary     *dicDataDic = [self.dataList objectAtIndex:indexPath.row];
    
    // 제도구분코드 1 DB
    // 제도구분코드 2 DC
    // 제도구분코드 3 기업형IRP
    // 제도구분코드 4 개인형IRP
    
    if ( [dicDataDic[@"제도구분코드"] isEqualToString:@"1"] )       // DB의 경우 선택 불가
    {
        intSelectedRow = -1;
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"제도유형 DB는 조회하실수 없는 거래입니다."];
        return;
    }
    
    // DB가 아닌경우 상세view로 이동
    [self pushNextViewWithDataListIndex:indexPath.row];
}


#pragma mark -
#pragma mark Notifications

- (void)listSurchargeComplete
{
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
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
    
    // 퇴직연금의 메뉴 1,2,3,4,5 경우 가입 유무와 동의 확인이 필요하다
    // 메뉴 진입 전 로그인 후에 처리되고 있음(2군데)
    
    // title 설정
    self.title = @"퇴직연금 적립금 조회";
    self.strBackButtonTitle = @"퇴직연금 적립금 조회 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    // 선택된 row 초기 값 설정
    intSelectedRow = -1;
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW765000Q2",
                            @"고객구분" : @"3",
                            @"플랜번호" : @"",
                            @"가입자번호" : @"",
                            @"제도구분" : @"",
                            @"페이지인덱스" : @"1",
                            @"전체조회건수" : @"0",
                            @"페이지패치건수" : @"500",
                            @"예비필드" : @"",
                            //@"주민사업자번호" : AppInfo.ssn
                            //@"주민사업자번호" : [AppInfo getPersonalPK],
                            @"주민사업자번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                            }] autorelease];
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_RESERVE_LIST viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    // 조회화면에서 입금 후 완료 시
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"listSurchargeComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listSurchargeComplete) name:@"listSurchargeComplete" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"listSurchargeComplete" object:nil];
    
    [super dealloc];
}

@end
