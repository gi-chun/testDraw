//
//  SHBSmartCareDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartCareDetailViewController.h"

@interface SHBSmartCareDetailViewController ()

@end

@implementation SHBSmartCareDetailViewController

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
    
    webView.delegate = self;
    [_numberLabel initFrame:_numberLabel.frame];
    [_numberLabel setText:[NSString stringWithFormat:@"<midGray_13>전담직원 : </midGray_13><midLightBlue_13>%@(%@)</midLightBlue_13>\n<midGray_13>상담대표번호 : </midGray_13><midLightBlue_13>%@</midLightBlue_13>",
                         self.dicSelectedData[@"상담사이름"], self.dicSelectedData[@"상담사번호"], self.dicSelectedData[@"전화번호"]]];
    
    
    
    if ([[self.dicSelectedData objectForKey:@"GBN"] isEqualToString:@"01"] ||
        [[self.dicSelectedData objectForKey:@"GBN"] isEqualToString:@"02"] ||
        [[self.dicSelectedData objectForKey:@"GBN"] isEqualToString:@"03"] ||
        [[self.dicSelectedData objectForKey:@"GBN"] isEqualToString:@"04"])
    {
        NSString *detail_type = [NSString stringWithFormat:@"%@", [self.dicSelectedData objectForKey:@"KEYCODE"]];
        
        if (AppInfo.realServer) {
           [webView loadRequestWithString:[NSString stringWithFormat:@"%@/pages/notice/sb_smart_care_detail.jsp?KEYCODE=%@&EQUP_CD=SI", URL_M,detail_type]];
        }
        
        else {
            [webView loadRequestWithString:[NSString stringWithFormat:@"%@/pages/notice/sb_smart_care_detail.jsp?KEYCODE=%@&EQUP_CD=SI", URL_M_TEST,detail_type]];
         }
    
    }
    
    else if ([[self.dicSelectedData objectForKey:@"GBN"] isEqualToString:@"05"])
    {
        NSString *event_type = [NSString stringWithFormat:@"%@", [self.dicSelectedData objectForKey:@"EVNT_SEQ"]];
        if (AppInfo.realServer) {
            [webView loadRequestWithString:[NSString stringWithFormat:@"%@/pages/notice/event_detail.jsp?EVNT_SEQ=%@&EQUP_CD=SI&SERVICE=SCM", URL_M,event_type]];
        }
        else {
            [webView loadRequestWithString:[NSString stringWithFormat:@"%@/pages/notice/event_detail.jsp?EVNT_SEQ=%@&EQUP_CD=SI&SERVICE=SCM", URL_M_TEST,event_type]];
        }
    }
}

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag])
    {
        case 1: // 이전
        {
            if ([_delegate respondsToSelector:@selector(smartCareDetailBack)]) {
                [_delegate smartCareDetailBack];
            }
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.dicSelectedData[@"상담사번호"]]]];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.dicSelectedData[@"전화번호"]]]];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView

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


- (void)dealloc {
    [_numberLabel release];
    [super dealloc];
}
@end
