//
//  SHBELD_BA17_3ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_3ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBELD_WebViewController.h"
#import "SHBELD_BA17_5ViewController.h"
#import "SHBProductService.h"
#import "SHBTelephoneConsultationRequestViewController.h"

@interface SHBELD_BA17_3ViewController ()

@end

@implementation SHBELD_BA17_3ViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            // 수익률범위 버튼
            NSString *stringTemp = [NSString stringWithFormat:@"https://dev-m.shinhan.com/pages/financialPrdt/deposit/sb_deposit_detail2.jsp?PROD_ID=%@&EQUP_CD=SI", self.viewDataSource[@"상품코드"]];
            
            if (AppInfo.realServer) {
                stringTemp = [NSString stringWithFormat:@"https://m.shinhan.com/pages/financialPrdt/deposit/sb_deposit_detail2.jsp?PROD_ID=%@&EQUP_CD=SI", self.viewDataSource[@"상품코드"]];
            }
            
            SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
            viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                             @"SUBTITLE" : self.viewDataSource[@"상품한글명"],
                                             @"URL" : stringTemp,
                                             @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
        case 1:
        {
            // 가입 버튼
            SHBELD_BA17_5ViewController *viewController = [[SHBELD_BA17_5ViewController alloc] initWithNibName:@"SHBELD_BA17_5ViewController" bundle:nil];
            
            viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
            
            if (self.isPushAndScheme) {
                [viewController.viewDataSource setObject:self.data forKey:@"mdicPushInfo"];
            }
            
            [viewController setNeedsCert:YES];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
        case 100:
        {
            // 전화상담요청 페이지로 이동
            SHBTelephoneConsultationRequestViewController *viewController = [[SHBTelephoneConsultationRequestViewController alloc] initWithNibName:@"SHBTelephoneConsultationRequestViewController" bundle:nil];
            
            if ([viewController isTelephoneConsultationRequest]) {
                                
                AppInfo.commonDic = @{@"콜백서비스" : @"97",     // 예금
                                      @"페이지정보" : @"P41000", // S뱅크 > 상품가입 > 예적금가입 > 전화상담요청
                                      @"상품코드" : self.viewDataSource[@"상품코드"]};
                
                viewController.needsLogin = YES;
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            
            [viewController release];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 

- (void)viewReload
{
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:self.viewDataSource[@"상품한글명"] maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    [self.view bringSubviewToFront:self.button1];
    
    NSString *stringTemp = nil;
    
    if (AppInfo.realServer) {
        
        stringTemp = [NSString stringWithFormat:@"https://m.shinhan.com/pages/financialPrdt/deposit/sb_deposit_detail.jsp?PROD_ID=%@&EQUP_CD=SI", self.viewDataSource[@"상품코드"]];
    }
    else {
        
        stringTemp = [NSString stringWithFormat:@"https://dev-m.shinhan.com/pages/financialPrdt/deposit/sb_deposit_detail.jsp?PROD_ID=%@&EQUP_CD=SI", self.viewDataSource[@"상품코드"]];
    }
    
    [self.webView1 loadRequestWithString:stringTemp];
}

#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	[super executeWithDic:mDic];
    
    if (mDic) {
        
        self.isPushAndScheme = YES;
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:kD3276Id
                                                      viewController:self] autorelease];
        [self.service start];
        
        self.data = mDic;
    }
}

#pragma mark - Network

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    BOOL isEqual = NO;
    
    // productCode = 상품코드, recStaffNo = 권유직원번호
    for (NSDictionary *dic in [aDataSet arrayWithForKey:@"상품목록"]) {
        if ([dic[@"상품코드"] isEqualToString:self.data[@"productCode"]]) {
            isEqual = YES;
            
            self.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            break;
        }
    }
    
    if (!isEqual) {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:990 title:nil message:@"모집기간이 지난 상품입니다."];
        
        return NO;
    }
    
    [self viewReload];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 990) {
        [self.navigationController fadePopToRootViewController];
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
    self.button1 = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"예금/적금 가입"]; // 타이틀
    self.strBackButtonTitle = @"지수연동예금 상품설명";
    
    if (!self.isPushAndScheme) {
        
        [self viewReload];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
