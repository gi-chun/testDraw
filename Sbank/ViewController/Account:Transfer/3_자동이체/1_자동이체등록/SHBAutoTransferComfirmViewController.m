//
//  SHBAutoTransferComfirmViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferComfirmViewController.h"
#import "SHBAutoTransferCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBAutoTransferComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.eSignNVBarTitle = @"자동이체";
    
    AppInfo.electronicSignString = @"";
    //[AppInfo addElectronicSign:AppInfo.commonDic[@"제목"]];
    
    for (int i = 1; i < [AppInfo.commonDic[@"SignDataList"] count]; i ++)
    {
        NSString *strFieldName = AppInfo.commonDic[@"SignDataList"][i];
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                    i,
                                    strFieldName,
                                    AppInfo.commonDic[strFieldName]]];
    }
    
    SHBDataSet *aDataSet = nil;
    
    if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2201"] || [AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2241"])   // 당행, 가상계좌
    {
        AppInfo.electronicSignCode = @"D2203";
        AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
        
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2203" viewController:self] autorelease];
        
        NSString *strTransferDate = self.data[@"이체일자"];
        
        if([self.data[@"말일이체구분"] isEqualToString:@"1"] && [self.data[@"이체일자"] isEqualToString:@"28"])
        {
            strTransferDate = @"31";
        }
        
        aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                     @"일괄_출금계좌번호" : self.data[@"출금계좌번호"],
                     @"일괄_입금계좌번호" : self.data[@"입금계좌번호"],
                     @"일괄_이체종류" : AppInfo.commonDic[@"이체종류"],
                     @"일괄_이체주기" : self.data[@"이체주기"],
                     @"일괄_이체일자" : strTransferDate,
                     @"일괄_이체시작일자" : self.data[@"이체시작일자"],
                     @"일괄_이체종료일자" : self.data[@"이체종료일자"],
                     @"일괄_이체금액" : self.data[@"이체금액"],
                     @"일괄_말일이체구분" : self.data[@"말일이체구분"],
                     @"일괄_휴일이체구분" : self.data[@"휴일이체구분"],
                     @"일괄_메모" : self.data[@"출금계좌통장메모"],
                     @"일괄_입금계좌통장메모" : self.data[@"입금계좌통장메모"],
                     @"출금은행구분" : AppInfo.commonDic[@"출금은행구분"],
                     }] autorelease];
    }
    else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2231"])  // 타행
    {
        AppInfo.electronicSignCode = @"D2233";
        AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
        
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2233" viewController:self] autorelease];
        
        aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                     @"출금은행구분" : AppInfo.commonDic[@"출금은행구분"],
                     @"출금계좌번호" : AppInfo.commonDic[@"출금계좌번호"],
                     @"입금은행코드" : AppInfo.commonDic[@"입금은행코드"],
                     @"입금계좌번호" : self.data[@"입금계좌번호"],
                     @"이체금액" : self.data[@"이체금액"],
                     @"이체일자" : self.data[@"이체일자"],
                     @"이체주기" : self.data[@"이체주기"],
                     @"이체시작일자" : self.data[@"이체시작일자"],
                     @"이체종료일자" : self.data[@"이체종료일자"],
                     @"메모" : @"",
                     @"권유직원번호" : AppInfo.commonDic[@"권유직원번호"],
                     @"휴일이체구분" : self.data[@"휴일이체구분"],
                     @"말일이체구분" : self.data[@"말일이체구분"],
                     @"출금계좌통장메모" : self.data[@"출금계좌통장메모"],
                     @"입금계좌통장메모" : self.data[@"입금계좌통장메모"],
                     @"출금계좌비밀번호" : AppInfo.commonDic[@"출금계좌비밀번호"],
                     }] autorelease];
    }
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBAutoTransferCompleteViewController *nextViewController = [[[SHBAutoTransferCompleteViewController alloc] initWithNibName:@"SHBAutoTransferCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = noti.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
//    [self.navigationController performSelector:@selector(fadePopViewController) withObject:nil afterDelay:0.1];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SHBAutoTransferAgreeViewController")]) {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
//    [self.navigationController performSelector:@selector(fadePopViewController) withObject:nil afterDelay:0.1];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SHBAutoTransferAgreeViewController")]) {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
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
    
    self.title = @"자동이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체등록 확인" maxStep:4 focusStepNumber:3] autorelease]];
    
    self.data = AppInfo.commonDic[@"RecvData"];
    
    NSArray *dataArray = @[
    AppInfo.commonDic[@"출금계좌번호"],
    AppInfo.commonDic[@"입금은행"],
    AppInfo.commonDic[@"입금계좌번호"],
    AppInfo.commonDic[@"입금계좌예금주"],
    AppInfo.commonDic[@"이체금액"],
    [NSString stringWithFormat:@"%@ ~ %@", AppInfo.commonDic[@"이체시작일"], AppInfo.commonDic[@"이체종료일"]],
    AppInfo.commonDic[@"이체주기"],
    AppInfo.commonDic[@"받는통장메모"],
    AppInfo.commonDic[@"내통장메모"],
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 236.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 236 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        
        if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2201"] ||
           [AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2241"])   // 당행, 가상계좌
        {
            secretotpView.nextSVC = @"D2203";
        }
        else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2231"])  // 타행
        {
            secretotpView.nextSVC = @"D2233";
        }
        
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 236.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 236 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        
        if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2201"] ||
           [AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2241"])   // 당행, 가상계좌
        {
            secretcardView.nextSVC = @"D2203";
        }
        else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2231"])  // 타행
        {
            secretcardView.nextSVC = @"D2233";
        }
        
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

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_infoView release];
    [_secretView release];
    [_lblData release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setInfoView:nil];
    [self setSecretView:nil];
    [self setLblData:nil];
    [super viewDidUnload];
}
@end
