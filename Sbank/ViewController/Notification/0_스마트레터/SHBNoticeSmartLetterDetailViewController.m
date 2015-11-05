//
//  SHBNoticeSmartLetterDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartLetterDetailViewController.h"
#import "SHBNotificationService.h" // 서비스
#import "SHBUtilFile.h"
#import "SHBPushInfo.h"

@interface SHBNoticeSmartLetterDetailViewController ()
{
    BOOL _isReload;
}

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

/**
 view resize
 @param resizeHeight webView 높이
 */
- (void)resizeToView:(NSInteger)resizeHeight;

@end

@implementation SHBNoticeSmartLetterDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewHidden];
    
    self.webView.delegate = self;
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    CGFloat y = _subject.frame.origin.y;
    
    [self adjustToView:_subject
               originX:_subject.frame.origin.x
               originY:y
                  text:_subject.text];
    
    y += _subject.frame.size.height + 10;
    
    [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x,
                                                y,
                                                self.contentScrollView.frame.size.width,
                                                self.view.bounds.size.height - y)];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"일련번호" : AppInfo.commonDic[@"일련번호"],
                            }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTLETTER_E2411
                                                         viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
    
    _isReload = NO;
    
    if ([AppInfo.commonDic[@"쪽지URL"] length] > 0) {
        [_webView loadRequestWithString:AppInfo.commonDic[@"쪽지URL"]];
    }
    else {
        [_webView setHidden:YES];
        
        [self resizeToView:0];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isReload) {
        if ([AppInfo.commonDic[@"쪽지URL"] length] > 0) {
            [_webView loadRequestWithString:AppInfo.commonDic[@"쪽지URL"]];
        }
        else {
            [_webView setHidden:YES];
            
            [self resizeToView:0];
        }
    }
    
    _isReload = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_webView release];
    [_subject release];
    [_message release];
    [_contentView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setSubject:nil];
    [self setMessage:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

- (void)resizeToView:(NSInteger)resizeHeight
{
    CGFloat y = 0;
    
    [self adjustToView:_message
               originX:_message.frame.origin.x
               originY:y
                  text:_message.text];
    
    y += _message.frame.size.height + 10;
    
    [_webView setFrame:CGRectMake(_webView.frame.origin.x,
                                  y,
                                  _webView.frame.size.width,
                                  resizeHeight)];
    
    y += _webView.frame.size.height;
    
    [_contentView setFrame:CGRectMake(_contentView.frame.origin.x,
                                      y,
                                      _contentView.frame.size.width,
                                      _contentView.frame.size.height)];
    
    y += _contentView.frame.size.height;
    
    [self.contentScrollView setContentSize:CGSizeMake(320, y)];
}

#pragma mark - Button

/// 이전
- (IBAction)backBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(smartLetterDetailBack)]) {
        [_delegate smartLetterDetailBack];
    }
}

- (IBAction)listBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(smartLetterDetailList)]) {
        [_delegate smartLetterDetailList];
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
    AppInfo.isSmartLetterNew = [aDataSet[@"NEW_LETTER"] isEqualToString:@"Y"] ? YES : NO;
    AppInfo.isCouponNew = [aDataSet[@"NEW_COUPON"] isEqualToString:@"Y"] ? YES : NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SmartLetter_Coupon_New" object:nil];
    
    return YES;
}

#pragma mark - UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSInteger resizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    
    [AppDelegate closeProgressView];
    [self resizeToView:resizeHeight];
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
    
    //urlStr = @"https://sbk.shinhan.com/common/smt/jsp/callSbank/"
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
    if ([SHBUtility isFindString:urlStr find:@"iphonesbank://SM_06?"])
    {
        AppInfo.noticeState = 2;
        AppInfo.isSmartCareNoti = YES;
//        for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
//        {
//            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:AppInfo.noticeState];
//        }
        
        NSString *clsNm = @"SHBNoticeMenuViewController";
        
        SHBBaseViewController *viewController = [[[NSClassFromString(clsNm) class] alloc] initWithNibName:clsNm bundle:nil];
        AppInfo.lastViewController = viewController;
        //[AppDelegate.navigationController fadePopToViewController:viewController];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        viewController.isPushAndScheme = YES;
        viewController.data = @{
                                 @"screenID" : @"SM_06",
                                    
                                };
        [viewController release];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"smartCareReceiveNoti" object:nil];
        return NO;
    }
	return YES;
}
@end
