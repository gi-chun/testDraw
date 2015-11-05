//
//  SHBELD_WebViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_WebViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBELD_WebViewController ()

@property (retain, nonatomic) SHBDataSet *argDataSet;
@end

@implementation SHBELD_WebViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
            // 확인 버튼
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppDelegate closeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [AppDelegate closeProgressView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSLog(@"Start Load with Request !!!============================\n%@",request);
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
    
    if ([SHBUtility isFindString:urlStr find:@"shbcall://"])
    {
        NSString *commandStr;
        
        NSArray *tmpArr = [urlStr componentsSeparatedByString:@"://"];
        
        
        if ([SHBUtility isFindString:tmpArr[1] find:@"?"])
        {
            NSArray *cmdArr = [tmpArr[1] componentsSeparatedByString:@"?"];
            commandStr = cmdArr[0];
            
            NSArray *argArray = [cmdArr[1] componentsSeparatedByString:@"&"];
            self.argDataSet = [SHBDataSet dictionary];
            NSString *key, *value;
            for (int i = 0; i < [argArray count] ; i++)
            {
                NSArray *arr = [argArray[i] componentsSeparatedByString:@"="];
                key = arr[0];
                value = [arr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.argDataSet setObject:value forKey:key];
            }
           
        }else
        {
            commandStr = [urlStr substringFromIndex:10];
        }
       
        if ([commandStr isEqualToString:@"back"])
        {
            //현재 화면 닫기
             NSLog(@"back 명령");
            
        }else if ([commandStr isEqualToString:@"home"])
        {
            //메인화면으로 이동
            NSLog(@"home 명령");
        }else if ([commandStr isEqualToString:@"tel"])
        {
            //전화걸기
            NSLog(@"tel 명령");
            NSLog(@"파라미터:%@", self.argDataSet);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:self.argDataSet[@"msg"]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"취소", @"통화", nil];
            alert.tag = 2222;
            [alert show];
            [alert release];
            
        }else if ([commandStr isEqualToString:@"confirm"])
        {
            //확인
            NSLog(@"확인 명령");
            
            [self.navigationController fadePopViewController];
            
        }else
        {
            NSLog(@"알수 없는 명령");
        }
    }
	return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2222 && buttonIndex != alertView.firstOtherButtonIndex)
    {
        NSString *URL = [NSString stringWithFormat:@"tel:%@", self.argDataSet[@"telNo"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.webView1 = nil;
    self.viewDataSource = nil;
    self.view1 = nil;
    self.view2 = nil;
    
    self.argDataSet = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView1.delegate = self;
    // 타이틀
    if (self.viewDataSource[@"TITLE"] != nil) {
        
        [self setTitle:self.viewDataSource[@"TITLE"]]; // 사용자 임의 타이틀
    }
    else {
        
        [self setTitle:@"예금/적금 가입"]; // 기본 타이틀
    }
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:self.viewDataSource[@"SUBTITLE"] maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    if ([self.viewDataSource[@"URL"] hasSuffix:@".pdf"]) {
        
        [self.webView1 setScalesPageToFit:YES];
        
        [self.webView1 loadRequestWithStringFile:self.viewDataSource[@"URL"]];
    }
    else {
        
        [self.webView1 loadRequestWithString:self.viewDataSource[@"URL"]];
    }
    
    // 1: 초보자가이드, 약관ㄴ동의 및 상품설명서
    // 2: 지수연동예금(ELD) 주요 질의, 응답
    if ([self.viewDataSource[@"BOTTOM_TYPE"] isEqualToString:@"1"]) {
        
    }
    else if ([self.viewDataSource[@"BOTTOM_TYPE"] isEqualToString:@"2"]) {
        [self navigationBackButtonHidden];
        
        [self.view1 setHidden:YES];
        
        CGRect frame = self.webView1.frame;
        frame.size.height = self.view2.frame.size.height;
        [self.webView1 setFrame:frame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
