//
//  SHBNoticeMenuNotLogInViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 7. 9..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeMenuNotLogInViewController.h"
#import "SHBNotificationService.h" // 서비스
#import "SHBNoticeMenuViewController.h"
#import "SHBNotiListViewCell.h"

@interface SHBNoticeMenuNotLogInViewController ()
{
    NSString *seq; //이벤트 새소식 상세페이지로 이동
    NSString *faq_seq; //이벤트 새소식 상세페이지로 이동
}
@end

@implementation SHBNoticeMenuNotLogInViewController
@synthesize webView;
@synthesize subTitleLabel;
@synthesize notiTabel;

- (void)dealloc
{
    [notiTabel release];
    [subTitleLabel release];
    [webView release];
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
    
    self.webView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newIconSetting)
                                                 name:@"SmartLetter_Coupon_New"
                                               object:nil];
    
    
    
    
    //스마트케어
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newIconSetting)
                                                 name:@"smartCareReceiveNoti"
                                               object:nil];
    
    [self navigationViewHidden];
	[self setBottomMenuView];
    
    if(!self.isPushAndScheme)
    {
        self.subTitleLabel.text = @"새소식";
        //푸시 또는 스키마로 들어온 경우가 아닌경우
        AppInfo.isNeedBackWhenError = YES;
        
//        self.service = nil;
//        self.service = [[[SHBNotificationService alloc] initWithServiceId:GET_NOTICE_SERVICE viewController:self] autorelease];
        //GET_ALIM_SERVICE
//        self.service = [[[SHBNotificationService alloc] initWithServiceId:GET_ALIM_SERVICE viewController:self] autorelease];
//        [self.service start];
        
        self.service = nil;
        self.service = [[[SHBNotificationService alloc] initWithServiceId:NEW_STATE_SERVICE viewController:self] autorelease];
        [self.service start];
        
    }else
    {
        //푸시, 스키마로 들어온 경우
        seq = @"";
        if (![self.data[@"SEQ"] isEqualToString:@""] && [self.data[@"SEQ"] length] > 0){
            //if (![self.data[@"SEQ"] isEqualToString:@""]){
            seq = [NSString stringWithFormat:@"%@", self.data[@"SEQ"]];
            NSLog(@"seq==%@",seq);
        }
        
        faq_seq = @"";
        if (![self.data[@"FAQ_SEQ"] isEqualToString:@""] && [self.data[@"FAQ_SEQ"] length] > 0){
            //if (![self.data[@"FAQ_SEQ"] isEqualToString:@""]){
            faq_seq = [NSString stringWithFormat:@"%@", self.data[@"FAQ_SEQ"]];
            NSLog(@"faq_seq==%@",faq_seq);
        }
        
        
        if ([self.data[@"screenID"] isEqualToString:@"SM_01"]) { // 스마트레터
            //[self selectMenu:btn_menu3];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_02"]) { // 쿠폰함
            //[_btnNextLeftMenu setEnabled:YES];
            //[_btnNextMenu setEnabled:YES];
            //[self changeMenu_right:nil];
            //[self selectMenu:btn_menu5];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_04"]) { // 이벤트
            //[self selectMenu:btn_menu2];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_03"]) { // 새소식
            //[self selectMenu:btn_menu1];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_05"]) { // FAQ
            //[self selectMenu:btn_menu6];
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_06"]) { // 스마트캐어
            //[self selectMenu:btn_menu4];
            //[self changeMenu_right:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	[super executeWithDic:mDic];
    
    if (mDic) {
        NSLog(@"aaaaaaa %@",mDic);
        self.data = mDic;
    }
}

- (void)newIconSetting
{
    /*
    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++) {
        if (AppInfo.isSmartLetterNew || AppInfo.isCouponNew) {
            AppInfo.noticeState = 2;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:2];
        }
        
        if (!AppInfo.isSmartLetterNew && !AppInfo.isCouponNew) {
            AppInfo.noticeState = 0;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:0];
        }
    }
     */
}

#pragma mark - Action
- (IBAction)closeBtnAction:(UIButton *)sender
{
    //AppInfo.commonDic = [NSDictionary dictionary];
    AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

- (IBAction)iconBtnAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 999:
        {
            //새소식
            SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            
            viewController.data = @{
                                    @"screenID" : @"SM_03",
                                    };
            
            
            [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
            
        }
            break;
        case 1000:
        {
            //이벤트
            /*
            self.subTitleLabel.text = @"이벤트";
            [webView setHidden:NO];
            if (!self.isPushAndScheme)
            {
                
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_event.jsp?EQUP_CD=SI"]];
                }
                else {
                    [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_event.jsp?EQUP_CD=SI"];
                }
            }
            else
            {
                
                
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@%@", URL_M, @"/pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]];
                }
                else {
                    NSLog(@"aaaa:%@",seq);
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com//pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]];
                    
                    NSLog(@"======%@",[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]);
                }
                
                self.isPushAndScheme = NO;
            }
            */
            //이벤트
            SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            
            viewController.isPushAndScheme = YES;
            viewController.data = @{
                                    @"screenID" : @"SM_04",
                                    
                                    };
            
            
            [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
            
        }
            break;
        case 1001:
        {
            if (AppInfo.isLogin == LoginTypeNo)
            {
                //스마트레터(로그인 필요)
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_01",
                                        
                                        };
                AppInfo.lastViewController = viewController;
                [viewController release];
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                
                //쿠폰함(로그인 필요)
                AppInfo.isSingleLogin = YES;
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }else
            {
                //스마트레터
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_01",
                                        
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                //SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                //[AppDelegate.navigationController pushFadeViewController:viewController];
                AppInfo.certProcessType = CertProcessTypeLogin;
                viewController.needsLogin = YES;
                
                [AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }
            */
            
            
            
        }
            break;
        case 1002:
        {
            
            if (AppInfo.isLogin == LoginTypeNo)
            {
                //스마트명함(로그인 필요)
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_07",
                                        
                                        };
                AppInfo.lastViewController = viewController;
                [viewController release];
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                
                
                AppInfo.isSingleLogin = YES;
                
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }else
            {
                //스마트명함
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_07",
                                        
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                //SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                //[AppDelegate.navigationController pushFadeViewController:viewController];
                AppInfo.certProcessType = CertProcessTypeLogin;
                viewController.needsLogin = YES;
                
                [AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }
            */
            
            
            
        }
            break;
        case 1003:
        {
            
            if (AppInfo.isLogin == LoginTypeNo)
            {
                //스마트케어매니저(로그인 필요)
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_06",
                                        
                                        };
                AppInfo.lastViewController = viewController;
                [viewController release];
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                
                //스마트케어매니저(로그인 필요)
                AppInfo.isSingleLogin = YES;
                
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }else
            {
                //스마트케어매니저
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_06",
                                        
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                //SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                //[AppDelegate.navigationController pushFadeViewController:viewController];
                AppInfo.certProcessType = CertProcessTypeLogin;
                viewController.needsLogin = YES;
                
                [AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }
            */
            
            
            
        }
            break;
        case 1004:
        {
            
            if (AppInfo.isLogin != LoginTypeCert)
            {
                //스마트신규(로그인 필요)
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_08",
                                        
                                        };
                //AppInfo.lastViewController = viewController;
                //[viewController release];
                viewController.needsLogin = YES;
                viewController.needsCert = YES;
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController.viewControllers[0] checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                //스마트신규
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_08",
                                        
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            
            //NSLog(@"abcd:%@",AppDelegate.navigationController.viewControllers);
            /*
            //쿠폰함(로그인 필요)
            AppInfo.isSingleLogin = YES;
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
             */
            
        }
            break;
        case 1005:
        {
            
            
            if (AppInfo.isLogin == LoginTypeNo)
            {
                //쿠폰함(로그인 필요)
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_02",
                                        
                                        };
                AppInfo.lastViewController = viewController;
                [viewController release];
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                
                AppInfo.isSingleLogin = YES;
                
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }else
            {
                //쿠폰함
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_02",
                                        
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                //SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                //[AppDelegate.navigationController pushFadeViewController:viewController];
                AppInfo.certProcessType = CertProcessTypeLogin;
                viewController.needsLogin = YES;
                
                [AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }
             */
            
            
             
            
        }
            break;
        case 1006:
        {
            //FAQ
            /*
            self.subTitleLabel.text = @"FAQ";
            [webView setHidden:NO];
            
            if (!self.isPushAndScheme)
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_faq.jsp?EQUP_CD=SI"]];
                }
                else {
                    [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_faq.jsp?EQUP_CD=SI"];
                }
            }
            else
            {
                
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@%@", URL_M, @"/pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]];
                }
                else {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com//pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]];
                    
                    NSLog(@"======%@",[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]);
                }
                
                self.isPushAndScheme = NO;
            }
            */
           
            SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            
            viewController.isPushAndScheme = YES;
            viewController.data = @{
                                    @"screenID" : @"SM_05",
                                    
                                    };
            
            
            [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }
            break;
        case 1007:
        {
            //이용안내
            /*
            self.subTitleLabel.text = @"이용안내";
            [webView setHidden:NO];
            
            if (AppInfo.realServer) {
                [webView loadRequestWithString:@"http://img.shinhan.com/sbank/mov/sbank_info.html"];
            }
            else {
                [webView loadRequestWithString:@"http://imgdev.shinhan.com/sbank/mov/sbank_info.html"];
            }
             */
            SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            
            viewController.isPushAndScheme = YES;
            viewController.data = @{
                                    //@"screenID" : @"SM_09",
                                     @"screenID" : @"SM_05",
                                    };
            
            
            [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
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
    if ([aDataSet[@"NEW_LETTER"] isEqualToString:@"Y"])
    {
        //[_smartLetterNew setHidden:NO];
    }else
    {
        //[_smartLetterNew setHidden:YES];
    }
    
    if ([aDataSet[@"NEW_COUPON"] isEqualToString:@"Y"])
    {
        //[_couponNew setHidden:NO];
    }else
    {
        //[_couponNew setHidden:YES];
    }
    
    if (AppInfo.commonDic[@"배너"]) {
        NSMutableDictionary *dic = AppInfo.commonDic[@"배너"];
        
        [webView setHidden:NO];
        
        if ([dic[@"티커구분"] isEqualToString:@"0"])
        {
            //_currentIndex = 100;
            // 새소식
            
        }else if ([dic[@"티커구분"] isEqualToString:@"1"])
        {
            //_currentIndex = 200;
            
            // 이벤트

        }
        
        [webView loadRequestWithString:dic[@"티커Url"]];
    }else
    {
        
        
         //기존 웹뷰 방식
        if (AppInfo.realServer)
        {
            [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_notice.jsp?EQUP_CD=SI"]];
        }
        else {
            [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_notice.jsp?EQUP_CD=SI"];
        }
        
        //예전방식으로 환원
        /*
        self.dataList = aDataSet[@"data"];
        //self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
        NSLog(@"aaaa:%@",self.dataList);
        //NSLog(@"aaaa:%i",[self.dataList count]);
        [self.notiTabel reloadData];
         */
    }
    return YES;
}

#pragma mark - Delegate : UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//Debug(@"webViewDidStartLoad !!!");
    AppInfo.isWebSchemeCall = YES;
    NSString *urlStr = [[request URL] absoluteString];
    NSLog(@"urlStr:%@",urlStr);
    if ([urlStr isEqualToString:@"about:blank"])
    {
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"notice_detail.jsp?NOTC_SEQ="])
    {
        //새소식으로 연결
        NSArray *schemeArr =  [urlStr componentsSeparatedByString:@"?"];
        
        
        if ([schemeArr count] == 2)
        {
            NSString *tmpSar = schemeArr[1];
            NSArray *appArr = [tmpSar componentsSeparatedByString:@"="];
            //if ([appArr count] == 2)
            //{
                
                SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
                
                viewController.isPushAndScheme = YES;
                viewController.data = @{
                                        @"screenID" : @"SM_03",
                                        @"SEQ" : appArr[1],
                                        };
                
                
                [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
                [AppDelegate.navigationController pushSlideUpViewController:viewController];
                [viewController release];
                return NO;
            //}
        }
        
    }
    
    if ([SHBUtility isFindString:urlStr find:@"sbankapplink://?"])
    {
        //웹뷰안에서 타 앱으로 sso링크 태울때 사용한다.
        NSArray *schemeArr =  [urlStr componentsSeparatedByString:@"://?"];
        
        if ([schemeArr count] == 2)
        {
            NSString *tmpSar = schemeArr[1];
            NSArray *appArr = [tmpSar componentsSeparatedByString:@"="];
            if ([appArr count] == 2)
            {
                
                SHBPushInfo *pushInfo = [SHBPushInfo instance];
                [pushInfo requestOpenURL:[SHBUtility nilToString:appArr[1]] Parm:nil];
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:urlStr];
    if ([SHBUtility isFindString:urlStr find:@"iVer="])
    {
        NSMutableDictionary *dataDic    = [[NSMutableDictionary alloc] init];
        NSArray *screenArr =  [urlStr componentsSeparatedByString:@"?"];
        
        if( [screenArr count] == 2 )
        {
            [dataDic removeAllObjects];
            
            
            NSArray *argArr =  [[screenArr objectAtIndex:1] componentsSeparatedByString:@"&"];
            for( int i=0;i < [argArr count];i++){
                NSArray *ArrKeyVal = [[argArr objectAtIndex:i] componentsSeparatedByString:@"="];
                
                if ([ArrKeyVal count] < 2) break;
                
                [dataDic setObject:[ArrKeyVal objectAtIndex:1] forKey:[ArrKeyVal objectAtIndex:0]];
                
            }
        }
        
        NSString *tmpStr = [dataDic objectForKey:@"iVer"];
        
        if ([tmpStr length] > 0)
        {
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([tmpStr intValue] > [versionNumber intValue])
            {
                [AppInfo updateAlert:[dataDic objectForKey:@"iVer"]];
                return NO;
            }
        }
        
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goMain=Y"])
    {
        //메인 이동
        [AppDelegate.navigationController fadePopToRootViewController];
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goBack=Y"])
    {
        //이전화면이동
        [AppDelegate.navigationController fadePopViewController];
        return NO;
    }
    
    //사파리로 열어야 될 경우 처리
    if ([SHBUtility isFindString:urlStr find:@"browser=Y"])
    {
        [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
        return NO;
    }
    
    //웹뷰안에 버튼 클릭시 스키마 유알엘을 타지 못하는 문제 해결(ios6은 문제 없음)
    if ([SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"5."] || [SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"4."])
    {
        if ([SHBUtility isFindString:urlStr find:@"iphonesbank://"])
        {
            [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
            return NO;
        }
    }
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	Debug(@"webViewDidStartLoad !!!");
    
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	Debug(@"webViewDidFinishLoad !!!");
    [AppDelegate closeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	Debug(@"didFailLoadWithError !!!");
    [AppDelegate closeProgressView];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBNotiListViewCell *cell = (SHBNotiListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBNotiListViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBNotiListViewCell *)currentObject;
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    SHBDataSet *notiDic = [self.dataList objectAtIndex:indexPath.row];
    
    cell.label1.text = notiDic[@"NOTICE_LIST"][@"TITLE"];
    cell.noti_seq = notiDic[@"NOTICE_LIST"][@"NOTC_SEQ"];
    
    if (indexPath.row == 0)
    {
        cell.lineView.hidden = NO;
    }else
    {
        cell.lineView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBDataSet *notiDic = [self.dataList objectAtIndex:indexPath.row];
    NSString *notiSeq = notiDic[@"NOTICE_LIST"][@"NOTC_SEQ"];
    
    SHBNoticeMenuViewController *viewController = [[SHBNoticeMenuViewController alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
    
    viewController.isPushAndScheme = YES;
    viewController.data = @{
                            @"screenID" : @"SM_03",
                            @"SEQ" : notiSeq,
                            };
    
    [AppDelegate.navigationController fadePopToRootViewController]; //메인 화면으로 들어간다.
    [AppDelegate.navigationController pushSlideUpViewController:viewController];
    [viewController release];
    
}
@end
