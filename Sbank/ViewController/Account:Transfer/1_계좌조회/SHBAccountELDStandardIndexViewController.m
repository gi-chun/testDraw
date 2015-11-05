//
//  SHBAccountELDStandardIndexViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 6. 24..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBAccountELDStandardIndexViewController.h"
#import "SHBAccountELDStandardIndexCell.h"

#import "SHBAccountService.h"

@interface SHBAccountELDStandardIndexViewController ()

@end

@implementation SHBAccountELDStandardIndexViewController

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
    
    [self setTitle:@"계좌조회"];
    
    NSLog(@"!!!  %@", _accountInfo);
    
    [_accountName initFrame:_accountName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_accountName setCaptionText:_accountInfo[@"계좌명"]];
    
    [_accountNumber setText:_accountInfo[@"계좌번호"]];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D1125" viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBAccountELDStandardIndexCell"
                   dataSetList:@"기준지수.vector.data"];
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"거래구분" : @"1",
                             @"상품CODE" : self.accountInfo[@"계좌정보상세"][@"상품코드"],
                             @"적용시작일자" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                             @"적용종료일자" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                             @"승인상태" : @"2",
                             @"과목CODE" : @"209",
                             }] autorelease];
    
    self.service.requestData = aDataSet;
    
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountInfo = nil;
    
    [_dataTable release];
    [_accountName release];
    [_accountNumber release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setAccountName:nil];
    [self setAccountNumber:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)okButton:(id)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Orchestra Naive

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

@end
