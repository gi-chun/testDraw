//
//  SHBVersionViewController.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBVersionViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "UIDevice+Hardware.h"

@interface SHBVersionViewController ()

@end

@implementation SHBVersionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_currentVerLabel release];
    [_latestVerLabel release];
	[_bgImageView release];
	[_modelNameLabel release];
	[_osVersionLabel release];
	[_bottomView1 release];
	[_bottomView2 release];
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCurrentVerLabel:nil];
    [self setLatestVerLabel:nil];
	[self setBgImageView:nil];
	[self setModelNameLabel:nil];
	[self setOsVersionLabel:nil];
	[self setBottomView1:nil];
	[self setBottomView2:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"버전확인"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    
    [self.view viewWithTag:NAVI_BACK_BTN_TAG].accessibilityLabel = [NSString stringWithFormat:@"%@ 뒤로이동", @"환경설정"];
    
    FrameResize(self.scrollView, 317, height(self.scrollView));
    FrameReposition(self.scrollView, 0, 77);
    
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"신한S뱅크 정보" maxStep:0 focusStepNumber:0]autorelease]];
	
//	UIImage *img = [UIImage imageNamed:@"box_infor.png"];
//	self.bgImageView.image = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
	
	NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
	NSString *buildDate = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"Build Date"];
	[self.currentVerLabel setText:[NSString stringWithFormat:@"현재버전 : %@ (%@)", version, buildDate]];
    
	Debug(@"AppInfo.versionInfo : %@", AppInfo.versionInfo);
	NSString *strLatestVersion = [AppInfo.versionInfo objectForKey:@"최신버전"];
	NSString *strLatestUpdate = [AppInfo.versionInfo objectForKey:@"최근출시일"];
	
	[self.latestVerLabel setText:[NSString stringWithFormat:@"최신버전 : %@ (%@)", strLatestVersion, [SHBUtility getDateWithDash:strLatestUpdate]]];
	
	NSString *strModel = [[UIDevice currentDevice]platformString];
	[self.modelNameLabel setText:[NSString stringWithFormat:@"모델명 : %@", strModel]];
	
	NSString *strOsVersion = [[UIDevice currentDevice]osVersionName];
	[self.osVersionLabel setText:[NSString stringWithFormat:@"OS버전명 : %@", strOsVersion]];
    
    
    
	NSInteger nCurrent = [[version stringByReplacingOccurrencesOfString:@"." withString:@""]integerValue];
	NSInteger nLatest = [[strLatestVersion stringByReplacingOccurrencesOfString:@"." withString:@""]integerValue];
        
	if (nLatest > nCurrent) {
		[self.bottomView2 setHidden:NO];
        [self.webView setHidden:NO];
        
        NSString *URL = nil;
        
        if (AppInfo.realServer) {
            URL = [NSString stringWithFormat:@"%@/sbank/yak/SbkUpIph.html", URL_IMAGE];
        }
        else {
            URL = [NSString stringWithFormat:@"%@/sbank/yak/SbkUpIph.html", URL_IMAGE_TEST];
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:URL]]]];
	}
	else
	{
		[self.bottomView1 setHidden:NO];
        [self.webView setHidden:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

- (IBAction)updateBtnAction:(SHBButton *)sender {
//	[UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:9876 title:@"" message:@"새로운 버전이 출시되었습니다. 버전업데이트를 하시겠습니까?"];
	[[[[UIAlertView alloc]initWithTitle:@"" message:@"새로운 버전이 출시되었습니다. 버전업데이트를 하시겠습니까?" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil]autorelease]show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/kr/app/id357484932?mt=8"]];
		// TODO: URL이 바뀔 수 있음
	}
}

@end
