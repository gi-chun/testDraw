//
//  SHBDeviceRegistServiceListViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceListViewController.h"
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBMobileCertificateService.h"
#import "SHBDeviceRegistServiceListCell.h" // cell

#import "SHBDeviceRegistServiceDeleteConfirmViewController.h" // 이용기기 삭제 확인

@interface SHBDeviceRegistServiceListViewController ()

@end

@implementation SHBDeviceRegistServiceListViewController

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
    
    [self setTitle:@"이용기기 등록 서비스"];
    self.strBackButtonTitle = @"이용기기 등록 조회/해제";
    
    self.dataList = AppInfo.commonDic[@"data"];
    
    [_dataTable reloadData];
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

#pragma mark - Button

- (void)tableViewDeleteBtn:(UIButton *)sender
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                     message:@"선택하신 이용기기를 삭제 하시겠습니까?"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"예", @"아니오", nil] autorelease];
    [alert setTag:[sender tag]];
    [alert show];
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
    SHBDeviceRegistServiceDeleteConfirmViewController *viewController = [[[SHBDeviceRegistServiceDeleteConfirmViewController alloc] initWithNibName:@"SHBDeviceRegistServiceDeleteConfirmViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        AppInfo.commonDic = @{ @"data" : self.dataList, @"selectData" : self.dataList[alertView.tag] };
        
        self.service = nil;
        self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
        [self.service start];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBDeviceRegistServiceListCell *cell = (SHBDeviceRegistServiceListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBDeviceRegistServiceListCell"];
    
	if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBDeviceRegistServiceListCell"
                                                       owner:self options:nil];
		cell = (SHBDeviceRegistServiceListCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    [cell.deleteBtn setTag:indexPath.row];
    [cell.deleteBtn addTarget:self action:@selector(tableViewDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
