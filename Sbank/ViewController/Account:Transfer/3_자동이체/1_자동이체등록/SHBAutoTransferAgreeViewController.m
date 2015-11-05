//
//  SHBAutoTransferAgreeViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferAgreeViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBAutoTransferViewController.h"
#import "SHBLoanService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferAgreeViewController ()
{
    int serviceType;
    
    BOOL isRead1;
    BOOL isRead2;
    
    BOOL isNotNeed;
    BOOL isBackMarketingAgree;
}

- (BOOL)validationCheck;

@end

@implementation SHBAutoTransferAgreeViewController

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        if (isBackMarketingAgree && [_marketingWV isHidden]) {
            
            isBackMarketingAgree = NO;
            
            isRead1 = NO;
            [_btnAutoTransferAgree setSelected:NO];
            
            [self navigationBackButtonHidden];
            
            [_marketingWV setHidden:NO];
            [_mainView setHidden:YES];
            
            return;
        }
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:   // 자동이체 약관보기
        {
            isRead1 = YES;
            
            SHBWebViewConfirmViewController *nextViewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];

            if(AppInfo.realServer)
            {
                [nextViewController executeWithTitle:@"자동이체" SubTitle:@"자동이체약관" RequestURL:@"http://img.shinhan.com/sbank/yak/yak_auto.html"];
            }
            else
            {
                [nextViewController executeWithTitle:@"자동이체" SubTitle:@"자동이체약관" RequestURL:@"http://imgdev.shinhan.com/sbank/yak/yak_auto.html"];
            }
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 200:   // 개인정보 약관보기
        {
            isRead2 = YES;
            
            SHBWebViewConfirmViewController *nextViewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];
            if(AppInfo.realServer)
            {
                [nextViewController executeWithTitle:@"자동이체" SubTitle:@"개인(신용)정보 수집,이용,제공 동의서" RequestURL:@"http://img.shinhan.com/sbank/yak/yak_agree.html"];
            }
            else
            {
                [nextViewController executeWithTitle:@"자동이체" SubTitle:@"개인(신용)정보 수집,이용,제공 동의서" RequestURL:@"http://imgdev.shinhan.com/sbank/yak/yak_agree.html"];
            }
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 300:   // 자동이체 약관동의
        {
            _btnAutoTransferAgree.selected = !_btnAutoTransferAgree.isSelected;
        }
            break;
        case 400:   // 개인정보 약관동의
        {
            if(sender.isSelected) return;
            _btnAgree.selected = YES;
            _btnNotAgree.selected = NO;
        }
            break;
        case 500:   // 개인정보 약관 미동의
        {
            if(sender.isSelected) return;
            _btnAgree.selected = NO;
            _btnNotAgree.selected = YES;
        }
            break;
        case 600:   // 확인
        {
            if(![self validationCheck]) return;
            
            SHBAutoTransferViewController *nextViewController = [[[SHBAutoTransferViewController alloc] initWithNibName:@"SHBAutoTransferViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 700:   // 취소
        {
            if (isBackMarketingAgree && [_marketingWV isHidden]) {
                
                isBackMarketingAgree = NO;
                isRead1 = NO;
                [_btnAutoTransferAgree setSelected:NO];
                
                [self setMarketingView];
                
                return;
            }
            
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            if ([aDataSet[@"마케팅활용동의여부"] isEqualToString:@"1"] || [aDataSet[@"마케팅활용동의여부"] isEqualToString:@"2"])
            {
                // 동의한 경우
                
                [_mainView setHidden:NO];
                [_marketingWV setHidden:YES];
            }
            else {
                
                self.data = aDataSet;
                
                [self setMarketingView];
            }
        }
            break;
        case 1:
        {
            SHBAutoTransferViewController *nextViewController = [[[SHBAutoTransferViewController alloc] initWithNibName:@"SHBAutoTransferViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
            
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지

    if(!isRead1){
        strAlertMessage = @"자동이체 약관을 읽고 확인 버튼을 선택하시기 바랍니다.";
        goto ShowAlert;
    }

    if(!_btnAutoTransferAgree.isSelected){
        strAlertMessage = @"자동이체 약관에 동의하셔야 자동이체등록이 가능합니다.";
        goto ShowAlert;
    }
    
ShowAlert:
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:nil
												   cancelButtonTitle:@"확인"
												   otherButtonTitles:nil] autorelease];
		[alertView show];
        
		return NO;
	}
	
	return YES;
}

- (void)setMarketingView
{
    // 마케팅활용동의
    
    [self navigationBackButtonHidden];
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/marketing/marketing_info.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    NSDictionary *dic = @{ @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
                           @"필수정보동의여부" : @"1",
                           @"선택정보동의여부" : @"1",
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
    
    [_mainView setHidden:YES];
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

    self.title = @"자동이체";
    self.strBackButtonTitle = @"자동이체 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체등록 약관동의" maxStep:4 focusStepNumber:1] autorelease]];

    serviceType = 0;
    
    isRead1 = NO;
    isRead2 = NO;
    
    isNotNeed = NO; // 개인정보동의 여부 체크
    
    _marketingWV.delegate = self;
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2315" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];

    [self.service start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        _btnAutoTransferAgree.selected = NO;
        _btnAgree.selected = NO;
        _btnNotAgree.selected = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.marketingAgreeDic = nil;
    
    [_btnAutoTransferAgree release];
    [_btnAgree release];
    [_btnNotAgree release];
    [_infoAgreeView release];
    [_buttonView release];
    [_marketingWV release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnAutoTransferAgree:nil];
    [self setBtnAgree:nil];
    [self setBtnNotAgree:nil];
    [self setInfoAgreeView:nil];
    [self setButtonView:nil];
    [super viewDidUnload];
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
            
            self.marketingAgreeDic = dic;
            
            [_marketingAgreeDic setObject:@"1" forKey:@"은행구분"];
            [_marketingAgreeDic setObject:@"1" forKey:@"검색구분"];
            [_marketingAgreeDic setObject:AppInfo.customerNo forKey:@"고객번호"];
            [_marketingAgreeDic setObject:AppInfo.customerNo forKey:@"고객번호1"];
            [_marketingAgreeDic setObject:@"1" forKey:@"장표출력SKIP여부"];
            [_marketingAgreeDic setObject:@"" forKey:@"DATA존재유무"];
            [_marketingAgreeDic setObject:@"1" forKey:@"마케팅활용매체별동의"];
            [_marketingAgreeDic setObject:self.data[@"필수정보동의여부"] forKey:@"필수정보동의여부"];
            [_marketingAgreeDic setObject:self.data[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", _marketingAgreeDic);
            
            isBackMarketingAgree = YES;
            
            [self navigationBackButtonShow];
            
            [_mainView setHidden:NO];
            [_marketingWV setHidden:YES];
            
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
