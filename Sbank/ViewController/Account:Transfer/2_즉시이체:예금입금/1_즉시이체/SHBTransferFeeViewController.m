//
//  SHBTransferFeeViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 7..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBTransferFeeViewController.h"
#import "SHBTransferFeeCell.h" // cell
#import "SHBAccountService.h" // 서비스

@interface SHBTransferFeeViewController ()

@end

@implementation SHBTransferFeeViewController

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
    
    [self setTitle:@"수수료 면제 횟수 조회"];
    self.strBackButtonTitle = @"수수료 면제 횟수 조회";
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:@{
                                                               @"_조회계좌" : _accountNumber,
                                                               @"_조회일" : AppInfo.tran_Date
                                                               }];
    [self.binder bind:self dataSet:dataSet];
    
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"통합계좌번호" : [_accountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                  @"업무구분" : @"2",
                                                                  }];
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5100" viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountNumber = nil;
    
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopViewController];
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
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBTransferFeeCell *cell = (SHBTransferFeeCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBTransferFeeCell"];
    
	if (!cell) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBTransferFeeCell"
                                                       owner:self options:nil];
		cell = (SHBTransferFeeCell *)array[0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
