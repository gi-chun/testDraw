//
//  SHBCardAcknowledgmentDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardAcknowledgmentDetailViewController.h"
#import "SHBUtility.h" // 유틸
#import "SHBCardService.h" // 서비스

@interface SHBCardAcknowledgmentDetailViewController ()

@end

@implementation SHBCardAcknowledgmentDetailViewController

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
    
    [self setTitle:@"승인내역조회"];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2905
                                                 viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBCardAcknowledgmentDetailCell"
                   dataSetList:@"LIST.vector.data"];
    
    self.service.requestData = AppInfo.commonDic[@"dataSet"];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
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
    
    self.dataList = [aDataSet arrayWithForKey:@"LIST"];
    
    [aDataSet insertObject:@"승인내역조회 완료"
                    forKey:@"_타이틀"
                   atIndex:0];
    [aDataSet insertObject:AppInfo.commonDic[@"infoDic"][@"카드명"]
                    forKey:@"_카드명"
                   atIndex:0];
    [aDataSet insertObject:AppInfo.commonDic[@"infoDic"][@"카드번호"]
                    forKey:@"_카드번호"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"조회기간:%@~%@[%d건]",
                            [SHBUtility getDateWithDash:AppInfo.commonDic[@"dataSet"][@"조회시작일"]],
                            [SHBUtility getDateWithDash:AppInfo.commonDic[@"dataSet"][@"조회종료일"]],
                            [self.dataList count]]
                    forKey:@"_조회기간"
                   atIndex:0];
    
    [self.binder bind:self dataSet:aDataSet];
    
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"기간내에 승인내역이 존재하지 않습니다."];
        return NO;
    }
    
    for (NSMutableDictionary *dic in self.dataList) {
        [dic setObject:[NSString stringWithFormat:@"%@%@", dic[@"본인여부"], dic[@"사용카드"]]
                forKey:@"_본인여부카드비고"];
        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"승인금액"]]
                forKey:@"_승인금액"];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
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
    
}

@end
