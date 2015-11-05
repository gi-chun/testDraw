//
//  SHBDeviceRegistServiceViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceViewController.h"
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBUtilFile.h" // 유틸

#import "SHBDeviceRegistServiceAddInfoViewController.h" // 이용기기 등록 주의사항
#import "SHBDeviceRegistServiceListViewController.h" // 이용기기 조회/삭제
#import "SHBDeviceRegistServiceCloseInfoViewController.h" // 이용기기 등록 서비스 해지

#import "SHBDeviceRegistServiceAddConfirmViewController.h" // 이용기기 등록 완료
#import "SHBDeviceRegistServiceDeleteConfirmViewController.h" // 이용기기 등록 해제 완료

#import "SHBOldSecurityViewController.h" // 구 이용PC 사전등록 변경

#define MAXCOUNT 5

@interface SHBDeviceRegistServiceViewController ()
{
    BOOL _isAddData; // 이미 등록된 이용기기인 경우
    BOOL _isService; // 이용기기 등록 서비스 가입 여부
    BOOL _isDeleteOK; // 이용기기 삭제 후 해지로 바로 가는 경우
}

/// 등록된 이용기기 조회
- (void)requestList;

@end

@implementation SHBDeviceRegistServiceViewController

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
    self.strBackButtonTitle = @"이용기기 등록 서비스";
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    _isDeleteOK = NO;
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self requestList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [super viewDidUnload];
}

#pragma mark -

- (void)deviceRegistServiceDeleteCompleteOK
{
    _isDeleteOK = YES;
    
    [self requestList];
}

- (void)requestList
{
    _isAddData = NO;
    _isService = NO;
    
    self.service = nil;
    self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3013_SERVICE viewController:self] autorelease];
    self.service.requestData = [SHBDataSet dictionary];
    [self.service start];
}

#pragma mark - Button

/// 이용기기 등록
- (IBAction)addBtn:(UIButton *)sender
{
    if (!AppInfo.isOldPCRegister) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:111
                         title:@""
                       message:@"구 이용PC 사전등록 변경동의 대상 고객입니다. 변경동의 후 서비스를 이용하실 수 있습니다."];
        return;
    }
    
    if (_isAddData) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이미 등록된 이용기기 입니다."];
        return;
    }
    
    if ([self.dataList count] >= MAXCOUNT) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:[NSString stringWithFormat:@"등록 가능한 개수(최대%d대)를 초과하였습니다. 기존 등록 기기 삭제 후 다시 진행하시기 바랍니다.", MAXCOUNT]];
        return;
    }
    
    AppInfo.commonDic = @{ @"data" : self.dataList };
    
    SHBDeviceRegistServiceAddInfoViewController *viewController = [[[SHBDeviceRegistServiceAddInfoViewController alloc] initWithNibName:@"SHBDeviceRegistServiceAddInfoViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 이용기기 조회/삭제
- (IBAction)deleteBtn:(UIButton *)sender
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"등록된 이용기기가 없습니다."];
        return;
    }
    
    AppInfo.commonDic = @{ @"data" : self.dataList };
    
    SHBDeviceRegistServiceListViewController *viewController = [[[SHBDeviceRegistServiceListViewController alloc] initWithNibName:@"SHBDeviceRegistServiceListViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 이용기기 등록 서비스 해지
-  (IBAction)closeBtn:(UIButton *)sender
{
    if (!AppInfo.isOldPCRegister) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:111
                         title:@""
                       message:@"구 이용PC 사전등록 변경동의 대상 고객입니다. 변경동의 후 서비스를 이용하실 수 있습니다."];
        return;
    }
    
    if (!_isService) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이용기기 등록 서비스 미 가입 고객입니다."];
        return;
     }
    
    SHBDeviceRegistServiceCloseInfoViewController *viewController = [[[SHBDeviceRegistServiceCloseInfoViewController alloc] initWithNibName:@"SHBDeviceRegistServiceCloseInfoViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    self.dataList = [aDataSet arrayWithForKey:@"등록PC내역"];
    
    if ([self.dataList count] == 0) {
        self.dataList = [NSArray array];
    }
    
    for (NSMutableDictionary *dic in self.dataList) {
        if ([dic[@"MACADDRESS"] isEqualToString:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]]) {
            _isAddData = YES;
            
            break;
        }
    }
    
    if (![aDataSet[@"서비스신청여부"] isEqualToString:@"1"]) {
        _isService = NO;
    }
    else {
        _isService = YES;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (_isDeleteOK) {
        _isDeleteOK = NO;
        
        [self closeBtn:nil];
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 111) {
        SHBOldSecurityViewController *viewController = [[[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
