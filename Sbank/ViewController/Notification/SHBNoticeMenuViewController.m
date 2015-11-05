//
//  SHBNoticeMenuViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNoticeMenuViewController.h"
#import "SHBNotificationService.h" // 서비스

#import "SHBNoticeSmartLetterListViewController.h" // 스마트레터 목록
#import "SHBSmartCareViewController.h" // 스마트 케어 매니저
#import "SHBNoticeCouponListViewController.h" // 쿠폰함
#import "SHBNoticeSmartCardListViewController.h" // 스마트 명함
#import "SHBNoticeSmartNewViewController.h" // 스마트신규
#import "SHBNoticeAlimViewController.h"

@interface SHBNoticeMenuViewController ()
{
    NSInteger _currentIndex;
    NSInteger _currentMenuPage;
    int panStartY, panEndY;
}

@property (retain, nonatomic) SHBNoticeSmartLetterListViewController *smartLetterListViewController;
@property (retain, nonatomic) SHBSmartCareViewController *smartCareViewController;
@property (retain, nonatomic) SHBNoticeCouponListViewController *couponListViewController;
@property (retain, nonatomic) SHBNoticeSmartCardListViewController  *cardListViewController;
@property (retain, nonatomic) SHBNoticeSmartNewViewController *smartNewViewController;
@property (retain, nonatomic) SHBNoticeAlimViewController  *alimListViewController;

@end

@implementation SHBNoticeMenuViewController

@synthesize btn_menu1;
@synthesize btn_menu2;
@synthesize btn_menu3;
@synthesize btn_menu4;
@synthesize btn_menu5;
@synthesize btn_menu6;
@synthesize btn_menu7;
@synthesize btn_menu0;
@synthesize btn_menu8;
@synthesize btn_menu9;
@synthesize dragBtn;
@synthesize alimView;
@synthesize alimBaseView;
@synthesize closeBtn;
@synthesize lineBG;

#pragma mark - Action

- (IBAction)closeBtnAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.lastViewController = nil;
    
    AppInfo.commonDic = [NSDictionary dictionary];
    
    AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

#pragma mark - UIAlertView Delegate

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
    //NSLog(@"bbbb:%i",AppInfo.indexQuickMenu);
    
    webView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newIconSetting)
                                                 name:@"SmartLetter_Coupon_New"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:@"loginNotice"
                                               object:nil];
    

    //스마트케어
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newIconSetting)
                                                 name:@"smartCareReceiveNoti"
                                               object:nil];
    
    
    _currentMenuPage = 0;
    
	[self navigationViewHidden];
	[self setBottomMenuView];
    
    //알림뷰 add
    [self.view addSubview:self.alimBaseView];
    [self.alimBaseView setFrame:CGRectMake(self.alimBaseView.frame.origin.x, self.alimBaseView.frame.origin.y - 132, self.alimBaseView.frame.size.width, self.alimBaseView.frame.size.height)];
    [self.alimView setHidden:YES];
    [self.lineBG setHidden:NO];
    // Gesture 등록
	panBtnRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanBtnFrom:)];
	panBtnRecognizer.delegate = self;
	panBtnRecognizer.cancelsTouchesInView = NO;
	[self.dragBtn addGestureRecognizer:panBtnRecognizer];
    
    [btn_menu4.titleLabel setNumberOfLines:0];
    [btn_menu4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    if(!self.isPushAndScheme) {
        
        [self selectMenu:btn_menu1];
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBNotificationService alloc] initWithServiceId:NEW_STATE_SERVICE viewController:self] autorelease];
        [self.service start];
        
        //[self selectMenu:btn_menu0];
//        self.service = nil;
//        self.service = [[[SHBNotificationService alloc] initWithServiceId:GET_ALIM_SERVICE viewController:self] autorelease];
//        [self.service start];
    }
    else {
       
        seq = @"";
        if (![self.data[@"SEQ"] isEqualToString:@""] && [self.data[@"SEQ"] length] > 0){
        //if (![self.data[@"SEQ"] isEqualToString:@""]){
            seq = [NSString stringWithFormat:@"%@", self.data[@"SEQ"]];
            NSLog(@"seq==%@",seq);
        }
        
        faq_seq = @"";
        if (![self.data[@"FAQ_SEQ"] isEqualToString:@""] && [self.data[@"FAQ_SEQ"] length] > 0){
        //if (![self.data[@"FAQ_SEQ"] isEqualToString:@""]){
            faq_seq = [NSString stringWithFormat:@"%@", self.data[@"FAQ_SEQ"]];
            NSLog(@"faq_seq==%@",faq_seq);
        }

        
       if ([self.data[@"screenID"] isEqualToString:@"SM_01"]) { // 스마트레터
           /*
           [_btnNextLeftMenu setEnabled:YES];
           [_btnNextMenu setEnabled:YES];
           [self changeMenu_right:nil];
            [self selectMenu:btn_menu3];
            */
           [_btnNextLeftMenu setEnabled:NO];
           [_btnNextMenu setEnabled:YES];
           [self selectMenu:btn_menu3];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_02"]) { // 쿠폰함
            /*
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu5];
             */
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            //_menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu5];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_04"]) { // 이벤트
            [self selectMenu:btn_menu2];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_03"]) { // 새소식
            [self selectMenu:btn_menu1];
        }
        else if ([self.data[@"screenID"] isEqualToString:@"SM_05"]) { // FAQ
            
            /*
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self selectMenu:btn_menu7];
            [self changeMenu_right:nil];
            */
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu7];
            
            
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_06"]) { // 스마트캐어
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu4];
            
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_07"]) { // 스마트명함
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu8];
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_08"]) { // 스마트신규
        
            /*
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            
            [self selectMenu:btn_menu9];
            [self changeMenu_right:nil];
            */
            
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu9];
            
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_00"]) { // 알림
        
            //[self selectMenu:btn_menu0];
            
        }else if ([self.data[@"screenID"] isEqualToString:@"SM_09"]) { // 이용안내
            /*
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            _menuView.frame = CGRectMake(-570, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            
            [self selectMenu:btn_menu6];
            [self changeMenu_right:nil];
             */
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu7];
        }

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[self setBottomMenuView];
    
    if (_currentIndex == 300) {
        [_smartLetterListViewController viewWillAppear:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.alimListViewController = nil;
    self.smartLetterListViewController = nil;
    self.smartCareViewController = nil;
    self.couponListViewController = nil;
    self.cardListViewController = nil;
    self.smartNewViewController = nil;
    
    [closeBtn release];
    [alimBaseView release];
    [alimView release];
    [dragBtn release];
    [panBtnRecognizer release];
    [btn_menu0 release];
    [btn_menu1 release];
    [btn_menu2 release];    
    [btn_menu3 release];
    [btn_menu4 release];
    [btn_menu5 release];
    [btn_menu6 release];
    [btn_menu7 release];
    [btn_menu8 release];
    [btn_menu9 release];
    //[webView release];
    
    [_menuView release];
    [_btnNextMenu release];
    [_btnNextLeftMenu release];
    
    [_smartLetterNew release];
    [_couponNew release];
    
	[super dealloc];
}

#pragma mark - notification

- (void)newIconSetting
{
    if (AppInfo.isSmartLetterNew) {
        [_smartLetterNew setHidden:NO];
    }
    else {
        [_smartLetterNew setHidden:YES];
    }
    
    
    if (AppInfo.isCouponNew) {
        [_couponNew setHidden:NO];
    }
    else {
        [_couponNew setHidden:YES];
    }
    
    if (AppInfo.isSmartCareNoti) {  //스마트케어 2014.2.24 추가
        [_smartCareNew setHidden:NO];
        [_menuView bringSubviewToFront:_smartCareNew];
    }
    else {
        [_smartCareNew setHidden:YES];
    }
    
    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++) {
        if (AppInfo.isSmartLetterNew || AppInfo.isCouponNew) {
            AppInfo.noticeState = 2;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:2];
        }
        
        if (!AppInfo.isSmartLetterNew && !AppInfo.isCouponNew) {
            AppInfo.noticeState = 0;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:0];
        }
    }
}

- (void)loginSuccess
{
//    AppInfo.lastViewController = self;
    //NSLog(@"aaaa:%i",AppInfo.indexQuickMenu);
    AppInfo.indexQuickMenu = 1;
    if (AppInfo.isSingleLogin)
    {
        AppInfo.isSingleLogin = NO;
    }
    
    switch (_currentIndex) {
        case 99:
        {
            //알림
            [btn_menu0 setSelected:YES];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:NO];
            [btn_menu9 setSelected:NO];
            
            self.alimListViewController = [[[SHBNoticeAlimViewController alloc] initWithNibName:@"SHBNoticeAlimViewController" bundle:nil] autorelease];
            
            [self.view addSubview:_alimListViewController.view];
            
            
            [_alimListViewController.view setFrame:CGRectMake(0,
                                                                    74,
                                                                      _alimListViewController.view.frame.size.width,
                                                                      _alimListViewController.view.frame.size.height - 74 - 49)];
            
            
            
            [webView setHidden:YES];
        }
            break;
        case 300:
        {
            //스마트레터
            [btn_menu0 setSelected:NO];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:YES];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:NO];
            [btn_menu9 setSelected:NO];
            
            self.smartLetterListViewController = [[[SHBNoticeSmartLetterListViewController alloc] initWithNibName:@"SHBNoticeSmartLetterListViewController" bundle:nil] autorelease];
            
            [self.view addSubview:_smartLetterListViewController.view];
            
            [_smartLetterListViewController.view setFrame:CGRectMake(0,
                                                                     74,
                                                                     _smartLetterListViewController.view.frame.size.width,
                                                                     _smartLetterListViewController.view.frame.size.height - 74 - 49)];
            
            [webView setHidden:YES];
        }
            break;
        case 399:
        {
            //스마트명함
            [btn_menu0 setSelected:NO];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:YES];
            [btn_menu9 setSelected:NO];
            
            self.cardListViewController = [[[SHBNoticeSmartCardListViewController alloc] initWithNibName:@"SHBNoticeSmartCardListViewController" bundle:nil] autorelease];
            
            _cardListViewController.productCode = self.data[@"ProductCode"];
            
            [self.view addSubview:_cardListViewController.view];
            
            [_cardListViewController.view setFrame:CGRectMake(0,
                                                                74,
                                                                _cardListViewController.view.frame.size.width,
                                                                _cardListViewController.view.frame.size.height - 74 - 49)];
            
            [webView setHidden:YES];

            
        }
            break;
        case 400:
        {
            //스마트케어
            [btn_menu0 setSelected:NO];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:YES];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:NO];
            [btn_menu9 setSelected:NO];
            
            
            self.smartCareViewController = [[[SHBSmartCareViewController alloc] initWithNibName:@"SHBSmartCareViewController" bundle:nil] autorelease];
            
            [self.view addSubview:_smartCareViewController.view];
            
            [_smartCareViewController.view setFrame:CGRectMake(0,
                                                               74,
                                                               _smartCareViewController.view.frame.size.width,
                                                               _smartCareViewController.view.frame.size.height - 74 - 49)];
            
            [webView setHidden:YES];
            
            AppInfo.isSmartCareNoti = NO; //스마트케어 읽음완료
            AppInfo.noticeState = 0;
             [_smartCareNew setHidden:YES];
        }
            break;
        case 499:
        {
            //스마트신규
            [btn_menu0 setSelected:NO];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:NO];
            [btn_menu9 setSelected:YES];
            
            self.smartNewViewController = [[[SHBNoticeSmartNewViewController alloc] initWithNibName:@"SHBNoticeSmartNewViewController" bundle:nil] autorelease];
            
            [self.view addSubview:_smartNewViewController.view];
            
            [_smartNewViewController.view setFrame:CGRectMake(0,
                                                              74,
                                                              _smartNewViewController.view.frame.size.width,
                                                              _smartNewViewController.view.frame.size.height - 74 - 49)];
            
            [webView setHidden:YES];
            
        }
            break;
        case 500:
        {
            //쿠폰함
            [btn_menu0 setSelected:NO];
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:YES];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
            [btn_menu8 setSelected:NO];
            [btn_menu9 setSelected:NO];
            
            self.couponListViewController = [[[SHBNoticeCouponListViewController alloc] initWithNibName:@"SHBNoticeCouponListViewController" bundle:nil] autorelease];
            
            [self.view addSubview:_couponListViewController.view];
            
            [_couponListViewController.view setFrame:CGRectMake(0,
                                                                74,
                                                                _couponListViewController.view.frame.size.width,
                                                                _couponListViewController.view.frame.size.height - 74 - 49)];
            
            [webView setHidden:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)logoutClose
{
    _currentIndex = -1;
    _currentMenuPage = 0;
}

#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	[super executeWithDic:mDic];
    
    if (mDic) {
        NSLog(@"aaaaaaa %@",mDic);
        self.data = mDic;
    }
}

#pragma mark -

- (IBAction)changeMenu_left:(UIButton *)sender
{

    
    if (_menuView.frame.origin.x == 0.0f)
    {
        _currentMenuPage = 0;
    }else if (_menuView.frame.origin.x == -285.0f)
    {
        _currentMenuPage = 1;
    }else if (_menuView.frame.origin.x == -570.0f)
    {
        _currentMenuPage = 2;
    }else if (_menuView.frame.origin.x == -865.0f)
    {
        _currentMenuPage = 3;
    }
    
    switch (_currentMenuPage) {
        case 1:
        {
            [_btnNextLeftMenu setEnabled:NO];
            [_btnNextMenu setEnabled:YES];
            
            _btnNextLeftMenu.selected = YES;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(0, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
            
            break;
        case 2:
        {
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width - 285, _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
            
            break;
        case 3:
        {
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-570, 0, _menuView.frame.size.width - 285, _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
        default:
            break;
    }
    
}

- (IBAction)changeMenu_right:(UIButton *)sender
{
    
    
    if (_menuView.frame.origin.x == 0.0f)
    {
        _currentMenuPage = 0;
    }else if (_menuView.frame.origin.x == -285.0f)
    {
        _currentMenuPage = 1;
    }else if (_menuView.frame.origin.x == -570.0f)
    {
        _currentMenuPage = 2;
    }else if (_menuView.frame.origin.x == -865.0f)
    {
        _currentMenuPage = 3;
    }
    
    switch (_currentMenuPage) {
        case 0:
        {
            if (AppInfo.isSmartCareNoti) {  //스마트케어 2014.2.24 추가
                [_smartCareNew setHidden:NO];
                [_menuView bringSubviewToFront:_smartCareNew];
            }
            else {
                [_smartCareNew setHidden:YES];
            }
            
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
            
            break;
        case 1:
        {
            /*
            [_smartCareNew setHidden:YES];
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-570, 0, _menuView.frame.size.width + 285 , _menuView.frame.size.height);
            
            [UIView commitAnimations];
             */
            [_smartCareNew setHidden:YES];
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-570, 0, _menuView.frame.size.width + 285 , _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
            
            break;
        case 2:
        {
            [_smartCareNew setHidden:YES];
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            
            _btnNextLeftMenu.selected = NO;
            _btnNextMenu.selected = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            _menuView.frame = CGRectMake(-865, 0, _menuView.frame.size.width + 285, _menuView.frame.size.height);
            
            [UIView commitAnimations];
        }
            
            break;
        default:
            break;
    }
}

- (IBAction)selectMenu:(UIButton *)sender
{
    if (_smartLetterListViewController) {
        
        [_smartLetterListViewController.view removeFromSuperview];
    }
    
    if (_smartCareViewController) {
        
        [_smartCareViewController.view removeFromSuperview];
    }
    
    if (_couponListViewController) {
        
        [_couponListViewController.view removeFromSuperview];
    }
    
    if (_alimListViewController)
    {
        [_alimListViewController.view removeFromSuperview];
    }
    
    if (_smartNewViewController) {
        
        [_smartNewViewController.view removeFromSuperview];
    }
    
    if (_cardListViewController) {
        
        [_cardListViewController.view removeFromSuperview];
    }
    
    if (_menuView.frame.origin.x == 0.0f)
    {
        _currentMenuPage = 0;
    }else if (_menuView.frame.origin.x == -285.0f)
    {
        _currentMenuPage = 1;
    }else if (_menuView.frame.origin.x == -570.0f)
    {
        _currentMenuPage = 2;
    }else if (_menuView.frame.origin.x == -865.0f)
    {
        _currentMenuPage = 3;
    }
    
    NSLog(@"_currentMenuPage:%i",_currentMenuPage);
    [self.alimBaseView setFrame:CGRectMake(self.alimBaseView.frame.origin.x, -132, self.alimBaseView.frame.size.width, self.alimBaseView.frame.size.height)];
    
    [self.closeBtn setHidden:NO];
    [self.alimView setHidden:YES];
    [self.lineBG setHidden:NO];
    _currentIndex = [sender tag];
    
    if (sender == btn_menu0)
    {
        //알림
        [btn_menu0 setSelected:YES];
        [btn_menu1 setSelected:NO];
        [btn_menu2 setSelected:NO];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:NO];
        [btn_menu7 setSelected:NO];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:NO];
        
        if (![SHBAppInfo sharedSHBAppInfo].isLogin)
        {
            
            AppInfo.isSingleLogin = YES;
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                //viewController.needsCert = YES;
                
                //[AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [self.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
            }
            */
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            return;
        }
        
        [self loginSuccess];
    }
    else if (sender == btn_menu1 || _currentIndex == 100)
    {
        if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
            [self changeMenu_left:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_left:nil];
        }
        // 새소식
        [btn_menu0 setSelected:NO];
        [btn_menu1 setSelected:YES];
        [btn_menu2 setSelected:NO];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:NO];
        [btn_menu7 setSelected:NO];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:NO];
        
        [webView setHidden:NO];
        
        
        if (!self.isPushAndScheme)
        {
            
            if (AppInfo.realServer) {
                [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_notice.jsp?EQUP_CD=SI"]];
            }
            else {
                [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_notice.jsp?EQUP_CD=SI"];
            }
        }
        else
        {
            if ([seq length] > 0)
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@%@", URL_M, @"/pages/notice/notice_detail.jsp?EQUP_CD=SI&NOTC_SEQ=",seq]];
                }
                else {
//                    NSLog(@"aaaa:%@",[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/notice_detail.jsp?EQUP_CD=SI&NOTC_SEQ=",seq]);
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/notice_detail.jsp?EQUP_CD=SI&NOTC_SEQ=",seq]];
                }
            }else
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_notice.jsp?EQUP_CD=SI"]];
                }
                else {
                    [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_notice.jsp?EQUP_CD=SI"];
                }
            }
            
            
            
            self.isPushAndScheme = NO;
        }
        
        
    }
    else if (sender == btn_menu2 || _currentIndex == 200)
    {
        if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
            [self changeMenu_left:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_left:nil];
        }
        // 이벤트
        [btn_menu0 setSelected:NO];
        [btn_menu1 setSelected:NO];
        [btn_menu2 setSelected:YES];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:NO];
        [btn_menu7 setSelected:NO];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:NO];
        
        [webView setHidden:NO];
        
        
        if (!self.isPushAndScheme)
        {
            
            if (AppInfo.realServer) {
                [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_event.jsp?EQUP_CD=SI"]];
            }
            else {
                [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_event.jsp?EQUP_CD=SI"];
            }
        }
        else
        {
            
            if ([seq length] > 0)
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@%@", URL_M, @"/pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]];
                }
                else {
                    NSLog(@"aaaa:%@",seq);
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com//pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]];
                    
                    NSLog(@"======%@",[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/event_detail.jsp?EQUP_CD=SI&EVNT_SEQ=",seq]);
                }
            }else
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_event.jsp?EQUP_CD=SI"]];
                }
                else {
                    [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_event.jsp?EQUP_CD=SI"];
                }
            }
            
            
            self.isPushAndScheme = NO;
        }
    }
    else if (sender == btn_menu3 || _currentIndex == 300)
    {
        
        // 스마트레터
        
        if (![SHBAppInfo sharedSHBAppInfo].isLogin)
        {
            AppInfo.isSingleLogin = YES;
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                //viewController.needsCert = YES;
                
                //[AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
                AppInfo.lastViewController = self;
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [self.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
                AppInfo.lastViewController = self;
            }
            */
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            AppInfo.lastViewController = self;
            return;
        }
        
        if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
            [self changeMenu_left:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_left:nil];
        }
        [self loginSuccess];
    }
    else if (sender == btn_menu4 || _currentIndex == 400)
    {
        // 스마트 케어 매니저
        
        if (![SHBAppInfo sharedSHBAppInfo].isLogin)
        {
            AppInfo.isSingleLogin = YES;
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                //viewController.needsCert = YES;
                
                //[AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
                AppInfo.lastViewController = self;
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [self.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
                AppInfo.lastViewController = self;
            }
            */
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            AppInfo.lastViewController = self;
            return;
        }
        
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            [self changeMenu_right:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_right:nil];
        }
        [self loginSuccess];
    }
    else if (sender == btn_menu5 || _currentIndex == 500)
    {
        // 쿠폰함
        
        if (![SHBAppInfo sharedSHBAppInfo].isLogin)
        {
            AppInfo.isSingleLogin = YES;
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                //viewController.needsCert = YES;
                
                //[AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
                AppInfo.lastViewController = self;
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [self.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
                AppInfo.lastViewController = self;
            }
            */
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            AppInfo.lastViewController = self;
            return;
        }
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            
        }else if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
        }
        [self loginSuccess];
    }
    else if (sender == btn_menu6)
    {
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            [self changeMenu_right:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_right:nil];
        }
        
        // 이용안내
        [btn_menu0 setSelected:NO];
        [btn_menu1 setSelected:NO];
        [btn_menu2 setSelected:NO];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:YES];
        [btn_menu7 setSelected:NO];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:NO];
        
        [webView setHidden:NO];
        
        if (AppInfo.realServer) {
            [webView loadRequestWithString:@"http://img.shinhan.com/sbank/mov/sbank_info.html"];
        }
        else {
            [webView loadRequestWithString:@"http://imgdev.shinhan.com/sbank/mov/sbank_info.html"];
        }
    }
    else if (sender == btn_menu7 || _currentIndex == 700)
    {
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            [self changeMenu_right:nil];
        }else if (_currentMenuPage == 1)
        {
            [self changeMenu_right:nil];
        }
        // FAQ조회
        [btn_menu0 setSelected:NO];
        [btn_menu1 setSelected:NO];
        [btn_menu2 setSelected:NO];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:NO];
        [btn_menu7 setSelected:YES];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:NO];
        
        [webView setHidden:NO];
        
        
        if (!self.isPushAndScheme)
        {
            if (AppInfo.realServer) {
                [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_faq.jsp?EQUP_CD=SI"]];
            }
            else {
                [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_faq.jsp?EQUP_CD=SI"];
            }
        }
        else
        {
            if ([faq_seq length] > 0)
            {
                [_btnNextLeftMenu setEnabled:YES];
                [_btnNextMenu setEnabled:NO];
                
                _btnNextMenu.selected = YES;
                _btnNextLeftMenu.selected =  NO;
                
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@%@", URL_M, @"/pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]];
                }
                else {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com//pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]];
                    
                    NSLog(@"======%@",[NSString stringWithFormat:@"%@%@",@"http://dev-m.shinhan.com/pages/notice/sb_faq_detail.jsp?EQUP_CD=SI&FAQ_SEQ=",faq_seq]);
                }
            }else
            {
                if (AppInfo.realServer) {
                    [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_faq.jsp?EQUP_CD=SI"]];
                }
                else {
                    [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_faq.jsp?EQUP_CD=SI"];
                }
            }
            
            
            self.isPushAndScheme = NO;
        }
    }
    else if (sender == btn_menu8 || _currentIndex == 399)
    {
        //스마트명함
//        [btn_menu0 setSelected:NO];
//        [btn_menu1 setSelected:NO];
//        [btn_menu2 setSelected:NO];
//        [btn_menu3 setSelected:NO];
//        [btn_menu4 setSelected:NO];
//        [btn_menu5 setSelected:NO];
//        [btn_menu6 setSelected:NO];
//        [btn_menu7 setSelected:NO];
//        [btn_menu8 setSelected:YES];
//        [btn_menu9 setSelected:NO];
        
        if (![SHBAppInfo sharedSHBAppInfo].isLogin)
        {
            
            AppInfo.isSingleLogin = YES;
            /*
            //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
            if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
                //viewController.needsCert = YES;
                
                //[AppDelegate.navigationController.viewControllers.lastObject checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
                AppInfo.lastViewController = self;
            }else
            {
                UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
                [self.navigationController pushFadeViewController:loginViewController];
                [loginViewController release];
                AppInfo.lastViewController = self;
            }
            */
            UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
            [self.navigationController pushFadeViewController:loginViewController];
            [loginViewController release];
            AppInfo.lastViewController = self;
            return;
        }
        
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            
        }else if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
        }
        [self loginSuccess];
    }
    else if (sender == btn_menu9 || _currentIndex == 499)
    {
        
        //스마트신규
        [btn_menu0 setSelected:NO];
        [btn_menu1 setSelected:NO];
        [btn_menu2 setSelected:NO];
        [btn_menu3 setSelected:NO];
        [btn_menu4 setSelected:NO];
        [btn_menu5 setSelected:NO];
        [btn_menu6 setSelected:NO];
        [btn_menu7 setSelected:NO];
        [btn_menu8 setSelected:NO];
        [btn_menu9 setSelected:YES];
        
        if (AppInfo.isLogin != LoginTypeCert)
        {
            /*
            AppInfo.isSingleLogin = YES;
            
             UIViewController *loginViewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
             [self.navigationController pushFadeViewController:loginViewController];
             [loginViewController release];
            
            return;
             */
            //AppInfo.lastViewController = self;
            //[[NSNotificationCenter defaultCenter] removeObserver:self];
            
            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
            AppInfo.isSingleLogin = YES;

            viewController.needsLogin = YES;
            viewController.needsCert = YES;
            AppInfo.certProcessType = CertProcessTypeLogin;
            viewController.isPushAndScheme = YES;
            viewController.data = @{
                                    @"screenID" : @"SM_08",
                                    
                                    };
            [AppDelegate.navigationController fadePopToRootViewController];
            [AppDelegate.navigationController.viewControllers[0] checkLoginBeforePushViewController:viewController animated:YES];
            
            
            return;
        }
        if (_currentMenuPage == 0)
        {
            [self changeMenu_right:nil];
            
        }else if (_currentMenuPage == 2)
        {
            [self changeMenu_left:nil];
        }
        [self loginSuccess];
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
    if ([aDataSet[@"NEW_LETTER"] isEqualToString:@"Y"]) {
        AppInfo.isSmartLetterNew = YES;
        [_smartLetterNew setHidden:NO];
    }
    else {
        AppInfo.isSmartLetterNew = NO;
        [_smartLetterNew setHidden:YES];
    }
    
    if ([aDataSet[@"NEW_COUPON"] isEqualToString:@"Y"]) {
        AppInfo.isCouponNew = YES;
        [_couponNew setHidden:NO];
        [_menuView bringSubviewToFront:_couponNew];
    }
    else {
        AppInfo.isCouponNew = NO;
        [_couponNew setHidden:YES];
    }
    
    
    if (AppInfo.commonDic[@"배너"]) {
        NSMutableDictionary *dic = AppInfo.commonDic[@"배너"];
        
        [webView setHidden:NO];
        
        if ([dic[@"티커구분"] isEqualToString:@"0"]) {
            _currentIndex = 100;
            
            // 새소식
            [btn_menu1 setSelected:YES];
            [btn_menu2 setSelected:NO];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
        }
        else if ([dic[@"티커구분"] isEqualToString:@"1"]) {
            _currentIndex = 200;
            
            // 이벤트
            [btn_menu1 setSelected:NO];
            [btn_menu2 setSelected:YES];
            [btn_menu3 setSelected:NO];
            [btn_menu4 setSelected:NO];
            [btn_menu5 setSelected:NO];
            [btn_menu6 setSelected:NO];
            [btn_menu7 setSelected:NO];
        }
        
        [webView loadRequestWithString:dic[@"티커Url"]];
    }
    else {
        /*
        if (AppInfo.isSmartLetterNew)
        {
            [self selectMenu:btn_menu3];
        }else if (AppInfo.isCouponNew)
        {
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:NO];
            _menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
            [self changeMenu_right:nil];
            [self selectMenu:btn_menu5];
            
        }else if (AppInfo.isSmartCareNoti)
        {
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            [self selectMenu:btn_menu4];
            [self changeMenu_right:nil];
        }else
        {
            if (AppInfo.realServer)
            {
                [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_notice.jsp?EQUP_CD=SI"]];
            }
            else {
                [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_notice.jsp?EQUP_CD=SI"];
            }
        }
        */
        if (AppInfo.isSmartCareNoti)
        {
            [_btnNextLeftMenu setEnabled:YES];
            [_btnNextMenu setEnabled:YES];
            
            [self selectMenu:btn_menu4];
            [self changeMenu_right:nil];
        }else
        {
            if (AppInfo.isCouponNew)
            {
                [_btnNextLeftMenu setEnabled:YES];
                [_btnNextMenu setEnabled:NO];
                //_menuView.frame = CGRectMake(-285, 0, _menuView.frame.size.width, _menuView.frame.size.height);
                [self changeMenu_right:nil];
                [self selectMenu:btn_menu5];
            }else
            {
                if (AppInfo.isSmartLetterNew)
                {
                    [self selectMenu:btn_menu3];
                }else
                {
                    if (AppInfo.realServer)
                    {
                        [webView loadRequestWithString:[NSString stringWithFormat:@"%@%@", URL_M, @"/pages/notice/sb_notice.jsp?EQUP_CD=SI"]];
                    }
                    else {
                        [webView loadRequestWithString:@"http://dev-m.shinhan.com/pages/notice/sb_notice.jsp?EQUP_CD=SI"];
                    }
                }
            }
        }
        
        
    }
    return YES;
}


#pragma mark - Delegate : UIWebViewDelegate

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
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:urlStr];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	Debug(@"webViewDidStartLoad !!!");
    
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	Debug(@"webViewDidFinishLoad !!!");
    [AppDelegate closeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	Debug(@"didFailLoadWithError !!!");
    [AppDelegate closeProgressView];
}

- (void)viewDidUnload {
    [self setSmartLetterNew:nil];
    [self setCouponNew:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Responding To Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];
    NSLog(@"drag x:%f, drag y:%f",location.x, location.y);
    //[self.alimView setHidden:NO];
    return YES;
}

- (void)handlePanBtnFrom:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint translate = [recognizer translationInView:self.view];
    CGPoint translate = [recognizer translationInView:self.dragBtn];
	NSLog(@"translate.y:%f",translate.y);
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
	{
        panEndY = translate.y;
        
        
        NSLog(@"aaaa:%i",panStartY);
        NSLog(@"bbbb:%i",panEndY);
        if (self.alimBaseView.frame.origin.y == -132)
        {
            if (panStartY < panEndY)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                
                [self.alimView setHidden:NO];
                [self.closeBtn setHidden:YES];
                [self.lineBG setHidden:YES];
                
                [self.view bringSubviewToFront:self.alimBaseView];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.alimBaseView setFrame:CGRectMake(self.alimBaseView.frame.origin.x, self.alimBaseView.frame.origin.y + 132, self.alimBaseView.frame.size.width, self.alimBaseView.frame.size.height)];
                }completion:^(BOOL finished){
                    
                    
                    
                }];
                [UIView commitAnimations];
            }
            
        }else
        {
            if (panStartY > panEndY)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [self.alimBaseView setFrame:CGRectMake(self.alimBaseView.frame.origin.x, self.alimBaseView.frame.origin.y - 132, self.alimBaseView.frame.size.width, self.alimBaseView.frame.size.height)];
                }completion:^(BOOL finished){
                    
                    [self.closeBtn setHidden:NO];
                    [self.alimView setHidden:YES];
                    [self.lineBG setHidden:NO];
                }];
                
                [UIView commitAnimations];
            }
            
        }
        
        
        
    }else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        panStartY = translate.y;
    }else
    {
        
    }
}
- (IBAction)alimPress:(id)sender
{
    NSLog(@"alim touch");
}
@end
