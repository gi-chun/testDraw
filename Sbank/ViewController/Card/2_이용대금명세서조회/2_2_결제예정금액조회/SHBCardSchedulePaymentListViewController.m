//
//  SHBCardSchedulePaymentListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardSchedulePaymentListViewController.h"
#import "SHBCardService.h" // 서비스

#import "SHBCardSchedulePaymentDetailViewController.h" // 결제 예정금액 조회 상세

@interface SHBCardSchedulePaymentListViewController ()

@property (retain, nonatomic) NSMutableDictionary *selectCardDic; // 선택한 카드번호

@end

@implementation SHBCardSchedulePaymentListViewController

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
    
    [self setTitle:@"이용대금 명세서 조회"];
    self.strBackButtonTitle = @"결제 예정금액 조회";
    
    self.selectCardDic = AppInfo.codeList.creditCardList[0];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"신한카드번호" : _selectCardDic[@"카드번호"],
                           }];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2915
                                                 viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBCardMonthDateInputCell"
                   dataSetList:@"LIST.vector.data"];
    
    self.service.requestData = dataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCardDic = nil;
    
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    Debug(@"%@", aDataSet);
    
    self.dataList = [aDataSet arrayWithForKey:@"LIST"];
    
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"결제예정명세서가 존재하지 않습니다."];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController fadePopViewController];
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppInfo.commonDic = @{
                        @"카드번호" : _selectCardDic[@"카드번호"],
                        @"결제일자" : self.dataList[indexPath.row][@"결제일자"],
                        @"다원화순번" : self.dataList[indexPath.row][@"다원화순번"],
                        };
    
    SHBCardSchedulePaymentDetailViewController *viewController = [[[SHBCardSchedulePaymentDetailViewController alloc] initWithNibName:@"SHBCardSchedulePaymentDetailViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
