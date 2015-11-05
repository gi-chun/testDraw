//
//  SHBForexRequestInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestInfoViewController.h"
#import "SHBExchangeService.h" // 서비스

#import "SHBForexPreferentialRateCell.h" // 우대율 표 cell
#import "SHBForexRequestStipulationViewController.h" // 외화환전신청 약관동의

#import "SHBExchangePopupView.h" // list popup


@interface SHBForexRequestInfoViewController ()

@end

@implementation SHBForexRequestInfoViewController

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
    
    [self setTitle:@"외화환전신청"];
    self.strBackButtonTitle = @"외화환전신청 1단계";
    
    _infoWV.delegate = self;
    [[[_infoWV subviews] lastObject] setBounces:NO];
    
    NSString *URL = [NSString stringWithFormat:@"%@/pages/financialInfo/exchange_rate_gold/sb_foreign_currency_exchange_s1.jsp", AppInfo.realServer ? URL_M : URL_M_TEST];
    
    [_infoWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:URL]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCouponDic = nil;
    
    [_sectionView release];
    [_infoWV release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setSectionView:nil];
	[super viewDidUnload];
}

#pragma mark - Button

/// 우대율 조회
- (IBAction)preferentialRateBtn:(UIButton *)sender
{
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_TASK1_SERVICE
                                                   viewController:self] autorelease];
    [self.service start];
}

/// 확인
- (IBAction)nextBtn:(UIButton *)sender
{
    SHBForexRequestStipulationViewController *viewController = [[[SHBForexRequestStipulationViewController alloc] initWithNibName:@"SHBForexRequestStipulationViewController" bundle:nil] autorelease];
    
    viewController.selectCouponDic = _selectCouponDic;
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
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
    Debug(@"%@", aDataSet);
    
    self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
    
    SHBExchangePopupView *popupView = [[[SHBExchangePopupView alloc] initWithTitle:@"우대율 표"
                                                                     SubViewHeight:326] autorelease];
    [popupView.tableView setDataSource:self];
    [popupView.tableView setDelegate:self];
    
    [popupView showInView:self.navigationController.view animated:YES];
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSData *tempView = [NSKeyedArchiver archivedDataWithRootObject:_sectionView];
    UIView *view = [NSKeyedUnarchiver unarchiveObjectWithData:tempView];
    
    OFDataSet *dataSet = [OFDataSet dictionary];
    
    [dataSet insertObject:@"환전 스프레드 우대"
                   forKey:@"섹션명"
                  atIndex:0];
    
    [self.binder bindForAnnotation:view dataSet:dataSet depth:0];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBForexPreferentialRateCell *cell = (SHBForexPreferentialRateCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexPreferentialRateCell"];
    
    if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexPreferentialRateCell"
                                                       owner:self options:nil];
		cell = (SHBForexPreferentialRateCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppDelegate closeProgressView];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[[webView subviews] lastObject] flashScrollIndicators];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[AppDelegate closeProgressView];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[[webView subviews] lastObject] flashScrollIndicators];
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
