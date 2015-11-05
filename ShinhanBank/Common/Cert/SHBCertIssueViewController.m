//
//  SHBCertIssueViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueViewController.h"
#import "SHBVersionService.h"

@interface SHBCertIssueViewController ()

- (void) loadWebView;
@end

@implementation SHBCertIssueViewController

@synthesize termsView;
@synthesize connectURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate Guide";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書案内";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 안내";
    }
    
    self.termsView.delegate = self;
//    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"viewdidload event"];
    [self performSelector:@selector(loadWebView) withObject:nil afterDelay:0.2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void) loadWebView
{
    /*
    if(AppInfo.realServer)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self.termsView loadRequestWithString:@"http://img.shinhan.com/sbank/prod/ysign_info_en.html"];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self.termsView loadRequestWithString:@"http://img.shinhan.com/sbank/prod/ysign_info_en.html"];
        }else
        {
            [self.termsView loadRequestWithString:@"http://img.shinhan.com/sbank/prod/ysign_info.html"];
        }
        
    }
    else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self.termsView loadRequestWithString:@"http://imgdev.shinhan.com/sbank/prod/ysign_info_en.html"];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self.termsView loadRequestWithString:@"http://imgdev.shinhan.com/sbank/prod/ysign_info_en.html"];
        }else
        {
           [self.termsView loadRequestWithString:@"http://imgdev.shinhan.com/sbank/prod/ysign_info.html"];
        }
    }
     */
    [self.termsView loadRequestWithString:self.connectURL];
}

- (IBAction) confirmClick:(id)sender //확인
{
    [self.navigationController fadePopViewController];
}

- (IBAction) testClick:(id)sender
{
    /*
    SHBDataSet *aVectorSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                      TASK_NAME_KEY : @"sfg.sphone.task.config.UserAccount",
                                                    TASK_ACTION_KEY : @"setUseAccSort",
                               }] autorelease];
    
    SHBDataSet *aDataSet1 = [[[SHBDataSet alloc] initWithDictionary:@{
                              @"고객번호" : @"0123456789",
                              @"서비스코드" : @"D0011",
                              @"계좌번호" : @"110121234501",
                              @"순서" : @"1",
                              }] autorelease];
    
    SHBDataSet *aDataSet2 = [[[SHBDataSet alloc] initWithDictionary:@{
                              @"고객번호" : @"0123456789",
                              @"서비스코드" : @"D0011",
                              @"계좌번호" : @"110121234502",
                              @"순서" : @"2",
                              }] autorelease];
    
    SHBDataSet *aDataSet3 = [[[SHBDataSet alloc] initWithDictionary:@{
                              @"고객번호" : @"0123456789",
                              @"서비스코드" : @"D0011",
                              @"계좌번호" : @"110121234503",
                              @"순서" : @"3",
                              }] autorelease];
    //aVectorSet.vectorTitle = @"이체내역";
    [aVectorSet insertObject:aDataSet1 forKey:@"vector0" atIndex:0];
    [aVectorSet insertObject:aDataSet2 forKey:@"vector1" atIndex:1];
    [aVectorSet insertObject:aDataSet3 forKey:@"vector2" atIndex:2];
    
    // release 처리
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:XDA_S00001 viewController:self] autorelease];
    self.service.previousData = aVectorSet;
    [self.service start];
     */
    [self.termsView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_sbank_app_link.jsp"];
}

#pragma mark - Delegate : UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
	//[SVProgressHUD show];
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	//[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
	
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    AppInfo.isWebSchemeCall = YES;
	NSString *urlStr = [[request URL] absoluteString];
    NSLog(@"urlStr:%@",urlStr);
    if ([urlStr isEqualToString:@"about:blank"])
    {
        return NO;
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
@end
