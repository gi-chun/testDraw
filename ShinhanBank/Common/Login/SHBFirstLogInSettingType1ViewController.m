//
//  SHBFirstLogInSettingType1ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFirstLogInSettingType1ViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBLoginSettingViewController.h"


@interface SHBFirstLogInSettingType1ViewController ()
{
    NSMutableArray *marrCertificates;	
}
@end

@implementation SHBFirstLogInSettingType1ViewController
@synthesize certList;

- (void) dealloc
{
    [super dealloc];
}
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
    // Do any additional setup after loading the view from its nib.
    //[self navigationViewHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    self.certList = [AppInfo loadCertificates];
    
    if ([certList count] == 1)
    {
        NSUInteger row = [self.certList count] - 1;
        NSString *subject = [NSString stringWithFormat:@"%@",[[self.certList objectAtIndex:row] user]];
        
        //선택된 인증서를 전역으로 저장한다.
        CertificateInfo *certificate = [certList objectAtIndex:row];
        AppInfo.selectedCertificate = certificate;
        
        //인증서 지정
        [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeCertificateSelected];
        
        NSMutableDictionary *certInfoDic = [NSMutableDictionary dictionary];
        NSDictionary *forwardDic =
        @{
        @"1" : subject,
        @"2" : [[self.certList objectAtIndex:row] issuer],
        @"3" : [[self.certList objectAtIndex:row] expire],
        @"4" : [[self.certList objectAtIndex:row] type],
        };
        
        [certInfoDic setDictionary:forwardDic];
        [[NSUserDefaults standardUserDefaults]setCertificateData:certInfoDic];
        
        NSString *msg = @"복사된 인증서로\n로그인 되도록 설정 되었습니다.\n로그인 화면으로 이동합니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg];
    } else
    {
//        [self dismissModalViewControllerAnimated:NO];
//        [self.navigationController fadePopToRootViewController];
//        
//        SHBLoginSettingViewController *viewController = [[SHBLoginSettingViewController alloc] initWithNibName:@"SHBLoginSettingViewController" bundle:nil];
//        [AppDelegate.navigationController pushFadeViewController:viewController];
//        [viewController release];
        
        marrCertificates = [NSMutableArray array];
        for (int i = 0; i < [self.certList count]; i++)
        {
            if ([[self.certList objectAtIndex:i] expired] == 0)
            {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                [mdic setObject:[[self.certList objectAtIndex:i] user] forKey:@"1"];
                [mdic setObject:[[self.certList objectAtIndex:i] issuer] forKey:@"2"];
                [mdic setObject:[[self.certList objectAtIndex:i] expire] forKey:@"3"];
                [mdic setObject:[[self.certList objectAtIndex:i] type] forKey:@"4"];
                [marrCertificates addObject:mdic];
            }
            
        }
        
        SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"인증서 목록"
                                                                       options:marrCertificates
                                                                       CellNib:@"SHBLoginSettingCell"
                                                                         CellH:69
                                                                   CellDispCnt:5
                                                                    CellOptCnt:3] autorelease];
        [popupView setDelegate:self];
        [popupView showInView:self.view animated:YES];
    }
    
}
- (IBAction) cancelClick:(id)sender
{
    [AppInfo loadCertificates];
    if (AppInfo.certificateCount == 1)
    {
        // 인증서 로그인.
        if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
        }
        
        //[AppDelegate.navigationController fadePopViewController];
        [self dismissModalViewControllerAnimated:NO];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        viewController.whereAreYouFrom = FromLogin;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    } else
    {
        SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
        
        // 인증서 목록 로그인.
        if (AppInfo.certProcessType == CertProcessTypeInFotterLogin) {
            
            viewController.isSignupProcess = YES;
            
        } else
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
        }
        //[AppDelegate.navigationController fadePopViewController];
        [self dismissModalViewControllerAnimated:NO];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
        viewController.whereAreYouFrom = FromLogin;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 10) {
        
        
        //[AppDelegate.navigationController fadePopViewController];
        [self dismissModalViewControllerAnimated:NO];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
        //로그인 화면으로 이동
        AppInfo.certProcessType = CertProcessTypeLogin;
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    }
    
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	//NSLog(@"aaaa:%i",anIndex);
    
    //선택된 인증서를 전역으로 저장한다.
    CertificateInfo *certificate = [self.certList objectAtIndex:anIndex];
    AppInfo.selectedCertificate = certificate;
    NSString *subject = [NSString stringWithFormat:@"%@",[[self.certList objectAtIndex:anIndex] user]];
    //인증서 지정
    [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeCertificateSelected];
    
    NSMutableDictionary *certInfoDic = [NSMutableDictionary dictionary];
    NSDictionary *forwardDic =
    @{
    @"1" : subject,
    @"2" : [[self.certList objectAtIndex:anIndex] issuer],
    @"3" : [[self.certList objectAtIndex:anIndex] expire],
    @"4" : [[self.certList objectAtIndex:anIndex] type],
    };
    
    [certInfoDic setDictionary:forwardDic];
    [[NSUserDefaults standardUserDefaults]setCertificateData:certInfoDic];
    
    NSString *msg = @"선택된 인증서로\n로그인 되도록 설정 되었습니다.\n로그인 화면으로 이동합니다.";
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg];
	//self.selectedData = [self.marrCertificates objectAtIndex:anIndex];
	
	
}

- (void)listPopupViewDidCancel
{
	//[self.sbCertificate setState:SHBSelectBoxStateNormal];
}
@end
