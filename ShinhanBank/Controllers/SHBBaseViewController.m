//
//  SHBBaseViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SHBBaseViewController.h"
#import "SHBBankingService.h"
#import "SHBAccountService.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBSecureTextField.h"
#import "SHBTextField.h"
#import "SHBCheckingViewController.h"
#import "SHBNoCertForCertLogInViewController.h"
#import "SHBLoginViewController.h"
#include "amsLibrary.h"


@interface SHBBaseViewController ()
{
    BOOL isQuickLogin;
    int secureClickCnt;
    //ios7 + xcode5 대응
    BOOL isQuickMenuSlideIn;
    BOOL isPanGesture;
}
@end

#define HOME_BUTTON_TAG 9876

@implementation SHBBaseViewController
@synthesize contentScrollView;
@synthesize curTextField;
@synthesize whereAreYouFrom;
@synthesize needsLogin;
@synthesize needsCert;
@synthesize isPushAndScheme;
@synthesize strBackButtonTitle;
//@synthesize needsEasyAccountQuery;
@synthesize data;
@synthesize dataList;

@synthesize client;
@synthesize dataParser;
@synthesize dataBinder;

@synthesize needClearData;
@synthesize bottomMenuView = _bottomMenuView;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 5555555 && buttonIndex == 0)
    {
        //AppInfo.isLogin = LoginTypeNo;
		//AppInfo.certProcessType = CertProcessTypeNo;
        //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
        if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
            if (AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
        }else
        {
            SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
    } else if (alertView.tag == 9999999 && buttonIndex == 0)
    {
        [AppInfo logout];
		AppInfo.isLogin = LoginTypeNo;
		AppInfo.certProcessType = CertProcessTypeNo;
		if ([NSStringFromClass([self class]) isEqualToString:@"SHBMainViewController"]){
			// 하단의 퀵메뉴에 로그인,아웃 버튼 교체
			[self.bottomMenuView changeLogInOut:AppInfo.isLogin];
			
		}else{
			[self.navigationController fadePopToRootViewController];
		}
		
	}
    else if (alertView.tag == 1999997 && buttonIndex == 0)
    {
        //[AppInfo logout];
		[AppInfo loadCertificates];
        if (AppInfo.certificateCount < 1)
        {
            SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
		if (AppInfo.certificateCount == 1)
        {
            
			// 인증서 로그인.
			if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
				AppInfo.certProcessType = CertProcessTypeLogin;
			}
			
			UIViewController *certController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
			[self.navigationController pushFadeViewController:certController];
			[certController release];
			
		}
        else
        {
            
            //지정된 공인인증서가 있다면...
            if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected && AppInfo.selectedCertificate != nil)
            {
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                viewController.whereAreYouFrom = FromLogin;
                [self.navigationController pushFadeViewController:viewController];
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
                
                viewController.whereAreYouFrom = FromLogin;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
		}
	}
    else if (alertView.tag == 1999997 && buttonIndex == 0)
    {
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    }
    else if (alertView.tag == 1999998 && buttonIndex == 0)
    {
        if (AppInfo.certificateCount < 1)
        {
            SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
        
        if (AppInfo.certificateCount == 1){
            // 인증서 로그인.
            if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                AppInfo.certProcessType = CertProcessTypeLogin;
            }
            
            SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
        } else
        {
            if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone && AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
            {
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
                
            }else
            {
                SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                
                // 인증서 목록 로그인.
                if (AppInfo.certProcessType == CertProcessTypeInFotterLogin) {
                    viewController.isSignupProcess = YES;
                    
                } else
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
            
        }
    }else if (alertView.tag == 92673)
    {
        exit(-1);
    }else if (alertView.tag == 10286)
    {
        
        [(SHBTextField *)curTextField becomeFirstResponder];
    }
    
    if((alertView.tag == 1999997 || alertView.tag == 1999998) && buttonIndex == 1){
        
        if([NSStringFromClass([self.navigationController.topViewController class]) isEqualToString:@"SHBAccountInqueryViewController"] ||
           [NSStringFromClass([self.navigationController.topViewController class]) isEqualToString:@"SHBAccountMenuListViewController"] ||
           [NSStringFromClass([self.navigationController.topViewController class]) isEqualToString:@"SHBMainViewController"]){
            if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
                UIDevice *curDevice = [UIDevice currentDevice];
                curDevice.proximityMonitoringEnabled = YES;
                AppInfo.isShowSearchView = NO;

                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
            }
        }
    }
}

- (void)drawNavigationView{
    
    int cnt = [AppDelegate.navigationController.viewControllers count];
	UIView		*navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[navigationView setTag:NAVI_VIEW_TAG];
	UIImageView	*backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[backImageView setImage:[[UIImage imageNamed:@"bar_top.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	
	UILabel		*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 210, 44)];
    if (AppInfo.noticeState == 2)
    {
        [titleLabel setFrame:CGRectMake(45, 0, 210, 44)];
    }
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setText:self.title];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setTag:NAVI_TITLE_TAG];
	
	UIButton	*backButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 51, 28)];
	backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[backButton setTitle:@" 이전" forState:UIControlStateNormal];
	[backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backButton setBackgroundImage:[UIImage imageNamed:@"btn_topback.png"] forState:UIControlStateNormal];
	[backButton setTag:NAVI_BACK_BTN_TAG];
	[backButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    
    if(cnt > 1)
    {
        NSString *strLabelValue = ((SHBBaseViewController *)[AppDelegate.navigationController.viewControllers objectAtIndex:cnt - 2]).strBackButtonTitle;
        backButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 뒤로이동", strLabelValue];
    }
    
	UIButton	*menuButton = [[UIButton alloc] initWithFrame:CGRectMake(262, 8, 55, 27)];
	menuButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
	[menuButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[menuButton setTitle:@"메뉴" forState:UIControlStateNormal];
	[menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[menuButton setTitle:@"메뉴" forState:UIControlStateHighlighted];
	[menuButton setTitleColor:[UIColor colorWithRed:232.0f/255.0f green:170.0f/255.0f blue:77.0f/255.0f alpha:1] forState:UIControlStateHighlighted];
	[menuButton setBackgroundImage:[UIImage imageNamed:@"btn_quick.png"] forState:UIControlStateNormal];
	[menuButton setTag:NAVI_MENU_BTN_TAG];
	[menuButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    menuButton.accessibilityLabel = @"퀵메뉴보기";
    
    //새알림 확인 가기 버튼 만들기(확인때까지 기존의 퀵메뉴 활성화 금지)
    UIButton	*notiButton = [[UIButton alloc] initWithFrame:CGRectMake(234, 8, 55, 27)];
	//notiButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	//[notiButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	//[notiButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	//[notiButton setTitle:@"New" forState:UIControlStateNormal];
	//[notiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	//[notiButton setTitle:@"New" forState:UIControlStateHighlighted];
	//[notiButton setTitleColor:[UIColor colorWithRed:232.0f/255.0f green:170.0f/255.0f blue:77.0f/255.0f alpha:1] forState:UIControlStateHighlighted];
	[notiButton setBackgroundImage:[UIImage imageNamed:@"btn_quick_mail.png"] forState:UIControlStateNormal];
	[notiButton setTag:NAVI_NOTI_BTN_TAG];
	[notiButton addTarget:self action:@selector(notiButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    notiButton.accessibilityLabel = @"알림보기";
    
    
    
	UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(268, 8, 45, 29)];
	closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype1.png"] forState:UIControlStateNormal];
	[closeButton setTag:NAVI_CLOSE_BTN_TAG];
	[closeButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[closeButton setHidden:YES];
	
	UIButton	*dimmNaviButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 317, 44)];
	[dimmNaviButton setTag:NAVI_DIMM_BTN_TAG];
	//[dimmNaviButton setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4]];
	[dimmNaviButton setHidden:YES];
	[dimmNaviButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	
	[navigationView addSubview:backImageView];
	[navigationView addSubview:titleLabel];
	[navigationView addSubview:backButton];
	[navigationView addSubview:dimmNaviButton];
    
    if (!UIAccessibilityIsVoiceOverRunning())
    {
        //보이스오버 기능이 꺼져 있을시에만 활성화
        [navigationView addSubview:menuButton];
    }
	
    [navigationView addSubview:notiButton];
    
	[navigationView addSubview:closeButton];
	[backImageView release];
	[titleLabel release];
	[backButton release];
	[dimmNaviButton release];
	[menuButton release];
	[closeButton release];
	
	[self.view addSubview:navigationView];
	[navigationView release];
	
}

- (void)drawQuickMenu{
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
	UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, 317, viewHeight)];
	[dimmButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
	[dimmButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[dimmButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	[dimmButton setTag:MAIN_DIMM_BTN_TAG];
    
	//[dimmButton setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4]];
	[dimmButton setHidden:YES];
	[dimmButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview:dimmButton];
    [dimmButton setIsAccessibilityElement:NO];
	[dimmButton release];
	
	// 오른쪽에 있는 3픽셀영역
	UIImageView	*menuLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(317, 0, 3, viewHeight)];
	[menuLeftImageView setImage:[[UIImage imageNamed:@"quick_bg.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:40]];
	[menuLeftImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
	[menuLeftImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[menuLeftImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	[menuLeftImageView setTag:QUICK_LINE_TAG];
	[self.view addSubview:menuLeftImageView];
	[menuLeftImageView release];
	
	// 퀵메뉴 영역
	
    UIView		*menuView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 95, viewHeight)];
	[menuView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
	[menuView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[menuView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	[menuView setTag:QUICK_VIEW_TAG];
	[menuView setBackgroundColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1]];
	
	UIImageView	*lineImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	UIImageView	*lineImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	UIImageView	*lineImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	UIImageView	*lineImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	UIImageView	*lineImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	UIImageView	*lineImageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	[lineImageView1 setFrame:CGRectMake(4, 44*1, 84, 1)];
	[lineImageView2 setFrame:CGRectMake(4, 44*2, 84, 1)];
	[lineImageView3 setFrame:CGRectMake(4, 44*3, 84, 1)];
	[lineImageView4 setFrame:CGRectMake(4, 44*4, 84, 1)];
	[lineImageView5 setFrame:CGRectMake(4, 44*5, 84, 1)];
	[lineImageView6 setFrame:CGRectMake(4, 44*6, 84, 1)];
	
	UIButton	*homeButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*0), 87, 22)];
	[homeButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_home.png"] forState:UIControlStateNormal];
	[homeButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_home_on.png"] forState:UIControlStateHighlighted];
	[homeButton setTag:QUICK_HOME_TAG];
	[homeButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	//장차법
    homeButton.accessibilityLabel = @"메인화면이동";
    
	UIButton	*noticeButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*1), 87, 22)];
	[noticeButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_notice.png"] forState:UIControlStateNormal];
	[noticeButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_notice_on.png"] forState:UIControlStateHighlighted];
	[noticeButton setTag:QUICK_NOTICE_TAG];
	[noticeButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	//장차법
    noticeButton.accessibilityLabel = @"알림화면이동";
    
	UIButton	*myMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*2), 87, 22)];
	[myMenuButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_mymenu.png"] forState:UIControlStateNormal];
	[myMenuButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_mymenu_on.png"] forState:UIControlStateHighlighted];
	[myMenuButton setTag:QUICK_MYMENU_TAG];
	[myMenuButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	//장차법
    myMenuButton.accessibilityLabel = @"마이메뉴화면이동";
    
	UIButton	*appmoreButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*3), 87, 22)];
	[appmoreButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_appmore.png"] forState:UIControlStateNormal];
	[appmoreButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_appmore_on.png"] forState:UIControlStateHighlighted];
	[appmoreButton setTag:QUICK_APPMORE_TAG];
	[appmoreButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	//장차법
    appmoreButton.accessibilityLabel = @"앱더보기화면이동";
    
	UIButton	*settingButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*4), 87, 22)];
	[settingButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_setting.png"] forState:UIControlStateNormal];
	[settingButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_setting_on.png"] forState:UIControlStateHighlighted];
	[settingButton setTag:QUICK_SETTING_TAG];
	[settingButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	//장차법
    settingButton.accessibilityLabel = @"환경설정화면이동";
    
	UIButton	*logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 11+(44*5), 87, 22)];
	if (AppInfo.isLogin){
		[logoutButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_logout_on.png"] forState:UIControlStateNormal];
		[logoutButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_logout.png"] forState:UIControlStateHighlighted];
        //장차법
        logoutButton.accessibilityLabel = @"로그아웃";
	}else{
		[logoutButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_login.png"] forState:UIControlStateNormal];
		[logoutButton setBackgroundImage:[UIImage imageNamed:@"quickmenu_login_on.png"] forState:UIControlStateHighlighted];
        //장차법
        logoutButton.accessibilityLabel = @"로그인";
	}
	[logoutButton setTag:QUICK_LOGOUT_TAG];
	[logoutButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	
	
	UIImageView	*versionLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_line.png"]];
	[versionLine setFrame:CGRectMake(4, viewHeight - 70, 84, 1)];
	UIImageView	*logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_l.png"]];
	[logoImage setFrame:CGRectMake(8, viewHeight - 52, 76, 17)];
	
    BOOL isPersonality = NO;
    
    if ([AppInfo.userInfo[@"피싱방지이미지"] length] > 0 || [AppInfo.userInfo[@"피싱방지문구"] length] > 0)
    {
        isPersonality = YES;
    }
    //접속자 정보 표시 ///////////////////////
    UILabel *connectInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 133, 87, 22)];
    connectInfoLabel1.backgroundColor = [UIColor clearColor];
    connectInfoLabel1.textAlignment = UITextAlignmentLeft;
    connectInfoLabel1.textColor     = [UIColor whiteColor];
    connectInfoLabel1.font          = [UIFont systemFontOfSize:13];
    
    UILabel *connectInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 148, 87, 22)];
    connectInfoLabel2.backgroundColor = [UIColor clearColor];
    connectInfoLabel2.textAlignment = UITextAlignmentLeft;
    connectInfoLabel2.textColor     = [UIColor whiteColor];
    connectInfoLabel2.font          = [UIFont systemFontOfSize:13];
    
    UILabel *connectInfoLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 163, 87, 22)];
    connectInfoLabel3.backgroundColor = [UIColor clearColor];
    connectInfoLabel3.textAlignment = UITextAlignmentLeft;
    connectInfoLabel3.textColor     = [UIColor whiteColor];
    connectInfoLabel3.font          = [UIFont systemFontOfSize:13];
    
    UILabel *connectInfoLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 181, 87, 22)];
    connectInfoLabel4.backgroundColor = [UIColor clearColor];
    connectInfoLabel4.textAlignment = UITextAlignmentLeft;
    connectInfoLabel4.textColor     = RGB(88,184,243);
    connectInfoLabel4.font          = [UIFont systemFontOfSize:13];
    
    UILabel *connectInfoLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 196, 87, 22)];
    connectInfoLabel5.backgroundColor = [UIColor clearColor];
    connectInfoLabel5.textAlignment = UITextAlignmentLeft;
    connectInfoLabel5.textColor     = RGB(88,184,243);
    connectInfoLabel5.font          = [UIFont systemFontOfSize:13];
    
    
    UIView *personaltyBGView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 112, 95, 40)];
    personaltyBGView.backgroundColor = RGB(60, 60, 60);
    
    
    //개인화 문구 및 이미지가 없으면
    if (!isPersonality)
    {
        [connectInfoLabel1 setFrame:CGRectMake(3, viewHeight - 115, 87, 22)];
        [connectInfoLabel2 setFrame:CGRectMake(3, viewHeight - 130, 87, 22)];
        [connectInfoLabel3 setFrame:CGRectMake(3, viewHeight - 145, 87, 22)];
        [connectInfoLabel4 setFrame:CGRectMake(3, viewHeight - 163, 87, 22)];
        [connectInfoLabel5 setFrame:CGRectMake(3, viewHeight - 178, 87, 22)];
        
    }else
    {
        
        //개인화 이미지
        UIImageView *personalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 4, 18, 18)];
        NSString *tmpImgName = AppInfo.userInfo[@"피싱방지이미지"];
        NSString *personalImage = [NSString stringWithFormat:@"%@.png",tmpImgName];
        personalImgView.image = [UIImage imageNamed:personalImage];
        [personaltyBGView addSubview:personalImgView];
        
        UILabel *personalText = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 95, 22)];
        personalText.backgroundColor = [UIColor clearColor];
        personalText.textAlignment = UITextAlignmentCenter;
        personalText.textColor     = [UIColor whiteColor];
        personalText.font          = [UIFont systemFontOfSize:11];
        personalText.text = AppInfo.userInfo[@"피싱방지문구"];
        [personaltyBGView addSubview:personalText];
    }
    
    if (AppInfo.isLogin != 0)
    {
        //NSLog(@"aaaa:%@",AppInfo.userInfo);
        connectInfoLabel1.text = [NSString stringWithFormat:@"%@",[AppInfo.userInfo objectForKey:@"최종접속시간"]];
        connectInfoLabel2.text = [NSString stringWithFormat:@"%@",[AppInfo.userInfo objectForKey:@"최종접속일자"]];
        connectInfoLabel3.text = @"최근접속일자";
        connectInfoLabel4.text = @"안녕하세요.";
        connectInfoLabel5.text = [NSString stringWithFormat:@"%@ 고객님!",[AppInfo.userInfo objectForKey:@"고객성명"]];
        //connectInfoLabel5.text = [NSString stringWithFormat:@"%@ 고객님!",@"천상천하"];
        
        if (UIAccessibilityIsVoiceOverRunning())
        {
            connectInfoLabel5.tag = 730603;
            connectInfoLabel4.tag = 730604;
            connectInfoLabel3.tag = 730605;
            connectInfoLabel2.tag = 730606;
            connectInfoLabel1.tag = 730607;
        }
        
        if (isPersonality)
        {
            personaltyBGView.hidden = NO;
        }else
        {
            personaltyBGView.hidden = YES;
            
        }
    } else
    {
        personaltyBGView.hidden = YES;
        connectInfoLabel1.text = @"";
        connectInfoLabel2.text = @"";
        connectInfoLabel3.text = @"";
        connectInfoLabel4.text = @"";
        connectInfoLabel5.text = @"";
    }
    //////////////////////////////////////
    
	NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	UILabel		*versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, viewHeight - 32, 87, 22)];
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.textAlignment = UITextAlignmentCenter;
	versionLabel.textColor     = [UIColor whiteColor];
	versionLabel.font          = [UIFont systemFontOfSize:13];
    //	versionLabel.text          = [NSString stringWithFormat:@"Ver %@",versionNumber];
    
    if (!AppInfo.realServer)
    {
        versionLabel.text = [NSString stringWithFormat:@"Dev %@",versionNumber];
    } else
    {
        versionLabel.text = [NSString stringWithFormat:@"Ver %@",versionNumber];
    }
	
	
	[menuView addSubview:lineImageView1];
	[menuView addSubview:lineImageView2];
	[menuView addSubview:lineImageView3];
	[menuView addSubview:lineImageView4];
	[menuView addSubview:lineImageView5];
	[menuView addSubview:lineImageView6];
	[menuView addSubview:homeButton];
	[menuView addSubview:noticeButton];
	[menuView addSubview:myMenuButton];
	[menuView addSubview:appmoreButton];
	[menuView addSubview:settingButton];
	[menuView addSubview:logoutButton];
	
    [menuView addSubview:connectInfoLabel1];
    [menuView addSubview:connectInfoLabel2];
    [menuView addSubview:connectInfoLabel3];
    [menuView addSubview:connectInfoLabel4];
    [menuView addSubview:connectInfoLabel5];
	[menuView addSubview:versionLine];
	[menuView addSubview:logoImage];
	[menuView addSubview:versionLabel];
    
	[menuView addSubview:personaltyBGView];
    
	[lineImageView1 release];
	[lineImageView2 release];
	[lineImageView3 release];
	[lineImageView4 release];
	[lineImageView5 release];
	[lineImageView6 release];
	[homeButton release];
	[noticeButton release];
	[myMenuButton release];
	[appmoreButton release];
	[settingButton release];
	[logoutButton release];
	[versionLine release];
	[logoImage release];
	[versionLabel release];
	[connectInfoLabel1 release];
    [connectInfoLabel2 release];
    [connectInfoLabel3 release];
    [connectInfoLabel4 release];
    [connectInfoLabel5 release];
	[menuView setHidden:NO];
	[self.view addSubview:menuView];
	
	[menuView release];
}
- (void)loginInfoViewFadeOut
{
    //    [loginInfoView removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        loginInfoView.transform = CGAffineTransformMakeScale(.2, .2);
        loginInfoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [loginInfoView removeFromSuperview];
            loginInfoView = nil;
        }
    }];
}

- (void)animationBottomMenu{
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
	_bottomMenuView = [[SHBBottomView alloc] initWithFrame:CGRectMake(0, viewHeight - 49, self.view.frame.size.width, 49)];
	[self.view addSubview:_bottomMenuView];
    
	// 사용안함?
    //	UIView		*btnView = [[UIView alloc] initWithFrame:CGRectMake(273, viewHeight - 57, 44, 28)];
    //	btnView.backgroundColor = [UIColor clearColor];
	
	// 메뉴버튼 잠시 숨기기
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *menuButton   = (UIButton*)[navigationView viewWithTag:NAVI_MENU_BTN_TAG];
    UIButton *notiButton   = (UIButton*)[navigationView viewWithTag:NAVI_NOTI_BTN_TAG];
    [notiButton setFrame:CGRectMake(320, notiButton.frame.origin.y, notiButton.frame.size.width, notiButton.frame.size.height)];
	[menuButton setFrame:CGRectMake(320, menuButton.frame.origin.y, menuButton.frame.size.width, menuButton.frame.size.height)];
    [notiButton setHidden:YES];
	[menuButton setHidden:YES];
	
    //	// 에니메이션용 메뉴버튼
    //	UIButton	*menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    //	menuButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    //	[menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //	[menuButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //	[menuButton setTitle:@"메뉴" forState:UIControlStateNormal];
    //	[menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //	[menuButton setBackgroundImage:[UIImage imageNamed:@"btn_quick.png"] forState:UIControlStateNormal];
    //	[btnView addSubview:menuButton];
    //	btnView.hidden = YES;
    //	[self.view addSubview:btnView];
	
	
    //	// 오른쪽으로 슝~ 사라지고 메뉴 아래서 위로 휙~올라가는 에니메이션
    //	[UIView animateWithDuration:0.3f animations:^{
    //		[_bottomMenuView setFrame:CGRectMake(-50, _bottomMenuView.frame.origin.y, _bottomMenuView.frame.size.width, _bottomMenuView.frame.size.height)];
    //
    //	} completion:^(BOOL finished) {
    //		[UIView animateWithDuration:0.1f animations:^{
    //			[_bottomMenuView setFrame:CGRectMake(320, _bottomMenuView.frame.origin.y, _bottomMenuView.frame.size.width, _bottomMenuView.frame.size.height)];
    //
    //		} completion:^(BOOL finished) {
    //			[_bottomMenuView removeFromSuperview];
    //			[_bottomMenuView release];
    //			btnView.hidden = NO;
    //			btnView.transform = CGAffineTransformMakeScale(.2, .2);
    //
    //			[UIView animateWithDuration:0.3f animations:^{
    //				btnView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //			} completion:^(BOOL finished) {
    //				[UIView animateWithDuration:0.3f animations:^{
    //					btnView.transform = CGAffineTransformMakeScale(1, 1);
    //				} completion:^(BOOL finished) {
    //					[UIView animateWithDuration:0.2f animations:^{
    //						btnView.frame = CGRectMake(273,8,44,28);
    //					} completion:^(BOOL finished) {
    //						[btnView removeFromSuperview];
    //						[btnView release];
    //					}];
    //				}];
    //
    //			}];
    //
    //		}];
    //	}];
	
	// 하단메뉴 아래로 사라지고 상단 메뉴버튼 오른쪽에서 나타나는 에니메이션
	[UIView animateWithDuration:0.3f animations:^{
		[_bottomMenuView setFrame:CGRectMake(_bottomMenuView.frame.origin.x, viewHeight, _bottomMenuView.frame.size.width, _bottomMenuView.frame.size.height)];
	}completion:^(BOOL finished){
		[_bottomMenuView removeFromSuperview];
        //        [_bottomMenuView release];        // alloc 부분에 autorelease 추가로 삭제
		menuButton.hidden = NO;
		
        if (AppInfo.noticeState == 2)
        {
            /*
            //새로운 알림이 있고 확인 안했으면 알림확인을 퀵메뉴로 보여준다
            UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_MENU_BTN_TAG];
            [tmpBtn setHidden:YES];
            */
            [notiButton setHidden:NO];
        }else
        {
            //새로운 알림이 없거나 확인했다면 알림버튼을 숨긴다.
            //UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_NOTI_BTN_TAG];
            [notiButton setHidden:YES];
        }
        
		[UIView animateWithDuration:0.3f animations:^{
            [notiButton setFrame:CGRectMake(234, menuButton.frame.origin.y, menuButton.frame.size.width, menuButton.frame.size.height)];
			[menuButton setFrame:CGRectMake(262, menuButton.frame.origin.y, menuButton.frame.size.width, menuButton.frame.size.height)];
		}completion:^(BOOL finished){
			
		}];
	}];
	
	
}


- (void)dealloc
{
    [strBackButtonTitle release];
    [data release], data = nil;
    [dataList release], dataList = nil;
    [client release]; client = nil;
    [dataParser release]; dataParser = nil;
    [dataBinder release]; dataBinder = nil;
    
	[_bottomMenuView release];
	[panRecognizer release];
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 초기화.
        self.needsLogin = NO;
        self.dataParser = (SHBXmlDataParser *)[OFDataParser dataParser];
        self.dataBinder = (OFDataBinder *)[OFDataBinder dataBinder];
        //self.client = (SHBHTTPClient *)[OFHTTPClient httpClient];
        self.client = [[[SHBHTTPClient alloc] init] autorelease];
        //self.client = HTTPClient;
        self.client.delegate = self;
        
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    //ios7 + xcode5 대응
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {

        if (isPanGesture)
        {
            isPanGesture = NO;
            return;
        }
        if (!isQuickMenuSlideIn)
        {
            CGRect frame = [[UIScreen mainScreen] applicationFrame];
            //NSLog(@"%@", NSStringFromCGRect(frame));
            self.view.frame = frame;
        }else
        {
            //CGRect frame = [[UIScreen mainScreen] applicationFrame];
            //NSLog(@"%@", NSStringFromCGRect(frame));
            self.view.frame = CGRectMake(-95, 20, 320+95, self.view.frame.size.height);
        }
        
    }
    
    [super viewWillLayoutSubviews];
}

//ios7 + xcode5 대응
- (void)labeltextfieldinit:(UIView*)view
{
    
	if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *tempField = (UITextField *)view;
        
        if ([tempField.text length] == 0)
        {
            [view performSelector:@selector(setText:) withObject: @""];
        }
        
    }
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *tempLabel = (UILabel *)view;
        
        if ([tempLabel.text length] == 0)
        {
            [view performSelector:@selector(setText:) withObject: @""];
        }
        
    }
	if ([view.subviews count] > 0)
	{
		for (int i = 0; i < [view.subviews count]; i++)
		{
			[self labeltextfieldinit:[view.subviews objectAtIndex:i]];
		}
	}
}

//장차법 대응
- (void)controllerAccessablity:(UIView*)view
{
    
    if (self.view.frame.origin.x == 0)
    {
        //퀵메뉴 닫힐때....
        if (view.tag == NAVI_MENU_BTN_TAG || view.tag == QUICK_HOME_TAG || view.tag == QUICK_NOTICE_TAG || view.tag == QUICK_MYMENU_TAG || view.tag == QUICK_APPMORE_TAG || view.tag == QUICK_SETTING_TAG || view.tag == QUICK_LOGOUT_TAG || view.tag == 730603 || view.tag == 730604 || view.tag == 730605 || view.tag == 730606 || view.tag == 730607)
        {
            [view setIsAccessibilityElement:NO];
        }else
        {
            if (![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UIScrollView class]])
            {
                NSLog(@"해제");
                [view setIsAccessibilityElement:YES];
            }
            
        }
    }else
    {
        //퀵메뉴 펼쳐질때....
        if (view.tag == NAVI_MENU_BTN_TAG || view.tag == QUICK_HOME_TAG || view.tag == QUICK_NOTICE_TAG || view.tag == QUICK_MYMENU_TAG || view.tag == QUICK_APPMORE_TAG || view.tag == QUICK_SETTING_TAG || view.tag == QUICK_LOGOUT_TAG || view.tag == 730603 || view.tag == 730604 || view.tag == 730605 || view.tag == 730606 || view.tag == 730607)
        {
            
            [view setIsAccessibilityElement:YES];
        }else
        {
            [view setIsAccessibilityElement:NO];
        }
    }
    
    if ([view.subviews count] > 0)
	{
		for (int i = 0; i < [view.subviews count]; i++)
		{
			[self controllerAccessablity:[view.subviews objectAtIndex:i]];
		}
	}
}


- (void)viewDidLoad
{
    //NSString *msg = @"테스트입니다. 테스트입니다.";
    //NSString *msg = @"테스트입니다. 테스트입니다.뭐라고 테스트입니다.";
    //NSString *msg = @"테스트입니다. 테스트입니다.\n뭐라고 테스트입니다.absdkbaskdsldhflshdflsh";
    //NSString *msg = @"테스트입니다. 테스트입니다.\n뭐라고 테스트입니다.absdkbaskdsldhflshdflsh lkahsas성식이 준식이 사랑해 사랑해";
    //[UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:nil message:msg];
    
     #ifndef DEBUG
            disable_gdb();
            Debug(@"탈옥폰 체크!!!");
        #if TARGET_IPHONE_SIMULATOR
            // -> Module/AhnLab/ 에서 .h파일은 냅두고 .a 라이브러리 파일은 프로젝트에서 빼면~ 시뮬레이터는 정상 작동합니다...- -;
            
        #else //TARGET_IPHONE_DEVICE
    
            amsLibrary *ams = [[amsLibrary alloc] init];
            NSInteger  iResult = [ams a3142:@"AHN_3379024345_TK"];
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            NSInteger roundValue = round(interval);
    
            [ams release];
    
            NSInteger chkRtn = (long)(iResult - roundValue);
            if((long)chkRtn > 201) {
                
                //탈옥폰
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                alert.tag = 92673;
                [alert show];
                [alert release];
                 */
                
                //[UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:92673 title:nil buttonTitle:@"확인" message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."];
                [AppInfo xkfdhrAlert];
                return;
            }
        #endif
    #endif
    
    //xocde5 대응(textfield 에 값이 없으면 널값이 딕셔너리에 세팅되어 죽는 현상 방지)
    for (UIView *subview in self.view.subviews)
    {
        //if ([subview isKindOfClass: [UILabel class]] || [subview isKindOfClass:[UITextField class]])
        //{
            [self labeltextfieldinit:subview];
        //}
    }
    
    [super viewDidLoad];
	
    
    AppInfo.isNeedBackWhenError = NO;
    
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
    // Default Size Setting
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width, contentScrollView.frame.size.height + 20.0f);
    }else
    {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width, contentScrollView.frame.size.height);
    }
    
    
    displayKeyboard = NO;
    startTextFieldTag = 0;
    endTextFieldTag = 0;
    AppInfo.isNeedClearData = NO;
    
    
	if ([NSStringFromClass([self class]) isEqualToString:@"SHBSecretCardViewController"] || [NSStringFromClass([self class]) isEqualToString:@"SHBSecretOTPViewController"]){
		// OTP뷰 혹은 보안카드뷰 일경우 리사이즈 하지 않는다.
	}else{
		self.view.frame = CGRectMake(0, 0, 320, viewHeight);
	}
	
	self.navigationController.navigationBarHidden = YES;
	
	// Gesture 등록
	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
	panRecognizer.delegate = self;
	panRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:panRecognizer];
	
    //ios7 + xcode5 대응
    BOOL isAdjuest = NO; BOOL isOK1 = NO; BOOL isOK2 = NO;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        for( UIView *sView in [self.view subviews] )
        {
            //NSLog(@"object:%@",NSStringFromClass([sView class]));
            
            
            if ([NSStringFromClass([sView class]) isEqualToString:@"UIView"] && [[self.view subviews] count] == 2)
            {
                isOK1 = YES;
            }
            if ([NSStringFromClass([sView class]) isEqualToString:@"UIScrollView"] && [[self.view subviews] count] == 2)
            {
                isOK2 = YES;
            }
            if (isOK1 && isOK2)
            {
                isAdjuest = YES;
                break;
            }
        }
    }
	// Object 44픽셀만큼 자동 위치 조정
    // release 추가
	overClassArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	for( UIView *sView in [self.view subviews] ){
        
        
        
		float overHeight = sView.frame.origin.y + sView.frame.size.height + 44;
		float height = sView.frame.size.height;
		if (overHeight > viewHeight){
			NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
			[mDic setObject:sView	forKey:@"class"];
			[mDic setObject:[NSString stringWithFormat:@"%f",height]	forKey:@"height"];
			[overClassArray addObject:mDic];
			[mDic release];
			
			height -= 44;
		}
        
        if ([NSStringFromClass([sView class]) isEqualToString:@"UIScrollView"] && [[self.view subviews] count] == 1)
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                //NSLog(@"sView.frame.origin.y:%f",sView.frame.origin.y);
                [sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y + 24, sView.frame.size.width, height + 20)];
            }else
            {
                [sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y + 44, sView.frame.size.width, height)];
            }
            
        }else if (isAdjuest && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            //NSLog(@"super self.contentScrollView.frame.origin.y:%f",self.contentScrollView.frame.origin.y);
            if ([NSStringFromClass([sView class]) isEqualToString:@"UIScrollView"] && self.contentScrollView.frame.origin.y != 0)
            {
                [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, sView.frame.origin.y + 24, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height - 24)];
                [self.view sendSubviewToBack:self.contentScrollView];
                
            }else
            {
                [sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y + 44, sView.frame.size.width, height)];
            }
            
            
        }else
        {
            [sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y + 44, sView.frame.size.width, height)];
        }
		
	}
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
	// NavigationView Add
	[self drawNavigationView];
	
	// Quick Menu View Add
    [self drawQuickMenu];
    //[self changeBottmNotice:AppInfo.noticeState];
    
    
    if (AppInfo.noticeState == 2)
    {
        /*
        //새로운 알림이 있고 확인 안했으면 알림확인을 퀵메뉴로 보여준다
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_MENU_BTN_TAG];
        [tmpBtn setHidden:YES];
        */
    }else
    {
        //새로운 알림이 없거나 확인했다면 알림버튼을 숨긴다.
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_NOTI_BTN_TAG];
        [tmpBtn setHidden:YES];
    }
    
    
	// 메인메뉴, 알림, 마이메뉴 등의 화면에 따라 네비게이션 및 아래메뉴를 컨트롤
	if ([NSStringFromClass([self class]) isEqualToString:@"SHBMainViewController"]){
		[self navigationViewHidden];
		[self setBottomMenuView];
	}else if ([NSStringFromClass([self class]) isEqualToString:@"SHBNoticeMenuViewController"]){
		
	}else if ([NSStringFromClass([self class]) isEqualToString:@"SHBNoticeMenuNotLogInViewController"]){
        
    }else if ([NSStringFromClass([self class]) isEqualToString:@"SHBMyMenuViewController"]){
		
	}else if ([NSStringFromClass([self class]) isEqualToString:@"SHBMoreAppViewController"]){
		
	}else if ([NSStringFromClass([self class]) isEqualToString:@"SHBSettingsViewController"]){
		// 기존에 뷰컨트롤러 리무브
		NSMutableArray *viewArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
		for (int i = [viewArray count] - 2; i > 0; i --){
			[viewArray removeObjectAtIndex:i];
		}
		self.navigationController.viewControllers = viewArray;
        
        // release 추가
        [viewArray release];
		
	}else if ([NSStringFromClass([self class]) isEqualToString:LOGIN_CLASS]){
		if ([self.navigationController.viewControllers count] == 2 && AppInfo.isFirstOpen){
			AppInfo.isFirstOpen = NO;
			[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(animationBottomMenu) userInfo:nil repeats:NO];
		}else{
			if (AppInfo.isSingleLogin){
				// 기존에 뷰컨트롤러 리무브
				NSMutableArray *viewArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
				for (int i = [viewArray count] - 2; i > 0; i --){
					[viewArray removeObjectAtIndex:i];
				}
				self.navigationController.viewControllers = viewArray;
                //NSLog(@"aaaa:%@",self.navigationController.viewControllers);
                // release 추가
                [viewArray release];
			}
		}
		
	}else{
		if ([self.navigationController.viewControllers count] == 2 && AppInfo.isFirstOpen){
			AppInfo.isFirstOpen = NO;
			[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(animationBottomMenu) userInfo:nil repeats:NO];
		}
	}
	
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        //핫스팟이나 통화중일때... 화면 조정
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(test)
                                                     name:@"didChangeStatusBarFrame"
                                                   object:nil];
    }
}
- (void)test
{
    NSLog(@"self.view.y:%f",self.view.frame.origin.y);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	panRecognizer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
	
    
    if (AppInfo.noticeState == 2)
    {
        /*
        //새로운 알림이 있고 확인 안했으면 알림확인을 퀵메뉴로 보여준다
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_MENU_BTN_TAG];
        [tmpBtn setHidden:YES];
        */
        
    }else
    {
        //새로운 알림이 없거나 확인했다면 알림버튼을 숨긴다.
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_NOTI_BTN_TAG];
        [tmpBtn setHidden:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // keyboard가 올라온 상태에서 back시 문제 수정.
    //curTextField.delegate = nil;
	curTextField = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
}

//ios5 이하(하위 뷰 컨트롤러에 자동 상속 되므로 구현할 필요 없음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //보안 키패드 숫자 가로모드를 지원하지 않을 경우 처리
    if (AppInfo.isLandScapeKeyPadBolck)
    {
        return NO;
    }
    
    if (AppInfo.isSecurityKeyPad && !AppInfo.isSecurityKeyClose)
    {
        
        if (AppInfo.isForceRotate && [[UIDevice currentDevice] orientation] == UIInterfaceOrientationMaskPortrait)
        {
            return (interfaceOrientation ==UIInterfaceOrientationPortrait);
        } else
        {
            //if (AppInfo.isForceRotate && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
            if (AppInfo.isForceRotate)
            {
                [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
            }
            return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
        }
        
        //return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
        
    }else
    {
        if (AppInfo.isForceRotate)
        {
            //노티 날림
            //if (AppInfo.beforeRotateDirect == UIInterfaceOrientationPortrait && AppInfo.isSecurityKeyPad && !AppInfo.isSecurityKeyClose)
            if (AppInfo.isSecurityKeyPad && !AppInfo.isSecurityKeyClose)
            {
                
                return (interfaceOrientation == UIInterfaceOrientationPortrait);
                
            } else
            {
                
                [[NSNotificationCenter  defaultCenter] postNotificationName:@"forcerotateView" object:nil];
                return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
                
            }
            
        }
        
        
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
    return NO;
}

//ios6 이상(하위 뷰 컨트롤러에 자동 상속 되므로 구현할 필요 없음)
- (BOOL)shouldAutorotate
{
    
    return YES;
    
}

- (NSUInteger) supportedInterfaceOrientations
{
    
    //보안 키패드 숫자 가로모드를 지원하지 않을 경우 처리
    if (AppInfo.isLandScapeKeyPadBolck)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    if (AppInfo.isSecurityKeyPad && !AppInfo.isSecurityKeyClose)
    {
        
        if (AppInfo.isForceRotate && [[UIDevice currentDevice] orientation] == UIInterfaceOrientationMaskPortrait)
        {
            return UIInterfaceOrientationMaskPortrait;
        } else
        {
            
            if (AppInfo.isForceRotate)
            {
                [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationMaskPortrait];
            }
            return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
        }
        
    }else
    {
        if (AppInfo.isForceRotate)
        {
            
            if (AppInfo.isSecurityKeyPad && !AppInfo.isSecurityKeyClose)
            {
                
                return UIInterfaceOrientationMaskPortrait;
                
            } else
            {
                
                //[[NSNotificationCenter  defaultCenter] postNotificationName:@"forcerotateView" object:nil];
                return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
                
            }
            
        }
        
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskPortrait;
    
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    AppInfo.beforeRotateDirect = fromInterfaceOrientation; //회전전 회전 상태를 저장한다.
    
    if (AppInfo.isForceRotate && (fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight || fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft))
    {
        [[NSNotificationCenter  defaultCenter] postNotificationName:@"forcerotateView" object:nil];
    }
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"rotateView" object:nil];
}

#pragma mark - 퍼블릭 메서드

- (void)changeBottmNotice:(int)notiState
{
    /*
     UIButton *quickButton = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_MENU_BTN_TAG];
     UIView *quickView = (UIView*)[self.view viewWithTag:QUICK_VIEW_TAG];
     UIButton *logButton = (UIButton*)[quickView viewWithTag:QUICK_NOTICE_TAG];
     if (!quickButton.hidden)
     {
     if (notiState == 0)
     {
     [logButton setAccessibilityLabel:@""];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1.png"] forState:UIControlStateNormal];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateHighlighted];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateDisabled];
     } else if (notiState == 1) //업데이트
     {
     //footermenu_7
     [logButton setAccessibilityLabel:@"업데이트"];
     [logButton setImage:[UIImage imageNamed:@"footermenu_7.png"] forState:UIControlStateNormal];
     [logButton setImage:[UIImage imageNamed:@"footermenu_7_focus.png"] forState:UIControlStateHighlighted];
     [logButton setImage:[UIImage imageNamed:@"footermenu_7_focus.png"] forState:UIControlStateDisabled];
     } else if (notiState == 2)
     {
     [logButton setAccessibilityLabel:@"새알림"];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1_1.png"] forState:UIControlStateNormal];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1_1_focus.png"] forState:UIControlStateHighlighted];
     [logButton setImage:[UIImage imageNamed:@"footermenu_1_1_focus.png"] forState:UIControlStateDisabled];
     }
     }
     */
    
    if (_bottomMenuView){
		[_bottomMenuView changeNotiImage:notiState];
	}
}
- (void)changeQuickLogin:(BOOL)logIn{
	Debug(@"Quick Menu 및 바텀뷰를 다시 그린다. !!!");
    //	UIButton *quickButton = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_MENU_BTN_TAG];
    //	if (!quickButton.hidden){
    //		UIView *quickView = (UIView*)[self.view viewWithTag:QUICK_VIEW_TAG];
    //		UIButton *logButton = (UIButton*)[quickView viewWithTag:QUICK_LOGOUT_TAG];
    //
    //		if (logIn){
    //			[logButton setImage:[UIImage imageNamed:@"quickmenu_logout_on.png"] forState:UIControlStateNormal];
    //			[logButton setImage:[UIImage imageNamed:@"quickmenu_logout.png"] forState:UIControlStateHighlighted];
    //
    //		}else{
    //			[logButton setImage:[UIImage imageNamed:@"quickmenu_login.png"] forState:UIControlStateNormal];
    //			[logButton setImage:[UIImage imageNamed:@"quickmenu_login_on.png"] forState:UIControlStateHighlighted];
    //		}
    //	}
	
    //Quick Menu를 다시 그린다.
    //메인뷰제외
    if (![NSStringFromClass([self class]) isEqualToString:@"SHBMainViewController"])
    {
        [self drawQuickMenu];
    }
    
	if (_bottomMenuView)
    {
        
        float	viewHeight;
        if (AppInfo.isiPhoneFive)
            viewHeight = 568;
        else
            viewHeight = 480;
        
        if (logIn)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotice" object:nil];
            
            //개인화 이미지와 문구가 잇는지 확인하여 분기 처리 ////////////////////////////////////////////////////////////////////////////////////////////
            BOOL isPersonality = NO;
            
            if ([AppInfo.userInfo[@"피싱방지이미지"] length] > 0 || [AppInfo.userInfo[@"피싱방지문구"] length] > 0)
            {
                isPersonality = YES;
            }
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //로그인되었다는 개인화 뷰를 보여준다.
            if (loginInfoView == nil)
            {
                if (isPersonality)
                {
                    //개인화
                    loginInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 109, 320, 109)];
                }else
                {
                    //개인화 아님
                    loginInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 88, 320, 88)];
                }
                
            }
            
            loginInfoView.backgroundColor = [UIColor clearColor];
            UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mark.png"]];
            [topImg setFrame:CGRectMake(14, 0, 28, 39)];
            
            UIImageView *bgImg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_login_bottom.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
            if (isPersonality)
            {
                //개인화
                [bgImg setFrame:CGRectMake(0, 2, 320, 107)];
            }else
            {
                //개인화 아님
                [bgImg setFrame:CGRectMake(0, 2, 320, 86)];
            }
            
            UILabel *connectInfoLabel1;
            
            if (isPersonality)
            {
                //개인화
                connectInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 320, 30)];
            }else
            {
                //개인화 아님
                connectInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 30)];
            }
            
            connectInfoLabel1.backgroundColor = [UIColor clearColor];
            connectInfoLabel1.textAlignment = UITextAlignmentCenter;
            connectInfoLabel1.textColor = [UIColor whiteColor];
            connectInfoLabel1.font = [UIFont systemFontOfSize:19];
            connectInfoLabel1.text = [NSString stringWithFormat:@"%@ 고객님! 안녕하세요",[AppInfo.userInfo objectForKey:@"고객성명"]];
            
            UILabel *connectInfoLabel2;
            
            if (isPersonality)
            {
                //개인화
                connectInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 320, 30)];
            }else
            {
                //개인화 아님
                connectInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 30)];
            }
            
            
            connectInfoLabel2.backgroundColor = [UIColor clearColor];
            connectInfoLabel2.textAlignment = UITextAlignmentCenter;
            connectInfoLabel2.textColor = [UIColor whiteColor];
            connectInfoLabel2.font = [UIFont systemFontOfSize:15];
            if ([[AppInfo.userInfo objectForKey:@"최종접속일자"] length] > 0 && [[AppInfo.userInfo objectForKey:@"최종접속시간"] length] > 0)
            {
                connectInfoLabel2.text = [NSString stringWithFormat:@"최근접속일자:%@ %@",[AppInfo.userInfo objectForKey:@"최종접속일자"], [AppInfo.userInfo objectForKey:@"최종접속시간"]];
            }
            
            [loginInfoView addSubview:bgImg];
            [loginInfoView addSubview:topImg];
            [loginInfoView addSubview:connectInfoLabel1];
            [loginInfoView addSubview:connectInfoLabel2];
            
            //개인화 이미지 설정 //////////////////////////////
            if (isPersonality)
            {
                UIImageView *personalBgView = [[UIImageView alloc] initWithFrame:CGRectMake(68, 66, 184, 34)];
                personalBgView.image = [UIImage imageNamed:@"bg_message_box.png"];
                
                //개인화 이미지
                //UIImageView *personalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 2, 18, 18)];
                UIImageView *personalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 2, 29, 29)];
                NSString *tmpImgName = AppInfo.userInfo[@"피싱방지이미지"];
                NSString *personalImage = [NSString stringWithFormat:@"%@.png",tmpImgName];
                personalImgView.image = [UIImage imageNamed:personalImage];
                personalImgView.tag = 75225;
                
                //개인화 텍스트
                //UILabel *personalLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 3, 136, 18)];
                UILabel *personalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 164, 18)];
                personalLabel.backgroundColor = [UIColor clearColor];
                personalLabel.font = [UIFont systemFontOfSize:12];
                personalLabel.textColor = [UIColor whiteColor];
                personalLabel.textAlignment = UITextAlignmentCenter;
                personalLabel.text = AppInfo.userInfo[@"피싱방지문구"];
                personalLabel.tag = 75226;
                
                [personalBgView addSubview:personalImgView];
                [personalBgView addSubview:personalLabel];
                
                [loginInfoView addSubview:personalBgView];
            }
            
            //////////////////////////////////////////////
            [bgImg release];
            [topImg release];
            [connectInfoLabel1 release];
            [connectInfoLabel2 release];
            
            if (!AppInfo.isFishingDefence)
            {
                AppInfo.isFishingDefence = YES;
                [AppDelegate.window addSubview:loginInfoView];
                
                loginInfoView.transform = CGAffineTransformMakeScale(.2, .2);
                loginInfoView.alpha = 0;
                //
                [UIView animateWithDuration:.5 animations:^{
                    loginInfoView.alpha = 1;
                    loginInfoView.transform = CGAffineTransformMakeScale(1, 1);
                }completion:^(BOOL finished){
                    
                    [self performSelector:@selector(loginInfoViewFadeOut) withObject:nil afterDelay:5];
                    
                }];

            }
            
        }
        
		[_bottomMenuView changeLogInOut:logIn];
        
	}
	
}

- (void)resetFishingDefence
{
    UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:75225];
    UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:75226];
    
    if ([AppInfo.commonDic[@"업무"] isEqualToString:@"fishing_dismiss"])
    {
        tmpImgView.image = nil;
        tmpLabel.text = @"";
    }
}

- (void)slideIn{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [(UIView*)[self.view viewWithTag:QUICK_VIEW_TAG] setHidden:NO];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(-95, 20, 320+95, self.view.frame.size.height)];
    }else
    {
        [self.view setFrame:CGRectMake(-95, 0, 320+95, self.view.frame.size.height)];
    }
    
    [UIView commitAnimations];
    
    UIButton *dimmButton1 = (UIButton*)[self.view viewWithTag:MAIN_DIMM_BTN_TAG];
    UIButton *dimmButton2 = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_DIMM_BTN_TAG];
    [dimmButton1 setHidden:NO];
    [dimmButton2 setHidden:NO];
    
    //장차법대응
//    if (UIAccessibilityIsVoiceOverRunning())
//    {
//        for (UIView *subview in self.view.subviews)
//        {
//            
//            [self controllerAccessablity:subview];
//            
//        }
//    }
    
	
}
- (void)slideOut{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
    }else
    {
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    }
	
	[UIView commitAnimations];
	
	UIButton *dimmButton1 = (UIButton*)[self.view viewWithTag:MAIN_DIMM_BTN_TAG];
	UIButton *dimmButton2 = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_DIMM_BTN_TAG];
	[dimmButton1 setHidden:YES];
	[dimmButton2 setHidden:YES];
    //	[(UIView*)[self.view viewWithTag:QUICK_VIEW_TAG] setHidden:YES];
	
    
    //장차법대응
//    if (UIAccessibilityIsVoiceOverRunning())
//    {
//        for (UIView *subview in self.view.subviews)
//        {
//            
//            [self controllerAccessablity:subview];
//            
//        }
//    }
}

- (void)setTitle:(NSString *)title{
	UIView *navigationView = (UIView*)[self.view viewWithTag:NAVI_VIEW_TAG];
	UILabel *titleLabel = (UILabel*)[navigationView viewWithTag:NAVI_TITLE_TAG];
	titleLabel.Text = title;
	if ([title length] > 10){
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	}else{
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
	}
}


#pragma mark -
#pragma mark home Button Pressed

- (void)homeButtonPressed:(id)sender
{
    UIButton *trickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trickButton setTag:QUICK_HOME_TAG];
    [self navigationButtonPressed:trickButton];
    
}

- (void)homeButtonLongPressed:(id)sender
{
    // 이전 버튼이 존재할 경우 처리
    if ([self.view viewWithTag:HOME_BUTTON_TAG])
    {
        [[self.view viewWithTag:HOME_BUTTON_TAG] removeFromSuperview];
    }
}

//알림으로만가기
- (void)notiButtonPressed
{
    AppInfo.indexQuickMenu = 1;
    [self pushViewControllerQuickMenu:QUICK_NOTICE_TAG];
}

- (void)navigationButtonPressed:(id)sender{
    
    if (AppInfo.lastViewController != nil)
    {
        AppInfo.lastViewController = nil;
    }
	UIButton *btnSender = (UIButton*)sender;
    //ios7 + xcode5 대응
    isQuickMenuSlideIn = NO;
	switch (btnSender.tag) {
		case NAVI_BACK_BTN_TAG:
			// 이전버튼
            
			[self.navigationController fadePopViewController];
			break;
		case NAVI_CLOSE_BTN_TAG:
			[self.navigationController fadePopToRootViewController];
			break;
		case NAVI_MENU_BTN_TAG:
			// 퀵메뉴버튼
			if (self.view.frame.origin.x == 0) {
                //ios7 + xcode5 대응
                isQuickMenuSlideIn = YES;
                [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴닫기";
				[self slideIn];
			}else{
                [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴보기";
				[self slideOut];
			}
			break;
			
		case NAVI_DIMM_BTN_TAG:
		case MAIN_DIMM_BTN_TAG:
			// 딤버튼(퀵메뉴닫기)
            [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴보기";
			[self slideOut];
			break;
			
		case QUICK_HOME_TAG:
			// 홈버튼
			AppInfo.indexQuickMenu = 0;
			[self.navigationController fadePopToRootViewController];
			break;
		case QUICK_NOTICE_TAG:	// 알림버튼
            AppInfo.indexQuickMenu = 1;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_MYMENU_TAG:	// 마이메뉴버튼
            AppInfo.indexQuickMenu = 2;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_APPMORE_TAG:	// 앱더보기버튼
            AppInfo.indexQuickMenu = 3;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_SETTING_TAG:	// 환경설정버튼
            AppInfo.indexQuickMenu = 4;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_LOGOUT_TAG:	// 로그아웃버튼
            isQuickLogin = YES;
			[self pushViewControllerQuickMenu:btnSender.tag];
			break;
			
		default:
			break;
	}
}

- (void)navigationViewHidden{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIView *menuLineView   = [self.view viewWithTag:QUICK_LINE_TAG];
	[navigationView setHidden:YES];
	[menuLineView setHidden:YES];
	
    //	float	viewHeight;
    //	if (AppInfo.isiPhoneFive)
    //		viewHeight = 548;
    //	else
    //		viewHeight = 460;
	
	// Object 44픽셀만큼 자동 위치 조정
	for( UIView *sView in [self.view subviews] ){
        //		float overHeight = sView.frame.origin.y + sView.frame.size.height + 44;
        //		float height = sView.frame.size.height;
        //		if (overHeight > viewHeight){
        //			height -= 44;
        //		}
		
		[sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y - 44, sView.frame.size.width, sView.frame.size.height)];
	}
	
	for (int i=0; i < [overClassArray count]; i++) {
		UIView *sView = [[overClassArray objectAtIndex:i] objectForKey:@"class"];
		float orgHeight = [[[overClassArray objectAtIndex:i] objectForKey:@"height"] floatValue];
		
		[sView setFrame:CGRectMake(sView.frame.origin.x, sView.frame.origin.y, sView.frame.size.width, orgHeight)];
	}
	
	// Gesture Remove
	[self.view removeGestureRecognizer:panRecognizer];
}

- (void)navigationBackButtonShow{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *backButton   = (UIButton*)[navigationView viewWithTag:NAVI_BACK_BTN_TAG];
	[backButton setHidden:NO];
}

- (void)navigationBackButtonHidden{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *backButton   = (UIButton*)[navigationView viewWithTag:NAVI_BACK_BTN_TAG];
	[backButton setHidden:YES];
}

- (void)navigationBackButtonEnglish{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *backButton   = (UIButton*)[navigationView viewWithTag:NAVI_BACK_BTN_TAG];
    UIButton *menuButton   = (UIButton*)[navigationView viewWithTag:NAVI_MENU_BTN_TAG];
	[backButton setTitle:@" Back" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    
}

- (void)navigationBackButtonJapnes{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *backButton   = (UIButton*)[navigationView viewWithTag:NAVI_BACK_BTN_TAG];
    UIButton *menuButton   = (UIButton*)[navigationView viewWithTag:NAVI_MENU_BTN_TAG];
	[backButton setTitle:@" 戻る" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [menuButton setTitle:@"メニュー" forState:UIControlStateNormal];
}

- (void)quickMenuHidden{
	UIView *navigationView = [self.view viewWithTag:NAVI_VIEW_TAG];
	UIButton *menuButton   = (UIButton*)[navigationView viewWithTag:NAVI_MENU_BTN_TAG];
	UIButton *closeButton  =(UIButton*)[navigationView viewWithTag:NAVI_CLOSE_BTN_TAG];
	UIView *menuLineView   = [self.view viewWithTag:QUICK_LINE_TAG];
	[menuButton setHidden:YES];
	//[menuLineView setHidden:YES];
    [menuLineView setHidden:NO];
    [closeButton setHidden:YES];
    //[closeButton setHidden:NO];
	
	// Gesture Remove
	[self.view removeGestureRecognizer:panRecognizer];
}

- (void)pushViewControllerQuickMenu:(int)tag{
    
    if (AppInfo.lastViewController != nil)
    {
        AppInfo.lastViewController = nil;
    }
    
	if (tag == QUICK_HOME_TAG){
		// HOME
		[self.navigationController fadePopToRootViewController];
	}else if (tag == QUICK_NOTICE_TAG){
		// 알림
        /*
        //2014.07.09 변경 : 로그인전과 로그인 후 알림 메인 UI 변경
        if (AppInfo.isLogin == LoginTypeNo)
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuNotLogInViewController") class] alloc] initWithNibName:@"SHBNoticeMenuNotLogInViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }else
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }
		*/
        //2014.09.26 변경 : 알림 메인 UI 변경
        if (AppInfo.noticeState == 2)
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }else
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuNotLogInViewController") class] alloc] initWithNibName:@"SHBNoticeMenuNotLogInViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }
        
        
	}else if (tag == QUICK_MYMENU_TAG){
		// 마이메뉴
		UIViewController *viewController = [[[NSClassFromString(@"SHBMyMenuViewController") class] alloc] initWithNibName:@"SHBMyMenuViewController" bundle:nil];
		[SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
		[self.navigationController fadePopToRootViewController];
		[AppDelegate.navigationController pushSlideUpViewController:viewController];
		[viewController release];
	}else if (tag == QUICK_APPMORE_TAG){
		// 앱더보기
		UIViewController *viewController = [[[NSClassFromString(@"SHBAppPlusViewController") class] alloc] initWithNibName:@"SHBAppPlusViewController" bundle:nil];
		[SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
		[self.navigationController fadePopToRootViewController];
		[AppDelegate.navigationController pushSlideUpViewController:viewController];
		[viewController release];
	}else if (tag == QUICK_SETTING_TAG){
		//환경설정
		UIViewController *viewController = [[[NSClassFromString(@"SHBSettingsViewController") class] alloc] initWithNibName:@"SHBSettingsViewController" bundle:nil];
		[SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
		[self.navigationController fadePopToRootViewController];
		[AppDelegate.navigationController pushSlideUpViewController:viewController];
		[viewController release];
	}else if (tag == QUICK_LOGOUT_TAG){
		if ([SHBAppInfo sharedSHBAppInfo].isLogin){
            //			// 로그아웃
            //			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            //															message:@"신한S뱅크를 로그아웃 하시겠습니까?"
            //														   delegate:self
            //												  cancelButtonTitle:nil
            //												  otherButtonTitles:@"예", @"아니오",nil];
            //			alert.tag = 9999999;
            //			[alert show];
            //			[alert release];
            
            if ([NSStringFromClass([self class]) isEqualToString:@"SHBMainViewController"])
            {
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"신한S뱅크를 로그아웃 하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오",nil];
                alert.tag = 9999999;
                [alert show];
                [alert release];
                 */
                [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:9999999 title:nil buttonTitle:@"예,아니오" message:@"신한S뱅크를 로그아웃 하시겠습니까?"];
            } else
            {
                [AppInfo logoutAlert];
            }
			
		}else{
            
			// 로그인화면 오픈
            AppInfo.isSingleLogin = YES;
            AppInfo.certProcessType = CertProcessTypeInFotterLogin;
            
            //지정된 공인인증서가 있다면...
            if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected)
            {
                //이미 화면이 오픈되어 있는지 확인
                //NSLog(@"aaaa:%@",[AppDelegate.navigationController viewControllers]);
                
                [AppInfo loadCertificates];
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                //viewController.whereAreYouFrom = FromLogin;
                //[self.navigationController pushFadeViewController:viewController];
                viewController.needsCert = YES;
                [self checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
                
            } else if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificate)
            {
                //이미 화면이 오픈되어 있는지 확인
                
                SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                
                viewController.isSignupProcess = YES;
                
                //viewController.whereAreYouFrom = FromLogin;
                //[self.navigationController pushFadeViewController:viewController];
                viewController.needsCert = YES;
                [self checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            } else
            {
                if (isQuickLogin)
                {
                    isQuickLogin = NO;
                    //NSString *msg = @"로그인 후, 메인화면으로\n이동합니다.\n로그인 하시겠습니까?";
                    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:5555555 title:@"" message:msg];
                    [AppInfo moveLoginAlert];
                } else
                {
                    //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
                    if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
                    {
                        [AppInfo loadCertificates];
                        AppInfo.certProcessType = CertProcessTypeLogin;
                        //인증서가 한개이면 인증서 상세 화면
                        if (AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
                        {
                            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                            [self.navigationController pushFadeViewController:viewController];
                            [viewController release];
                        }else
                        {
                            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                            [self.navigationController pushFadeViewController:viewController];
                            [viewController release];
                        }
                    }else
                    {
                        UIViewController *viewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                        [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
                        [self.navigationController pushFadeViewController:viewController];
                        [viewController release];
                    }
                    
                }
                
                
                /*
                 UIViewController *viewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                 [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
                 [self.navigationController pushFadeViewController:viewController];
                 [viewController release];
                 */
            }
		}
		
	}
	
}

- (void)setBackgroundDimm:(int)viewTag DimmFlag:(BOOL)flag{
	UIButton *mainDimm = (UIButton*)[self.view viewWithTag:MAIN_DIMM_BTN_TAG];
	UIButton *naviDimm = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_DIMM_BTN_TAG];
	switch (viewTag) {
		case 0:		// 둘다
			[mainDimm setHidden:flag];
			[naviDimm setHidden:flag];
			break;
		case 1:		// 상단의 네비게이션바만
			[naviDimm setHidden:flag];
			break;
		case 2:		// 중앙의 메인영역만
			[mainDimm setHidden:flag];
			break;
		default:
			break;
	}
	
}

- (void)setBottomMenuView{
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
	if (!_bottomMenuView)
        // release 추가
		_bottomMenuView = [[[SHBBottomView alloc] initWithFrame:CGRectMake(0, viewHeight - 49, self.view.frame.size.width, 49)] autorelease];
	
	if (AppInfo.isLogin){
		[_bottomMenuView changeLogInOut:YES];
	}else{
		[_bottomMenuView changeLogInOut:NO];
	}
	
    [self changeBottmNotice:AppInfo.noticeState];
	[_bottomMenuView setDelegate:self];
	[self.view addSubview:_bottomMenuView];
	
}
- (void)blockAccessBottomMenuView:(BOOL)isBlock
{
    
    [_bottomMenuView blockAccessbility:isBlock];
    
}
- (void)checkLoginBeforePushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (AppInfo.lastViewController != nil)
    {
        AppInfo.lastViewController = nil;
    }
    // 로그인 후 이동할 화면의 뷰컨트롤러.
    if (viewController == nil)
    {
        NSLog(@"푸시 AppInfo.lastViewController 널값입니다");
    }
    AppInfo.lastViewController = viewController;
    AppInfo.commonNotiOption = -1;
    if (((SHBBaseViewController*)viewController).needsCert)
    {
        AppInfo.lastViewControllerNeedCert = YES;
    } else
    {
        AppInfo.lastViewControllerNeedCert = NO;
    }
    if (!AppInfo.isLogin)
    {
        [AppInfo loadCertificates];
        //초기 설정 또는 설정에서 인증서 지정하고 로그인이 필요한 메뉴라면
        //if (([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected && AppInfo.selectedCertificate != nil) && (((SHBBaseViewController *)viewController).needsLogin || ((SHBBaseViewController*)viewController).needsCert))
        if (([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected) && (((SHBBaseViewController *)viewController).needsLogin || ((SHBBaseViewController*)viewController).needsCert))
        {
            //지정된 공인인증서가 있다면...
            if (AppInfo.selectedCertificate != nil)
            {
                
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                viewController.whereAreYouFrom = FromLogin;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
                
            } else
            {
                [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeDefault];
                [[NSUserDefaults standardUserDefaults]setCertificateData:nil];
                NSString *msg = @"로그인 설정으로 지정해 놓은\n인증서가 삭제되거나 만료되어,\n로그인 설정이 초기화 되었습니다.\n기본 로그인 화면으로 이동합니다.\n\n(환경 설정 메뉴에서\n로그인설정을 변경하실 수 있습니다.)";
                //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:5555555 title:@"" message:msg];
                [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:5555555 title:nil buttonTitle:nil message:msg];
                return;
                
                
            }
            
        } else if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificate && (((SHBBaseViewController *)viewController).needsLogin || ((SHBBaseViewController*)viewController).needsCert))
        {
            if (AppInfo.certificateCount < 1)
            {
                SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
                return;
            }
            
            if (AppInfo.certificateCount == 1){
                
                
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
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
                
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
                
                
            }
            
        }else if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeDefault && (((SHBBaseViewController*)viewController).needsCert))
        {
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"예", @"아니오",nil];
            alert.tag = 1999998;
            [alert show];
            [alert release];
             */
            [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:1999998 title:nil buttonTitle:@"예,아니오" message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"];
        }else if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeDefault && (((SHBBaseViewController *)viewController).needsLogin || ((SHBBaseViewController*)viewController).needsCert))
            
        {
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            
        }else if (((SHBBaseViewController *)viewController).needsLogin)
        {
			if (![NSStringFromClass([viewController class]) isEqualToString:LOGIN_CLASS]){
				AppInfo.isSingleLogin = NO;
                
                //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
                if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                    //인증서가 한개이면 인증서 상세 화면
                    if (AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
                    {
                        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                        [self.navigationController pushFadeViewController:viewController];
                        [viewController release];
                    }else
                    {
                        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                        [self.navigationController pushFadeViewController:viewController];
                        [viewController release];
                    }
                }else
                {
                    UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                    [self.navigationController pushFadeViewController:loginViewController];
                    [loginViewController release];
                }
				
            }
		}else if (((SHBBaseViewController*)viewController).needsCert && AppInfo.isLogin == LoginTypeNo)
        {
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"예", @"아니오",nil];
            alert.tag = 1999998;
            [alert show];
            [alert release];
            */
            [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:1999998 title:nil buttonTitle:@"예,아니오" message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"];
            
		}else
        {
			[self.navigationController pushFadeViewController:viewController];
		}
        
    }else if (AppInfo.isLogin == LoginTypeIDPW && ((SHBBaseViewController*)viewController).needsCert)
    {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"예", @"아니오",nil];
		alert.tag = 1999997;
		[alert show];
		[alert release];
		*/
        [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:1999997 title:nil buttonTitle:@"예,아니오" message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"];
	}
    else
    {
        // 신한카드 메뉴 선택인 경우 이용동의 체크
        if ([NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCard"]) {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 보안센터 이용기기등록서비스 선택시
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBDeviceRegistServiceViewController"]) {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 지로 지방세의 경우
        // 메뉴 1,2,3,4 경우 시간 확인이 필요
        // 메뉴 진입전 처리
        else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBGiroTax"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBDistricTaxMenu"])
        {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 퇴직연금의 경우
        // 퇴직연금의 메뉴 1,2,3,4,5 경우 가입 유무와 동의 확인이 필요하다
        // 메뉴 진입 전 로그인 후에 처리되고 있음(2군데)
        else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReserve"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBProductState"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBSurcharge"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReceip"]|| [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBESNoti"] )
        {
            
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 간편조회 서비스의 경우
        else if (AppInfo.isEasyInquiry && [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBAccountInqueryViewController"]) {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 예적금담보대출의 신청버튼을 누른 경우 4영업일 이내 가입인지 체크
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBLoanStipulationViewController"]) {
            
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        // 스마트 이체 조회/등록/변경
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBSmartTransferAddInputViewController"]) {
            
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
        
        else
        {
            [self.navigationController pushFadeViewController:viewController];
        }
    }
}

- (void) serviceRequest: (SHBDataSet *)aDataSet
{
    NSString *url =[SHBBankingService urlForServiceCode: aDataSet.serviceCode];
    NSString *body = [self.dataParser generate:aDataSet];
    
    NSLog(@"serviceRequest: %@ \n %@", url, body);
    //[self.client request: [SHBBankingService urlForServiceCode: aDataSet.serviceCode] postBody: [self.dataParser generate:aDataSet] signText:nil signTitle:nil];
    [self.client request:url postBody:body signText:nil signTitle:nil];
}

- (void)helloCustomer{
	UIView	*helloView = [[UIView alloc] initWithFrame:CGRectMake(22, 280, 276, 72)];
	helloView.backgroundColor = [UIColor clearColor];
	helloView.tag = HELLO_VIEW;
	helloView.hidden = NO;
	
	UIImageView	*subView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 276, 62)];
	subView.backgroundColor = [UIColor whiteColor];
	
	UIImageView	*boxTopImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popup_top.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	UIImageView	*boxMidImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popup_mid.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	UIImageView	*boxBtmImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popup_bottom.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	
	boxTopImageView.frame = CGRectMake(0, 0, 276, 12);
	boxMidImageView.frame = CGRectMake(0,12, 276, 50);
	boxBtmImageView.frame = CGRectMake(0,62, 276, 10);
	
	
	UILabel	*nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 256, 23)];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.textAlignment = UITextAlignmentCenter;
	nameLabel.textColor     = [UIColor blackColor];
	nameLabel.font          = [UIFont systemFontOfSize:16];
	nameLabel.text          = [NSString stringWithFormat:@"%@ 고객님! 안녕하세요.",[AppInfo.userInfo objectForKey:@"고객성명"]];
	
	UILabel	*dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 256, 20)];
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.textAlignment = UITextAlignmentCenter;
	dateLabel.textColor     = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
	dateLabel.font          = [UIFont systemFontOfSize:14];
	dateLabel.text          = [NSString stringWithFormat:@"최근접속일자 %@ %@",[AppInfo.userInfo objectForKey:@"최종접속일자"],[AppInfo.userInfo objectForKey:@"최종접속시간"]];
	
	[helloView addSubview:subView];
	[helloView addSubview:boxTopImageView];
	[helloView addSubview:boxMidImageView];
	[helloView addSubview:boxBtmImageView];
	[helloView addSubview:nameLabel];
	[helloView addSubview:dateLabel];
	[boxTopImageView release];
	[boxMidImageView release];
	[boxBtmImageView release];
	[nameLabel release];
	[dateLabel release];
	
	[self.view addSubview:helloView];
    [subView release];
	[helloView release];
	
	helloView.transform = CGAffineTransformMakeScale(0.2, 0.2);
	helloView.alpha = 0;
	[UIView animateWithDuration:.45 animations:^{
		helloView.alpha = 1;
		helloView.transform = CGAffineTransformMakeScale(1, 1);
	} completion:^(BOOL finished) {
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeHello) userInfo:nil repeats:NO];
	}];
	
}

- (void)removeHello{
	UIView *hellowView = [self.view viewWithTag:HELLO_VIEW];
	[hellowView removeFromSuperview];
}

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary*)mDic{
	
}

- (void)executeWithDic:(NSMutableDictionary *)mDic{
	Debug(@"executeWithDic : %@",mDic);
}

- (void)setUpLayout
{
    
}

- (void)setTextFieldTagOrder:(NSArray *)array
{
    for (UITextField *textField in array) {
        [textField setTag:0];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++) {
        if ([array[i] isEnabled] && [array[i] isUserInteractionEnabled]) {
            [tempArray addObject:array[i]];
        }
    }
    
    for (int i = 0; i < [tempArray count]; i++) {
        [tempArray[i] setTag:i + 30300];
    }
    
    // textField 시작과 끝 tag 설정
    startTextFieldTag = 30300;
    endTextFieldTag = 30300 + [tempArray count] - 1;
}

#pragma mark - Delegate : SHBBottomViewDelegate
- (void)pushViewControlByBottomMenu:(int)menuTag{
    
    if (AppInfo.lastViewController != nil)
    {
        AppInfo.lastViewController = nil;
    }
	switch (menuTag) {
		case 1:
            if (AppInfo.indexQuickMenu != menuTag)
            {
                [self pushViewControllerQuickMenu:QUICK_NOTICE_TAG];
                AppInfo.indexQuickMenu = menuTag;
            }
			
			break;
		case 2:
            if (AppInfo.indexQuickMenu != menuTag)
            {
                [self pushViewControllerQuickMenu:QUICK_MYMENU_TAG];
                AppInfo.indexQuickMenu = menuTag;
            }
			
			break;
		case 3:
            if (AppInfo.indexQuickMenu != menuTag)
            {
                [self pushViewControllerQuickMenu:QUICK_APPMORE_TAG];
                AppInfo.indexQuickMenu = menuTag;
            }
			
			break;
		case 4:
            if (AppInfo.indexQuickMenu != menuTag)
            {
                [self pushViewControllerQuickMenu:QUICK_SETTING_TAG];
                AppInfo.indexQuickMenu = menuTag;
            }
			
			break;
		case 5:
			if (!AppInfo.isLogin){
				AppInfo.isFirstOpen = YES;
			}
			[self pushViewControllerQuickMenu:QUICK_LOGOUT_TAG];
            AppInfo.indexQuickMenu = 0;
			break;
			
		default:
			break;
	}
}

#pragma mark - Responding To Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    //새로운 알림이 있면 퀵메뉴의 슬라이딩을 지원하지 않는다.
    //if (AppInfo.noticeState == 2) return NO;
    
    
	CGPoint location = [touch locationInView:self.view];
	//if (location.x < 212.0) return NO;
	if (location.x < 290.0) return NO;
    
	return YES;
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    
	UIButton *dimmButton1 = (UIButton*)[self.view viewWithTag:MAIN_DIMM_BTN_TAG];
	UIButton *dimmButton2 = (UIButton*)[(UIView*)[self.view viewWithTag:NAVI_VIEW_TAG] viewWithTag:NAVI_DIMM_BTN_TAG];
	[dimmButton1 setHidden:NO];
	[dimmButton2 setHidden:NO];
	
	if(recognizer.state == UIGestureRecognizerStateEnded)
	{
		if (self.view.frame.origin.x == 0 || self.view.frame.origin.x == -95) return;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		if (self.view.frame.origin.x > -45){
			[dimmButton1 setHidden:YES];
			[dimmButton2 setHidden:YES];
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                CGRect frame = [[UIScreen mainScreen] applicationFrame];
                self.view.frame = frame;
                //[self.view setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
            }else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            }
            
			
		}else{
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.view setFrame:CGRectMake(-95, 20, 320+95, self.view.frame.size.height)];
            }else
            {
                [self.view setFrame:CGRectMake(-95, 0, 320+95, self.view.frame.size.height)];
            }
			
		}
		
		[UIView commitAnimations];
		return;
	}
	
	CGPoint translate = [recognizer translationInView:self.view];
	//NSLog(@"translate.x:%f",translate.x);
	if (translate.x > 0){
		if (self.view.frame.origin.x >= 0){
			[dimmButton1 setHidden:YES];
			[dimmButton2 setHidden:YES];
			//[self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
			return;
		}
		
		if (translate.x > 95){
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                CGRect frame = [[UIScreen mainScreen] applicationFrame];
                self.view.frame = frame;
                //[self.view setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
            }else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            }
			
		}else{
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.view setFrame:CGRectMake(translate.x, 20, 320+95, self.view.frame.size.height)];
                
            }else
            {
                [self.view setFrame:CGRectMake(translate.x, 0, 320+95, self.view.frame.size.height)];
            }
			
		}
		
	}else{
		if (translate.x < -95){
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.view setFrame:CGRectMake(-95, 20, 320+95, self.view.frame.size.height)];
                
            }else
            {
                [self.view setFrame:CGRectMake(-95, 0, 320+95, self.view.frame.size.height)];
            }
			
		}else{
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.view setFrame:CGRectMake(translate.x, 20, 320+95, self.view.frame.size.height)];
            }else
            {
                [self.view setFrame:CGRectMake(translate.x, 0, 320+95, self.view.frame.size.height)];
            }
			
		}
	}
    isPanGesture = YES;
}



- (NSMutableArray *)outAccountList
{
    NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    //for (NSMutableDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
    for (NSMutableDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
    {
        if([[dic objectForKey:@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [[dic objectForKey:@"계좌번호"] characterAtIndex:0] == '1')
        {
            [tableDataArray addObject:@{
                                        @"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
                                        @"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
                                        @"은행코드" : [dic objectForKey:@"은행코드"],
                                        @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
                                        @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                        @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
                                        @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
                                        @"상품코드" : [SHBUtility nilToString:[dic objectForKey:@"상품코드"]]
                                        }];
        }
    }
    
    return tableDataArray;
}

#pragma mark -
#pragma mark UITextField Delegate

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *tmpStr;
//    tmpStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"text:%@",tmpStr);
//    tmpStr = [tmpStr stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
//    if (tmpStr == nil)
//    {
//        return NO;
//    }
    tmpStr = [string stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    //ios7 + xcode5 대응
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    //    {
    //        if([[self.view viewWithTag:textField.tag] isKindOfClass:[SHBSecureTextField class]])
    //        {
    //            secureClickCnt++;
    //            if (self.curTextField.tag == textField.tag)
    //            {
    //                if (secureClickCnt % 2 == 0)
    //                {
    //                    secureClickCnt = 0;
    //                    [textField becomeFirstResponder];
    //                }
    //            }
    //        }
    //    }
    
    curTextField = textField;
    
    int intFirstTextFieldTag = startTextFieldTag;
    int intLastTextFieldTag  = endTextFieldTag;
    
    // 최초 textField의 이전 버튼 처리
    for ( int i = intFirstTextFieldTag ; i < intLastTextFieldTag ; i++ )
    {
        if ( ((UITextField*)[self.view viewWithTag:intFirstTextFieldTag]).enabled == YES )
        {
            break;
        }
        
        intFirstTextFieldTag++;
    }
    
    // 마지막 textField의 다음 버튼 처리
    for ( int i = intLastTextFieldTag ; i > intFirstTextFieldTag ; i-- )
    {
        if ( ((UITextField*)[self.view viewWithTag:intLastTextFieldTag]).enabled == YES )
        {
            break;
        }
        
        intLastTextFieldTag--;
    }
    
    [(SHBTextField *)curTextField enableAccButtons:curTextField.tag == intFirstTextFieldTag ? NO : YES Next:curTextField.tag == intLastTextFieldTag ? NO : YES];
    
    if([curTextField respondsToSelector:@selector(focusSetWithLoss:)])
    {
        [(SHBTextField *)curTextField focusSetWithLoss:YES];
    }
    
    CGRect textFieldRect = [textField convertRect:textField.bounds toView:contentScrollView];
    int changeHeight = AppInfo.isiPhoneFive ? 548 : 460;
    changeHeight -= contentScrollView.frame.origin.y;
    if([curTextField isKindOfClass:[SHBSecureTextField class]])
    {
        if(((SHBSecureTextField *)curTextField).keyboardType == 0)
        {// 숫자키패드
            changeHeight -= 260;
        }
        else
        {// 문자키패드
            changeHeight -= 284;
        }
    }
    else
    {
        changeHeight -= 256;
    }
    /*
     textFieldRect.origin.y -= (changeHeight - textFieldRect.size.height);
     if(textFieldRect.origin.y < 0) textFieldRect.origin.y = 0;
     
     [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
     
     if(textFieldRect.origin.y > contentViewHeight - contentScrollView.frame.size.height)
     {
     offset.y = contentViewHeight - contentScrollView.frame.size.height;
     }
     else
     {
     offset.y = textFieldRect.origin.y;
     }
     contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, contentViewHeight + 260.0f);
     */
    
    textFieldRect.origin.y -= (changeHeight - textFieldRect.size.height);
    NSLog(@"textFieldRect.origin.y:%f",textFieldRect.origin.y);
    if(textFieldRect.origin.y < 0)
    {
        
        //ios7 + xcode5 대응
        //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && textFieldRect.origin.y < -20)
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            
            if (([SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"] || [UIScreen mainScreen].bounds.size.height >= 568) && [curTextField isKindOfClass:[SHBSecureTextField class]])
            {
                if (textFieldRect.origin.y > -20)
                {
                    //조정 안함
                }else
                {
                    textFieldRect.origin.y = -20;
                }
                
                [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                
            }else
            {
                //if (textFieldRect.origin.y < -64)
                if (textFieldRect.origin.y < -44)
                {
                    textFieldRect.origin.y = -20;
                    [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                    
                }
                else
                {
                    
                    [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                }
            }
            
            
        }else
        {
            textFieldRect.origin.y = 0;
            [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
        }
        offset.y = textFieldRect.origin.y;
        
        
    } else
    {
        
        if (self.navigationController.navigationBarHidden)
        {
            [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
        } else
        {
            [contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y + 44) animated:YES];
        }
        offset.y = textFieldRect.origin.y;
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, contentViewHeight + 260.0f + 20.0f);
    }else
    {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, contentViewHeight + 260.0f);
    }
    
    
    displayKeyboard = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *tmpStr;
    tmpStr = [textField.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        if (!AppInfo.liveAlert)
        {
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:10286 title:nil buttonTitle:nil message:@"지원하지 않는 문자입니다.\n다시 입력해 주세요."];
            return;
        }else
        {
            AppInfo.liveAlert = NO;
        }
        
    }
    
    [(SHBTextField *)curTextField focusSetWithLoss:NO];
//    NSLog(@"aaaa:%i",textField.tag);
    if (UIAccessibilityIsVoiceOverRunning())
    {
        //NAVI_TITLE_TAG
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self.view viewWithTag:NAVI_TITLE_TAG]);
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textField);
        
    }
    
}

#pragma mark -
#pragma mark SHBTextFieldDelegate

- (void)didPrevButtonTouch          // 이전버튼
{
    
    NSString *tmpStr;
    tmpStr = [curTextField.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        [curTextField resignFirstResponder];
        return;
    }
    
    int intPreviousTag = curTextField.tag - 1;      // 이전 textField 태그값
    
    // 이전 textField가 이동 가능한지 확인
    for ( int i = intPreviousTag ; i > startTextFieldTag ; i-- )
    {
        if ( ((UITextField*)[self.view viewWithTag:intPreviousTag]).enabled == YES )
        {
            break;
        }
        
        intPreviousTag--;
    }
    
    // 암호화 텍스트 필드의 경우
    if([[self.view viewWithTag:intPreviousTag] isKindOfClass:[SHBSecureTextField class]])
    {
        [curTextField resignFirstResponder];
    }
    
    [[self.view viewWithTag:intPreviousTag] becomeFirstResponder];
}

- (void)didNextButtonTouch          // 다음버튼
{
    NSString *tmpStr;
    tmpStr = [curTextField.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        [curTextField resignFirstResponder];
        return;
    }
    
    int intNextTag = curTextField.tag + 1;      // 다음 textField 태그값
    
    // 다음 textField가 이동 가능한지 확인
    for ( int i = intNextTag ; i < endTextFieldTag ; i++ )
    {
        if ( ((UITextField*)[self.view viewWithTag:intNextTag]).enabled == YES )
        {
            break;
        }
        
        intNextTag++;
    }
    
    // 암호화 텍스트 필드의 경우
    if([[self.view viewWithTag:intNextTag] isKindOfClass:[SHBSecureTextField class]])
    {
        [curTextField resignFirstResponder];
    }
    
    [[self.view viewWithTag:intNextTag] becomeFirstResponder];
}

- (void)didCompleteButtonTouch      // 완료버튼
{
    if([curTextField isKindOfClass:[SHBSecureTextField class]])
    {
        [((SHBSecureTextField *)curTextField) closeSecureKeyPad];
    }else
    {
        
        [curTextField resignFirstResponder];
        //curTextField = nil;
    }
	
}

#pragma mark - SHBSecureDelegate
- (IBAction) closeNormalPad:(id)sender
{
    [curTextField resignFirstResponder];
    //[self.idTextField resignFirstResponder];
    //[AppDelegate hideKeyboard];
}

- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField
{
    [self textFieldDidBeginEditing:(SHBTextField *)textField];
}

- (void)onPreviousClick:(NSData *)pPlainText encText:(NSString*)pEncText
{
	[((SHBSecureTextField *)curTextField) closeSecureKeyPad];
    
	[self textField:(SHBSecureTextField *)curTextField didEncriptedData:pPlainText didEncriptedVaule:pEncText];
    [self didPrevButtonTouch];
}

- (void)onNextClick:(NSData*)pPlainText encText:(NSString*)pEncText
{
	[((SHBSecureTextField *)curTextField) closeSecureKeyPad];
    
	[self textField:(SHBSecureTextField *)curTextField didEncriptedData:pPlainText didEncriptedVaule:pEncText];
    [self didNextButtonTouch];
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:aData didEncriptedVaule:(NSString *)value
{
    
    displayKeyboard = NO;
    if(offset.y < 0)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
            [contentScrollView setContentOffset:CGPointZero animated:YES];
        }
        
    }
    else
    {
        [contentScrollView setContentOffset:offset animated:YES];
    }
    offset = CGPointMake(0, 0);
    [self performSelector:@selector(scrollviewContentSizeChange) withObject:nil afterDelay:0.4];
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textField);
    }
}

- (void)onPressSecureKeypad:(NSString*)pPlainText encText:(NSString*)pEncText
{
    
}

- (void)scrollviewContentSizeChange
{
	if (displayKeyboard) {
		return;
	}
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        contentScrollView.contentSize = CGSizeMake(317, contentViewHeight + 20.0f);
    }else
    {
        contentScrollView.contentSize = CGSizeMake(317, contentViewHeight);
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
	if (!displayKeyboard) {
		return;
	}
    displayKeyboard = NO;
    if(offset.y < 0)
    {
        
        //[contentScrollView setContentOffset:CGPointZero animated:YES];
    
    }
    else
    {
        [contentScrollView setContentOffset:offset animated:YES];
    }
    
    [self performSelector:@selector(scrollviewContentSizeChange) withObject:nil afterDelay:0.4];
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
        NSLog(@"textField.offset.y:%f",offset.y);
        if (scrollView.contentOffset.y != offset.y && !AppInfo.scrollBlock)
        {
            if (scrollView.contentOffset.y != 0)
            {
//                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//                {
//                    offset.y = offset.y - 20;
//                    [scrollView setContentOffset:offset animated:NO];
//                }else
//                {
                    [scrollView setContentOffset:offset animated:NO];
                //}
                
            }
            
        }
    }
    AppInfo.scrollBlock = NO;
}
@end
