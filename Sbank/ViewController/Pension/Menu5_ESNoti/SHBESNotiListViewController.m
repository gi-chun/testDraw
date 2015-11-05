//
//  SHBESNotiListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBESNotiListViewController.h"
#import "SHBPentionService.h"               // 퇴직연금 서비스
#import "SHBESNotiEditViewController.h"     // 다음 view


@interface SHBESNotiListViewController ()

@end

@implementation SHBESNotiListViewController


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제

    // 상세뷰로 이동
    SHBESNotiEditViewController *viewController = [[SHBESNotiEditViewController alloc] initWithNibName:@"SHBESNotiEditViewController" bundle:nil];
    
    viewController.dicDataDictionary = [self.service.dataList objectAtIndex:indexPath.row];
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
    self.title = @"이메일, SMS통지/정보변경";
    self.strBackButtonTitle = @"이메일, SMS통지/정보변경 조회 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
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
    [self.service setTableView: tableView1 tableViewCellName:@"SHBESNotiListCell" dataSetList:@"LIST.vector.data"];
    self.service.previousData = aDataSet;
    [self.service start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
