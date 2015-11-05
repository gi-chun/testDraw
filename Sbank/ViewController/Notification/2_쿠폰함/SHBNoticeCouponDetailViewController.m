//
//  SHBNoticeCouponDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBNoticeCouponDetailViewController.h"
#import "SHBForexRequestInfoViewController.h"        // 환전신청 view
#import "SHBNoticeCuponInputViewController.h"  //우대금리 조회
#import "SHBNoticeCuponStoreListViewController.h"
#import "SHBSmartNewListViewController.h"

@interface SHBNoticeCouponDetailViewController ()

@end

@implementation SHBNoticeCouponDetailViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag])
    {
        case 11:        // 이전 버튼
        {
            [self.view removeFromSuperview];
        }
            break;
            
        case 12:        // 목록 보기(새로고침 됨)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"couponListButtonDidPush" object:nil];
            [self.view removeFromSuperview];
        }
            break;
            
        case 21:        // 작업 정의 중
        {
            SHBForexRequestInfoViewController *viewController = [[[SHBForexRequestInfoViewController alloc] initWithNibName:@"SHBForexRequestInfoViewController" bundle:nil] autorelease];
            
            // 정보 setting
            viewController.selectCouponDic = self.dicDataDictionary;
            viewController.needsCert = YES;
            
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 22:        // 우대금리 조회하기
        {
            
            SHBNoticeCuponInputViewController *viewController = [[[SHBNoticeCuponInputViewController alloc] initWithNibName:@"SHBNoticeCuponInputViewController" bundle:nil] autorelease];
            
            
            [self.dicDataDictionary setObject:a_label0.text forKey:@"상품명"];
            [self.dicDataDictionary setObject:strDateResult forKey:@"우대금리유효기간"];
            viewController.selectCouponDic = self.dicDataDictionary;
            viewController.needsCert = YES;
            
            
            if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"11"]  &&
                ([self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"003"] ||
                 [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"004"] ||
                  [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"007"]))
            {
                viewController.isTypeB = NO;  //민트, 그린애,민트(온리인), s드림 정기예금
            }
            else{
                viewController.isTypeB = YES;  //(TOP회전정기, U드림 회전정기예금
            }
            
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
            
        }
            break;
            
            
        case 23:        // 영업점 상담 금리승인 내역
        {
            
            SHBNoticeCuponStoreListViewController *viewController = [[[SHBNoticeCuponStoreListViewController alloc] initWithNibName:@"SHBNoticeCuponStoreListViewController" bundle:nil] autorelease];
            
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
            
        }
            break;
            
            
        case 24:        // 스마트신규 추천 내역
        {
            
            SHBSmartNewListViewController *viewController = [[[SHBSmartNewListViewController alloc] initWithNibName:@"SHBSmartNewListViewController" bundle:nil] autorelease];
            viewController.isCoupon = YES;
            
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
            
        }
            break;
            
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark Xcode Generate

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
    
    webView1.delegate = self;
    //webView2.delegate = self;
    if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"12"])   // 환전 쿠폰
    {
        
        [typeView1 setHidden:NO];
        [typeView2 setHidden:YES];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:YES];
        [webView1 setHidden:YES];
        
        
        NSString *strDate1 = self.dicDataDictionary[@"등록일"];
        NSString *strDate2 = self.dicDataDictionary[@"유효일자"];
        NSString *strDateResult1 = [SHBUtility getDateWithDash:strDate1];
        NSString *strDateResult2 = [SHBUtility getDateWithDash:strDate2];
        
        label1.text = [NSString stringWithFormat:@"%@ 고객님께, 드리는 환율우대쿠폰", [AppInfo.userInfo objectForKey:@"고객성명"]];
        label2.text = self.dicDataDictionary[@"등록점명"];
        label3.text = [NSString stringWithFormat:@"%@~%@", strDateResult1, strDateResult2];
        label4.text = [NSString stringWithFormat:@"%@%%", self.dicDataDictionary[@"환전우대율"]];
        
        if ([self.dicDataDictionary[@"등록점"] isEqualToString:@"1100"])
        {
            [view2 setHidden:NO];
            [scrollView1 setContentSize:CGSizeMake(0, view1.frame.size.height)];
        }
        
    }
    
    
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"11"]  &&
             ([self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"003"] ||   //고객별산출금리 금리쿠폰
              [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"004"] ||
              [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"005"] ||
              [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"007"]))  //s드림 정기예금
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:YES];
        [typeView3 setHidden:NO];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:YES];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
        
        NSString *strDate1 = self.dicDataDictionary[@"등록일"];
        NSString *strDate2 = self.dicDataDictionary[@"유효일자"];
        NSString *strDateResult1 = [SHBUtility getDateWithDash:strDate1];
        NSString *strDateResult2 = [SHBUtility getDateWithDash:strDate2];
        
        
        strDateResult = [[NSString alloc] initWithFormat:@"%@~%@", strDateResult1, strDateResult2];
        
        NSString *tmp =  self.dicDataDictionary[@"제목"];
        //NSString *title = [tmp substringToIndex:[tmp length]-6];
        a_label0.text = tmp;
        a_label1.text = [NSString stringWithFormat:@"%@ 고객님께, 드리는 특별한 금리우대쿠폰 입니다.", [AppInfo.userInfo objectForKey:@"고객성명"]];
        a_label2.text = self.dicDataDictionary[@"등록점명"];
        a_label3.text = [NSString stringWithFormat:@"%@~%@", strDateResult1, strDateResult2];
        
        
    }
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"11"]  &&
             [self.dicDataDictionary[@"마케팅실행채널ID"]isEqualToString:@"002"] )  // 영업점승인금리 쿠폰
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:YES];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:NO];
        [typeView5 setHidden:YES];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
    }
    
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"98"] )  // 스마트신규 쿠폰
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:YES];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:NO];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
    }
    
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"11"])  // 민트 금리쿠폰
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:NO];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:YES];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
        NSString *strDate1 = self.dicDataDictionary[@"등록일"];
        NSString *strDate2 = self.dicDataDictionary[@"유효일자"];
        NSString *strDateResult1 = [SHBUtility getDateWithDash:strDate1];
        NSString *strDateResult2 = [SHBUtility getDateWithDash:strDate2];
        
        g_label1.text = [NSString stringWithFormat:@"%@ 고객님께, 드리는 금리우대쿠폰", [AppInfo.userInfo objectForKey:@"고객성명"]];
        g_label2.text = self.dicDataDictionary[@"등록점명"];
        g_label3.text = [NSString stringWithFormat:@"%@~%@", strDateResult1, strDateResult2];
        
        
        strCoupontUrl = self.dicDataDictionary[@"쿠폰URL2"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strCoupontUrl]]];
        [webView1 loadRequest:request];
    }
    
    
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"13"])  // 북21 금리우대쿠폰
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:NO];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:YES];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
        NSString *strDate1 = self.dicDataDictionary[@"등록일"];
        NSString *strDate2 = self.dicDataDictionary[@"유효일자"];
        NSString *strDateResult1 = [SHBUtility getDateWithDash:strDate1];
        NSString *strDateResult2 = [SHBUtility getDateWithDash:strDate2];
        
        g_label1.text = [NSString stringWithFormat:@"%@ 고객님께, 드리는 금리우대쿠폰", [AppInfo.userInfo objectForKey:@"고객성명"]];
        g_label2.text = self.dicDataDictionary[@"등록점명"];
        
        if ([strDate2 isEqualToString:@"제한없음"])
        {
            g_label3.text = @"제한없음";
        }
        else
        {
            g_label3.text = [NSString stringWithFormat:@"%@~%@", strDateResult1, strDateResult2];
        }
        
        strCoupontUrl = self.dicDataDictionary[@"쿠폰URL2"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strCoupontUrl]]];
        [webView1 loadRequest:request];
    }
    
    
    else if ([self.dicDataDictionary[@"쿠폰구분"]isEqualToString:@"14"])  // 북21 자유이용권 쿠폰
    {
        
        [typeView1 setHidden:YES];
        [typeView2 setHidden:NO];
        [typeView3 setHidden:YES];
        [typeView4 setHidden:YES];
        [typeView5 setHidden:YES];
        [view2 setHidden:YES];
        [btn1 setHidden:YES];
        
        // NSString *strDate1 = self.dicDataDictionary[@"등록일"];
        NSString *strDate2 = self.dicDataDictionary[@"유효일자"];
        // NSString *strDateResult1 = [SHBUtility getDateWithDash:strDate1];
        NSString *strDateResult2 = [SHBUtility getDateWithDash:strDate2];
        
        g_label1.text = [NSString stringWithFormat:@"%@ 고객님께, 드리는 신한은행 쿠폰", [AppInfo.userInfo objectForKey:@"고객성명"]];
        g_label2.text = self.dicDataDictionary[@"등록점명"];
        g_label3.text = [NSString stringWithFormat:@"%@", strDateResult2];
        
        strCoupontUrl = self.dicDataDictionary[@"쿠폰URL2"];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strCoupontUrl]]];
        [webView1 loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

#pragma mark - UIWebView Delegate

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
