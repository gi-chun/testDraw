//
//  SHBSimpleLoanBranchSearchViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 19..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanBranchSearchViewController.h"
#import "SHBLoanService.h" // service

@interface SHBSimpleLoanBranchSearchViewController ()

@end

@implementation SHBSimpleLoanBranchSearchViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 영업점조회";
    
    startTextFieldTag = 3330;
    endTextFieldTag = 3330;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_branch release];
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBranch:nil];
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    if ([_branch.text length] < 2) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"최소 두 글자 이상\n입력해 주세요."];
        return;
    }
    
    [_branch resignFirstResponder];
    
//    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
//                            @{
//                              @"검색어" : _branch.text
//                              }];
//    
//    self.service = nil;
//    self.service = [[[SHBBranchesService alloc] initWithServiceId:kE4307Id viewController:self] autorelease];
//    
//    [self.service setTableView:_dataTable
//             tableViewCellName:@"SHBSimpleLoanBranchSearchCell"
//                   dataSetList:@"검색결과.vector.data"];
//    
//	self.service.requestData = aDataSet;
//	[self.service start];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                              TASK_ACTION_KEY : @"getBranchCode",
                              @"영업점명" : _branch.text
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_BRANCH_SEARCH_SERVICE viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBSimpleLoanBranchSearchCell"
                   dataSetList:@"data"];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    if ([self.service.dataList count] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"검색결과가\n존재하지 않습니다."];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(simpleLoanBranchSearchSelectIndexPath:withData:)]) {
        
        [_delegate simpleLoanBranchSearchSelectIndexPath:indexPath withData:self.service.dataList[indexPath.row]];
    }
    
    [self.navigationController fadePopViewController];
}

@end
