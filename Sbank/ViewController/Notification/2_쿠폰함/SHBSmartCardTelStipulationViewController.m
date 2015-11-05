//
//  SHBSmartCardTelStipulationViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartCardTelStipulationViewController.h"
#import "SHBSmartCardTelRequestViewController.h"

@interface SHBSmartCardTelStipulationViewController () <SHBSmartCardTelRequestDelegate>
{
    BOOL _isSee;
    NSString *strUrl;
}

@property (retain, nonatomic) NSArray *collectionList;

@property (retain, nonatomic) SHBSmartCardTelRequestViewController *smartCardTelRequestViewController;

@end


@implementation SHBSmartCardTelStipulationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
//    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewHidden];
    [self setBottomMenuView];
    
    self.webView.delegate = self;
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [_mainSV addSubview:_mainView];
    //[_mainSV setContentSize:_mainView.frame.size];
    [_mainSV setContentSize:CGSizeMake(_mainView.frame.size.width, _mainView.frame.size.height + 120)];
    
    _isSee = NO;
    
    self.collectionList = @[ _useEssentialCollection, _useSelectCollection, _useInherentCollection ];
    
   // [self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
}

- (void)setBottomMenuView{
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
	if (!_bottomMenuView)
        // release 추가
		
        _bottomMenuView = [[[SHBBottomView alloc] initWithFrame:CGRectMake(0, viewHeight - (74+49), self.view.frame.size.width, 49)] autorelease];
	
	if (AppInfo.isLogin){
		[_bottomMenuView changeLogInOut:YES];
	}else{
		[_bottomMenuView changeLogInOut:NO];
	}
	
    [self changeBottmNotice:AppInfo.noticeState];
	[_bottomMenuView setDelegate:self];
	[self.view addSubview:_bottomMenuView];
//	[self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
}

//- (void)adjustView
//{
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height)];
//        
//    }
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.collectionList = nil;
    
    [_mainView release];
    [_mainSV release];
    [_useEssentialCollection release];
    [_useSelectCollection release];
    [_useInherentCollection release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setMainSV:nil];
    [self setUseEssentialCollection:nil];
    [self setUseSelectCollection:nil];
    [self setUseInherentCollection:nil];
    [super viewDidUnload];
}

#pragma mark - UIButton

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag])
    {
        case 1: // 이전
        {
            
           // [self.view removeFromSuperview];
            
            if (_stipulationView.alpha == 1) {
                
                CATransition *transition = [CATransition animation];
                [transition setDuration:0.3f];
                [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [transition setType:kCATransitionFade];
                [self.view.layer addAnimation:transition forKey:nil];
                
                [_stipulationView setAlpha:0];
                [_stipulationView removeFromSuperview];
            }
            else {
                
                if ([_delegate respondsToSelector:@selector(smartCardTelStipulationBack)]) {
                    
                    [_delegate smartCardTelStipulationBack];
                }
            }
            
        }
            break;
        case 2: // 보기
        {
            _isSee = YES;
            
            if (!AppInfo.realServer)
            {
                strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK_TEST];
            }
            else
            {
                strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK];
            }
            
            [_stipulationView setAlpha:1];
            
            [_stipulationView setFrame:_mainSV.frame];
            
            [self.view addSubview:_stipulationView];
            
//            [_mainView setHidden:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strUrl]]];
            [_webView loadRequest:request];
            
            
        }
            break;
        case 111: // 1. 필수적 정보 (동의함)
        case 112: // 1. 필수적 정보 (동의하지 않음)
        case 121: // 1. 선택적 정보 (동의함)
        case 122: // 1. 선택적 정보 (동의하지 않음)
        case 131: // 2. 고유식별정보 (동의함)
        case 132: // 2. 고유식별정보 (동의하지 않음)
        {
            NSUInteger index = ([sender tag] / 10) - 11;
            
            for (UIButton *button in _collectionList[index]) {
                
                [button setSelected:NO];
            }
            
            [sender setSelected:YES];
        }
            break;
        case 201: // 동의
        {
            if (!_isSee)
            {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"개인(신용)정보 수집,이용 동의서(비여신 금융거래) 및 고객권리 안내문 보기를 선택하여 확인 하시기 바랍니다."];
                return;
            }
            
            if (![_useEssentialCollection[0] isSelected])
            {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"1번 필수적 정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            if (![_useInherentCollection[0] isSelected])
            {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            self.smartCardTelRequestViewController = [[[SHBSmartCardTelRequestViewController alloc] initWithNibName:@"SHBSmartCardTelRequestViewController" bundle:nil] autorelease];
            
            _smartCardTelRequestViewController.delegate = self;
            self.smartCardTelRequestViewController.dicDataDictionary = self.dicDataDictionary;

            
            
            if ([self.type isEqualToString:@"A"])
            {
                self.smartCardTelRequestViewController.type= @"A";
            }
            else
            {
                self.smartCardTelRequestViewController.type= @"B";
            }
            
            
            [self.view addSubview:_smartCardTelRequestViewController.view];
            
            [_smartCardTelRequestViewController.view setFrame:CGRectMake(0,
                                                                         0,
                                                                         _smartCardTelRequestViewController.view.frame.size.width,
                                                                         _smartCardTelRequestViewController.view.frame.size.height - 74 - 49)];
        }
            break;
        case 202: // 동의하지 않음
        {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:202
                             title:@""
                           message:@"메시지 전송 및 전화상담 요청시 개인정보,수집,이용동의가 필요합니다. 동의하지 않으실 경우 ☎1577-8000(상담시간:09:00~18:00 은행휴무일제외)를 이용해 주시기 바랍니다. 감사합니다."];
        }
            break;
        case 203: // 약관 확인
        {
            CATransition *transition = [CATransition animation];
            [transition setDuration:0.3f];
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [transition setType:kCATransitionFade];
            [self.view.layer addAnimation:transition forKey:nil];
            
            [_stipulationView setAlpha:0];
            [_stipulationView removeFromSuperview];
//            [self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
            [_mainView setHidden:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SHBSmartCardTelRequest Delegate

- (void)smartCardTelRequestSuccess
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_smartCardTelRequestViewController.view setAlpha:0];
    [_smartCardTelRequestViewController.view removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(smartCardTelStipulationBack)]) {
        [_delegate smartCardTelStipulationBack];
    }
}

- (void)smartCardTelRequestBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_smartCardTelRequestViewController.view setAlpha:0];
    [_smartCardTelRequestViewController.view removeFromSuperview];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 202) {
        if ([_delegate respondsToSelector:@selector(smartCardTelStipulationBack)]) {
            [_delegate smartCardTelStipulationBack];
        }
    }
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


@end
