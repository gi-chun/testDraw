//
//  SHBReservationTransferComfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservationTransferComfirmViewController.h"
#import "SHBReservationTransferCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBReservationTransferComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBReservationTransferComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.eSignNVBarTitle = @"기타이체";
    
    AppInfo.electronicSignString = @"";
    ////[AppInfo addElectronicSign:AppInfo.commonDic[@"제목"]];
    AppInfo.electronicSignCode = @"D2103";
    AppInfo.electronicSignTitle = @"예약이체";
    for (int i = 1; i < [AppInfo.commonDic[@"SignDataList"] count]; i ++)
    {
        NSString *strFieldName = AppInfo.commonDic[@"SignDataList"][i];
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                    i,
                                    strFieldName,
                                    AppInfo.commonDic[strFieldName]]];
    }
    
    if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2101"]
       || [AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2104"]
       || [AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2105"]) 
    {
        AppInfo.electronicSignCode = @"D2103";
        AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
        
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2103" viewController:self] autorelease];
        
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                 @"출금계좌번호" : [AppInfo.commonDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                 @"입금계좌번호" : [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                 @"전화번호" : AppInfo.commonDic[@"전화번호"],
                                 }] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
        
    }
    else {
        [self.navigationController fadePopViewController];
    }
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBReservationTransferCompleteViewController *nextViewController = [[[SHBReservationTransferCompleteViewController alloc] initWithNibName:@"SHBReservationTransferCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = noti.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
    
    [self.navigationController fadePopViewController];
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
        
    }
    else {
        [self.navigationController fadePopViewController];
    }
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

    self.title = @"기타이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예약이체정보 확인" maxStep:3 focusStepNumber:2] autorelease]];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData02.text = AppInfo.commonDic[@"입금은행"];
    _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData04.text = AppInfo.commonDic[@"수취인성명"];
    _lblData05.text = AppInfo.commonDic[@"이체금액"];
    _lblData06.text = [NSString stringWithFormat:@"%@ %@", AppInfo.commonDic[@"이체예정일자"], AppInfo.commonDic[@"이체예정시간"]];
    _lblData07.text = AppInfo.commonDic[@"받는통장메모"];
    _lblData08.text = AppInfo.commonDic[@"내통장메모"];
    _lblData09.text = AppInfo.commonDic[@"CMS코드"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 227.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 227 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.nextSVC = @"D2103";
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 227.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 227 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        secretcardView.nextSVC = @"D2103";
        secretcardView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    
    if(self.contentScrollView.frame.size.height < _infoView.frame.size.height)
    {
        self.contentScrollView.contentSize = CGSizeMake(317.0f, _infoView.frame.size.height);
        contentViewHeight = _infoView.frame.size.height;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [secretcardView release];
    [secretotpView release];
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    
    [_infoView release];
    [_secretView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];

    [self setInfoView:nil];
    [self setSecretView:nil];
    [super viewDidUnload];
}

@end
