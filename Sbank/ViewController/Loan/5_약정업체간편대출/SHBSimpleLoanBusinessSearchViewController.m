//
//  SHBSimpleLoanBusinessSearchViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanBusinessSearchViewController.h"
#import "SHBLoanService.h" // service

#import "SHBSimpleLoanSIDViewController.h" // 주민등록번호 확인 화면

@interface SHBSimpleLoanBusinessSearchViewController ()

@end

@implementation SHBSimpleLoanBusinessSearchViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 가능업체 검색";
    
    startTextFieldTag = 3330;
    endTextFieldTag = 3330;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_business release];
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBusiness:nil];
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 조회
            
            if ([_business.text length] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"검색어를 입력하여 업체검색 후 선택하여 주시기 바랍니다."];
                return;
            }
            
            [_business resignFirstResponder];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                      TASK_ACTION_KEY : @"selectEasyLoan",
                                      @"P_BIZNMS" : _business.text,
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_SIMPLELOAN_SEARCH_SERVICE viewController:self] autorelease];
            
            [self.service setTableView:_dataTable
                     tableViewCellName:@"SHBSimpleLoanBusinessSearchCell"
                           dataSetList:@"data"];
            
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 200: {
            
            // 취소
            
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
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
    
    if ([self.service.dataList count] == 0) {
        
        return;
    }
    
    SHBSimpleLoanSIDViewController *viewController = [[[SHBSimpleLoanSIDViewController alloc] initWithNibName:@"SHBSimpleLoanSIDViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - SHBSimpleLoanSIDDelegate

- (void)simpleLoanSIDCancel
{
    [_business setText:@""];
    
    self.service.dataList = @[];
    
    [_dataTable reloadData];
}

@end
