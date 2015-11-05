//
//  LPAppDelegate.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAppDelegate.h"
#import "SHBPushInfo.h"

// 메인.
#import "SHBMainViewController.h"

//SSO 관련 디바이스 정보 추출 헤더
#import "DeviceManager.h"
#import "SHBTextField.h"

///moasign
#import "MoaSignSDK.h"

#include "amsLibrary.h"

@interface SHBAppDelegate ()
{
    BOOL alertBlock;
    BOOL isBackground;
    BOOL is10Alert;
    BOOL timeBlock;
    
}

- (NSDictionary *)parseQueryString:(NSString *)query;
- (void) closeConnection;
- (void) warningConnection;
@end

@implementation SHBAppDelegate

@synthesize navigationController;
@synthesize moaSignCurrentFunctionString;
@synthesize moaSignUrl;
@synthesize moaSignTimer;
@synthesize ssAgent;

- (void)dealloc
{
    [_window release];
    //[_navigationController release];
    [super dealloc];
}
- (void)gdbcheck
{
    disable_gdb();
    //NSLog(@"disable_gdb");
    [self performSelector:@selector(gdbcheck) withObject:nil afterDelay:2];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"memory waring");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    #ifndef DEVELOPER_MODE
        //[self performSelector:@selector(gdbcheck) withObject:nil];
    #endif
    
    //#ifndef DEBUG
        if (![[self rmrjtdmfcpzmgkqslek] isEqualToString:@"!!@(@!#*^!dlrkqtdms!@#%@#@#Tmforlrkqtdmfh1234275dkftnrk!@#$58238djqttmqslek.%^&*%^&"])
        {
            //return NO;
        }
    //#endif
    /*
    //[LPStopwatch start:@"앱 기동"];
   //모빌리언스넷 마이그레이션 구동
    NSString *mobilianNetMigration = [[NSUserDefaults standardUserDefaults]isMobilianNetMigration];
    if (mobilianNetMigration == nil)
    {
        //HQ59H9US6W.com.initech.KeychainSuite
        IXL_SetKeyChainAccessGroup("HQ59H9US6W.com.initech.KeychainSuite");
        int rtn = IXL_MigrateMobilianSFilterKeychain();
        // 업데이트 전 앱이 MobilianSFilter인 경우 인증서 키체인을 마이그레이션 작업을 한다.
        [[NSUserDefaults standardUserDefaults]setMobilianNetMigration:@"마이그레이션기록함"];
        NSLog(@"MobilianSFilter migration Start!!");
        
    }
    */
    //테스트로 나중에 막아야 됨....
    //AppInfo.LanguageProcessType = EnglishLan;
    //AppInfo.LanguageProcessType = JapanLan;
    
    self.ssAgent = [[SmartSafeAgent alloc] init];
    
    int keychainStatus = 0;
    int returnValue = IXL_SetKeyChainAccessGroup("HQ59H9US6W.com.initech.KeychainSuite",&keychainStatus);
    
    if (0 != returnValue)
    {
    
        //처리결과가 0이 아닌경우 키체인 설정 실패, 키체인그룹이 정상적인 경우가 아니라면 키체인 초기화를 실시한다.
        //설정실패시 키체인 초기화를 할것인지 alert팝업
        NSLog(@"KeychainStatus:%d",keychainStatus);
        
        //NSString *msg = @"인증서데이터 오류가 발생되어\n인증서데이터를 초기화합니다.\n고객님의 안전한 거래를 위하여\n공인인증센터 메뉴에서 인증서를\n다시 설치하여 주십시오.";
        //msg = [NSString stringWithFormat:@"%@\n%i",msg,keychainStatus];
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:200 title:@"" message:msg];
        
        int keychainStatusPugy = 0;
        int result = IXL_PurgeKeychainGroup("HQ59H9US6W.com.initech.KeychainSuite", &keychainStatusPugy);
        if (0 != result) {
            
            NSString *msg = [NSString stringWithFormat:@"인증서데이터 오류가 발생되어\n인증서데이터 초기화를 시도\n했으나 실패하였습니다.\n신한S뱅크를 종료 하시겠습니까?\n고객센터(1577-8000)로\n문의주시기 바랍니다.\n(%d)\n(%d)",keychainStatus,keychainStatusPugy];
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
            //[UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:msg];
        }else
        {
            NSString *msg = @"인증서데이터 오류가 발생되어\n인증서데이터를 초기화했습니다.\n고객님의 안전한 거래를 위하여\n공인인증센터 메뉴에서 인증서를\n다시 설치하여 주십시오.";
            msg = [NSString stringWithFormat:@"%@\n(%d)",msg,keychainStatus];
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
            //[UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:nil message:msg];
        }

    }
    //NSLog(@"aaaa:%@",[SHBUtilFile getOSVersion]);
    
    // 앱인포.
    [SHBAppInfo sharedSHBAppInfo];
    
    [AppInfo initProcess]; //초기화 작업
    
    AppInfo.isBackGroundCall = NO;
	// 메인(메뉴).
	SHBMainViewController *viewController;
	if (AppInfo.isiPhoneFive){
		viewController = [[[SHBMainViewController alloc] initWithNibName:@"SHBMainViewController568h" bundle:nil] autorelease];
	}else{
		viewController = [[[SHBMainViewController alloc] initWithNibName:@"SHBMainViewController" bundle:nil] autorelease];
	}
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    self.navigationController.delegate = self;
    self.navigationController.view.frame = self.window.bounds;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = self.navigationController;
    //ios7 + xcode5 대응
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
	
	
	// push
	SHBPushInfo* push = [SHBPushInfo instance];
	NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	if (userInfo)
	{
		[push onReceivePush:userInfo];
	}
	else
	{
		//if (NO == [push readDeviceTokenFromFile])
		//{
			//APNS에 장치 등록
			[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
		//}
	}
	
	//Badge 개수 설정
	application.applicationIconBadgeNumber = 0;
	
    /*
     //타이머를 사용해서 1초뒤에 인증서 관리화면으로 이동하게함
     //url scheme를 처리하는 델리게이트에서 타이머를 중지시킴
     //즉, url scheme가 있는경우 moaSignDidLoaded가 실행, 아닌경우 인증서 관리가 실행되도록 함.
     self.moaSignTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f)
     target:(SHBMainViewController*)(navigationController.topViewController)
     selector:@selector(moveToCertificateList)
     userInfo:nil repeats:NO];
     */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    isBackground = YES;
    // iOS 버전 확인: 멀티태스킹 지원은 iOS 4부터...
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        // 디바이스의 멀티태스킹 지원 확인.
        if ([[UIDevice currentDevice] isMultitaskingSupported])
        {
            UIApplication *application = [UIApplication sharedApplication];
            // 작업 객체 생성.
            __block UIBackgroundTaskIdentifier backgroundTask;
            backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^ {
                [application endBackgroundTask: backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }];
            // 백그라운드 작업은 비동기로...
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // 실제 작업은 이 곳에...-------------------------------------------
                NSLog(@"\n\n백그라운드 실행 중!\n\n");
                // 실제 작업은 이 곳에...-------------------------------------------
                
                // 작업 종료.
                //[application endBackgroundTask: backgroundTask];
                //backgroundTask = UIBackgroundTaskInvalid;
            });
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    isBackground = NO;
    
    AppInfo.isBackGroundCall = YES; //동시 전문 전송을 막기 위해
    if (AppInfo.isLogin != LoginTypeNo )
    {
        double foreTime = [[NSDate date] timeIntervalSince1970];
        double differTime = foreTime - startTime;
        
        NSLog(@"differtime:%f",differTime);
        if (!is10Alert && differTime > 600)
        {
            AppInfo.indexQuickMenu = 0;
            timeBlock = YES;
            NSString *errorMsg = @"10분동안 거래가 없어 고객님의 금융거래를 보호하기 위하여 자동으로 로그아웃되었습니다. 확인을 누르시면 신한S뱅크 메인화면으로 이동합니다.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1005 title:@"" message:errorMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutClose" object:nil];
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:1005 title:nil buttonTitle:nil message:errorMsg];
            //[self performSelector:@selector(delyAlertShow) withObject:nil afterDelay:1];
        }
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}


#pragma mark - Push Message

//push : APNS 에 장치 등록 성공시 자동실행
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	Debug(@"deviceToken : %@", deviceToken);
	
	SHBPushInfo *pushInfo = [SHBPushInfo instance];
	[pushInfo setDeviceTokenWithData:deviceToken];
    
}


//push : APNS 에 장치 등록 오류시 자동실행
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	Debug(@"deviceToken error : %@", error);
	//[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"deviceToken error"];
}

//push : 메시지 수신시
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
	Debug(@"push message receive : %@", userInfo);
	
	SHBPushInfo *pushInfo = [SHBPushInfo instance];
	[pushInfo onReceivePush:userInfo];
}


#pragma mark - URL schema
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
	if (!url){
		// URL이 nil인 경우.
		return NO;
	}
    Debug(@"handleOpen URL ==>[%@]",[url absoluteString]);
	
    
    AppInfo.schemaUrl = [url absoluteString];
    SHBPushInfo *openURLManager = [SHBPushInfo instance];
    [openURLManager recieveOpenURL];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if (!url)
    {
        return NO;
    }
    
	
    
    //신한 은행 인증서 복사 요청을 처리한다.
    NSString *URLString = [url absoluteString];
	Debug(@"sourceApplication URL ==>[%@]",URLString);
	
    
    if ([URLString rangeOfString:@"sbankmoasign://"].location != NSNotFound)
    {
        [self closeAlertView];
        [AppInfo logout];
        if ([URLString rangeOfString:@"&lang=ENG"].location != NSNotFound)
        {
            AppInfo.LanguageProcessType = EnglishLan;
        } else
        {
            //AppInfo.LanguageProcessType = KoreaLan;
        }
        
        [AppDelegate.window setUserInteractionEnabled:NO];
        self.moaSignUrl = [url absoluteString];
        
        [self.navigationController fadePopToRootViewController];
        [(SHBMainViewController*)(self.navigationController.topViewController) performSelector:@selector(moaSignDidLoaded) withObject:nil afterDelay:0.5f];
        
        return YES;
    } else
    {
        AppInfo.schemaUrl = URLString;
        
        if (AppInfo.isBackGroundCall || AppInfo.isWebSchemeCall)
        {
            //앱이 백그라운드 상태에 있거나 웹뷰 연동 요청을 받을경우...
            SHBPushInfo *openURLManager = [SHBPushInfo instance];
            [openURLManager recieveOpenURL];
            AppInfo.isBackGroundCall = NO;
            AppInfo.isWebSchemeCall = NO;
        }else
        {
            //연동 요청을 받았는데 앱이 기동될경우 mainviewcontroller 의 onBind에서 처리..
            [self showProgressView];
            
        }
    }
    
	
	
	
    return YES;
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    UIViewController *vc = AppDelegate.navigationController.viewControllers.lastObject;
    
    if (vc.view.frame.origin.y >= 40)
    {
        AppInfo.isHotSpot = YES;
    }else
    {
        AppInfo.isHotSpot = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeStatusBarFrame" object:nil];
}
#pragma mark - 타이머 관련
- (void) showProgressView
{
    
       #ifndef DEVELOPER_MODE
        disable_gdb();
       #endif
    
    
    [SVProgressHUD show];
}
- (void) closeProgressView
{
    [SVProgressHUD dismiss];
}
- (void) initTimer
{
    if (_timer9 != nil && [_timer9 isValid])
    {
        [_timer9 invalidate];
        
    }
    
    if (_timer10 != nil && [_timer10 isValid])
    {
        [_timer10 invalidate];
        
        
    }
    
    limtTime = 60;
    //timeBlock = NO;
    alertBlock = NO;
    AppInfo.serviceCode = nil;
    _timer9 = nil;
    _timer10 = nil;
}
- (void) startTimer
{
    
    if (_timer9 != nil && [_timer9 isValid])
    {
        [_timer9 invalidate];
        _timer9 = nil;
    }
    
    if (_timer10 != nil && [_timer10 isValid])
    {
        [_timer10 invalidate];
        _timer10 = nil;
        
    }
    
    limtTime = 60;
    //timeBlock = NO;
    alertBlock = NO;
    //인증센터에서 로그인을 하지 않은 상태에서 전문을 태우는데 타이머가 돌면 안되서 로그인 상태가 아니면 타이머를 구동하지 않는다.
    if (AppInfo.isLogin == LoginTypeNo)
    {
        //[AppInfo loadPublicKeyForNFilter];
        return;
    }
    

    startTime = [[NSDate date] timeIntervalSince1970];
    
    
    _timer9 = [NSTimer scheduledTimerWithTimeInterval:KEEP_ALIVE_TIMEOUTWARNING target:self selector:@selector(warningConnection) userInfo:nil repeats:NO];
    
    _timer10 = [NSTimer scheduledTimerWithTimeInterval:KEEP_ALIVE_TIMEOUT target:self selector:@selector(closeConnection) userInfo:nil repeats:NO];
    
    //[AppInfo getNFilterPK];
    //[AppInfo loadPublicKeyForNFilter];
    
    
}
- (void) initNFlterTimer
{
    if (_timer10ForNFIlter != nil && [_timer10ForNFIlter isValid])
    {
        [_timer10ForNFIlter invalidate];
        _timer10ForNFIlter = nil;
    }
    _timer10ForNFIlter = [NSTimer scheduledTimerWithTimeInterval:KEEP_ALIVE_TIMEOUT target:self selector:@selector(reGetNFilterPK) userInfo:nil repeats:YES];
}
- (void) reGetNFilterPK
{
    //AppInfo.isGetKeyNFilter = NO;
    //[AppInfo getNFilterPK];
}

- (void)closeConnection
{
    if (_timer9 != nil && [_timer9 isValid])
    {
        [_timer9 invalidate];
        _timer9 = nil;
    }
    
    if (_timer10 != nil && [_timer10 isValid])
    {
        [_timer10 invalidate];
        _timer10 = nil;
        
    }
    if (isBackground) return;

    is10Alert = YES;
    AppInfo.indexQuickMenu = 0;
    //NSString *errorMsg = @"10분동안 거래가 없어\n고객님의 금융거래를 보호하기 위하여\n자동으로 로그아웃되었습니다.\n확인을 누르시면 신한S뱅크\n메인화면으로 이동합니다.";
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1005 title:@"" message:errorMsg];
    
    //if (alertBlock)
    //{
        limtTime = 61;
        timeBlock = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alertLimitClose" object:nil];
        NSLog(@"alertLimitClose");
    //}
    
    [self performSelector:@selector(delyAlertShow) withObject:nil afterDelay:1];
}

-(void)delyAlertShow
{
    limtTime = 0;
    NSString *errorMsg = @"10분동안 거래가 없어\n고객님의 금융거래를 보호하기 위하여\n자동으로 로그아웃되었습니다.\n확인을 누르시면 신한S뱅크\n메인화면으로 이동합니다.";
    [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:1005 title:nil buttonTitle:nil message:errorMsg];
}
- (void) warningConnection
{
    if (_timer9 != nil && [_timer9 isValid])
    {
        [_timer9 invalidate];
        _timer9 = nil;
    }
    limtTime = 60;
    timeBlock = NO;
    //NSLog(@"limittimer:%i",limtTime);
    
    if (isBackground) return;
    
    //키패드가 떠있으면 닫는다.
    AppInfo.liveAlert = YES;
    
    // ZBarReaderViewController에서는 오류가 나서 죽으므로 수정
    if (![AppDelegate.navigationController.viewControllers.lastObject isKindOfClass:NSClassFromString(@"ZBarReaderViewController")]) {
        
        [(AppDelegate.navigationController.viewControllers.lastObject) performSelector:@selector(didCompleteButtonTouch) withObject:nil];
    }
    
    NSString *msg = [NSString stringWithFormat:@"(%i초) 로그아웃 예정입니다.\n10분동안 사용이 없을 경우 자동으로\n로그아웃됩니다.",limtTime];
    /*
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle:@"로그인 연장"
                                               otherButtonTitles:@"로그아웃",nil] autorelease];
    
    alertView.tag = 1004;
    [alertView show];
     
    [self performSelector:@selector(showWarningTime:) withObject:alertView];
    */
    [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:1004 title:nil buttonTitle:@"로그인 연장,로그아웃" message:msg];
    [self performSelector:@selector(showWarningTime:) withObject:nil];
}

- (void) showWarningTime:(UIAlertView*)alert
{
    /*
    NSString *msg = [NSString stringWithFormat:@"%i초 후 로그아웃 예정입니다.\n10분동안 사용이 없을 경우 자동으로\n로그아웃됩니다.",limtTime];
    alert.message = msg;
    
    if (limtTime == 0)
    {
        alertBlock = YES;
        [alert dismissWithClickedButtonIndex:1 animated:YES];
        
        
    } else
    {   limtTime--;
        if (limtTime < 60 && limtTime >= 0)
        {
            [self performSelector:@selector(showWarningTime:) withObject:alert afterDelay:1];
        }
        
    }
     */
    
    NSString *msg = [NSString stringWithFormat:@"%i초 후 로그아웃 예정입니다.\n10분동안 사용이 없을 경우 자동으로\n로그아웃됩니다.",limtTime];
    AppInfo.dummyStr = msg;
    if (limtTime == 0)
    {
        alertBlock = YES;
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"alertLimitClose" object:nil];
        //[self closeConnection];
    }else
    {
        limtTime--;
        //NSLog(@"limtTime:%i",limtTime);
        if (limtTime < 60 && limtTime >= 0)
        {
            if (timeBlock)
            {
                //timeBlock = NO;
            }else
            {
                [self performSelector:@selector(showWarningTime:) withObject:nil afterDelay:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alertChangeMessage" object:nil];
            }
            
        }
    }
}

//alertview 죽이기
- (void)closeAlertView
{
	UIWindow *tempWindow;
    
	for (int c=0; c < [[[UIApplication sharedApplication] windows] count]; c++)
	{
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
		for (int i = 0; i < [tempWindow.subviews count]; i++)
		{
			[self _hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
		}
	}
}

//alertView 사라지게 하기 위해 사용하는 재귀함수
- (void)_hideKeyboardRecursion:(UIView*)view
{
    //NSLog(@"view:%@",NSStringFromClass([view class]));
	if ([view isKindOfClass:[UIAlertView class]])
	{
		//[view resignFirstResponder];
        [(UIAlertView*)view dismissWithClickedButtonIndex:1 animated:NO];
        NSLog(@"resign");
	}
	if ([view.subviews count]>0)
	{
		for (int i = 0; i < [view.subviews count]; i++)
		{
			[self _hideKeyboardRecursion:[view.subviews objectAtIndex:i]];
		}
	}
}

#pragma mark - 얼럿뷰 델리게이트
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1004 && buttonIndex == 0)
    {
        //[self initTimer];
        limtTime = 61;
        timeBlock = YES;
        NSLog(@"reSession");
        [AppInfo reSession];
        
    } else if (alertView.tag == 1004 && buttonIndex == 1)
    {
        
        
        limtTime = 61;
        timeBlock = YES;
        if ([[AppDelegate.navigationController viewControllers] count] > 1)
        {
            [AppDelegate.navigationController fadePopToRootViewController];
        }
        if (alertBlock == YES)
        {
            
            if (_timer9 != nil && [_timer9 isValid])
            {
                [_timer9 invalidate];
                _timer9 = nil;
                
            }
            
            if (_timer10 != nil && [_timer10 isValid])
            {
                [_timer10 invalidate];
                _timer10 = nil;
                
            }
            
            
        } else
        {
            limtTime = 61;
            timeBlock = YES;
            [self closeAlertView];
            NSLog(@"logout 1");
            if (AppInfo.isLogin != LoginTypeNo)
            {
                [AppInfo logout];
            }
            
        }
        
        alertBlock = NO;
        
    } else if (alertView.tag == EXIT_ALERT_VIEW_TAG && buttonIndex == 0)
    {
        // 앱 종료.
        exit(-1);
    } else if (alertView.tag == 1005)
    {
        is10Alert = NO;
        if ([[AppDelegate.navigationController viewControllers] count] > 1)
        {
            [AppDelegate.navigationController fadePopToRootViewController];
        }
        [self closeAlertView];
        
        if (AppInfo.isLogin != LoginTypeNo)
        {
            [AppInfo logout];
        }
        
    }  else if (alertView.tag == 200)
    {
//        int keychainStatus = 0;
//        int result = IXL_PurgeKeychainGroup("HQ59H9US6W.com.initech.KeychainSuite", &keychainStatus);
//        if (0 != result) {
//            
//            NSString *msg = [NSString stringWithFormat:@"인증서데이터 초기화에 실패하여 신한S뱅크가 종료됩니다.\n고객센터(1577-8000)로 문의주시기 바랍니다.\n:%d",keychainStatus];
//            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
//            
//        }
    }
    
    
}
#pragma mark - 프라이빗 메서드
- (NSString *)getSSODeviceID{
	Debug(@"Make Device ID : [%@]",[DeviceManager makeDeviceId]);
	return [DeviceManager makeDeviceId];
    
    //ios7 대응
    //Debug(@"Make Device ID : [%@]",[DeviceManager makeDeviceId:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"]]);
    //return [DeviceManager makeDeviceId:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"]];
}

// Custom URL 파싱.
- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:8] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
	
	for (NSString *pair in pairs)
    {
		NSArray *elements = [pair componentsSeparatedByString:@"="];
		NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *val = nil;
		
        // TODO: 이 부분은 Custom URL 정의에 따라 구현할 것!
		// val 이 nil인 경우 예외 처리!
		if (val != nil)
        {
			if ([key isEqualToString:@"target"])
            {
				// !!!: target의 경우 URL 디코딩 안함.
				val = [elements objectAtIndex:1];
			}
			else
            {
				val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}
		}
        else
        {
			val = @"";
		}
		
		[dict setObject:val forKey:key];
	}
    
    return dict;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*
     Debug(@"\n------------------------------------------------------------------\
     \nCurrent navigationController.viewControllers count: %d\
     \n------------------------------------------------------------------", [self.navigationController.viewControllers count]);
     */
    Debug(@"\n------------------------------------------------------------------\
          \n현재 View Controller : %@\
          \n------------------------------------------------------------------", NSStringFromClass([viewController class]));
    
    if (AppInfo.isLogin && [NSStringFromClass([viewController class]) isEqualToString:LOGIN_CLASS])
    {
        
        //[self.navigationController popViewControllerAnimated:animated];
        //[self.navigationController.navigationBar popNavigationItemAnimated:NO];
    }
    
}

- (NSString *)rmrjtdmfcpzmgkqslek
{
    
    #ifndef DEVELOPER_MODE
        disable_gdb();
    #endif
    
    //Debug(@"탈옥폰 체크!!!");
#if TARGET_IPHONE_SIMULATOR
    // -> Module/AhnLab/ 에서 .h파일은 냅두고 .a 라이브러리 파일은 프로젝트에서 빼면~ 시뮬레이터는 정상 작동합니다...- -;
    return @"!!@(@!#*^!dlrkqtdms!@#%@#@#Tmforlrkqtdmfh1234275dkftnrk!@#$58238djqttmqslek.%^&*%^&"; // -> 시뮬레이터일 경우 무조건 통과!!
#else //TARGET_IPHONE_DEVICE
    // #define ahnTrue 1
    // #define ahnFalse 0
    // #define ahnError -1
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger  iResult = [ams a3142:@"AHN_3379024345_TK"];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger roundValue = round(interval);
    //NSLog(@"result : %ld",(long)iResult);
    //NSLog(@"interval : %ld",(long)roundValue);
    //NSLog(@"check result : %ld",(long)(iResult - roundValue));
    [ams release];
    
    //NSLog(@"iResult:%i",iResult);
    
    if((long)(iResult - roundValue) > 201) {
        //Debug(@"탈옥 폰입니다. result = [%d]", iResult);
        //탈옥폰
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."
//                                                       delegate:self
//                                              cancelButtonTitle:@"확인"
//                                              otherButtonTitles:nil];
//        alert.tag = EXIT_ALERT_VIEW_TAG; //444,EXIT_ALERT_VIEW_TAG=exit(1); -> 확인버튼 누를 시 종료 시킬려면 444, EXIT_ALERT_VIEW_TAG로 바꾸세요~~
//        [alert show];
//        [alert release];
        //[UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."];
        [AppInfo xkfdhrAlert];
        return @"dlrjtdms14xkf5d8hrv^*hsdlqs07)lek$$&^%$!01243kfjasdfjk#%!12cnvwksjadsjhl81246a6^^aaq";
    }
    else {
        //Debug(@"순정 폰입니다.");
        return @"!!@(@!#*^!dlrkqtdms!@#%@#@#Tmforlrkqtdmfh1234275dkftnrk!@#$58238djqttmqslek.%^&*%^&";
    }
#endif
    
}

@end
