//
//  SHBRetirementConfirmViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementConfirmViewController.h"
#import "SHBRetirementTermsViewController.h"            // 동의서 화면
#import "SHBPentionService.h"           // 퇴직연금 서비스


@interface SHBRetirementConfirmViewController ()

@end

@implementation SHBRetirementConfirmViewController

#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"퇴직연금";
    self.strBackButtonTitle = @"퇴직연금 동의 메인";
    
    [self navigationBackButtonHidden];
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/marketing/marketing_info.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    NSDictionary *dic = @{ @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
                           @"필수정보동의여부" : self.data[@"필수정보동의여부"],
                           @"선택정보동의여부" : self.data[@"선택정보동의여부"],
                           @"자택TM통지요청구분" : self.data[@"자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.data[@"직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.data[@"휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.data[@"SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.data[@"EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.data[@"DM희망지주소구분"],
                           @"VERSION" : [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"COM_SUBCHN_KBN" : CHANNEL_CODE };
    
    BOOL isFirst = YES;
    
    for (NSString *key in [dic allKeys]) {
        
        if (isFirst) {
            
            isFirst = NO;
            
            [URL appendFormat:@"%@=%@", key, dic[key]];
        }
        else {
            
            [URL appendFormat:@"&%@=%@", key, dic[key]];
        }
    }
    
    NSString *strURL = [(NSString *)URL stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    [_marketingWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strURL]]]];
    
    [[[_marketingWV subviews] lastObject] setBounces:NO];
    [_marketingWV setHidden:NO];
    
    [self.contentScrollView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_marketingWV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMarketingWV:nil];
    [super viewDidUnload];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (self.service.serviceId == PENSION_AGREE_RUN) {
        
        NSString *strClassName = NSStringFromClass([AppInfo.lastViewController class]);
        
        [AppDelegate.navigationController fadePopViewController];
        
        // 클래스 정보를 가지고 다음 뷰를 호출한다
        SHBBaseViewController *viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
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
    if ([SHBUtility isFindString:urlStr find:@"C2315_WEB=Y"])
    {
        NSArray *schemeArr = [urlStr componentsSeparatedByString:@"?"];
        
        if ([schemeArr count] == 2) {
            
            NSArray *tmpArr = [schemeArr[1] componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (NSString *str in tmpArr) {
                
                NSArray *array = [str componentsSeparatedByString:@"="];
                
                if ([array count] == 2) {
                    
                    NSString *key = [array[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *value = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [dic setObject:value forKey:key];
                }
            }
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", dic);
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"은행구분" : @"1",
                                                                         @"검색구분" : @"1",
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         @"고객번호1" : AppInfo.customerNo,
                                                                         @"마케팅활용동의여부" : dic[@"마케팅활용동의여부"],
                                                                         @"장표출력SKIP여부" : @"1",
                                                                         @"인터넷수행여부" : @"2",
                                                                         @"필수정보동의여부" : @"1",
                                                                         @"선택정보동의여부" : dic[@"선택정보동의여부"],
                                                                         @"자택TM통지요청구분" : dic[@"자택TM통지요청구분"],
                                                                         @"직장TM통지요청구분" : dic[@"직장TM통지요청구분"],
                                                                         @"휴대폰통지요청구분" : dic[@"휴대폰통지요청구분"],
                                                                         @"SMS통지요청구분" : dic[@"SMS통지요청구분"],
                                                                         @"EMAIL통지요청구분" : dic[@"EMAIL통지요청구분"],
                                                                         @"DM희망지주소구분" : dic[@"DM희망지주소구분"],
                                                                         @"DATA존재유무" : @"",
                                                                         @"마케팅활용매체별동의" : @"1",
                                                                         }];
            
            self.service = nil;
			self.service = [[[SHBPentionService alloc] initWithServiceId:PENSION_AGREE_RUN viewController:self] autorelease];
			self.service.requestData = dataSet;
			[self.service start];
            
            return NO;
        }
        else {
            
            return NO;
        }
        
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
