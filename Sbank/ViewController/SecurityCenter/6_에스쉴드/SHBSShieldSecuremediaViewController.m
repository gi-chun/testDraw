//
//  SHBSShieldSecuremediaViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSShieldSecuremediaViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBSecurityCenterService.h"
#import "SHBSShieldFinishViewController.h"

@interface SHBSShieldSecuremediaViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBSShieldSecuremediaViewController

- (void)dealloc
{
    [_mainView release];
    [_secretView release];
    [_shbDayMaxCnt release];
    [_shbNightMaxCnt release];
    [_shbSatDayMaxCnt release];
    [_shbSatNightMaxCnt release];
    [_shbSunDayMaxCnt release];
    [_shbSunNightMaxCnt release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"S-Shield";
    
    self.shbDayMaxCnt.text = AppInfo.commonDic[@"평일주간이체가능건수"];
    self.shbNightMaxCnt.text = AppInfo.commonDic[@"평일야간이체가능건수"];
    self.shbSatDayMaxCnt.text = AppInfo.commonDic[@"토요일주간이체가능건수"];
    self.shbSatNightMaxCnt.text = AppInfo.commonDic[@"토요일야간이체가능건수"];
    self.shbSunDayMaxCnt.text = AppInfo.commonDic[@"일요일주간이체가능건수"];
    self.shbSunNightMaxCnt.text = AppInfo.commonDic[@"일요일야간이체가능건수"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    // 보안관련
    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    {           //OTP
        
        secretotpView = [[[SHBSecretOTPViewController alloc] init] autorelease];
        secretotpView.targetViewController = self;
        
        [secretotpView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretotpView.view.bounds.size.height)];
        
        [self.secretView addSubview:secretotpView.view];
        [self.secretView setFrame:CGRectMake(self.secretView.frame.origin.x, self.secretView.frame.origin.y, secretotpView.view.frame.size.width, secretotpView.view.frame.size.height)];
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            secretotpView.selfPosY = self.secretView.frame.origin.y;
        }else
        {
            secretotpView.selfPosY = self.secretView.frame.origin.y + 40;
        }
        
        self.contentScrollView.contentSize = CGSizeMake(317.0f, self.mainView.frame.size.height + self.secretView.frame.size.height);
        secretotpView.delegate = self;
    }else
    {
        //보안카드
        
        secretcardView = [[[SHBSecretCardViewController alloc] init] autorelease];
        secretcardView.targetViewController = self;
        
        [secretcardView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, secretcardView.view.bounds.size.height)];
        
        [self.secretView addSubview:secretcardView.view];
        
        [self.secretView setFrame:CGRectMake(self.secretView.frame.origin.x, self.secretView.frame.origin.y, secretcardView.view.frame.size.width, secretcardView.view.frame.size.height)];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            secretcardView.selfPosY = self.secretView.frame.origin.y;
        }else
        {
            secretcardView.selfPosY = self.secretView.frame.origin.y + 40;
            
        }
        
        self.contentScrollView.contentSize = CGSizeMake(317.0f, self.mainView.frame.size.height + self.secretView.frame.size.height);
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void)confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        
        
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"S-Shield";
        //
        AppInfo.electronicSignCode = @"E7011";
        AppInfo.electronicSignTitle = @"S-Shield (전자금융 의심거래 방지 서비스)를 설정/변경합니다.";
        
        [AppInfo addElectronicSign:@"1.변경내용"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)평일주간이체가능건수: %@", AppInfo.commonDic[@"평일주간이체가능건수"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)평일야간이체가능건수: %@", AppInfo.commonDic[@"평일야간이체가능건수"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)토요일주간이체가능건수: %@", AppInfo.commonDic[@"토요일주간이체가능건수"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)토요일야간이체가능건수: %@", AppInfo.commonDic[@"토요일야간이체가능건수"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)일요일주간이체가능건수: %@", AppInfo.commonDic[@"일요일주간이체가능건수"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)일요일야간이체가능건수: %@", AppInfo.commonDic[@"일요일야간이체가능건수"]]];
        
        SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                      
                                      @"평일주간이체가능건수" : AppInfo.commonDic[@"평일주간이체가능건수"],
                                      @"평일야간이체가능건수" : AppInfo.commonDic[@"평일야간이체가능건수"],
                                      @"토요일주간이체가능건수" : AppInfo.commonDic[@"토요일주간이체가능건수"],
                                      @"토요일야간이체가능건수" : AppInfo.commonDic[@"토요일야간이체가능건수"],
                                      @"일요일주간이체가능건수" : AppInfo.commonDic[@"일요일주간이체가능건수"],
                                      @"일요일야간이체가능건수" : AppInfo.commonDic[@"일요일야간이체가능건수"],
                                      }] autorelease];
        
        self.service = nil;
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E7011_SERVICE viewController:self] autorelease];
        self.service.requestData = forwardData;
        [self.service start];
        
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

- (void)getElectronicSignResult:(NSNotification *)notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType)
    {
        SHBSShieldFinishViewController *viewController = [[SHBSShieldFinishViewController alloc]initWithNibName:@"SHBSShieldFinishViewController" bundle:nil];
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
    }
    
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}
@end
