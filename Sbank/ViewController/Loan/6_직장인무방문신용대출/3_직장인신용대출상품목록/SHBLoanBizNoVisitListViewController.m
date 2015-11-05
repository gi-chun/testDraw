//
//  SHBLoanBizNoVisitListViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitListViewController.h"
#import "SHBLoanService.h" // 서비스
#import "SHBLoanBizNoVisitListViewCell.h" // cell

#import "SHBLoanBizNoVisitListDetailViewController.h" // 직장인신용대출상품 목록 안내

@interface SHBLoanBizNoVisitListViewController ()

@end

@implementation SHBLoanBizNoVisitListViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인신용대출상품 목록";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              TASK_NAME_KEY : @"sfg.sphone.task.loan.LoanTask",
                              TASK_ACTION_KEY : @"selectProductList"
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_PRODUCT_LIST_SERVICE
                                               viewController:self] autorelease];
    self.service.requestData = aDataSet;
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
    
    self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
    
    [_dataTable reloadData];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBLoanBizNoVisitListViewCell *cell = (SHBLoanBizNoVisitListViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBLoanBizNoVisitListViewCell"];
    
    if (cell == nil) {
        
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanBizNoVisitListViewCell"
                                                       owner:self options:nil];
		cell = (SHBLoanBizNoVisitListViewCell *)array[0];
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    [cell.productName initFrame:cell.productName.frame
                      colorType:RGB(44, 44, 44)
                       fontSize:15
                      textAlign:0];
    [cell.productName setCaptionText:cellDataSet[@"C_PROD_NAME"]];
    [cell.productName.caption1 setFont:[UIFont boldSystemFontOfSize:15]];
    [cell.productName.caption1 setHighlightedTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    SHBLoanBizNoVisitListDetailViewController *viewController = [[[SHBLoanBizNoVisitListDetailViewController alloc] initWithNibName:@"SHBLoanBizNoVisitListDetailViewController" bundle:nil] autorelease];
    
    viewController.data = [NSDictionary dictionaryWithDictionary:cellDataSet];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
