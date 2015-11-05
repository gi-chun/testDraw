//
//  SHBProductStateDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBProductStateDetailViewController.h"
#import "SHBPentionService.h"               // 퇴직연금 서비스

@interface SHBProductStateDetailViewController ()

@end

@implementation SHBProductStateDetailViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3715"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"운용상품평가금액합계"]] forKey:@"운용상품평가금액합계원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"원금합계"]] forKey:@"원금합계원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"평가손익합계"]] forKey:@"평가손익합계원"];
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3715"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            label1.text = self.dicDataDictionary[@"플랜명"];
            label2.text = self.dicDataDictionary[@"부담금통합계좌번호"];
            // 기존 버전에서는 조회종료일자를 사용하였으나 전일자로 변경됨
            label3.text = [NSString stringWithFormat:@"%@[%@건]", [SHBUtility dateStringToMonth:0 toDay:-1], aDataSet[@"반복횟수"]];
        }
    }
    return YES;
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
    
    self.title = @"운용상품 현황조회";
    self.strBackButtonTitle = @"운용상품 현황조회 상세";
    
    AppInfo.isNeedBackWhenError = YES;
    
    NSString    *strLastDate = [SHBUtility dateStringToMonth:0 toDay:-1];
    strLastDate = [strLastDate stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW765020Q0",
                            @"고객구분" : @"3",
                            @"플랜번호" : self.dicDataDictionary[@"플랜번호"],
                            @"가입자번호" : self.dicDataDictionary[@"가입자번호"],
                            @"제도구분" : self.dicDataDictionary[@"제도구분"],
                            @"페이지인덱스" : @"1",
                            @"전체조회건수" : @"0",
                            @"페이지패치건수" : @"500",
                            @"예비필드" : @"",
                            @"조회시작일자" : strLastDate,
                            @"조회종료일자" : strLastDate
                            }] autorelease];
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_PRODUCT_STATE_DETAIL viewController: self] autorelease];
    [self.service setTableView:tableView1 tableViewCellName:@"SHBProductStateDetailCell" dataSetList:@"LIST.vector.data"];
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
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
