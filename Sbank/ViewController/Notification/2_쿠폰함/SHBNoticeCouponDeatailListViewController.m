//
//  SHBNoticeCouponDeatailListViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 10. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeCouponDeatailListViewController.h"
#import "SHBNotificationService.h"


@interface SHBNoticeCouponDeatailListViewController ()

@end

@implementation SHBNoticeCouponDeatailListViewController

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
    
    [self setTitle:@"예금/적금 금리우대쿠폰"];
     webView1.delegate = self;
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/coupon/rate_coupon.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    
    NSDictionary *dic = @{// @"고객번호" : AppInfo.customerNo,
                          // @"고객성명" : AppInfo.userInfo[@"고객성명"],
                           @"탑스클럽등급" : AppInfo.userInfo[@"탑스클럽등급"],
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
    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strURL]]]];
  

    
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
    if ([SHBUtility isFindString:urlStr find:@"Coupon_web=Y"])
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
            
            self.couponWebDic = dic;
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", _couponWebDic);
            
            
            SHBDataSet *dataSet = [[[SHBDataSet alloc] initWithDictionary:
                                        @{
                                          TASK_NAME_KEY : @"SMTCommonTask",
                                          TASK_ACTION_KEY : @"couponDownlodProcess",
                                          @"금리오퍼코드" : _couponWebDic[@"금리오퍼코드"],
                                          @"오퍼번호" : _couponWebDic[@"오퍼번호"],
                                          @"변환오퍼코드" : _couponWebDic[@"변환오퍼코드"],
                                          }] autorelease];
            
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_DOWNLOD_SERVICE viewController:self] autorelease];
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



- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    if (self.service.serviceId == COUPON_DOWNLOD_SERVICE)
    {
        
        
        
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
