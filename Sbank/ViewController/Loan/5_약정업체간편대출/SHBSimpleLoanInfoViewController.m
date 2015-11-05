//
//  SHBSimpleLoanInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanInfoViewController.h"

#import "SHBTelephoneConsultationRequestViewController.h" // 전화상담요청
#import "SHBSimpleLoanSIDViewController.h" // 약정업체 간편대출 - 주민등록번호 확인 화면
#import "SHBSimpleLoanBusinessSearchViewController.h" // 약정업체 간편대출 - 약정업체 확인

@interface SHBSimpleLoanInfoViewController ()

@end

@implementation SHBSimpleLoanInfoViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 신청 안내";
    
    _infoWV.delegate = self;
    [[[_infoWV subviews] lastObject] setBounces:NO];
    
    NSString *URL = [NSString stringWithFormat:@"%@/sbank/prod/sbank_desc_999999999.html", AppInfo.realServer ? URL_IMAGE : URL_IMAGE_TEST];
    
    [_infoWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:URL]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_infoWV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoWV:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 전화상담요청
            
            SHBTelephoneConsultationRequestViewController *viewController = [[[SHBTelephoneConsultationRequestViewController alloc] initWithNibName:@"SHBTelephoneConsultationRequestViewController" bundle:nil] autorelease];
            
            if ([viewController isTelephoneConsultationRequest]) {
                
                AppInfo.commonDic = @{@"콜백서비스" : @"85",     // 대출
                                      @"페이지정보" : @"P44000", // S뱅크 > 상품가입 > 대출 > 전화상담요청
                                      @"상품코드" : @"[간편대출신청 전화상담요청]"};
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
            break;
            
        case 200: {
            
            // 약정업체 조회
            
            SHBSimpleLoanBusinessSearchViewController *viewController = [[[SHBSimpleLoanBusinessSearchViewController alloc] initWithNibName:@"SHBSimpleLoanBusinessSearchViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 300: {
            
            // 대출 신청
            
            SHBSimpleLoanSIDViewController *viewController = [[[SHBSimpleLoanSIDViewController alloc] initWithNibName:@"SHBSimpleLoanSIDViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIWebView

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

@end
