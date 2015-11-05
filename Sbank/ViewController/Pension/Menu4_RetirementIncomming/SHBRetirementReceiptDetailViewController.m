//
//  SHBRetirementReceiptDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReceiptDetailViewController.h"
#import "SHBPentionService.h"               // 퇴직연금 서비스


@interface SHBRetirementReceiptDetailViewController ()

@end

@implementation SHBRetirementReceiptDetailViewController


#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW765010Q0",
                            @"고객구분" : @"3",
                            @"플랜번호" : self.dicDataDictionary[@"플랜번호"],
                            @"가입자번호" : self.dicDataDictionary[@"가입자번호"],
                            @"제도구분" : self.dicDataDictionary[@"제도구분"],
                            @"예비필드" : @"",
                            @"조회시작일자" : strSelectedStartDate,
                            @"조회종료일자" : strSelectedEndDate
                            }] autorelease];
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_SURCHARGE_LIST viewController: self] autorelease];
    [self.service setTableView:tableView1 tableViewCellName:@"SHBRetirementReceipDetailCell" dataSetList:@"LIST.vector.data"];
    self.service.previousData = aDataSet;
    [self.service start];
}

- (void)refreshTableView
{
    label1.text = @"";
    label2.text = @"조회기간 : ";
    [label3 setHidden:YES];

    // tableView 초기화
    [tableView1 reloadData];
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:            // 1개월
        {
            intMonth = -1;
        }
            break;
            
        case 12:            // 3개월
        {
            intMonth = -3;
        }
            break;
            
        case 13:            // 6개월
        {
            intMonth = -6;
        }
            break;
            
        case 14:            // 기간선택
        {
            SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
            [popupView setDelegate:self];
            [popupView periodModeForDate:YES];
            [popupView setMaxDate:[NSDate date]];
            [popupView showInView:self.navigationController.view animated:YES];
            
            return;         // 내려가지 않도록 막는다
        }
            break;
            
        default:
            break;
    }
    
    strSelectedStartDate = [SHBUtility dateStringToMonth:intMonth toDay:0];
    strSelectedEndDate = AppInfo.tran_Date;
    
    // tableView 초기화
    [self refreshTableView];
    
    // 서비스 호출
    [self requestService];
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3710"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            [aDataSet setObject:self.dicDataDictionary[@"플랜명"] forKey:@"플랜명"];
            [aDataSet setObject:self.dicDataDictionary[@"부담금통합계좌번호"] forKey:@"계좌번호"];
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3710"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )      // 통신 성공시
        {
            if ( [aDataSet[@"반복횟수"] intValue] == 0 )
            {
                [label3 setHidden:NO];
            }
                // 사용자부담금 조회기간 갱신
            label1.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:aDataSet[@"사용자부담금합계"]]];
            label2.text = [NSString stringWithFormat:@"조회기간 : %@~%@[%@건]", strSelectedStartDate, strSelectedEndDate, [aDataSet objectForKey:@"반복횟수"]];
        }
    }
    
    return YES;
}


#pragma mark - 
#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    // tableView 초기화
    [self refreshTableView];
    
    strSelectedStartDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    strSelectedEndDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self requestService];
}

- (void)popupViewDidCancel
{
    
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
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
    
    self.title = @"퇴직연금 입금내역 조회";
    self.strBackButtonTitle = @"퇴직연금 입금내역 조회 상세";
    
    AppInfo.isNeedBackWhenError = YES;
    
    // 최초 진입시 setting
    intMonth = -1;
    strSelectedStartDate    = [SHBUtility dateStringToMonth:intMonth toDay:0];
    strSelectedEndDate      = [SHBAppInfo sharedSHBAppInfo].tran_Date;
    
    // 서비스 호출
    [self requestService];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
