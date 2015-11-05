//
//  SHBLoanCancelComfirmViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanCancelComfirmViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBLoanService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBLoanCancelCompleteViewController.h"

@interface SHBLoanCancelComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBLoanCancelComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    AppInfo.eSignNVBarTitle = @"한도대출 해지";
    
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
    
    AppInfo.electronicSignCode = @"L1241";
    AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
    
    
    [AppInfo addElectronicSign:@"4.신청내용"];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)성명: %@", AppInfo.userInfo[@"고객성명"]]];
    //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)실명번호: %@", [AppInfo getPersonalPK]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)실명번호: %@", @""]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)고객ID: %@", AppInfo.customerNo]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)해지계좌: %@",AppInfo.commonDic[@"대출계좌번호"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)신청정보: 한도대출 한도 해지"]];
    

    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1241" viewController:self] autorelease];
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                     @"업무구분" : @"51",
                                                                     @"한도대출계좌번호" : [AppInfo.commonDic[@"대출계좌번호_전문"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                     @"한도대출계좌비밀번호" : AppInfo.commonDic[@"출금계좌비밀번호"],
                                                                     @"한도은행구분" : @"1",
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
    SHBLoanCancelCompleteViewController *nextViewController = [[[SHBLoanCancelCompleteViewController alloc] initWithNibName:@"SHBLoanCancelCompleteViewController" bundle:nil] autorelease];
    //nextViewController.data = noti.userInfo;
    nextViewController.L1241 = [noti userInfo];
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
    
    [AppDelegate.navigationController popToViewController:[AppDelegate.navigationController.viewControllers objectAtIndex:curIndex - 2] animated:YES];
    //    [AppDelegate.navigationController fadePopViewController];
    //    [AppDelegate.navigationController fadePopViewController];
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
    
    self.title = @"대출조회/한도해지";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"한도대출 해지" maxStep:3 focusStepNumber:2] autorelease]];
    
    
    NSArray *dataArray = @[
                           AppInfo.commonDic[@"대출계좌번호"],
                           AppInfo.commonDic[@"대출계좌번호"],
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
        secretotpView.nextSVC = @"L1241";
        
        _secretView.frame = CGRectMake(0.0f, 70.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 136 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        secretcardView.nextSVC = @"L1241";
        
        _secretView.frame = CGRectMake(0.0f, 70.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 136 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
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
