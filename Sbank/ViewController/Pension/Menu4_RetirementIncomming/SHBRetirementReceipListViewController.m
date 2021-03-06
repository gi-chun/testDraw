//
//  SHBRetirementReceipListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReceipListViewController.h"
#import "SHBRetirementReceipListCell.h"                         // tableView cell
#import "SHBPentionService.h"                                   // 퇴직연금 서비스
#import "SHBRetirementReceiptDetailViewController.h"            // 다음 view


@interface SHBRetirementReceipListViewController ()

@end

@implementation SHBRetirementReceipListViewController

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3925"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            self.dataList = [aDataSet arrayWithForKey:@"LIST.vector.data"];     // 받아온 list 전체
            
            for (NSDictionary *dic in self.dataList)
            {
                // 제도구분코드 1 DB
                // 제도구분코드 2 DC
                // 제도구분코드 3 기업형IRP
                // 제도구분코드 4 개인형IRP
                
                // DB가 아닌 것들만 표시
                if ( ![dic[@"제도구분"] isEqualToString:@"1"] )
                {
                    [arrayDataArray addObject:dic];          // 실제 표시될 데이터
                }
            }
            [tableView1 reloadData];            // table 갱신
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
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
    SHBRetirementReceipListCell *cell = (SHBRetirementReceipListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBRetirementReceipListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBRetirementReceipListCell *)currentObject;
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
    
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    // 상세뷰로 이동
    SHBRetirementReceiptDetailViewController *viewController = [[SHBRetirementReceiptDetailViewController alloc] initWithNibName:@"SHBRetirementReceiptDetailViewController" bundle:nil];
    
    viewController.dicDataDictionary = [arrayDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
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
    self.title = @"퇴직연금 입금내역 조회";
    self.strBackButtonTitle = @"퇴직연금 입금내역 조회 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
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

- (void)dealloc
{
    [arrayDataArray release];
    
    [super dealloc];
}

@end
