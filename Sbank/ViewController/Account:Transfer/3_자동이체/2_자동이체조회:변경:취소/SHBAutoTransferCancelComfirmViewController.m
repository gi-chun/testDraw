//
//  SHBAutoTransferCancelComfirmViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferCancelComfirmViewController.h"
#import "SHBAutoTransferCancelCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferCancelComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBAutoTransferCancelComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.eSignNVBarTitle = @"자동이체";
    
    AppInfo.electronicSignString = @"";
    //[AppInfo addElectronicSign:@"자동이체 취소를 신청합니다."];

    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)거래구분: %@", @"자동이체 취소"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)출금계좌번호: %@", self.data[@"출금계좌번호"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)입금은행: %@", [AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)입금계좌번호: %@", self.data[@"_입금계좌번호"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)입금계좌예금주: %@", self.data[@"입금계좌성명"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)이체주기: %@", self.data[@"이체주기->display"] != nil ? self.data[@"이체주기->display"] : @"1개월"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)이체일: %@", [NSString stringWithFormat:@"%@일", self.data[@"이체일자"]]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)이체시작일: %@", self.data[@"이체시작일자"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)이체종료일: %@", self.data[@"이체종료일자"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)이체금액: %@", [NSString stringWithFormat:@"%@원", self.data[@"이체금액"]]]];
    
    SHBDataSet *aDataSet = nil;
    
    if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
    {
        AppInfo.electronicSignCode = @"D2211";
        AppInfo.electronicSignTitle = @"자동이체 취소를 신청합니다.";
        
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2211" viewController:self] autorelease];
        
        aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                     @"출금계좌번호" : self.data[@"_신계좌번호"],
                     }] autorelease];
    
        SHBDataSet *aVectorSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                   @"일괄_출금계좌번호" : self.data[@"_신계좌번호"],
                                   @"일괄_입금은행코드" : self.data[@"입금은행코드"],
                                   @"일괄_입금계좌번호" : self.data[@"입금계좌번호"],
                                   @"일괄_이체종류" : self.data[@"이체종류"],
                                   @"일괄_이체주기" : self.data[@"이체주기"],
                                   @"일괄_이체일자" : self.data[@"이체일자"],
                                   @"일괄_이체시작일자" : self.data[@"이체시작일자"],
                                   @"일괄_이체종료일자" : self.data[@"이체종료일자"],
                                   @"일괄_이체금액" : self.data[@"이체금액"],
                                   @"일괄_실행번호" : self.data[@"실행번호"],
                                   @"일괄_일련번호" : self.data[@"일련번호"],
                                   }] autorelease];
        
        aDataSet.vectorTitle = @"이체내역";
        [aDataSet insertObject:aVectorSet forKey:@"vector0" atIndex:0];
    
    
    }
    else  // 타행취소
    {
        AppInfo.electronicSignCode = @"D2212";
        AppInfo.electronicSignTitle = @"자동이체 취소를 신청합니다.";
        
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2212" viewController:self] autorelease];
        
        aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                     @"출금계좌번호" : self.data[@"_신계좌번호"],
                     @"입금은행코드" : self.data[@"입금은행코드"],
                     @"입금계좌번호" : self.data[@"입금계좌번호"],
                     @"이체금액" : self.data[@"이체금액"],
                     @"이체일자" : self.data[@"이체일자"],
                     @"일련번호" : self.data[@"일련번호"],
                     @"이체시작일자" : self.data[@"이체시작일자"],
                     @"이체종료일자" : self.data[@"이체종료일자"],
//                     @"출금계좌비밀번호" : AppInfo.commonDic[@"출금계좌비밀번호"],
                     }] autorelease];
    }
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBAutoTransferCancelCompleteViewController *nextViewController = [[[SHBAutoTransferCancelCompleteViewController alloc] initWithNibName:@"SHBAutoTransferCancelCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = self.data;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
//    AppInfo.isNeedClearData = YES;
//    [self.navigationController performSelector:@selector(fadePopViewController) withObject:nil afterDelay:0.1];
    NSLog(@"aaaa:%@",self.navigationController.viewControllers);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

- (void) cancelSecretMedia
{
//    AppInfo.isNeedClearData = YES;
//    [self.navigationController performSelector:@selector(fadePopViewController) withObject:nil afterDelay:0.1];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체 취소" maxStep:2 focusStepNumber:1] autorelease]];
    
    NSString *strBankName = [AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]];
    
    NSArray *dataArray = @[
    self.data[@"출금계좌번호"], 
    strBankName,
    self.data[@"_입금계좌번호"],
    self.data[@"입금계좌성명"],
    [NSString stringWithFormat:@"%@원", self.data[@"이체금액"]],
    [NSString stringWithFormat:@"%@ ~ %@", self.data[@"이체시작일자"], self.data[@"이체종료일자"]],
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
        
        _secretView.frame = CGRectMake(0.0f, 161.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 161 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        
        if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
        {
            secretotpView.nextSVC = @"D2211";
        }
        else
        {
            secretotpView.nextSVC = @"D2212";
        }
        
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 161.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 161 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        
        if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
        {
            secretcardView.nextSVC = @"D2211";
        }
        else
        {
            secretcardView.nextSVC = @"D2212";
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
