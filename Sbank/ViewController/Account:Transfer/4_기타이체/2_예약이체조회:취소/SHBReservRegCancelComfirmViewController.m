//
//  SHBReservRegCancelComfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservRegCancelComfirmViewController.h"
#import "SHBReservRegCancelCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"

@interface SHBReservRegCancelComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBReservRegCancelComfirmViewController
@synthesize infoDic;

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.commonDic = @{
    @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"이체예정일자", @"이체예정시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"수취인성명", @"이체금액", @"받는통장메모", @"내통장메모", @"CMS코드"],
    @"제목" : @"예약이체 취소",
    @"거래일자" : AppInfo.tran_Date,
    @"거래시간" : AppInfo.tran_Time,
    @"이체예정일자" : self.infoDic[@"예약처리일자"],
    @"이체예정시간" : self.infoDic[@"예약처리시간"],
    @"출금계좌번호" : self.infoDic[@"출금계좌번호"],
    @"입금은행" : [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]],
    @"입금계좌번호" : self.infoDic[@"입금계좌번호"],
    @"수취인성명" : self.infoDic[@"입금계좌성명"],
    @"이체금액" : [NSString stringWithFormat:@"%@원", self.infoDic[@"이체금액"]],
    @"CMS코드" : self.infoDic[@"CMS코드"],
    @"받는통장메모" : self.infoDic[@"입금계좌통장메모"],
    @"내통장메모" : self.infoDic[@"출금계좌통장메모"],
    @"전문번호" : AppInfo.serviceCode
    };
    
    AppInfo.eSignNVBarTitle = @"기타이체";
    
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
    
    AppInfo.electronicSignCode = @"D2111";
    AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2111" viewController:self] autorelease];
    
    SHBDataSet *aVectorSet = [[[SHBDataSet alloc] init] autorelease];
    SHBDataSet *aDataSet1 = [[[SHBDataSet alloc] initWithDictionary:@{
                             @"상태" : self.infoDic[@"상태"],
                             @"등록일자" : self.infoDic[@"등록일자"],
                             @"등록일련번호" : self.infoDic[@"등록일련번호"],
                             @"예약처리일자" : self.infoDic[@"예약처리일자"],
                             @"예약처리시간" : self.infoDic[@"예약처리시간"],
                             }] autorelease];
    
    aVectorSet.vectorTitle = @"이체내역";
    [aVectorSet insertObject:aDataSet1 forKey:@"vector0" atIndex:0];
    
    self.service.requestData = aVectorSet;
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
    SHBReservRegCancelCompleteViewController *nextViewController = [[[SHBReservRegCancelCompleteViewController alloc] initWithNibName:@"SHBReservRegCancelCompleteViewController" bundle:nil] autorelease];
    nextViewController.infoDic = self.infoDic;
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
    
    self.title = @"기타이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예약이체 취소" maxStep:2 focusStepNumber:1] autorelease]];
    
    _lblData01.text = self.infoDic[@"출금계좌번호"];
    _lblData02.text = [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]];
    _lblData03.text = self.infoDic[@"입금계좌번호"];
    _lblData04.text = self.infoDic[@"입금계좌성명"];
    _lblData05.text = self.infoDic[@"이체금액"];
    _lblData06.text = [NSString stringWithFormat:@"%@ %@", self.infoDic[@"예약처리일자"], self.infoDic[@"예약처리시간"]];
    _lblData07.text = self.infoDic[@"입금계좌통장메모"];
    _lblData08.text = self.infoDic[@"출금계좌통장메모"];
    _lblData09.text = self.infoDic[@"CMS코드"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 236.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, 236 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.nextSVC = @"D2111";
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
        secretcardView.nextSVC = @"D2111";
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
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [super viewDidUnload];
}

@end
