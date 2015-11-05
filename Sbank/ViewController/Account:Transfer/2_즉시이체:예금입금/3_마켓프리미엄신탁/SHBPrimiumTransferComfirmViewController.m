//
//  SHBPrimiumTransferComfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPrimiumTransferComfirmViewController.h"
#import "SHBPrimiumTransferCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBPrimiumTransferComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBPrimiumTransferComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.eSignNVBarTitle = @"즉시이체/예금입금";
    
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
    
    AppInfo.electronicSignCode = @"D2037";
    AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2037" viewController:self] autorelease];
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                             @"계좌번호" : AppInfo.commonDic[@"출금계좌번호"],
                             @"은행구분" : AppInfo.commonDic[@"출금은행구분"],
                             @"비밀번호" : AppInfo.commonDic[@"비밀번호"],
                             @"일부해지구분" : AppInfo.commonDic[@"일부해지구분"],
                             @"일부해지금액" : AppInfo.commonDic[@"일부해지금액"],
                             @"입금계좌번호" : AppInfo.commonDic[@"입금계좌번호"],
                             @"입금은행구분" : AppInfo.commonDic[@"입금은행구분"],
                             }] autorelease];

    self.service.requestData = aDataSet;
    [self.service start];
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppInfo.isNeedClearData = YES;
    [AppDelegate.navigationController fadePopViewController];
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBPrimiumTransferCompleteViewController *nextViewController = [[[SHBPrimiumTransferCompleteViewController alloc] initWithNibName:@"SHBPrimiumTransferCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = noti.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    AppInfo.isNeedClearData = YES;

    NSString *strSelfName = NSStringFromClass([self class]);
    
    int curIndex = 0;
    
    for(UIViewController *controller in AppDelegate.navigationController.viewControllers)
    {
        if([NSStringFromClass([controller class]) isEqualToString:strSelfName])
        {
            break;
        }
        curIndex += 1;
    }
    
    [AppDelegate.navigationController popToViewController:[AppDelegate.navigationController.viewControllers objectAtIndex:curIndex - 1] animated:YES];
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

    self.title = @"즉시이체/예금입금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"출금정보 확인" maxStep:3 focusStepNumber:2] autorelease]];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData02.text = AppInfo.commonDic[@"출금방식"];
    _lblData03.text = AppInfo.commonDic[@"출금예상금액"];
    _lblData04.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData05.text = AppInfo.commonDic[@"신규일"];
    _lblData06.text = AppInfo.commonDic[@"만기일"];
    _lblData07.text = AppInfo.commonDic[@"거래일자"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 179.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 179 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.nextSVC = @"D2037";
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 179.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 179 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        secretcardView.nextSVC = @"D2037";
        secretcardView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    
    _scrollView1.contentSize = CGSizeMake(317.0f, _infoView.frame.size.height);
    
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
    [_scrollView1 release];
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
    [self setScrollView1:nil];
    [self setInfoView:nil];
    [self setSecretView:nil];
    [super viewDidUnload];
}
@end
