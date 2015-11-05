//
//  SHBSurchargeListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSurchargeListViewController.h"
#import "SHBSurchargeListCell.h"                // tableView Cell
#import "SHBPentionService.h"                   // 퇴직연금 서비스
#import "SHBSurchargeReqViewController.h"       // 다음 view



@interface SHBSurchargeListViewController ()

@end

@implementation SHBSurchargeListViewController


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
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3925"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            if ( [aDataSet[@"반복회수"] isEqualToString:@"0"] )
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"신한은행 퇴직연금 가입자 전용 메뉴입니다. 가입 후 이용해 주시기 바랍니다."];
                
                [self.navigationController fadePopViewController];
                return NO;
            }
            
            self.dataList = [aDataSet arrayWithForKey:@"LIST"];     // 받아온 list 전체
            
            for (NSDictionary *dic in self.dataList)
            {
                // 제도구분코드 1 DB
                // 제도구분코드 2 DC
                // 제도구분코드 3 기업형IRP
                // 제도구분코드 4 개인형IRP
                
                // DC와 기업IRP 계좌목록만 출력되어야함 // 개인형 IRP 추가 2013.02.05
                if ( [dic[@"제도구분"] isEqualToString:@"2"] || [dic[@"제도구분"] isEqualToString:@"3"] || [dic[@"제도구분"] isEqualToString:@"4"] )
                {
                    [arrayDataArray addObject:dic];          // 실제 표시될 데이터
                }
            }
            
            // 입금가능한 상품이 없을 경우 추가
            if ([arrayDataArray count] == 0)
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:99 title:@"" message:@"입금가능한 상품이 없습니다."];
                return NO;
            }
            
            [tableView1 reloadData];
            
            BOOL isNeedPopup = NO;
            
            if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"RetirementSurchargePopupOffStatus"] isEqualToString:@"Y"] )
            {
                // 체크 된 경우
                NSString *strDate = AppInfo.tran_Date;
                NSString *strSavedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"RetirementSurchargePopupDate"];
                
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
                SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"가입자 부담금이란?" subView:viewPopup];
                [popupView setDelegate:self];
                [popupView showInView:self.navigationController.view animated:YES];
                [popupView release];
            }
        }
    }
    
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
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
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"RetirementSurchargePopupOffStatus"];
        [[NSUserDefaults standardUserDefaults] setObject:AppInfo.tran_Date forKey:@"RetirementSurchargePopupDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBSurchargeListCell *cell = (SHBSurchargeListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBSurchargeListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBSurchargeListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // cell 내용 설정
    NSDictionary    *dicDataDic = [arrayDataArray objectAtIndex:indexPath.row];
    
    cell.label1.text = dicDataDic[@"플랜명"];
    cell.label2.text = dicDataDic[@"부담금통합계좌번호"];
    
    // 선택된 경우 cell 색상 변경
    if(intSelectedRow == indexPath.row)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
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
    
    NSDictionary     *dicDataDic = [arrayDataArray objectAtIndex:intSelectedRow];
    
    SHBSurchargeReqViewController *viewController = [[SHBSurchargeReqViewController alloc] initWithNibName:@"SHBSurchargeReqViewController" bundle:nil];
    viewController.dicDataDictionary = (NSMutableDictionary*)dicDataDic;
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


#pragma mark -
#pragma mark Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99)
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
    
    // 퇴직연금의 메뉴 1,2,3,4,5 경우 가입 유무와 동의 확인이 필요하다
    // 메뉴 진입 전 로그인 후에 처리되고 있음(2군데)
    
    // title 설정
    self.title = @"가입자부담금입금";
    self.strBackButtonTitle = @"가입자부담금입금 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    intSelectedRow = -1;
    
    arrayDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW767010Q0",
                            @"고객구분" : @"3",
                            @"플랜번호" : @"",
                            @"가입자번호" : @"",
                            @"제도구분" : @"",
                            @"페이지인덱스" : @"1",
                            @"전체조회건수" : @"0",
                            @"페이지패치건수" : @"500",
                            @"예비필드" : @"",
                            @"적립금조회" : @"",
                            //@"주민사업자번호" : AppInfo.ssn
                            //@"주민사업자번호" : [AppInfo getPersonalPK],
                            @"주민사업자번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                            }] autorelease];
    
    // E3925로 가져온다( E3946과 플랜명이 약간 상이함, 이전 코드 및 인터넷 뱅킹 참조 )
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_JOIN_JUDGE viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
