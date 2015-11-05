//
//  SHBOldSecurityViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 2..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOldSecurityViewController.h"
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBUtilFile.h" // 유틸
#import "SHBOldSecurityEndViewController.h"
#import "SHBoldDeviceRegisAddInputViewController.h"   //이용기기 별명
#import "SHBDeviceRegistServiceListViewController.h" // 이용기기 등록 조회/삭제
#define MAXCOUNT 5

@interface SHBOldSecurityViewController ()


@end

@implementation SHBOldSecurityViewController

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
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
    [self setTitle:@"구 이용PC 사전등록 변경"];
    
    self.strBackButtonTitle = @"구 이용PC 사전등록 변경";

    [self initNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_checkBtn release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCheckBtn:nil];
    [super viewDidUnload];
}



#pragma mark - Button

- (IBAction)checkButton:(id)sender
{
    [sender setSelected:![sender isSelected]];
}


- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    self.dataList = [aDataSet arrayWithForKey:@"등록PC내역"];
    
    if ([self.dataList count] == 0) {
        self.dataList = [NSArray array];
    }
    
    
    
    if ([self.dataList count] >= MAXCOUNT) {     // 알럿 후 이용등록 조회,삭제리스트로 이동
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:10
                         title:@""
                       message:[NSString stringWithFormat:@"등록 가능한 개수(최대%d대)를 초과하였습니다. 기존 등록 기기 삭제 후 다시 진행하시기 바랍니다.", MAXCOUNT]];
        
    }
    else    // 이용기기 5대 미만일때 별명등록 이동
    {
        SHBoldDeviceRegisAddInputViewController *viewController = [[[SHBoldDeviceRegisAddInputViewController alloc] initWithNibName:@"SHBoldDeviceRegisAddInputViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
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
   
   if (alertView.tag == 10)
   {
       AppInfo.commonDic = @{ @"data" : self.dataList };
       SHBDeviceRegistServiceListViewController *viewController = [[[SHBDeviceRegistServiceListViewController alloc] initWithNibName:@"SHBDeviceRegistServiceListViewController" bundle:nil] autorelease];
       [self checkLoginBeforePushViewController:viewController animated:YES];

       
   }
    
}

- (IBAction)okButton:(id)sender
{
    
    if (![_checkBtn isSelected])
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"구 이용PC사전등록 변경에 동의하신 후, 진행하실 수 있습니다."];
        
        return;
    }
    

    
    
    self.service = nil;
    self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3013_SERVICE viewController:self] autorelease];
    self.service.requestData = [SHBDataSet dictionary];
    [self.service start];

  
    
}

- (IBAction)cancelButton:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}


#pragma mark - Notification Center


- (void)oldpcSignCancel
{
   // [self initNotification];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
    _checkBtn.selected = NO;
}

#pragma mark -

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
       // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(oldpcSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(oldpcSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}




@end
