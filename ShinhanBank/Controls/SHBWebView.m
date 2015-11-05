//
//  SHBWebView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBWebView.h"

@implementation SHBWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadRequestWithString:(NSString *)request{
    
	NSURL *targetURL = [NSURL URLWithString:[SHBUtility addTimeStamp:request]];
    NSURLRequest *targetRequest = [NSURLRequest requestWithURL:targetURL];
	[self loadRequest:targetRequest];
}
- (void)loadRequestWithString:(NSString*)request delegateObj:(id)aDelegateObj
{
    self.delegate = aDelegateObj;
	NSURL *targetURL = [NSURL URLWithString:[SHBUtility addTimeStamp:request]];
    NSURLRequest *targetRequest = [NSURLRequest requestWithURL:targetURL];
	[self loadRequest:targetRequest];
}
- (void)loadRequestWithStringFile:(NSString *)request{
    
	NSURL *targetURL = [NSURL URLWithString:request];
    NSURLRequest *targetRequest = [NSURLRequest requestWithURL:targetURL];
	[self loadRequest:targetRequest];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {

    //[SVProgressHUD show];
    [AppDelegate showProgressView];


}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    //[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [AppDelegate closeProgressView];
    //[SVProgressHUD dismiss];
//    NSString *msg = @"인터넷 연결이 원할치 않습니다.";
//    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
//
//
}

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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    alertViewClick = NO;
	NSLog(@"javascript alert : %@",message);
	
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [customAlert show];
	
    //suyong 수정
    //iOS7 BETA6에서 문제가 발생됨
    //[alertView show] 로 팝업창이 올라와도 superview는 nil이다 superview의 변화가 없다
    //마찬가지로 alertView.subviews.count 변화도 없고, window의 subviews 도 변화가 없다
    //frame에도 변화가 없다.
    //alertView가 올라와 있으면(버튼을 클릭하지 않았다면) loop
    //    while (customAlert.hidden == NO && customAlert.superview != nil) {
	while (!alertViewClick) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
	}
	[customAlert release];
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    alertViewClick = NO;
	NSLog(@"javascript confirm : %@",message);
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
	[customAlert addButtonWithTitle:@"취소"];
	
    
    [customAlert show];
    
    //suyong 수정
    //iOS7 BETA6에서 문제가 발생됨
    //[alertView show] 로 팝업창이 올라와도 superview는 nil이다 superview의 변화가 없다
    //마찬가지로 alertView.subviews.count 변화도 없고, window의 subviews 도 변화가 없다
    //frame에도 변화가 없다.
    //alertView가 올라와 있으면(버튼을 클릭하지 않았다면) loop
    //    while (customAlert.hidden == NO && customAlert.superview != nil) {
	while (!alertViewClick) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
	}
    
	[customAlert release];
    
	return confirmResult;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //버튼 클릭했음..즉 alertView가 닫힘
    alertViewClick=YES;
    
	//index 0 : NO , 1 : YES
	if (buttonIndex == 1){
		confirmResult = NO;
	} else if (buttonIndex == 0) {
		confirmResult = YES;
	}
}
@end
