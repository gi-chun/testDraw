//
//  SHBMainViewController.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SHBMainViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SHBPushInfo.h"

#import "SHBAccountService.h"
#import "SHBVersionService.h"

#import "SHBAccidentPopupView.h" // 고객센터 사고신고 팝업
#import "SHBAccidentInfoView.h" // 고객센터 사고신고 팝업

#import "SHBAccidentSearchInfoView.h" // 고객센터 사고신고 조회 팝업
#import "SFG_CertificateShare_SDS.h" //신한 앱간 인증서 이동
#import "SHBFirstLogInSettingViewController.h" //최초 기동시 뛰우는 로그인 설정 화면
#import "SHBFindBranchesLocationViewController.h" // 영업점검색, 대기고객조회 화면
#import "SHBFindBranchesMapViewController.h" // 위치기반 영업점/ATM 찾기 화면

#import "SHBCheckInputViewController.h"     // 수표조회/사고신고조회
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertElectronicSignViewController.h"
//#import "SHBCardSSOAgreeContentsViewController.h"
//#import "SHBCheckingViewController.h"
#import "INISAFEXSafe.h"

#import "SHBSearchView.h"
#include "amsLibrary.h"
#import "UIImageView+AsyncAndCache.h"
#import "SHBCertIssueViewController.h"

@interface SHBMainViewController () <SHBPopupViewDelegate>
{
    int shinyCount;
    BOOL isBolckOpen;
    int menuIndex;
    BOOL isMovePage;
    NSDictionary *myMenuDic;
}
- (void)shinyButton;
- (void)blockAccessbility;   //1depth 막음
//- (void)releaseAccessbility; //1depth 품
- (void)certLogOutAlert;
- (void)showSearchView;
//- (void)CloseSearchView;

@end

@implementation SHBMainViewController
@synthesize notiTypeBtn;
@synthesize notiTypeLabel;
@synthesize notiCloseBtn;
@synthesize notiView;
@synthesize notiPView;
@synthesize certExplainBtn;
@synthesize exCertExplainBtn;

/*
 - (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
 {
 
 for(NSDictionary *dic in aDataSet[@"exchange"])
 {
 if (!([dic[@"code"] isEqualToString:@"83"] || //평화은행
 [dic[@"code"] isEqualToString:@"56"] || //암로은행
 [dic[@"code"] isEqualToString:@"26"] || //구신한은행
 [dic[@"code"] isEqualToString:@"25"] || //서울은행
 [dic[@"code"] isEqualToString:@"21"] || //구조흥은행
 [dic[@"code"] isEqualToString:@"12"] || //농협회원
 [dic[@"code"] isEqualToString:@"06"] || //주택은행
 [dic[@"code"] isEqualToString:@"27"])) //한미은행
 {   // PopupListView 에서 사용 하도록 key값을 1, 2로 준다.
 [AppInfo.codeList.bankList addObject:@{@"1" : dic[@"value"], @"2" : dic[@"code"]}];
 }
 
 AppInfo.codeList.bankCode[dic[@"value"]] = dic[@"code"];
 AppInfo.codeList.bankCodeReverse[dic[@"code"]] = dic[@"value"];
 }
 
 [self.service release];
 self.service = nil;
 
 return NO;
 }
 */


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangedWallpaper" object:nil];
    [notiTypeBtn release];
    [notiTypeBtn release];
    [firstSubMenuArray release];
    [secondSubMenuArray release];
    [_noticeView release];
    [_noticeWebView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (BOOL)isJailBreakPhone{
    Debug(@"탈옥폰 체크!!!");
#if TARGET_IPHONE_SIMULATOR
    // -> Module/AhnLab/ 에서 .h파일은 냅두고 .a 라이브러리 파일은 프로젝트에서 빼면~ 시뮬레이터는 정상 작동합니다...- -;
    return FALSE; // -> 시뮬레이터일 경우 무조건 통과!!
#else //TARGET_IPHONE_DEVICE
    // #define ahnTrue 1
    // #define ahnFalse 0
    // #define ahnError -1
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger  iResult = [ams a3142:@"AHN_3379024345_TK"];
    [ams release];
    
    if(iResult == ahnTrue) {
        Debug(@"탈옥 폰입니다. result = [%d]", iResult);
        //탈옥폰
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        alert.tag = 444; //444=exit(1); -> 확인버튼 누를 시 종료 시킬려면 444로 바꾸세요~~
        [alert show];
        [alert release];
        return TRUE;
    }
    else {
        Debug(@"순정 폰입니다.");
        return FALSE;
    }
#endif
    
}
*/

//- (void)viewWillLayoutSubviews
//{
//    
//}

- (void)viewDidLoad
{
    // super viewDidLoad 전 처리사항
    

#ifndef DEBUG
    /*
    if ([self isJailBreakPhone]) {
        Debug(@"탈옥 폰 입니다!!!");
        //탈옥 관련 처리 할 거 있으면 쓰세요~
     
        return; //아무것도 안뜨고 로딩화면에서 스탑!!!
    }
     */

    if ([[AppDelegate rmrjtdmfcpzmgkqslek] isEqualToString:@"dlrjtdms14xkf5d8hrv^*hsdlqs07)lek$$&^%$!01243kfjasdfjk#%!12cnvwksjadsjhl81246a6^^aaq"])
    {
        
        [self requestSavePhoneInfo];
        return;
    }

#endif
 
    [super viewDidLoad];
    
    
    
    isBolckOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerSetAccessbility) name:@"bannerViewChange" object:nil];
    
    self.strBackButtonTitle = @"메인";
    
    _noticeWebView.delegate = self;
    
    //지시등 깜빡거림
    shinyCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shinyButton) userInfo:nil repeats:YES];
    
    Debug(@"\n------------------------------------------------------------------\
          \n메인뷰 viewDidLoad 시작 !!!\
          \n------------------------------------------------------------------");
    [self changeBackgroundImage];
    [self.bottomMenuView changeLogInOut:(AppInfo.isLogin == 0) ? NO : YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeBackgroundImage)
                                                 name:@"ChangedWallpaper"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popToRootViewControllerNotification)
                                                 name:@"popToRootViewControllerNotification"
                                               object:nil];
    
    // Do any additional setup after loading the view from its nib.
    // 2. Version Check
    if ([AppInfo.schemaUrl length] == 0 || AppInfo.schemaUrl == Nil)
    {
        
        [self requestVersionInfo];
    }
    
    // Add SubView To ScrollView
    [_scrollView addSubview:_menu1View];
    [_scrollView addSubview:_menu2View];
    [_menu1View setFrame:CGRectMake(_scrollView.frame.size.width*0, 0.0f, _menu1View.frame.size.width, _menu1View.frame.size.height)];
    [_menu2View setFrame:CGRectMake(_scrollView.frame.size.width*1, 0.0f, _menu2View.frame.size.width, _menu2View.frame.size.height)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*2, _scrollView.frame.size.height)];
    
    // Menu Icon Setting
    [self setMenuIcon];
    
    [_page1Image setHidden:NO];
    [_page2Image setHidden:NO];
    // Initialize
    indexCurrentMenuPage = 0;
    [self setImageWithPage:indexCurrentMenuPage];
    firstSubMenuArray  = [[NSMutableArray alloc] initWithCapacity:0];
    secondSubMenuArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 폴더 메뉴뷰에 테이블형식의 메뉴뷰 추가
    //[_tableMenuView setFrame:CGRectMake(9, 9, _tableMenuView.frame.size.width, 151)];
    [_tableMenuView setFrame:CGRectMake(0, 0, _tableMenuView.frame.size.width, 166)];
    [_folderView addSubview:_tableMenuView];
    [_tableMenuView setHidden:YES];
    //[_tableBigMenuView setFrame:CGRectMake(9, 9, _tableBigMenuView.frame.size.width, 212)];
    
    if (AppInfo.isiPhoneFive)
    {
        [_tableBigMenuView setFrame:CGRectMake(0, 0, _tableBigMenuView.frame.size.width, 275)];
    } else
    {
        [_tableBigMenuView setFrame:CGRectMake(0, 0, _tableBigMenuView.frame.size.width, 230)];
    }
    
    [_folderView addSubview:_tableBigMenuView];
    [_tableBigMenuView setHidden:YES];
    folder = [SHBFolders folder];
    folderGapHeight = 0;
    folderHeight = 0;
    // Version 정보셋팅
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    AppInfo.bundleVersion = versionNumber;
    
    NSString *typeofcert = [[NSUserDefaults standardUserDefaults]typeOfLoginCert];
    
    if ([typeofcert isEqualToString:@"testCert"]) //테스트용 인증서(테스트 서버 접속)
    {
        _versionLabel.text = [NSString stringWithFormat:@"Dev %@",versionNumber];
        
    } else if ([typeofcert isEqualToString:@"realCert"]) //실 인증서 제출(운영서버 접속)
    {
        _versionLabel.text = [NSString stringWithFormat:@"Ver %@",versionNumber];
        
    } else //디폴트(운영서버 접속)
    {
        _versionLabel.text = [NSString stringWithFormat:@"Ver %@",versionNumber];
    }
    //_versionLabel.text = [NSString stringWithFormat:@"Ver %@",versionNumber];
    //_versionLabel.text = [NSString stringWithFormat:@"Dev %@",@"2013.01.05"];
    /*
     NSString *firstStartApp = [[NSUserDefaults standardUserDefaults]isFirstAppStart];
     
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *switchAddress = [userDefaults objectForKey:@"SelectAddress"];
     
     if (firstStartApp == nil && ([switchAddress isEqualToString:@""] || switchAddress == nil))
     {
     [[NSUserDefaults standardUserDefaults]setFirstAppStart:@"앱최초실행기록함"];
     SHBFirstLogInSettingViewController *viewController = [[SHBFirstLogInSettingViewController alloc] initWithNibName:@"SHBFirstLogInSettingViewController" bundle:nil];
     //[self.navigationController pushFadeViewController:viewController];
     //[viewController release];
     [self presentModalViewController:viewController animated:YES];
     return;
     }
     */
    
    // 간편조회 설정 확인
    [self executeEasyInquiryAccount];
}

//방향 지시등 깜빡거림
- (void) shinyButton
{
    shinyCount++;
    
    if (shinyCount %2 == 1)
    {
        _rightButton.imageView.image = [UIImage imageNamed:@"arrow_right_focus.png"];
        _leftButton.imageView.image = [UIImage imageNamed:@"arrow_left_focus.png"];
    } else
    {
        _rightButton.imageView.image = [UIImage imageNamed:@"arrow_right.png"];
        _leftButton.imageView.image = [UIImage imageNamed:@"arrow_left.png"];
        shinyCount = 0;
    }
    
}
- (void)redrawMainView
{
//    NSLog(@"aaaa:%@",@"redrawMainView");
//    [self mainBannerListBtnClick:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"downloadBannerImgDone" object:nil];
//    [self mainBannerListBtnClick:nil];
//    [self.view setNeedsDisplay];
}
- (void)startTicker{
    //NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"TickerList.vector.data"];
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M001List.vector.data"];
    if ([tickArray count] > 0)
    {
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
            NSLog(@"아이콘Url:%@",[nDic objectForKey:@"아이콘Url"]);
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            //CGRect tickerRect;
            
            switch (i)
            {
                case 0:

                    [_bannerScrollBtn1 setIsAccessibilityElement:YES];
                    //[_bannerScrollBtn1 setIsAccessibilityElement:NO];
                    _bannerMainBtn1.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    _bannerScrollBtn1.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    
                    [_bannerMainBtn1 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    [_bannerScrollBtn1 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    
                    break;
                case 1:

                    [_bannerScrollBtn2 setIsAccessibilityElement:YES];
                    //[_bannerScrollBtn2 setIsAccessibilityElement:NO];
                    _bannerMainBtn2.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    _bannerScrollBtn2.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    
                    [_bannerMainBtn2 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    [_bannerScrollBtn2 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    
                    break;
                case 2:

                    [_bannerScrollBtn3 setIsAccessibilityElement:YES];
                    //[_bannerScrollBtn3 setIsAccessibilityElement:NO];
                    _bannerMainBtn3.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    _bannerScrollBtn3.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    
                    [_bannerMainBtn3 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    [_bannerScrollBtn3 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    
                    break;
                case 3:

                    [_bannerScrollBtn4 setIsAccessibilityElement:YES];
                    //[_bannerScrollBtn4 setIsAccessibilityElement:NO];
                    _bannerMainBtn4.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    _bannerScrollBtn4.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    
                    [_bannerMainBtn4 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    [_bannerScrollBtn4 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    
                    break;
                case 4:

                    [_bannerScrollBtn5 setIsAccessibilityElement:YES];
                    //[_bannerScrollBtn5 setIsAccessibilityElement:NO];
                    _bannerMainBtn5.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    _bannerScrollBtn5.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    
                    [_bannerMainBtn5 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    [_bannerScrollBtn5 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                    
                    break;
                default:
                    break;
            }
        }
        _bannerOpenBtn.hidden = NO;
        _bannerOpenBtn.isAccessibilityElement = YES;
        
        [_bannerOpenBtn setImage:[UIImage imageNamed:@"btn_mail_close_off.png"] forState:UIControlStateNormal];
        [_bannerOpenBtn setImage:[UIImage imageNamed:@"btn_mail_close_on.png"] forState:UIControlStateHighlighted];
    } else
    {
        _bannerOpenBtn.hidden = YES;
        _bannerOpenBtn.isAccessibilityElement = NO;
    }
    
    if (tickArray){
        _tickerView.isSlideText = NO;
        
        [_tickerView executeWithData:tickArray];
        
        if ([tickArray count] > 3)
        {
            _bannerOpenBtn.hidden = NO;
            _bannerOpenBtn.isAccessibilityElement = YES;
            if ([tickArray count] == 4)
            {

                _bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height + 9);
            } else if ([tickArray count] == 5)
            {

                _bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height+ 54);
            }
            
            
            
        } else if ([tickArray count] == 1)
        {
            _bannerOpenBtn.hidden = NO;
            _bannerOpenBtn.isAccessibilityElement = YES;
            
            [_bannerListBtn setFrame:CGRectMake(_bannerListBtn.frame.origin.x, _bannerListBtn.frame.origin.y - 72.0f, _bannerListBtn.frame.size.width, _bannerListBtn.frame.size.height)];
            [_bannerView setFrame:CGRectMake(0, _bannerView.frame.origin.y + 72.0f, _bannerView.frame.size.width, _bannerView.frame.size.height - 112.0f)];
            [_bannerScrollView setFrame:CGRectMake(_bannerScrollView.frame.origin.x, _bannerScrollView.frame.origin.y + 130.0f, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
            
        } else if ([tickArray count] == 2)
        {
            _bannerOpenBtn.hidden = NO;
            _bannerOpenBtn.isAccessibilityElement = YES;
            [_bannerListBtn setFrame:CGRectMake(_bannerListBtn.frame.origin.x, _bannerListBtn.frame.origin.y - 36.0f, _bannerListBtn.frame.size.width, _bannerListBtn.frame.size.height)];
            [_bannerView setFrame:CGRectMake(0, _bannerView.frame.origin.y + 36.0f, _bannerView.frame.size.width, _bannerView.frame.size.height - 56.0f)];
            [_bannerScrollView setFrame:CGRectMake(_bannerScrollView.frame.origin.x, _bannerScrollView.frame.origin.y + 65.0f, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        }
        
        
    }else{
        _tickerView.hidden = YES;
        [_tickerView.voiceOverBtn setIsAccessibilityElement:NO];
        _bannerOpenBtn.hidden = YES;
        _bannerOpenBtn.isAccessibilityElement = NO;
    }
 
    
    
}

- (void)bannerSetAccessbility
{
    /*
     NSLog(@"bannerSetAccessbility:%i",AppInfo.bannerAccessBtnTag - 1);
     NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"TickerList.vector.data"];
     NSDictionary *nDic = [tickArray objectAtIndex:AppInfo.bannerAccessBtnTag - 1];
     switch (AppInfo.bannerAccessBtnTag)
     {
     case 1:
     [_bannerMainBtn1 setIsAccessibilityElement:YES];
     [_bannerMainBtn2 setIsAccessibilityElement:NO];
     [_bannerMainBtn3 setIsAccessibilityElement:NO];
     [_bannerMainBtn4 setIsAccessibilityElement:NO];
     [_bannerMainBtn5 setIsAccessibilityElement:NO];
     _bannerMainBtn1.accessibilityLabel = [nDic objectForKey:@"티커제목"];
     break;
     case 2:
     
     [_bannerMainBtn2 setIsAccessibilityElement:YES];
     
     [_bannerMainBtn1 setIsAccessibilityElement:NO];
     [_bannerMainBtn3 setIsAccessibilityElement:NO];
     [_bannerMainBtn4 setIsAccessibilityElement:NO];
     [_bannerMainBtn5 setIsAccessibilityElement:NO];
     _bannerMainBtn2.accessibilityLabel = [nDic objectForKey:@"티커제목"];
     
     break;
     case 3:
     [_bannerMainBtn3 setIsAccessibilityElement:YES];
     [_bannerMainBtn1 setIsAccessibilityElement:NO];
     [_bannerMainBtn2 setIsAccessibilityElement:NO];
     [_bannerMainBtn4 setIsAccessibilityElement:NO];
     [_bannerMainBtn5 setIsAccessibilityElement:NO];
     _bannerMainBtn3.accessibilityLabel = [nDic objectForKey:@"티커제목"];
     break;
     case 4:
     [_bannerMainBtn4 setIsAccessibilityElement:YES];
     [_bannerMainBtn1 setIsAccessibilityElement:NO];
     [_bannerMainBtn2 setIsAccessibilityElement:NO];
     [_bannerMainBtn3 setIsAccessibilityElement:NO];
     [_bannerMainBtn5 setIsAccessibilityElement:NO];
     _bannerMainBtn4.accessibilityLabel = [nDic objectForKey:@"티커제목"];
     break;
     case 5:
     [_bannerMainBtn5 setIsAccessibilityElement:YES];
     [_bannerMainBtn1 setIsAccessibilityElement:NO];
     [_bannerMainBtn2 setIsAccessibilityElement:NO];
     [_bannerMainBtn3 setIsAccessibilityElement:NO];
     [_bannerMainBtn4 setIsAccessibilityElement:NO];
     _bannerMainBtn5.accessibilityLabel = [nDic objectForKey:@"티커제목"];
     break;
     default:
     break;
     }
     */
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Debug(@"메인 메뉴의 viewWillAppear 실행 !!!");
    
    // 하단의 퀵메뉴에 로그인,아웃 버튼 교체
    [self.bottomMenuView changeLogInOut:(AppInfo.isLogin == 0) ? NO : YES];
    
    // 최초 앱구동시 간편조회를 통해 계좌조회 화면 이동시 로그인 취소할 경우
    AppInfo.isEasyInquiry = NO;
    
    AppInfo.indexQuickMenu = 0; //하단 메뉴 눌리게
    
    //앱접근성일경우 페이지 이동버튼의 위치를 이동한다
    if (!UIAccessibilityIsVoiceOverRunning())
    {
        if (!AppInfo.isiPhoneFive)
        {
            [_leftButton setFrame:CGRectMake(_leftButton.frame.origin.x, 182.0f, _leftButton.frame.size.width, _leftButton.frame.size.height)];
            [_rightButton setFrame:CGRectMake(_rightButton.frame.origin.x, 182.0f, _rightButton.frame.size.width, _rightButton.frame.size.height)];
        }else
        {
            [_leftButton setFrame:CGRectMake(_leftButton.frame.origin.x, 225.0f, _leftButton.frame.size.width, _leftButton.frame.size.height)];
            [_rightButton setFrame:CGRectMake(_rightButton.frame.origin.x, 225.0f, _rightButton.frame.size.width, _rightButton.frame.size.height)];
        }
        
    }else
    {
        if (!AppInfo.isiPhoneFive)
        {
            [_leftButton setFrame:CGRectMake(_leftButton.frame.origin.x, 270.0f, _leftButton.frame.size.width, _leftButton.frame.size.height)];
            [_rightButton setFrame:CGRectMake(_rightButton.frame.origin.x, 270.0f, _rightButton.frame.size.width, _rightButton.frame.size.height)];
        }else
        {
            [_leftButton setFrame:CGRectMake(_leftButton.frame.origin.x, 320.0f, _leftButton.frame.size.width, _leftButton.frame.size.height)];
            [_rightButton setFrame:CGRectMake(_rightButton.frame.origin.x, 320.0f, _rightButton.frame.size.width, _rightButton.frame.size.height)];
        }
    }
    
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - For Banner
- (IBAction)mainBannerBtnClick:(id)sender
{
    //@"M001List.vector.data"
    //NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"TickerList.vector.data"];
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M001List.vector.data"];
    
    if ([tickArray count] == 0) {
        return;
    }
    
    _tickerView.hidden = YES;
    _bannerView.hidden = NO;
    _bannerOpenBtn.hidden = YES;
    
//    _bannerScrollBtn1.backgroundColor = [UIColor whiteColor];
//    _bannerScrollBtn2.backgroundColor = [UIColor whiteColor];
//    _bannerScrollBtn3.backgroundColor = [UIColor whiteColor];
//    _bannerScrollBtn4.backgroundColor = [UIColor whiteColor];
//    _bannerScrollBtn5.backgroundColor = [UIColor whiteColor];
    
    if (_bannerScrollBtn1.currentBackgroundImage != nil) _bannerScrollBtn1.backgroundColor = [UIColor whiteColor];
    if (_bannerScrollBtn2.currentBackgroundImage != nil) _bannerScrollBtn2.backgroundColor = [UIColor whiteColor];
    if (_bannerScrollBtn3.currentBackgroundImage != nil) _bannerScrollBtn3.backgroundColor = [UIColor whiteColor];
    if (_bannerScrollBtn4.currentBackgroundImage != nil) _bannerScrollBtn4.backgroundColor = [UIColor whiteColor];
    if (_bannerScrollBtn5.currentBackgroundImage != nil) _bannerScrollBtn5.backgroundColor = [UIColor whiteColor];
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        for (int i = 1; i < 19; i++) {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:NO];
        }
        
        [[[self view] viewWithTag:567] setIsAccessibilityElement:NO];
        [[[self view] viewWithTag:756] setIsAccessibilityElement:NO];
        
        [super blockAccessBottomMenuView:YES];
        
        [_bannerField becomeFirstResponder];
        [_bannerField resignFirstResponder];
        //[_page1Image setIsAccessibilityElement:NO];
        //[_page2Image setIsAccessibilityElement:NO];
//        [_bannerMainBtn1 setIsAccessibilityElement:NO];
//        [_bannerMainBtn2 setIsAccessibilityElement:NO];
//        [_bannerMainBtn3 setIsAccessibilityElement:NO];
//        [_bannerMainBtn4 setIsAccessibilityElement:NO];
//        [_bannerMainBtn5 setIsAccessibilityElement:NO];
        
        [_bannerOpenBtn setIsAccessibilityElement:NO];
        [_tickerView.voiceOverBtn setIsAccessibilityElement:NO];
        [_bannerListBtn setIsAccessibilityElement:YES];
        
        
    }
    
    
    
}

- (IBAction)mainBannerListBtnClick:(id)sender; //메인화면 배너 리스트 오픈 터치
{
    _tickerView.hidden = NO;
    _bannerView.hidden = YES;
    _bannerOpenBtn.hidden = NO;
    
    _bannerScrollBtn1.backgroundColor = [UIColor clearColor];
    _bannerScrollBtn2.backgroundColor = [UIColor clearColor];
    _bannerScrollBtn3.backgroundColor = [UIColor clearColor];
    _bannerScrollBtn4.backgroundColor = [UIColor clearColor];
    _bannerScrollBtn5.backgroundColor = [UIColor clearColor];
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        for (int i = 1; i < 19; i++) {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:YES];
        }
        
        [[[self view] viewWithTag:567] setIsAccessibilityElement:YES];
        [[[self view] viewWithTag:756] setIsAccessibilityElement:YES];
        
        [super blockAccessBottomMenuView:NO];
        
        [_bannerField becomeFirstResponder];
        [_bannerField resignFirstResponder];
        
        if ([_rightButton isHidden])
        {
            //[_page1Image setIsAccessibilityElement:NO];
            //[_page2Image setIsAccessibilityElement:YES];
        }
        else
        {
            //[_page1Image setIsAccessibilityElement:YES];
            //[_page2Image setIsAccessibilityElement:NO];
        }
        
//        [_bannerMainBtn1 setIsAccessibilityElement:YES];
//        [_bannerMainBtn2 setIsAccessibilityElement:YES];
//        [_bannerMainBtn3 setIsAccessibilityElement:YES];
//        [_bannerMainBtn4 setIsAccessibilityElement:YES];
//        [_bannerMainBtn5 setIsAccessibilityElement:YES];
        
        [_bannerOpenBtn setIsAccessibilityElement:YES];
        [_tickerView.voiceOverBtn setIsAccessibilityElement:YES];
        
        [_bannerListBtn setIsAccessibilityElement:NO];
    }
    
}

- (IBAction)mainBannerContentClick:(id)sender
{
    UIButton *tmpBtn = sender;
    int btnTag =  (tmpBtn.tag - 4000);
    //NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"TickerList.vector.data"];
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M001List.vector.data"];
    
    if ([tickArray count] == 0) {
        return;
    }
    
    NSDictionary *nDic = [tickArray objectAtIndex:btnTag];
    NSString *tickerURL = [NSString stringWithFormat:@"%@&EQUP_CD=SI",[nDic objectForKey:@"티커Url"]];
    
    
    SHBDataSet *bannerDic  = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                               @"티커제목" : [nDic objectForKey:@"티커제목"],
                               @"티커번호" : [nDic objectForKey:@"티커번호"],
                               @"티커Url" : tickerURL,
                               @"티커구분" : [nDic objectForKey:@"티커구분"],
                               @"아이콘Url" : [nDic objectForKey:@"아이콘Url"],
                               }] autorelease];
    
    
    if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"0"] || [[nDic objectForKey:@"티커구분"] isEqualToString:@"1"]) //새소식연결,이벤트
    {
        AppInfo.commonDic = @{ @"배너" : bannerDic };
        AppInfo.indexQuickMenu = 1;
        //2014.07.09 변경 : 로그인전과 로그인 후 알림 메인 UI 변경
        /*
        if (AppInfo.isLogin == LoginTypeNo)
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuNotLogInViewController") class] alloc] initWithNibName:@"SHBNoticeMenuNotLogInViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }else
        {
            UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
            [self.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController pushSlideUpViewController:viewController];
            [viewController release];
        }
         */
        //메인배너 클릭시 무조건 기존 새소식으로 이동
        UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
        [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
        [self.navigationController fadePopToRootViewController];
        [AppDelegate.navigationController pushSlideUpViewController:viewController];
        [viewController release];
        
    }  else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"2"]) //m신한 연결
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
    } else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"3"]) //기타
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // base view 동작 필요한 경우위해 super 호출
    [super alertView:alert clickedButtonAtIndex:buttonIndex];
    
    if (alert.tag == 444 && buttonIndex == 0)
    { // "확인" 버튼
        exit(1);
    }else if (alert.tag == 337337)
    {
        if (buttonIndex == 0) {
            if ([CLLocationManager locationServicesEnabled])
            {
                // 위치기반 영업점/ATM 찾기 화면으로
                SHBFindBranchesMapViewController *viewController = [[[SHBFindBranchesMapViewController alloc]initWithNibName:@"SHBFindBranchesMapViewController" bundle:nil]autorelease];
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }else
            {
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"현재위치를 검색할 수 없습니다. 아이폰의 설정에서 '위치서비스'가 '켬'으로 되어 있는지 확인해주시기 바랍니다."];
            }
        }else
        {
            // 영업점/ATM 검색화면으로..
            SHBFindBranchesLocationViewController *viewController = [[[SHBFindBranchesLocationViewController alloc]initWithNibName:@"SHBFindBranchesLocationViewController" bundle:nil]autorelease];
            viewController.strMenuTitle = @"영업점/ATM 검색";
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
    }else if (alert.tag == 445)
    {
        [self requestBankCode];
    }
    else if (alert.tag == 8888)  //신한S기업뱅크
    {
        if (buttonIndex == 0) {
            SHBPushInfo *push = [SHBPushInfo instance];
            [push requestOpenURL:@"iphoneSbizbank://" Parm:nil];
        }
    }
    else if (alert.tag == 76589 && buttonIndex == 0)
    {
        //로그아웃
        //[AppInfo logout];
//        NSDictionary *nDic = [firstSubMenuArray objectAtIndex:menuIndex - 1];
//        if ([[nDic objectForKey:@"controller"] length] > 0 || [[nDic objectForKey:@"webAddress"] length] > 0)
//        {
//            [self pushMenuViewController:nDic];
//        }else if ( [[nDic objectForKey:@"schemeURL"] length] > 0)
//        {
//            SHBPushInfo *push = [SHBPushInfo instance];
//            [push requestOpenURL:[nDic objectForKey:@"schemeURL"] Parm:nil];
//        }else
//        {
//            if ([[nDic objectForKey:@"depth2key"] length] > 0)
//            {
//                NSString *title = [nDic objectForKey:@"title"];
//                NSString *depth2Key = [nDic objectForKey:@"depth2key"];
//                [self loadFolderSecondDepthWithTitle:title Key:depth2Key Sender:nil];
//            }
//        }
        
        AppInfo.isSettingServiceView = YES;
        [AppInfo logout];
        NSString *controlName = [myMenuDic objectForKey:@"controller"];
        NSString *controlNibName = [myMenuDic objectForKey:@"controller"];
        
        SHBBaseViewController *viewController = [[[NSClassFromString(controlName) class] alloc] initWithNibName:controlNibName bundle:nil];
        if ([[myMenuDic objectForKey:@"needsLogin"] isEqualToString:@"Y"] || [[myMenuDic objectForKey:@"needsLogin"] isEqualToString:@"1"]){
            viewController.needsLogin = YES;
            viewController.needsCert = NO;
        }else if ([[myMenuDic objectForKey:@"needsLogin"] isEqualToString:@"2"]){
            viewController.needsLogin = NO;
            viewController.needsCert = YES;
        }else{
            viewController.needsLogin = NO;
            viewController.needsCert = NO;
        }
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
    }else if (alert.tag == 76589 && buttonIndex == 1)
    {
        //로그아웃 취소
        AppInfo.certProcessType = CertProcessTypeNo;
    }else if (alert.tag == 1560 && buttonIndex == 0)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
        {
            //계좌조회 위젯
            NSString *nickName = @"S뱅크계좌조회";
            
            nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
            
            NSString *argStr = [NSString stringWithFormat:@"screenID=D0011&nickName=%@",nickName];
            #ifdef DEVELOPER_MODE
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"dev-m.shinhan.com", WIDGET_SERVICE_URL,argStr];
            #else
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"m.shinhan.com", WIDGET_SERVICE_URL,argStr];
            #endif
            NSLog(@"aaaa:%@",urlStr);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
    
}


#pragma mark - IBAction;
- (IBAction)openFolder:(UIButton*)sender{
    
    //동시에 버튼 터치 되는것 막음
    if (!isBolckOpen)
    {
        isBolckOpen = YES;
    }else
    {
        return;
    }
    
    // 현재 버튼 인덱스 셋팅
    indexCurrentBtnTag = sender.tag;
    _tickerView.hidden = YES;
    [_tickerView.voiceOverBtn setIsAccessibilityElement:NO];
    
    _bannerView.hidden = YES;
    _bannerOpenBtn.hidden = YES;
    _bannerOpenBtn.isAccessibilityElement = NO;
    
    // 1단계 폴더의 메뉴 버튼 셋팅(indexCurrentMenuTag Setting)
    [self loadFolderFirstDepthWithIndex:indexCurrentBtnTag];
    // 활성화 이미지 위치(위 메소드 1단계 폴더의 메뉴 버튼 셋팅에서 폴더뷰 사이즈를 조절한다.)
    float pointY = sender.frame.origin.y + sender.frame.size.height + 15;
    float oversize = (_tickerView.frame.size.height + _tickerView.frame.origin.y) - (pointY + _folderView.frame.size.height + 50);
    if (oversize > 0) oversize = 0;
    [_focusIconImage setFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + oversize, sender.frame.size.width, sender.frame.size.height)];
    // 스마트금융 별도 화면 오픈
    SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSmartBankViewController") class] alloc] initWithNibName:@"SHBSmartBankViewController" bundle:nil];
    SHBPushInfo *openURLManager = [SHBPushInfo instance];
    switch (indexCurrentMenuTag)
    {
        
        case 13: // 지식서재
            isBolckOpen = NO;
            _tickerView.hidden = NO;
            [_tickerView.voiceOverBtn setIsAccessibilityElement:YES];
            _bannerView.hidden = YES;
            _bannerOpenBtn.hidden = NO;
            _bannerOpenBtn.isAccessibilityElement = YES;
            if (AppInfo.realServer)
            {
                [openURLManager requestOpenURL:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/financialInfo/book/book_main.jsp"] SSO:NO];
            } else
            {
                [openURLManager requestOpenURL:@"http://dev-m.shinhan.com/pages/financialInfo/book/book_main.jsp" SSO:NO];
            }
            break;
//        case 15: // 모바일웹
//            isBolckOpen = NO;
//            _tickerView.hidden = NO;
//            _bannerView.hidden = YES;
//            _bannerOpenBtn.hidden = NO;
//            _bannerOpenBtn.isAccessibilityElement = YES;
//            if (!AppInfo.realServer)
//            {
//                if (AppInfo.isLogin == LoginTypeNo)
//                {
//                    [openURLManager requestOpenURL:@"http://dev-m.shinhan.com" SSO:NO];
//                } else
//                {
//                    [openURLManager requestOpenURL:@"http://dev-m.shinhan.com" SSO:YES];
//                }
//            } else
//            {
//                if (AppInfo.isLogin == LoginTypeNo)
//                {
//                    [openURLManager requestOpenURL:URL_M SSO:NO];
//                } else
//                {
//                    [openURLManager requestOpenURL:URL_M SSO:YES];
//                }
//            }
//            
//            break;
        default:
            // 폴더 열기
            [self openFolderDown:sender];
            break;
    }
    [viewController release];
}

- (IBAction)firstSubMenuPressed:(UIButton*)sender{
    if ([firstSubMenuArray count] < 1) return;
    int index = sender.tag - 1000;
    menuIndex = index;
    //스마트 펀드를 위해
    if (indexCurrentMenuTag == 3 || indexCurrentMenuTag == 2)
    {
        //스마트펀드센터
        if (index == 3 ||index == 5) AppInfo.smartFundType = 1;
        
    }
    if (indexCurrentMenuTag == 16 && index == 1)
    {
        //안심거래 메뉴 터치
        AppInfo.isTapSmithingMenu = YES;
    }else
    {
        //안심거래 메뉴 미터치
        AppInfo.isTapSmithingMenu = NO;
    }
    
//    if (indexCurrentMenuTag == 16 && index == 7)
//    {
//        //피싱방지 보안설정
//        AppInfo.certProcessType = CertProcessTypeLogin;
//    }
    NSLog(@"onedepth menu:%i",indexCurrentMenuTag);
    NSLog(@"twodepth menu:%i",index);
    //공인인증센터를 위해
    if (indexCurrentMenuTag == 9)
    {
        //NSLog(@"index:%i",index);
        myMenuDic = [firstSubMenuArray objectAtIndex:index - 1];
        switch (index) {
            case 1: //인증서 발급/ 재발급
                AppInfo.certProcessType = CertProcessTypeIssue;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
                    [self certLogOutAlert];
                    return;
                }
                
                break;
                
            case 2: //pc->QR 인증서 복사
                AppInfo.certProcessType = CertProcessTypeCopyQR;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
//                    [self certLogOutAlert];
//                    return;
                }
                
                break;
                
            case 3: //pc->스마트폰 인증서 복사
                AppInfo.certProcessType = CertProcessTypeCopySmart;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
//                    [self certLogOutAlert];
//                    return;
                }
                
                break;
                
            case 4: //스마트폰 -> PC
                
                AppInfo.certProcessType = CertProcessTypeCopyPC;
                break;
                
            case 5: //신한앱간 인증서 복사
                
                break;
                
            case 6: //인증서 갱신
                AppInfo.certProcessType = CertProcessTypeRenew;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
                    [self certLogOutAlert];
                    return;
                }
                
                break;
            case 7: //인증서 창구 발급/재발급
                AppInfo.certProcessType = CertProcessTypeSpotIssue;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
                    [self certLogOutAlert];
                    return;
                }
                
                break;
            case 8: //인증서 폐기
                AppInfo.certProcessType = CertProcessTypeRegOrExpire;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
                    [self certLogOutAlert];
                    return;
                }
                
                break;
                
            case 9: //인증서 관리
                AppInfo.certProcessType = CertProcessTypeManage;
                if (AppInfo.isLogin != LoginTypeNo)
                {
                    //[AppInfo logout];
//                    [self certLogOutAlert];
//                    return;
                }
                
                break;
                
//            case 9: //인증서 안내
//                //AppInfo.certProcessType = CertProcessTypeIntroduce;
//                AppInfo.certProcessType = CertProcessTypeSpotIssue;
//                break;
            default:
                break;
        }
    }
    else
    {
        AppInfo.certProcessType = CertProcessTypeNo;
        
    }
    
    
    NSDictionary *nDic = [firstSubMenuArray objectAtIndex:index - 1];
    if ([[nDic objectForKey:@"controller"] length] > 0 || [[nDic objectForKey:@"webAddress"] length] > 0){
        [self pushMenuViewController:nDic];
    }else if ( [[nDic objectForKey:@"schemeURL"] length] > 0){
        SHBPushInfo *push = [SHBPushInfo instance];
        NSLog(@"Scheme url:%@",[nDic objectForKey:@"schemeURL"]);
        [push requestOpenURL:[nDic objectForKey:@"schemeURL"] Parm:nil];
    }else{
        if ([[nDic objectForKey:@"depth2key"] length] > 0){
            NSString *title = [nDic objectForKey:@"title"];
            NSString *depth2Key = [nDic objectForKey:@"depth2key"];
            [self loadFolderSecondDepthWithTitle:title Key:depth2Key Sender:sender];
        }
    }
}

- (IBAction)closeTableMenu:(UIButton*)sender{
    
    
    
    if (!_tableMenuView.hidden){
        _tableMenuView.transform = CGAffineTransformMakeScale(1, 1);
        _tableMenuView.alpha = 1;
        [UIView animateWithDuration:.45 animations:^{
            _tableMenuView.alpha = 0;
            _tableMenuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            if (finished) {
                [_tableMenuView setHidden:YES];
            }
        }];
    }else{
        _tableBigMenuView.transform = CGAffineTransformMakeScale(1, 1);
        _tableBigMenuView.alpha = 1;
        [UIView animateWithDuration:.45 animations:^{
            _tableBigMenuView.alpha = 0;
            _tableBigMenuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            if (finished) {
                [_tableBigMenuView setHidden:YES];
            }
        }];
    }
    _hiddenButtonView.hidden = YES;
    _hidden3depthBigView.hidden = YES;
    _hidden3depthView.hidden = YES;
    
    _folderView.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderHeight);
    [folder resizeContentsView:folderGapHeight * -1];
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        [_2depthField becomeFirstResponder];
        [_2depthField resignFirstResponder];
        
        [_firstDeptheLabel setIsAccessibilityElement:YES];
        [_firstDeptheLabel setIsAccessibilityElement:YES];
        for (int i = 10001; i < 10010; i++)
        {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:YES];
        }
        _tickerView.voiceOverBtn.hidden = NO;
    }
    
}

- (IBAction)guideButtonPressed:(UIButton*)sender{
    // 3단메뉴에서 안내버튼이 있는 경우
    if ([sender tag] == 4) { // 사고신고
        
        if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
            UIDevice *curDevice = [UIDevice currentDevice];
            curDevice.proximityMonitoringEnabled = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        }
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBAccidentInfoView"
                                                       owner:self options:nil];
        SHBAccidentInfoView *viewController = (SHBAccidentInfoView *)array[0];
        
        SHBAccidentPopupView *popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"사고신고 안내"
                                                                         SubViewHeight:318
                                                                        setContentView:viewController] autorelease];
        popupView.delegate = self;
        
        [popupView showInView:self.navigationController.view animated:YES];
    }
    else if ([sender tag] == 5) { // 사고신고 조회
        
        if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
            UIDevice *curDevice = [UIDevice currentDevice];
            curDevice.proximityMonitoringEnabled = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        }
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBAccidentSearchInfoView"
                                                       owner:self options:nil];
        SHBAccidentSearchInfoView *viewController = (SHBAccidentSearchInfoView *)array[0];
        
        SHBAccidentPopupView *popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"사고신고 조회 안내"
                                                                         SubViewHeight:176
                                                                        setContentView:viewController] autorelease];
        popupView.delegate = self;
        
        [popupView showInView:self.navigationController.view animated:YES];
    }
}

- (IBAction)arrowButtonPressed:(UIButton*)sender{
    
    isMovePage = YES;
    int newIndex = [self getCurrentPageNumInScollerView:_scrollView pageWidth:_scrollView.frame.size.width];
    
    if (sender == _rightButton){
        //[self setBackgroundDimm:0 DimmFlag:NO];
        
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
        
        _leftButton.hidden = NO;
        _rightButton.hidden = YES;
        
        
        newIndex +=1;
        indexCurrentMenuPage = 1;
        [_page1Image setImage:[UIImage imageNamed:@"page_off.png"]];
        [_page2Image setImage:[UIImage imageNamed:@"page_on.png"]];
        //[_page1Image setIsAccessibilityElement:NO];
        //[_page2Image setIsAccessibilityElement:YES];
    }else{
        //[self setBackgroundDimm:0 DimmFlag:NO];
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
        
        _leftButton.hidden = YES;
        _rightButton.hidden = NO;
        newIndex -=1;
        indexCurrentMenuPage = 0;
        [_page1Image setImage:[UIImage imageNamed:@"page_on.png"]];
        [_page2Image setImage:[UIImage imageNamed:@"page_off.png"]];
        //[_page1Image setIsAccessibilityElement:YES];
        //[_page2Image setIsAccessibilityElement:NO];
    }
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        [_1depthField becomeFirstResponder];
        [_1depthField resignFirstResponder];
    }
    

    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*newIndex, 0) animated:TRUE];

}



#pragma mark - Method
//로그아웃이 필요한 인증서 메뉴 진입시 알럿을 뛰워주고 처리
- (void)certLogOutAlert
{
    [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:76589 title:@"" message:@"로그아웃 후 사용이 가능한 메뉴입니다.\n\n로그아웃 하시겠습니까?"];
    //[UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:76589 title:nil buttonTitle:nil message:@"로그아웃 후 사용이 가능한 메뉴입니다.\n로그아웃 하시겠습니까?"];
}

- (void)folderTitleBarWithHidden:(BOOL)hidden SenderTag:(int)senderTag{
    UILabel *menuLabel;
    if ( (senderTag > 0 && senderTag < 4) || (senderTag > 9 && senderTag < 13) ){
        // 첫번째 라인
        menuLabel = (UILabel*)[_menu1View viewWithTag:101];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:102];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:103];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:110];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:111];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:112];
        menuLabel.hidden = hidden;
        _menuTableImage1.hidden = hidden;
        _menuTableImage4.hidden = hidden;
    }else if ( (senderTag > 3 && senderTag < 7) || (senderTag > 12 && senderTag < 16) ){
        // 두번째 라인
        menuLabel = (UILabel*)[_menu1View viewWithTag:104];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:105];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:106];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:113];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:114];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:115];
        menuLabel.hidden = hidden;
        _menuTableImage2.hidden = hidden;
        _menuTableImage5.hidden = hidden;
    }else if ( (senderTag > 6 && senderTag < 10) || (senderTag > 15 && senderTag < 19) ){
        // 세번째 라인
        menuLabel = (UILabel*)[_menu1View viewWithTag:107];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:108];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu1View viewWithTag:109];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:116];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:117];
        menuLabel.hidden = hidden;
        menuLabel = (UILabel*)[_menu2View viewWithTag:118];
        menuLabel.hidden = hidden;
        _menuTableImage3.hidden = hidden;
        _menuTableImage6.hidden = hidden;
    }
}
- (void)openFolderDown:(id)sender
{
    
    if (indexCurrentMenuTag == 9)
    {
        self.certExplainBtn.hidden = NO;
        self.exCertExplainBtn.hidden = NO;
    }
    
    [self folderTitleBarWithHidden:YES SenderTag:indexCurrentBtnTag];
    UILabel *menuLabel;
    int labelTag = indexCurrentBtnTag + 100;
    
    if (indexCurrentMenuPage == 0){
        menuLabel = (UILabel*)[_menu1View viewWithTag:labelTag];
        _firstDeptheLabel.text = menuLabel.text;
    }else{
        menuLabel = (UILabel*)[_menu2View viewWithTag:labelTag];
        _firstDeptheLabel.text = menuLabel.text;
    }
    float pointY = [sender frame].origin.y + [sender frame].size.height + 15;
    CGPoint openPoint = CGPointMake([sender center].x, pointY);
    
    float oversize = (_tickerView.frame.size.height + _tickerView.frame.origin.y) - (pointY + _folderView.frame.size.height + 50);
    _hiddenButtonView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2depth_bg"]];
    _hiddenButtonView.hidden = YES;
    _hidden3depthBigView.hidden = YES;
    _hidden3depthView.hidden = YES;
    
    folder.contentView = _folderView;
    folder.containerView = _mainMenuView;
    folder.position = openPoint;
    folder.direction = SHBFoldersOpenDirectionDown;
    folder.contentBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2depth_bg"]];
    folder.shadowsEnabled = YES;
    folder.darkensBackground = YES;
    folder.showsNotch = YES;
    if (folder.delegate == nil){
        [folder setDelegate:self];
    }
    [folder open];
    [_focusIconImage setImage:((UIButton*)sender).currentImage];
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        [self blockAccessbility];
        [_2depthField becomeFirstResponder];
        [_2depthField resignFirstResponder];
    }
    //NSLog(@"oversize:%f",oversize);
    if ( oversize < 0 ){
        // [UIView beginAnimations:nil context:nil];
        // [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        // [UIView setAnimationBeginsFromCurrentState:YES];
        // [_mainMenuView setFrame:CGRectMake(_mainMenuView.frame.origin.x, oversize, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height)];
        // [UIView commitAnimations];
        [UIView animateWithDuration:0.1f animations:^{
            //xcode5
            //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            //{
                //[_mainMenuView setFrame:CGRectMake(_mainMenuView.frame.origin.x, oversize, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height + 20)];
            //}else
            //{
                [_mainMenuView setFrame:CGRectMake(_mainMenuView.frame.origin.x, oversize, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height)];
            //}
            
        } completion:^(BOOL finished) {
            [_focusIconImage setHidden:NO];
        }];
    }else{
        [_focusIconImage setHidden:NO];
    }
    
}

- (void)setImageWithPage:(int)page{
    if (page == 0) {
        [_page1Image setImage:[UIImage imageNamed:@"page_on.png"]];
        [_page2Image setImage:[UIImage imageNamed:@"page_off.png"]];
        //[_page1Image setIsAccessibilityElement:YES];
        //[_page2Image setIsAccessibilityElement:NO];
    }else{
        [_page1Image setImage:[UIImage imageNamed:@"page_off.png"]];
        [_page2Image setImage:[UIImage imageNamed:@"page_on.png"]];
        //[_page1Image setIsAccessibilityElement:NO];
        //[_page2Image setIsAccessibilityElement:YES];
    }
}

- (int)getCurrentPageNumInScollerView:(UIScrollView *)scrollView pageWidth:(CGFloat)pageWidth{
    int _currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    return _currentPage;
}

- (void)blockAccessbility
{
    for (int i = 1; i < 19; i++)
    {
        
        if (i == indexCurrentMenuTag)
        {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:YES];
        } else
        {
            
            [[[self view] viewWithTag:i] setIsAccessibilityElement:NO];
        }
        
    }
    
    [[[self view] viewWithTag:567] setIsAccessibilityElement:NO];
    [[[self view] viewWithTag:756] setIsAccessibilityElement:NO];
    //[[[self view] viewWithTag:222] setIsAccessibilityElement:NO];
    //[[[self view] viewWithTag:333] setIsAccessibilityElement:NO];
    
    _tickerView.voiceOverBtn.hidden = YES;
    [_bannerScrollBtn1 setIsAccessibilityElement:NO];
    [_bannerScrollBtn2 setIsAccessibilityElement:NO];
    [_bannerScrollBtn3 setIsAccessibilityElement:NO];
    [_bannerScrollBtn4 setIsAccessibilityElement:NO];
    [_bannerScrollBtn5 setIsAccessibilityElement:NO];
    [_bannerMainBtn1 setIsAccessibilityElement:NO];
    [_bannerMainBtn2 setIsAccessibilityElement:NO];
    [_bannerMainBtn3 setIsAccessibilityElement:NO];
    [_bannerMainBtn4 setIsAccessibilityElement:NO];
    [_bannerMainBtn5 setIsAccessibilityElement:NO];
    
    [super blockAccessBottomMenuView:YES];
}
- (void)loadFolderFirstDepthWithIndex:(int)index{
    // 선택된 메뉴 아이콘의 원 태그 정보 가져오기
    NSArray *menuArray = [[NSUserDefaults standardUserDefaults]mainMenuOrderList];
    int menuTag = [[[menuArray objectAtIndex:index - 1] objectForKey:@"menu.tag"] intValue];
    indexCurrentMenuTag = menuTag;
    // plist에서 하위 메뉴정보 가져오기
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SHBSubMenu" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *depth1Dic = [dic objectForKey:@"depth1"];
    NSArray *depth1Array = [depth1Dic objectForKey:[NSString stringWithFormat:@"menu%i",menuTag]];
    UIButton *buttons;
    UILabel  *labels;
    // Objects Initialize
    [firstSubMenuArray removeAllObjects];
    for (int i=1; i < 13; i++) {
        buttons = (UIButton*)[_folderView viewWithTag:i + 1000];
        labels  = (UILabel*)[_folderView viewWithTag:i+10000];
        buttons.hidden = YES;
        labels.hidden = YES;
    }
    // 폴더의 버튼 메뉴 정보 셋팅
    for (int i = 0; i < [depth1Array count]; i++) {
        // 폴더 버튼메뉴 리스트 배열 셋팅
        if (indexCurrentMenuTag == 16 && [AppInfo.versionInfo[@"안심거래서비스사용여부"] isEqualToString:@"N"] && [[[depth1Array objectAtIndex:i] objectForKey:@"controller"] isEqualToString:@"SHBSmithingGuideViewController"])
        {
            NSLog(@"안심거래 서비스 사용여부:사용안함으로 내려옴!!");
        }else
        {
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [mDic setObject:[[depth1Array objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [mDic setObject:[[depth1Array objectAtIndex:i] objectForKey:@"controller"] forKey:@"controller"];
            [mDic setObject:[[depth1Array objectAtIndex:i] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
            [mDic setObject:[[depth1Array objectAtIndex:i] objectForKey:@"depth2key"] forKey:@"depth2key"];
            [mDic setObject:[SHBUtility nilToString:[[depth1Array objectAtIndex:i] objectForKey:@"webAddress"]] forKey:@"webAddress"];
            [mDic setObject:[SHBUtility nilToString:[[depth1Array objectAtIndex:i] objectForKey:@"schemeURL"]] forKey:@"schemeURL"];
            
            [firstSubMenuArray addObject:mDic];
            [mDic release];
            buttons = (UIButton*)[_folderView viewWithTag:i+1001];
            labels  = (UILabel*)[_folderView viewWithTag:i+10001];
            NSString *title = [[depth1Array objectAtIndex:i] objectForKey:@"title"];
            NSArray *titleArr =  [title componentsSeparatedByString:@" "];
            labels.text = [title stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
            labels.text = [labels.text stringByReplacingOccurrencesOfString:@"(space)" withString:@" "];
            if ([titleArr count] > 2){
                [labels setFont:[UIFont systemFontOfSize:13]];
            }else{
                [labels setFont:[UIFont systemFontOfSize:15]];
            }
            
            //[labels setFont:[UIFont systemFontOfSize:15]];
            buttons.hidden = NO;
            labels.hidden = NO;
            if ([mDic[@"depth2key"] length] > 0)
            {
                //NSLog(@"1111:%@",mDic[@"title"]);
                //NSLog(@"2222:%@",mDic[@"depth2key"]);
                labels.accessibilityHint = @"하위 메뉴가 있습니다";
                labels.accessibilityTraits = UIAccessibilityTraitButton;
            }else
            {
                //labels.accessibilityHint = @"실행";
                labels.accessibilityTraits = UIAccessibilityTraitButton;
            }
        }
        
    }
    
//    if ([depth1Array count] < 4){
//        folderHeight = 107.0f;
//    }else if ([depth1Array count] < 7){
//        folderHeight = 168.0f;
//    }else if ([depth1Array count] < 13){
//        folderHeight = 229.0f;
//    }
    
    if ([firstSubMenuArray count] < 4){
        folderHeight = 107.0f;
    }else if ([firstSubMenuArray count] < 7){
        folderHeight = 168.0f;
    }else if ([firstSubMenuArray count] < 13){
        folderHeight = 229.0f;
        
    }
    //if (AppInfo.isiPhoneFive)
    //{
    _folderView.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderHeight);
    //} else
    //{
    //    _folderView.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderHeight);
    //}
    _hiddenButtonView.frame = _folderView.frame;
}

- (void)loadFolderSecondDepthWithTitle:(NSString*)title Key:(NSString*)depth2Key Sender:(UIButton*)sender{
    
    
    // plist에서 하위 메뉴정보 가져오기
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SHBSubMenu" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *depth2Dic = [dic objectForKey:@"depth2"];
    NSArray *depth2Array = [depth2Dic objectForKey:depth2Key];
    [secondSubMenuArray removeAllObjects];
    for (int i = 0; i < [depth2Array count]; i++) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic setObject:[[depth2Array objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
        [mDic setObject:[[depth2Array objectAtIndex:i] objectForKey:@"controller"] forKey:@"controller"];
        [mDic setObject:[[depth2Array objectAtIndex:i] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
        [mDic setObject:[SHBUtility nilToString:[[depth2Array objectAtIndex:i] objectForKey:@"webAddress"]] forKey:@"webAddress"];
        [mDic setObject:[SHBUtility nilToString:[[depth2Array objectAtIndex:i] objectForKey:@"schemeURL"]] forKey:@"schemeURL"];
        [secondSubMenuArray addObject:mDic];
        [mDic release];
    }
    // 3Depth Setting
    if ([secondSubMenuArray count] > 2){
        
        if (AppInfo.isiPhoneFive)
        {
            folderGapHeight = folderHeight - 272;
        } else
        {
            folderGapHeight = folderHeight - 227;
        }
        if ( folderGapHeight < 0 && !depth3Resize && ( (indexCurrentBtnTag > 3 && indexCurrentBtnTag < 10) || (indexCurrentBtnTag > 12 && indexCurrentBtnTag < 19) ) ){
            depth3Resize = YES;
            [self resizeMainMenuView:folderGapHeight];
        }
        [folder resizeContentsView:folderGapHeight];
        if ([secondSubMenuArray count] > 7){
            _moreImageView.hidden = NO;
        }else{
            _moreImageView.hidden = YES;
        }
        //_depth3BigTitleLabel.text = [title stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        _depth3BigTitleLabel.text = title;
        
        if ([depth2Key isEqualToString:@"menu4"]){
            _guideBigButton.tag = 4;
            [_guideBigButton setFrame:CGRectMake(83, 22, 44, 20)];
            _guideBigButton.hidden = NO;
        }else if([depth2Key isEqualToString:@"menu5"]){
            _guideBigButton.tag = 5;
            [_guideBigButton setFrame:CGRectMake(111, 22, 44, 20)];
            _guideBigButton.hidden = NO;
        }else{
            _guideBigButton.hidden = YES;
        }
        [_menuBigTable reloadData];
        
        NSIndexPath *indPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_menuBigTable scrollToRowAtIndexPath:indPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        // folderView Resize
        _folderView.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderHeight - folderGapHeight);
        
        [_2depthField setIsAccessibilityElement:NO];
        _hiddenButtonView.frame = _folderView.frame;
        //_hiddenButtonView.hidden = NO;
        [_hiddenButtonView setIsAccessibilityElement:NO];
        
        
        // fade out animation
        _tableBigMenuView.hidden = NO;
        _tableBigMenuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        _tableBigMenuView.alpha = 0;
        [UIView animateWithDuration:.45 animations:^{
            _tableBigMenuView.alpha = 1;
            _tableBigMenuView.transform = CGAffineTransformMakeScale(1, 1);
            if (UIAccessibilityIsVoiceOverRunning())
            {
                [_firstDeptheLabel setIsAccessibilityElement:NO];
                [_3depthBigField becomeFirstResponder];
                [_3depthBigField resignFirstResponder];
                
            }
        }];
        
    }else{
        folderGapHeight = folderHeight - 166;
        if ( folderGapHeight < 0 && !depth3Resize && ( (indexCurrentBtnTag > 3 && indexCurrentBtnTag < 10) || (indexCurrentBtnTag > 12 && indexCurrentBtnTag < 19) ) ){
            depth3Resize = YES;
            [self resizeMainMenuView:folderGapHeight];
        }
        [folder resizeContentsView:folderGapHeight];
        //_depth3TitleLabel.text = [title stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        _depth3TitleLabel.text = title;
        if ([depth2Key isEqualToString:@"menu4"]){
            _guideBigButton.tag = 4;
            _guideBigButton.hidden = NO;
        }else if([depth2Key isEqualToString:@"menu5"]){
            _guideButton.tag = 5;
            _guideButton.hidden = NO;
        }else{
            _guideBigButton.hidden = YES;
        }
        
        [_menuTable reloadData];
        
        
        NSIndexPath *indPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_menuTable scrollToRowAtIndexPath:indPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        
        // folderView Resize
        _folderView.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderHeight - folderGapHeight);
        //_2depthBGImage.frame = CGRectMake(_folderView.frame.origin.x, _folderView.frame.origin.y, _folderView.frame.size.width, folderGapHeight);
        
        [_2depthField setIsAccessibilityElement:NO];
        _hiddenButtonView.frame = _folderView.frame;
        //_hiddenButtonView.hidden = NO;
        [_hiddenButtonView setIsAccessibilityElement:NO];
        
        // fade out animation
        _tableMenuView.hidden = NO;
        _tableMenuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        _tableMenuView.alpha = 0;
        [UIView animateWithDuration:.45 animations:^{
            _tableMenuView.alpha = 1;
            _tableMenuView.transform = CGAffineTransformMakeScale(1, 1);
            if (UIAccessibilityIsVoiceOverRunning())
            {
                [_firstDeptheLabel setIsAccessibilityElement:NO];
                [_3depthField becomeFirstResponder];
                [_3depthField resignFirstResponder];
                
            }
        }];
        
    }
    if (UIAccessibilityIsVoiceOverRunning())
    {
        
        for (int i = 10001; i < 10010; i++)
        {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:NO];
        }
        _tickerView.voiceOverBtn.hidden = YES;
    }
    
}

- (void)pushMenuViewController:(NSDictionary*)nDic
{
    
    NSLog(@"my menu ndic:%@",nDic);
    if (AppInfo.lastViewController != nil)
    {
        AppInfo.lastViewController = nil;
    }
    //이체화면 진입
    if ([[nDic objectForKey:@"controller"] isEqualToString:@"SHBAccountListViewController"] && AppInfo.isLogin != LoginTypeCert)
    {
        AppInfo.isD0011Start = NO;
    }else
    {
        //조회화면 진입
        if ([[nDic objectForKey:@"controller"] isEqualToString:@"SHBAccountMenuListViewController"] && AppInfo.isLogin == LoginTypeNo)
        {
            AppInfo.isD0011Start = NO;
        }else
        {
            AppInfo.isD0011Start = YES;
            
            if ([[nDic objectForKey:@"controller"] isEqualToString:@"SHBQueryAccountWidget"])
            {
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
                {
                    [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1560 title:@"" message:@"홈 화면에 바로가기\n아이콘이 생성됩니다.\n등록 하시겠습니까?"];
                    return;
                }else
                {
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"iOS 5.0 이상 버젼에서\n등록 가능 합니다."];
                }
            }
        }
        
    }
    
    AppInfo.isSingleLogin = NO;
    
    myMenuDic = nil;
    myMenuDic = nDic;
    //신한금융그룹 앱간 인증서 복사 처리
    if ([[nDic objectForKey:@"controller"] isEqualToString:@"SFG-SHC-smartcard://"])
    {
        AppInfo.certProcessType = CertProcessTypeCopySHCard;
        if (AppInfo.isLogin)
        {
            //[AppInfo logout];
        }
        
        [SFG_CertificateShare_SDS certificateSDSPushWithURLScheme:@"SFG-SHC-smartcard://" caller_url_scheme:@"SFG-SHB-sbank://"];
        return;
        
    } else if ([[nDic objectForKey:@"controller"] isEqualToString:@"SFG-SHL-slife://"])
    {
        AppInfo.certProcessType = CertProcessTypeCopySHInsure;
        if (AppInfo.isLogin)
        {
            //[AppInfo logout];
        }
        
        [SFG_CertificateShare_SDS certificateSDSPushWithURLScheme:@"SFG-SHL-slife://" caller_url_scheme:@"SFG-SHB-sbank://"];
        return;
    } else if ([[nDic objectForKey:@"controller"] isEqualToString:@"SFG-SEEROO-shsmartpay://"])
    {
        AppInfo.certProcessType = CertProcessTypeCopySHCardEasyPay;
        if (AppInfo.isLogin)
        {
            //[AppInfo logout];
        }
        
        [SFG_CertificateShare_SDS certificateSDSPushWithURLScheme:@"SFG-SEEROO-shsmartpay://" caller_url_scheme:@"SFG-SHB-sbank://"];
        return;
    }
    
    if ([[nDic objectForKey:@"controller"] length] > 0){
        AppInfo.isFirstOpen = YES;
        NSString *controlName = [nDic objectForKey:@"controller"];
        NSString *controlNibName = [nDic objectForKey:@"controller"];
        
        //공인인증센터 처리만 한다
        if ([nDic[@"title"] isEqualToString:@"인증서 발급/재발급"]) //인증서 발급
        {
            AppInfo.certProcessType = CertProcessTypeIssue;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                //[AppInfo logout];
                [self certLogOutAlert];
                return;
            }
            
            
        }else if([nDic[@"title"] isEqualToString:@"인증서 간편복사"]) //인증서 간편복사
        {
            AppInfo.certProcessType = CertProcessTypeCopyQR;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                //[AppInfo logout];
            }
            
        }else if([nDic[@"title"] isEqualToString:@"PC→스마트폰 인증서복사"]) //PC→스마트폰 인증서복사
        {
            AppInfo.certProcessType = CertProcessTypeCopySmart;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                //[AppInfo logout];
            }
            
        }else if([nDic[@"title"] isEqualToString:@"스마트폰 →PC 인증서복사"]) //스마트폰 →PC 인증서복사
        {
            AppInfo.certProcessType = CertProcessTypeCopyPC;
        }else if([nDic[@"title"] isEqualToString:@"인증서 갱신"]) //인증서 갱신
        {
            AppInfo.certProcessType = CertProcessTypeRenew;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                [self certLogOutAlert];
                return;
            }
            
        }else if([nDic[@"title"] isEqualToString:@"인증서 폐기"]) //인증서 폐기
        {
             AppInfo.certProcessType = CertProcessTypeRegOrExpire;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                //[AppInfo logout];
                [self certLogOutAlert];
                return;
            }
           
        }else if([nDic[@"title"] isEqualToString:@"인증서 관리"]) //인증서 폐기
        {
            AppInfo.certProcessType = CertProcessTypeManage;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                //[AppInfo logout];
            }
            
        }else if([nDic[@"title"] isEqualToString:@"인증서 안내"]) //인증서 폐기
        {
            AppInfo.certProcessType = CertProcessTypeIntroduce;
            
        }else if([nDic[@"title"] isEqualToString:@"인증서 창구 발급/재발급"]) //인증서 창구 발급/재발급
        {
            AppInfo.certProcessType = CertProcessTypeSpotIssue;
            if (AppInfo.isLogin != LoginTypeNo)
            {
                [self certLogOutAlert];
                return;
            }
        }
        
        if (AppInfo.LanguageProcessType == EnglishLan) //영문모드
        {
            //공인인증센터만 처리
            if (AppInfo.certProcessType != CertProcessTypeNo)
            {
                if (![controlName isEqualToString:@"SHBCertManageViewController"] && ![controlName isEqualToString:@"SHBCertDetailViewController"])
                {
                    controlNibName = [NSString stringWithFormat:@"%@%@",controlNibName,@"Eng"];
                }
                
            }
            
        }
        
        if (AppInfo.LanguageProcessType == JapanLan) //일어모드
        {
            //공인인증센터만 처리
            if (AppInfo.certProcessType != CertProcessTypeNo)
            {
                
                if (![controlName isEqualToString:@"SHBCertManageViewController"] && ![controlName isEqualToString:@"SHBCertDetailViewController"])
                {
                    controlNibName = [NSString stringWithFormat:@"%@%@",controlNibName,@"Jpn"];
                }
                
            }
            
        }
        
        SHBBaseViewController *viewController = [[[NSClassFromString(controlName) class] alloc] initWithNibName:controlNibName bundle:nil];
        if ([[nDic objectForKey:@"needsLogin"] isEqualToString:@"Y"] || [[nDic objectForKey:@"needsLogin"] isEqualToString:@"1"]){
            viewController.needsLogin = YES;
            viewController.needsCert = NO;
        }else if ([[nDic objectForKey:@"needsLogin"] isEqualToString:@"2"]){
            viewController.needsLogin = NO;
            viewController.needsCert = YES;
        }else{
            viewController.needsLogin = NO;
            viewController.needsCert = NO;
        }
        if ([viewController isKindOfClass:[SHBFindBranchesLocationViewController class]]) { // 영업점검색, 대기고객조회 화면
            // 영업점/ATM찾기로 왔는지 대기고객조회로 왔는지 구분
            [(SHBFindBranchesLocationViewController *)viewController setStrMenuTitle:[nDic objectForKey:@"title"]];
        }
        else if ([viewController isKindOfClass:[SHBFindBranchesMapViewController class]]) { // 위치기반 영업점/ATM 찾기 화면
            UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"" message:@"위치정보사용을\n승인하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니오", nil] autorelease];
            [alert setTag:337337];
            [alert show];
            
            // release 추가
            [viewController release];
            return; // 얼럿의 선택에 따라 분기
        }
        
        // 수표조회
        if ([viewController isKindOfClass:[SHBCheckInputViewController class]]) { // 수표조회
            [(SHBCheckInputViewController *)viewController setStrMenuTitle:[nDic objectForKey:@"title"]];
        }
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
    }
    else if ([[nDic objectForKey:@"webAddress"] length] > 0) {
        
        NSString *URL = @"";
        
        if ([SHBUtility isFindString:[nDic objectForKey:@"webAddress"] find:@"?"]) {
            URL = [NSString stringWithFormat:@"%@&EQUP_CD=SI", [nDic objectForKey:@"webAddress"]];
        }
        else if ([[nDic objectForKey:@"webAddress"] hasSuffix:@"jsp"]) {
            URL = [NSString stringWithFormat:@"%@?EQUP_CD=SI", [nDic objectForKey:@"webAddress"]];
        }
        else {
            URL = [nDic objectForKey:@"webAddress"];
        }
        
        if (!AppInfo.realServer)
        {
            if ([SHBUtility isFindString:URL find:URL_IMAGE]) {
                URL = [URL stringByReplacingOccurrencesOfString:URL_IMAGE withString:URL_IMAGE_TEST];
            }
            else if ([SHBUtility isFindString:URL find:URL_M]) {
                URL = [URL stringByReplacingOccurrencesOfString:URL_M withString:URL_M_TEST];
            }
        } else
        {
            if ([SHBUtility isFindString:URL find:URL_IMAGE_TEST]) {
                URL = [URL stringByReplacingOccurrencesOfString:URL_IMAGE_TEST withString:URL_IMAGE];
            }
            else if ([SHBUtility isFindString:URL find:URL_M_TEST]) {
                URL = [URL stringByReplacingOccurrencesOfString:URL_M_TEST withString:URL_M];
            }
        }
        
        if ([[nDic objectForKey:@"needsLogin"] isEqualToString:@"2"] || AppInfo.isLogin == LoginTypeCert) {
            [[SHBPushInfo instance] requestOpenURL:URL SSO:YES];
        }
        else {
            [[SHBPushInfo instance] requestOpenURL:URL SSO:NO];
        }
    
    }else if ( [[nDic objectForKey:@"schemeURL"] length] > 0){
 
        if ([[nDic objectForKey:@"schemeURL"] isEqualToString:@"smartfundcenter://"])
        {
            if ([[nDic objectForKey:@"title"] isEqualToString:@"Best펀드"])
            {
                AppInfo.smartFundType = 3;
            } else if ([[nDic objectForKey:@"title"] isEqualToString:@"펀드검색"])
            {
                AppInfo.smartFundType = 4;
            } else if ([[nDic objectForKey:@"title"] isEqualToString:@"펀드 자동이체"])
            {
                AppInfo.smartFundType = 2;
            }
            else {
                AppInfo.smartFundType = 0;
            }
        }
        if ([[nDic objectForKey:@"schemeURL"] isEqualToString:@"iphoneSbizbank://"])
        {
            UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"" message:@"급여이체는 기업뱅킹에 가입된 경우 가능합니다. 신한S기업뱅크로 이동합니다." delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니오", nil] autorelease];
            [alert setTag:8888];
            [alert show];
            
         
            return;
        }
        
        
        SHBPushInfo *push = [SHBPushInfo instance];
        [push requestOpenURL:[nDic objectForKey:@"schemeURL"] Parm:nil];
    }
}

- (void)resizeMainMenuView:(float)height{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //xcoe5
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    //{
        //_mainMenuView.frame = CGRectMake(_mainMenuView.frame.origin.x, _mainMenuView.frame.origin.y + height, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height + 20);
    
    //NSLog(@"abcd:%f",_mainMenuView.frame.size.height);
    //}else
    //{
        _mainMenuView.frame = CGRectMake(_mainMenuView.frame.origin.x, _mainMenuView.frame.origin.y + height, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height);
    //}
    
    [UIView commitAnimations];
    _focusIconImage.frame = CGRectMake(_focusIconImage.frame.origin.x, _focusIconImage.frame.origin.y + height, _focusIconImage.frame.size.width, _focusIconImage.frame.size.height);
}

- (void)closeFolderMenu{
    
    
    [folder closeCurrentFolder];
}

- (void)executeEasyInquiryAccount {
    NSString *settingData = [[NSUserDefaults standardUserDefaults] easyInquiryData];
    if ([[SHBUtility nilToString:settingData] isEqualToString:@"1"]) {
        AppInfo.isEasyInquiry = YES;
        
        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBAccountInqueryViewController") class] alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
        
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)changeQuickLogin:(BOOL)logIn{
    [super changeQuickLogin:logIn];
    //[super changeQuickLogin:AppInfo.noticeState];
}

- (void)changeBackgroundImage{
    

    _leftLogoImageView.hidden = YES;
    _rightLogoImageView.hidden = YES;
    
    switch ([[NSUserDefaults standardUserDefaults] wallpaper]) {
        case SettingsWallpaperValue1:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_1"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_1"];
            }
            break;
        case SettingsWallpaperValue2:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_2"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_2"];
            }
            break;
        case SettingsWallpaperValue3:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_3"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_3"];
            }
            break;
        case SettingsWallpaperValue4:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_4"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_4"];
            }
            break;
        case SettingsWallpaperValue5:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_5"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_5"];
            }
            break;
        case SettingsWallpaperValue6:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_6"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_6"];
            }
            break;
        case SettingsWallpaperValue7:
            // 홈페이지 배경으로 별도로 내려받은 로케이션의 이미지파일 사용
        {
            NSData *data = [[[NSUserDefaults standardUserDefaults] wallpaperData] objectForKey:@"배경이미지"];
            UIImage *img = [UIImage imageWithData:data];
            _backImageView.image = img;
        }
            break;
        case SettingsWallpaperValue8:
            _leftLogoImageView.hidden = NO;
            _rightLogoImageView.hidden = NO;
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *imagePath = [path stringByAppendingPathComponent:@"custom_bg.png"];
            
            _backImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            break;
            
        default:
            if (AppInfo.isiPhoneFive){
                _backImageView.image = [UIImage imageNamed:@"bg5_1"];
            }else{
                _backImageView.image = [UIImage imageNamed:@"bg_1"];
            }
            break;
    }
}

- (void)popToRootViewControllerNotification
{
    [self closeFolderMenu];
}

- (void)requestSavePhoneInfo{
    // 사용자 Device 정보 등록
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *carrierName;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        // Setup the Network Info and create a CTCarrier object
        CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        CTCarrier *carrier = [networkInfo subscriberCellularProvider];
        
        // Get carrier name
        if ([carrier carrierName] != nil){
            carrierName = [carrier carrierName];
        }else {
            carrierName = @"";
        }
    }else {
        carrierName = @"";
    }
    
    if ([carrierName isEqualToString:@"AT&T"]){
        carrierName = @"AT_T";
    }
    [AppInfo getDeviceInfo];
    Debug(@"openUDID : %@",AppInfo.openUDID);
    Debug(@"macAddress :%@",AppInfo.macAddress);
#if !TARGET_IPHONE_SIMULATOR
    NSString *phoneInfo = [NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP];
    NSString *phoneDetailInfo = [SHBUtilFile getResultSum:phoneInfo portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    //NSString *ktbMacAddress = [SHBUtilFile getWiFiMACAddress:YES];
    NSString *ktbMacAddress = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    NSLog(@"getUUID1:%@",[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"getUUID2:%@",[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"단말기통합정보:%@",phoneDetailInfo);
#endif
    //SBANK_MAC1값으로 getPhoneUUID2, SBANK_UID1 값으로 getPhoneUUID1 를 넣어준다.
#if !TARGET_IPHONE_SIMULATOR
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"phoneInfoInsert",
                                @"SBANK_SVC_CODE" : @"rooting",
                                @"SBANK_CUSNO" : @"",
                                @"SBANK_PHONE_ETC1" : @"",
                                @"SBANK_RRNO" : @"",
                                @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                                //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                                @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                                @"SBANK_PHONE_NO" : @"",
                                //@"SBANK_PHONE_COM" : carrierName,
                                @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                                //@"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
                                @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                                //@"SBANK_UID1" : AppInfo.openUDID,
                                @"SBANK_UID1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                //@"SBANK_MAC1" : AppInfo.macAddress,
                                @"SBANK_MAC1" : ktbMacAddress,
                                @"SBANK_PHONE_INFO" : phoneDetailInfo,
                                }] autorelease];
#else
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"phoneInfoInsert",
                                @"SBANK_SVC_CODE" : @"rooting",
                                @"SBANK_CUSNO" : @"",
                                @"SBANK_PHONE_ETC1" : @"",
                                @"SBANK_RRNO" : @"",
                                @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                                //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                                @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                                @"SBANK_PHONE_NO" : @"",
                                //@"SBANK_PHONE_COM" : carrierName,
                                @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                                //@"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
                                @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                                //@"SBANK_UID1" : AppInfo.openUDID,
                                @"SBANK_UID1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_MAC1" : AppInfo.macAddress,
                                //@"SBANK_PHONE_INFO" : phoneDetailInfo,
                                }] autorelease];
#endif
    
    //self.service = [[SHBVersionService alloc] initWithServiceId:VERSION_INFO viewController:self];
    // release 추가
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:PHONE_INFO viewController:self] autorelease];
    self.service.previousData = forwardData;
    //if (!AppInfo.isSSOLogin)
    //{
        //[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"알림0" message:AppInfo.schemaUrl];
        //AppInfo.serviceCode = @"앱정보전송";
    AppInfo.isStartApp = YES;
    //}
    
    [self.service start];
}

- (void)requestVersionInfo{
    
    // 버젼정보 요청
    //if (!AppInfo.isSSOLogin)
    //{
        //[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"알림1" message:AppInfo.schemaUrl];
        // 인디게이터 표시 안되게함.
        AppInfo.isStartApp = YES;
    //}
    isRequestVersionInfo = YES;
    isRequestAppList = NO;
    isRequestTikerList = NO;
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    AppInfo.bundleVersion = versionNumber;
    NSString *wallPaperType;
    
    if (AppInfo.isiPhoneFive) {
        wallPaperType = @"I_6401136"; // IOS 640*1136(아이폰5)
        
    }
    else if ([[UIDevice currentDevice]hasRetinaDisplay])
    {
        wallPaperType = @"I_640920"; // IOS 640*920(레티나)
        
    }
    else
    {
        wallPaperType = @"I_320460"; // IOS 320*460(아이폰3)
        
    }
    
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"doStart",
                                @"서비스구분" : SERVICE_TYPE,
                                @"채널구분코드" : CHANNEL_CODE,
                                @"Client버젼" : versionNumber,
                                @"배경구분" : wallPaperType,
                                }] autorelease];
    
    // release 추가
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:VERSION_INFO viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}

- (void)requestBankCode{
    // 은행코드 요청
    //if (!AppInfo.isSSOLogin)
    //{
        //[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"알림2" message:AppInfo.schemaUrl];
       AppInfo.isStartApp = YES;
    //}
    isRequestVersionInfo = NO;
    isRequestAppList = NO;
    isRequestTikerList = NO;
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"codeKey" : @"bank_code_smart",
                                }] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"CODE", CODE_URL, self, forwardData);
}

- (void)requestOtherAppList{
    //if (!AppInfo.isSSOLogin)
    //{
        //[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"알림3" message:AppInfo.schemaUrl];
        AppInfo.isStartApp = YES;
    //}
    isRequestAppList = YES;
    isRequestVersionInfo = NO;
    isRequestTikerList = NO;
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"getAppList",
                                @"앱구분" : @"009",
                                @"OS구분" : @"I",
                                @"신규앱조회여부" : @"Y",
                                }] autorelease];
    
    // release 추가
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_APP_LIST viewController:self] autorelease];
    self.service.previousData = forwardData;
    //if (!AppInfo.isSSOLogin)
    //{
        //AppInfo.serviceCode = @"타이머블럭";
    AppInfo.serviceCode = @"getAppList";
    //}
    
    [self.service start];
}

#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet {
    if (isRequestVersionInfo)
    {
        isRequestVersionInfo = NO;
                
        if([[NSUserDefaults standardUserDefaults] wallpaper] == SettingsWallpaperValue7)
        {
            if(![aDataSet[@"배경적용일시"] isEqualToString:[[[NSUserDefaults standardUserDefaults] wallpaperData] objectForKey:@"배경적용일시"]])
            {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"배경구분" : aDataSet[@"배경구분"], @"배경적용일시" : aDataSet[@"배경적용일시"], @"배경URL" : aDataSet[@"배경URL"]}];
                [mdic setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:aDataSet[@"배경URL"]]] forKey:@"배경이미지"];
                [[NSUserDefaults standardUserDefaults] setWallpaperData:mdic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedWallpaper" object:nil];
            }
        }
        
        // Ticker
        //[NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(startTicker) userInfo:nil repeats:NO];
        //[self performSelectorOnMainThread:@selector(startTicker) withObject:nil waitUntilDone:NO];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawMainView) name:@"downloadBannerImgDone" object:nil];
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self startTicker];
        });
        
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:AppInfo.schemaUrl];
        
        if ([[aDataSet objectForKey:@"코드적용일"] length] > 0){
            //코드 적용일의 파일이 있는지 document directory에 있는지 확인한다.
            AppInfo.bankCodeVersion = [aDataSet objectForKey:@"코드적용일"];
            NSString *bankCodePlist;
            bankCodePlist = [NSString stringWithFormat:@"%@/%@.bankcode.array",[SHBUtility getCachesDirectory],AppInfo.bankCodeVersion];
            
            //NSLog(@"bankCodePlist:%@",bankCodePlist);
            if (![SHBUtility isExistFile:bankCodePlist]){
                //파일이 존재하지 않는다면 뱅크코드를 가져와 저장한다.
                [self requestBankCode];
            } else{
                //file에서 부른다.
                NSString *codeArray = [NSString stringWithFormat:@"%@/%@.bankcode.array",[SHBUtility getCachesDirectory],AppInfo.bankCodeVersion];
                
                NSArray *dataList;
                dataList = [[NSArray alloc] initWithContentsOfFile:codeArray];
                //뱅크코드 파일이 혹시나 깨지는 경우 처리를 한다.
                if ([dataList count] == 0)
                {
                    NSFileManager *filemanager = [NSFileManager defaultManager];
                    [filemanager removeItemAtPath:codeArray error:nil];
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:445 title:@"" message:@"저장된 은행코드를 가져오는데 실패했습니다.\n서버에서 다시 가져옵니다."];
                    
                    return NO;
                }
                
                for(NSDictionary *dic in dataList){
                    if (!([dic[@"code"] isEqualToString:@"83"] || //평화은행
                          [dic[@"code"] isEqualToString:@"56"] || //암로은행
                          [dic[@"code"] isEqualToString:@"26"] || //구신한은행
                          [dic[@"code"] isEqualToString:@"25"] || //서울은행
                          [dic[@"code"] isEqualToString:@"21"] || //구조흥은행
                          [dic[@"code"] isEqualToString:@"12"] || //농협회원
                          [dic[@"code"] isEqualToString:@"06"] || //주택은행
                          [dic[@"code"] isEqualToString:@"27"])) //한미은행
                    {   // PopupListView 에서 사용 하도록 key값을 1, 2로 준다.
                        [AppInfo.codeList.bankList addObject:@{@"1" : dic[@"value"], @"2" : dic[@"code"]}];
                    }
                    
                    AppInfo.codeList.bankCode[dic[@"value"]] = dic[@"code"];
                    AppInfo.codeList.bankCodeReverse[dic[@"code"]] = dic[@"value"];
                }
                
                // release 추가
                [dataList release];
                // 신한 어플리케이션 목록 요청
                [self requestOtherAppList];
            }
        }
    }else if (isRequestAppList)
    {
        [AppInfo loadCertificates];
        isRequestAppList = NO;
        isRequestVersionInfo = NO;
        isRequestTikerList = YES;
        
        [AppInfo.otherAppArray removeAllObjects];
        // SafeRelease(AppInfo.otherAppArray);
        // release 추가
        AppInfo.otherAppArray = [[[NSMutableArray alloc] initWithArray:[aDataSet arrayWithForKeyPath:@"data"]] autorelease];
        
        if (!AppInfo.isBackGroundCall)
        {
            //스키마를 타고 앱이 기동했을 경우 멀티 리퀘스트 전송을 막기 위해 이곳에서 실행한다.
            [AppDelegate closeProgressView];
            SHBPushInfo *openURLManager = [SHBPushInfo instance];
            [openURLManager recieveOpenURL];
            
        }
        /*
        //2014.11.05 추가 마케팅을 위한 배너용 티커정보 가져오기
        SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                      TASK_ACTION_KEY : @"getAppList",
                                      @"앱구분" : @"009",
                                      @"OS구분" : @"I",
                                      @"신규앱조회여부" : @"Y",
                                      }] autorelease];
        
        // release 추가
        self.service = nil;
        self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_APP_LIST viewController:self] autorelease];
        self.service.previousData = forwardData;
        //if (!AppInfo.isSSOLogin)
        //{
        //AppInfo.serviceCode = @"타이머블럭";
        AppInfo.serviceCode = @"getAppList";
        //}
        
        [self.service start];
         */
    }else if (isRequestTikerList)
    {
        
    }
    AppInfo.isStartApp = NO;
    
    return NO;
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet{
    if (!isRequestVersionInfo){
        if (dataSet != nil){
            NSArray *dataList = [dataSet arrayWithForKeyPath:@"data"];
            
            //file로 저장한다.
            NSString *codeArray = [NSString stringWithFormat:@"%@/%@.bankcode.array",[SHBUtility getCachesDirectory],AppInfo.bankCodeVersion];
            
            if ([dataList writeToFile:codeArray atomically:YES]) {
                // 저장에 성공하면 정보를 저장한다.
                [[NSUserDefaults standardUserDefaults] setObject:AppInfo.bankCodeVersion forKey:@"SHB Bank Code Version"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                for(NSDictionary *dic in dataList){
                    if (!([dic[@"code"] isEqualToString:@"83"] || //평화은행
                          [dic[@"code"] isEqualToString:@"56"] || //암로은행
                          [dic[@"code"] isEqualToString:@"26"] || //구신한은행
                          [dic[@"code"] isEqualToString:@"25"] || //서울은행
                          [dic[@"code"] isEqualToString:@"21"] || //구조흥은행
                          [dic[@"code"] isEqualToString:@"12"] || //농협회원
                          [dic[@"code"] isEqualToString:@"06"] || //주택은행
                          [dic[@"code"] isEqualToString:@"27"])) //한미은행
                    {   // PopupListView 에서 사용 하도록 key값을 1, 2로 준다.
                        [AppInfo.codeList.bankList addObject:@{@"1" : dic[@"value"], @"2" : dic[@"code"]}];
                    }
                    
                    AppInfo.codeList.bankCode[dic[@"value"]] = dic[@"code"];
                    AppInfo.codeList.bankCodeReverse[dic[@"code"]] = dic[@"value"];
                }
            }
        }
    }
    [self requestOtherAppList];
    AppInfo.isStartApp = NO;
    
}



#pragma mark - Delegate : SHBFoldersDelegate
- (void)closeFolders{
    
    
    isBolckOpen = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [_mainMenuView setFrame:CGRectMake(_mainMenuView.frame.origin.x, 0, _mainMenuView.frame.size.width, _mainMenuView.frame.size.height)];
    [UIView commitAnimations];
    
    [self folderTitleBarWithHidden:NO SenderTag:indexCurrentBtnTag];
    [_focusIconImage setHidden:YES];
    [_tableMenuView setHidden:YES];
    [_tableBigMenuView setHidden:YES];
    depth3Resize = NO;
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        
        for (int i = 1; i < 19; i++)
        {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:YES];
        }
        
        for (int i = 10001; i < 10010; i++)
        {
            [[[self view] viewWithTag:i] setIsAccessibilityElement:YES];
        }
        
        [_firstDeptheLabel setIsAccessibilityElement:YES];
        
        [[[self view] viewWithTag:567] setIsAccessibilityElement:YES];
        [[[self view] viewWithTag:756] setIsAccessibilityElement:YES];
        //[[[self view] viewWithTag:222] setIsAccessibilityElement:YES];
        //[[[self view] viewWithTag:333] setIsAccessibilityElement:YES];
        
        [_1depthField becomeFirstResponder];
        [_1depthField resignFirstResponder];
        //[_tickerView setIsAccessibilityElement:YES];
        _tickerView.voiceOverBtn.hidden = NO;
        [super blockAccessBottomMenuView:NO];
    }
    _tickerView.hidden = NO;
    [_tickerView.voiceOverBtn setIsAccessibilityElement:YES];
    _bannerView.hidden = YES;
    _bannerOpenBtn.hidden = NO;
    _bannerOpenBtn.isAccessibilityElement = YES;
    
    self.certExplainBtn.hidden = YES;
    self.exCertExplainBtn.hidden = YES;
    
}

#pragma mark - Delegate : UIScrollViewDelegate
//페이지 이동이 실행되고 있는 동안 계속 호출됩니다.
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isMovePage)
    {
        self.view.userInteractionEnabled = NO;
    }
    
    if (scrollView == _scrollView) {
        //[self setBackgroundDimm:0 DimmFlag:NO];
        if( _scrollView.contentOffset.x == 0 ){ //맨앞
        }else if( _scrollView.contentOffset.x == _scrollView.contentSize.width - _scrollView.frame.size.width){ //맨뒤
        }else{//중간
        }
    }
}


// 스크롤뷰의 스크롤이 된후 실행됨.(called when scroll view grinds to a halt)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isMovePage) isMovePage = NO;
    
    self.view.userInteractionEnabled = YES;
    if (scrollView == _scrollView) {
        
        _leftButton.enabled = YES;
        _rightButton.enabled = YES;
        
        int newIndex = [self getCurrentPageNumInScollerView:_scrollView pageWidth:_scrollView.frame.size.width];
        if ( indexCurrentMenuPage != newIndex)
        {
            indexCurrentMenuPage = newIndex;
        }
        if( _scrollView.contentOffset.x == 0 ){ //맨앞
            _leftButton.hidden = YES;
            _rightButton.hidden = NO;
        }else if( _scrollView.contentOffset.x == _scrollView.contentSize.width - _scrollView.frame.size.width){ //맨뒤
            _leftButton.hidden = NO;
            _rightButton.hidden = YES;
        }else{//중간
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
        }
        [self setImageWithPage:indexCurrentMenuPage];
        //[self setBackgroundDimm:0 DimmFlag:YES];
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        self.view.frame = frame;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     if (isMovePage) isMovePage = NO;
     self.view.userInteractionEnabled = YES;
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        self.view.frame = frame;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (isMovePage) isMovePage = NO;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Delegate : UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
	//[SVProgressHUD show];
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	//[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
	
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
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
    NSString *notiType = AppInfo.versionInfo[@"공지사항TYPE"];
    NSArray *notiTypeArray = [notiType componentsSeparatedByString:@"|"];
    
    if ([SHBUtility isFindString:urlStr find:@"iphonesbank://SMS01?"])
    {
        AppInfo.isTapSmithingMenu = YES;
    }
    if ([SHBUtility isFindString:urlStr find:@"sbanknotice://close"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *notiType = [NSString stringWithFormat:@"%@|%@",notiTypeArray[0],notiTypeArray[1]];
        [defaults setObject:notiType forKey:@"NotiType"];
        [defaults setObject:@"0" forKey:@"NotiWebType"];
        [_noticeView removeFromSuperview];
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"sbanknotice://notview"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *notiType = [NSString stringWithFormat:@"1|%@",notiTypeArray[1]];
        [defaults setObject:notiType forKey:@"NotiType"];
        [defaults setObject:@"1" forKey:@"NotiWebType"];
        [defaults synchronize];
        [_noticeView removeFromSuperview];
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"sbanknotice://7days"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *notiType = [NSString stringWithFormat:@"2|%@",notiTypeArray[1]];
        [defaults setObject:notiType forKey:@"NotiType"];
        [defaults setObject:@"2" forKey:@"NotiWebType"];
        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
        [defaults setObject:currentDate forKey:@"NotiDate"];
        [defaults synchronize];
        [_noticeView removeFromSuperview];
        return NO;
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
    BOOL isNotiWebView = NO;
    if (AppInfo.versionInfo[@"공지사항여부"] && [AppInfo.versionInfo[@"공지사항URL"] length] > 0 && [SHBUtility isFindString:urlStr find:@"iphonesbank://"])
    {
        isNotiWebView = YES;
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
            if (isNotiWebView)
            {
                [AppInfo.versionInfo setValue:@"N" forKey:@"공지사항여부"];
                [self noticeViewClosePressed:nil];
            }
            [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
            
            return NO;
        }
    }
    if (isNotiWebView)
    {
        [AppInfo.versionInfo setValue:@"N" forKey:@"공지사항여부"];
        [self noticeViewClosePressed:nil];
        
    }
	return YES;
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [secondSubMenuArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"SHB3DepthMenuCell" owner:self options:nil];
        //xib파일의 객체중에 #번째 객체를 셋팅
        cell = [cellArray objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 172, 34)];
    selectView.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:68.0f/255.0f blue:98.0f/255.0f alpha:1];
    cell.selectedBackgroundView = selectView;
    [selectView release];
    int row = [indexPath row];
    UILabel *cell_lb;
    NSDictionary *dic = [secondSubMenuArray objectAtIndex:row];
    cell_lb = (UILabel *)[cell viewWithTag:1];
    [cell_lb setText:[dic objectForKey:@"title"]];
    //NSLog(@"1111:%@",[dic objectForKey:@"title"]);
    cell_lb.accessibilityTraits = UIAccessibilityTraitButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Menu에 해당하는 ViewController Push
    [self pushMenuViewController:[secondSubMenuArray objectAtIndex:indexPath.row]];
}


#pragma mark - Menu List Setting
- (void)setMenuIcon
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 메뉴의 초기화를 할 필요가 있을 경우 MAINMENU_VERSION을 변경하여 초기화 해준다.
    if (![defaults mainMenuVersion] || [[defaults mainMenuVersion] floatValue] < [MAINMENU_VERSION floatValue]) {
        [defaults setMainMenuVersion:MAINMENU_VERSION];
        [defaults setMainMenuOrderList:nil];
        [defaults synchronize];
    }

    NSMutableArray *menuArray = [defaults mainMenuOrderList];
    //    NSLog(@"aaaa:%@",menuArray);
    if (!menuArray){
        
        // release 추가
        menuArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        
        // Menu Array Add
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"조회/이체", @"menu.name",
                                  @"icon_account", @"menu.image",
                                  @"1", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"상품가입/해지", @"menu.name",
                                  @"icon_new", @"menu.image",
                                  @"2", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"펀드", @"menu.name",
                                  @"icon_fund", @"menu.image",
                                  @"3", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"대출", @"menu.name",
                                  @"icon_loan", @"menu.image",
                                  @"4", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"외환/골드", @"menu.name",
                                  @"icon_exchangegold", @"menu.image",
                                  @"5", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"신한카드", @"menu.name",
                                  @"icon_card", @"menu.image",
                                  @"6", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"자산관리", @"menu.name",
                                  @"icon_assets", @"menu.image",
                                  @"7", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"상품권", @"menu.name",
                                  @"icon_gift", @"menu.image",
                                  @"8", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"공인인증센터", @"menu.name",
                                  @"icon_cc", @"menu.image",
                                  @"9", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"퇴직연금", @"menu.name",
                                  @"icon_retire", @"menu.image",
                                  @"10", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"지로/지방세", @"menu.name",
                                  @"icon_girotax", @"menu.image",
                                  @"11", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"특화서비스", @"menu.name",
                                  @"icon_service", @"menu.image",
                                  @"12", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"지식서재", @"menu.name",
                                  @"icon_book", @"menu.image",
                                  @"13", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"금융정보", @"menu.name",
                                  @"icon_finance", @"menu.image",
                                  @"14", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Tops Club", @"menu.name",
                                  @"icon_tops", @"menu.image",
                                  @"15", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"보안센터", @"menu.name",
                                  @"icon_security", @"menu.image",
                                  @"16", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"영업점/ATM", @"menu.name",
                                  @"icon_atm", @"menu.image",
                                  @"17", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        {
            NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"고객센터", @"menu.name",
                                  @"icon_customer", @"menu.image",
                                  @"18", @"menu.tag",
                                  nil];
            [menuArray addObject:nDic];
        }
        [defaults setMainMenuOrderList:menuArray];
        [defaults synchronize];
        
    }
    // Set MenuButtons & Labels
    for (int i=0; i<[menuArray count]; i++) {
        UIImage *image = [UIImage imageNamed:[[menuArray objectAtIndex:i] objectForKey:@"menu.image"]];
        if (image == nil){
            image = [UIImage imageNamed:@"icon.png"];
        }
        if (i < 9){
            [((UIButton*)[_menu1View viewWithTag:i+1]) setImage:image forState:UIControlStateNormal];
            [((UIButton*)[_menu1View viewWithTag:i+1]) setAccessibilityLabel:[[menuArray objectAtIndex:i] objectForKey:@"menu.name"]];
            ((UILabel*)[_menu1View viewWithTag:i+101]).text = [[menuArray objectAtIndex:i] objectForKey:@"menu.name"];
        }else{
            [((UIButton*)[_menu2View viewWithTag:i+1]) setImage:image forState:UIControlStateNormal];
            [((UIButton*)[_menu2View viewWithTag:i+1]) setAccessibilityLabel:[[menuArray objectAtIndex:i] objectForKey:@"menu.name"]];
            ((UILabel*)[_menu2View viewWithTag:i+101]).text = [[menuArray objectAtIndex:i] objectForKey:@"menu.name"];
        }
    }
}

#pragma mark - MoaSign
- (void)moaSignDidLoaded
{
    NSLog(@"\nmoaSignDidLoaded \n\n");
    //[self dismiss];
    [AppDelegate closeProgressView];
    
    
    //모아싸인 시작처리 호출(URL을 사용하여 정책서버에서 처리정책을 취득)
    [MoaSignSDK startMoaSign:AppDelegate.moaSignUrl delegate:self];
    
    
}

#pragma mark - MoaSignDelegate
-(void)finishStartMoaSign:(NSString*)returnCode functionName:funcName mode:mode
{
    //모아싸인 버전 체크기능(서버에서 지정환 버전과 현재앱의 버전을 비교)
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionString = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    float versionNum = [[version stringByReplacingOccurrencesOfString:@"." withString:@""] floatValue];
    for (int i = 0; i < [versionString length]-1 ; i++)
    {
        versionNum = versionNum/10.0f;
    }
    
    NSString *iosVersionString = [[MoaSignSDK moaSignVersion] stringByReplacingOccurrencesOfString:@"." withString:@""];
    float iosVersionNum = [[[MoaSignSDK moaSignVersion] stringByReplacingOccurrencesOfString:@"." withString:@""] floatValue];
    for (int i = 0; i < [iosVersionString length]-1 ; i++)
    {
        iosVersionNum = iosVersionNum/10.0f;
    }
    
    if(versionNum >= iosVersionNum){
    }else {
        //App실행결과 서버로 전송처리 (성공)
        [MoaSignSDK finishMoaSign:nil errorCode:@"update"];
        return;
    }
    
    //NSLog(@"\nmode:%@",mode);
    //NSLog(@"\nfuncName:%@",funcName);
    NSArray *certArray = [MoaSignSDK getCertFromKeychain];
    
    if([funcName isEqualToString:@"login"])
    {
        
        AppDelegate.moaSignCurrentFunctionString = funcName;
        AppInfo.certProcessType = CertProcessTypeMoasignLogin;
        
        
        SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
        
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        
        
    }else if([funcName isEqualToString:@"sign"])
    {
        
        AppDelegate.moaSignCurrentFunctionString = funcName;
        AppInfo.certProcessType = CertProcessTypeMoasignSign;
        
        if (1 == [certArray count])
        {
            AppInfo.selectCertificateInfomation = [certArray objectAtIndex:0];
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertElectronicSignViewController *viewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewControllerEng" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertElectronicSignViewController *viewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
        } else
        {
            SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        /*
         if (AppInfo.selectCertificateInfomation != nil)
         {
         SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
         
         [self.navigationController pushFadeViewController:viewController];
         [viewController release];
         } else
         {
         SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
         
         [self.navigationController pushFadeViewController:viewController];
         [viewController release];
         
         }
         */
    }
    [AppDelegate.window setUserInteractionEnabled:YES];
}


- (void)noticeWebViewDidLoaded
{
    //return;
    [_noticeView setFrame:CGRectMake(AppDelegate.window.frame.origin.x, AppDelegate.window.frame.origin.y + 20, AppDelegate.window.frame.size.width, AppDelegate.window.frame.size.height)];
    
    //공지사항 저장
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //이전 공지사항과 같은지 비교
    NSString *preNotiSeq = [defaults objectForKey:@"NotiKey"];
    NSString *notiType = [defaults objectForKey:@"NotiType"];
    NSArray *notiTypeArray = [notiType componentsSeparatedByString:@"|"];
    NSArray *notiViewRateArray;
    NSString *serverNotiType = AppInfo.versionInfo[@"공지사항TYPE"];
    serverNotiType = [serverNotiType substringToIndex:1];
    NSLog(@"serverNotiType:%@",serverNotiType);
    
    float viewRateWidth = 100;
    float viewRateHeight = 100;
    if ([notiTypeArray count] == 2)
    {
        notiType = notiTypeArray[0];
        notiViewRateArray = [notiTypeArray[1] componentsSeparatedByString:@"*"];
        
        viewRateWidth = [notiViewRateArray[0] floatValue] / 100.0f;
        viewRateHeight = [notiViewRateArray[1] floatValue] / 100.0f;
    }else
    {
        notiType = AppInfo.versionInfo[@"공지사항TYPE"];
        notiTypeArray = [notiType componentsSeparatedByString:@"|"];
        notiType = notiTypeArray[0];
        notiViewRateArray = [notiTypeArray[1] componentsSeparatedByString:@"*"];
        viewRateWidth = [notiViewRateArray[0] floatValue] / 100.0f;
        viewRateHeight = [notiViewRateArray[1] floatValue] / 100.0f;
    }
                             
    NSLog(@"notiType:%@",notiType);
    NSLog(@"viewRateWidth:%f",viewRateWidth);
    NSLog(@"viewRateHeight:%f",viewRateHeight);
    
    if ([AppInfo.versionInfo[@"공지사항SEQ"] isEqualToString:preNotiSeq] && [[defaults objectForKey:@"NotiType"] length] > 0)
    {
        NSString *clientNotiType = notiType;
        if (![notiType isEqualToString:serverNotiType])
        {
            notiType = serverNotiType;
        }
        //버젼이 같다면 아래 로직을 체크한다
        //공지 문구 보여주기
        if ([notiType isEqualToString:@"0"])
        {
            self.notiTypeBtn.hidden = YES;
            self.notiTypeLabel.hidden = YES;
            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
            [AppDelegate.window addSubview:_noticeView];
            
            //[_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
        }else if ([notiType isEqualToString:@"1"])
        {
            
            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
            
        }else if ([notiType isEqualToString:@"2"])
        {
            self.notiTypeLabel.text = @"7일간 보지 않기";
            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
            
            NSLog(@"aaaa:%@",[defaults objectForKey:@"NotiDate"]);
            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *sdate = [outputFormatter dateFromString:[defaults objectForKey:@"NotiDate"]];

            NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
            //NSString *currentDate = @"2013-12-23";
            NSDate *edate = [outputFormatter dateFromString:currentDate];
            
            NSDateComponents *dcom = [[NSCalendar currentCalendar]components: NSDayCalendarUnit
                                                                    fromDate:sdate toDate:edate options:0];
            
            int dDay = [dcom day] + 1;
            NSLog(@"1111:%i",dDay);
            
            if (dDay >=0 && dDay < 8)
            {
                //아무것도 안함
            }else
            {
                [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
                NSArray *tmpArray = [AppInfo.versionInfo[@"공지사항TYPE"] componentsSeparatedByString:@"|"];
                if ([tmpArray count] == 2 && [tmpArray[0] isEqualToString:@"3"])
                {
                    self.notiView.hidden = YES;
                    //[_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height + 30)];
                    [_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height)];
                }
                //7일 지났음
                [AppDelegate.window addSubview:_noticeView];
                
                //[_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
            }
        }else if ([notiType isEqualToString:@"3"])
        {
            if ([clientNotiType intValue]== 2)
            {
                NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
                [outputFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *sdate = [outputFormatter dateFromString:[defaults objectForKey:@"NotiDate"]];
                
                NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
                //NSString *currentDate = @"2013-12-23";
                NSDate *edate = [outputFormatter dateFromString:currentDate];
                
                NSDateComponents *dcom = [[NSCalendar currentCalendar]components: NSDayCalendarUnit
                                                                        fromDate:sdate toDate:edate options:0];
                
                int dDay = [dcom day] + 1;
                NSLog(@"1111:%i",dDay);
                
                if (dDay >=0 && dDay < 8)
                {
                    //아무것도 안함
                    [defaults synchronize];
                    return;
                }
            }else if ([clientNotiType intValue]== 1)
            {
                [defaults synchronize];
                return;
            }
                
            self.notiView.hidden = YES;
            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
            //[_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height + 30)];
            [_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height)];
            [AppDelegate.window addSubview:_noticeView];
            //[_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
        }else
        {
            self.notiTypeBtn.hidden = YES;
            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
            [AppDelegate.window addSubview:_noticeView];
            
            //[_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
        }
        [defaults synchronize];
    }else
    {
        //틀리고 저장된 노티타입이 없다면
        if ([notiType isEqualToString:@"0"])
        {
            self.notiTypeBtn.hidden = YES;
            self.notiTypeLabel.hidden = YES;
        
        }else if ([notiType isEqualToString:@"1"])
        {
            self.notiTypeLabel.text = @"다시보지 않기";
            
        }else if ([notiType isEqualToString:@"2"])
        {
            self.notiTypeLabel.text = @"7일간 보지 않기";
        
        }else if ([notiType isEqualToString:@"3"])
        {
            //self.notiTypeLabel.text = @"7일간 보지 않기";
            self.notiView.hidden = YES;
            //[_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height + 30)];
            [_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x, _noticeWebView.frame.origin.y, _noticeWebView.frame.size.width, _noticeWebView.frame.size.height)];
        
        }else
        {
            self.notiTypeBtn.hidden = YES;
            //self.notiTypeLabel.text = @"7일간 보지 않기";
            //self.notiTypeLabel.text = @"다시보지 않기";
            
        }
        [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
        [defaults setObject:@"" forKey:@"NotiType"];
        [defaults setObject:@"" forKey:@"NotiDate"];
        [defaults synchronize];
        [AppDelegate.window addSubview:_noticeView];
        //[_noticeWebView loadRequestWithString:@"http://m.daum.net"];
        //[_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
    }
         
    [self redrawNotiView:[notiType intValue] viewRateWidth:viewRateWidth viewRateHeight:viewRateHeight];
    
}

- (void)redrawNotiView:(int)aNotiType viewRateWidth:(float)aViewRateWidth viewRateHeight:(float)aViewRateHeight
{
  //비율에 따른 웹뷰 조절
    float viewWidth = _noticeWebView.frame.size.width * aViewRateWidth;
    float viewHeight = _noticeWebView.frame.size.height * aViewRateHeight;
    
    float xmargin = (_noticeWebView.frame.size.width - viewWidth) / 2;
    float ymargin = (_noticeWebView.frame.size.height - viewHeight) / 2;
    NSLog(@"viewwidth:%f",viewWidth);
    NSLog(@"viewHeight:%f",viewHeight);
    NSLog(@"xmargin:%f",xmargin);
    NSLog(@"ymargin:%f",ymargin);
    
    //[self.notiView setFrame:CGRectMake(self.notiView.frame.origin.x + xmargin, viewHeight + ymargin, viewWidth, self.notiView.frame.size.height * aViewRateHeight)];
    
    [self.notiCloseBtn setFrame:CGRectMake(self.notiView.frame.origin.x + viewWidth - self.notiCloseBtn.frame.size.width, self.notiCloseBtn.frame.origin.y, self.notiCloseBtn.frame.size.width, self.notiCloseBtn.frame.size.height)];
    [self.notiView setFrame:CGRectMake(self.notiView.frame.origin.x + xmargin, viewHeight + ymargin, viewWidth, self.notiView.frame.size.height)];
    
    
    [_noticeWebView setFrame:CGRectMake(_noticeWebView.frame.origin.x + xmargin, _noticeWebView.frame.origin.y + ymargin, viewWidth, viewHeight)];
    [_noticeWebView loadRequestWithString:AppInfo.versionInfo[@"공지사항URL"]];
}

- (IBAction)noticeViewClosePressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *notiType = AppInfo.versionInfo[@"공지사항TYPE"];
    NSArray *notiTypeArray = [notiType componentsSeparatedByString:@"|"];
    notiType = notiTypeArray[0];
    if ([self.notiTypeBtn isSelected])
    {
        if ([notiType isEqualToString:@"0"])
        {
            //기타설정없음
            [defaults setObject:AppInfo.versionInfo[@"공지사항TYPE"] forKey:@"NotiType"];
        }else if ([notiType isEqualToString:@"1"])
        {
            //다시보지 않기
            [defaults setObject:AppInfo.versionInfo[@"공지사항TYPE"] forKey:@"NotiType"];
            
        }else if ([notiType isEqualToString:@"2"])
        {
            //7일간보지않기
            [defaults setObject:AppInfo.versionInfo[@"공지사항TYPE"] forKey:@"NotiType"];
            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
            [defaults setObject:currentDate forKey:@"NotiDate"];
            //[defaults setObject:AppInfo.versionInfo[@"COM_TRAN_DATE"] forKey:@"NotiDate"];
            //[defaults setObject:AppInfo.tran_Date forKey:@"NotiDate"];
        }else if ([notiType isEqualToString:@"3"])
        {
            [defaults setObject:AppInfo.versionInfo[@"공지사항TYPE"] forKey:@"NotiType"];
        }
        else
        {
            
            [defaults setObject:@"" forKey:@"NotiType"];
        }
        
    }
    [defaults synchronize];
    [_noticeView removeFromSuperview];
}

- (IBAction)notiBtnTypeClicked:(id)sender
{
    //동의 체크박스 체크
    [sender setSelected:![sender isSelected]];
}

- (IBAction)certExplainClick:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeIntroduce;
    NSString *cUrl = @"";
    if ((UIButton *)sender == self.certExplainBtn)
    {
        //인증서 안내
        if(AppInfo.realServer)
        {
            cUrl = @"http://img.shinhan.com/sbank/prod/ysign_info.html";
        }else
        {
            cUrl = @"http://imgdev.shinhan.com/sbank/prod/ysign_info.html";
        }
        
    }else if ((UIButton *)sender == self.exCertExplainBtn)
    {
        //타공인 인증서 등록 안내
        if(AppInfo.realServer)
        {
            cUrl = @"http://m.shinhan.com/sbank/info/ios_certinfo.jsp";
        }else
        {
            cUrl = @"http://dev-m.shinhan.com/sbank/info/ios_certinfo.jsp";
        }
    }
    
    //인증서 안내 페이지 이동
    //SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertIssueViewController") class] alloc] initWithNibName:@"SHBCertIssueViewController" bundle:nil];
    SHBCertIssueViewController *viewController = [[SHBCertIssueViewController alloc] initWithNibName:@"SHBCertIssueViewController" bundle:nil];
    viewController.connectURL = cUrl;
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
    
}
- (IBAction)test:(id)sender
{
//    SHBBaseViewController *testVC = [[[NSClassFromString(@"SHBSurchargeSecurityViewController") class] alloc] initWithNibName:@"SHBSurchargeSecurityViewController" bundle:nil];
//    [self.navigationController pushFadeViewController:testVC];
//    [testVC release];
    
    AppInfo.noticeState = 2;
    AppInfo.isSmartCareNoti = YES;
    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
    {
        [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:AppInfo.noticeState];
    }
    
    AppInfo.schemaUrl = @"http://SM_06?";
    SHBPushInfo *openURLManager = [SHBPushInfo instance];
    [openURLManager recieveOpenURL];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"smartCareReceiveNoti" object:nil];
    
//    NSArray *arr;
//    NSLog(@"%@",arr[0]);
    
}

- (void)proximityChanged:(NSNotification *)notification {
    if([UIAlertView myAlertTotCnt]>0) return;
    
    UIDevice *curDevice = [UIDevice currentDevice];
    curDevice.proximityMonitoringEnabled = NO;
    
    [self showSearchView];
}

- (void)showSearchView
{
    if(AppInfo.isShowSearchView)
    {
        return;
    }
    AppInfo.isShowSearchView = YES;
    
    SHBSearchView *searchView = [[[SHBSearchView alloc] init] autorelease];
    searchView = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchView" owner:self options:nil][0];
    searchView.frame = AppInfo.isiPhoneFive ? CGRectMake(0, 0, 320, 568) : CGRectMake(0, 0, 320, 480);
    searchView.navi = self.navigationController;
    [self.view.window addSubview:searchView];
    [searchView refresh];
}

//- (void)CloseSearchView
//{
//    UIDevice *curDevice = [UIDevice currentDevice];
//    curDevice.proximityMonitoringEnabled = YES;
//}

#pragma mark - popupview delegate

- (void)popupViewDidCancel
{
    if([[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"]){
        UIDevice *curDevice = [UIDevice currentDevice];
        curDevice.proximityMonitoringEnabled = YES;
        AppInfo.isShowSearchView = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

@end