//
//  SHBCardMonthDateInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardMonthDateInputViewController.h"
#import "SHBCardService.h" // 서비스

#import "SHBCardMonthSpecDetailViewController.h" // 월별 청구금액 조회 상세

@interface SHBCardMonthDateInputViewController ()

@property (retain, nonatomic) NSMutableDictionary *selectCardDic; // 선택한 카드번호

@end

@implementation SHBCardMonthDateInputViewController

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
    self.strBackButtonTitle = @"월별 청구금액 조회";
    
    self.selectCardDic = [NSMutableDictionary dictionary];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    [_monthField initFrame:_monthField.frame];
    [_monthField.textField setFont:[UIFont systemFontOfSize:15]];
    [_monthField.textField setTextColor:RGB(44, 44, 44)];
    [_monthField.textField setTextAlignment:UITextAlignmentLeft];
    [_monthField setDelegate:self];
    [_monthField selectDate:[dateFormatter dateFromString:AppInfo.tran_Date] animated:NO];
    
    self.selectCardDic = AppInfo.codeList.creditCardList[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCardDic = nil;
    
    [_dataTable release];
    [_monthField release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setMonthField:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)searchBtn:(UIButton *)sender
{
    self.service.dataList = [NSArray array];
    [_dataTable reloadData];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"신한카드번호" : _selectCardDic[@"카드번호"],
                           @"청구월" : [_monthField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                           }];
    
    self.service = nil;
    self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2913
                                                 viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBCardMonthDateInputCell"
                   dataSetList:@"LIST.vector.data"];
    
    self.service.requestData = dataSet;
    [self.service start];
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
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"해당월의 이용대금 명세서가 존재하지 않습니다."];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppInfo.commonDic = @{
                        @"카드번호" : _selectCardDic[@"카드번호"],
                        @"결제일자" : self.dataList[indexPath.row][@"결제일자"],
                        @"다원화순번" : self.dataList[indexPath.row][@"다원화순번"],
                        };
    
    SHBCardMonthSpecDetailViewController *viewController = [[[SHBCardMonthSpecDetailViewController alloc] initWithNibName:@"SHBCardMonthSpecDetailViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
