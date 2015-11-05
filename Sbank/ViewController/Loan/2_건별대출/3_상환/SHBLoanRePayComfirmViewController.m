//
//  SHBLoanRePayComfirmViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanRePayComfirmViewController.h"
#import "SHBLoanRePayCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBLoanService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanRePayComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
}
@end

@implementation SHBLoanRePayComfirmViewController

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    AppInfo.eSignNVBarTitle = @"대출조회/상환";
    
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
    
    AppInfo.electronicSignCode = [AppInfo.commonDic[@"제목"] isEqualToString:@"대출원리금상환"] ? @"L1222_B" : @"L1222_A";
    AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1222" viewController:self] autorelease];
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                             @"여신계좌번호" : [AppInfo.commonDic[@"대출계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                             @"거래금액" : [SHBUtility commaStringToNormalString:AppInfo.commonDic[@"상환원금"]],
                             @"거래구분" : [AppInfo.commonDic[@"제목"] isEqualToString:@"대출원리금상환"] ? @"10" : @"1",
                             // 2013.01.20 신계좌번호로 보내야함.
                             @"출금계좌번호" : [AppInfo.commonDic[@"출금신계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                             @"출금계좌비밀번호" : AppInfo.commonDic[@"출금계좌비밀번호"],
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
    SHBLoanRePayCompleteViewController *nextViewController = [[[SHBLoanRePayCompleteViewController alloc] initWithNibName:@"SHBLoanRePayCompleteViewController" bundle:nil] autorelease];
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
    
    self.title = @"대출조회/상환";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"대출상환 확인" maxStep:3 focusStepNumber:2] autorelease]];
    
    [_lblAccName initFrame:_lblAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblAccName setCaptionText:AppInfo.commonDic[@"대출계좌명"]];
    
    NSArray *dataArray = @[
    AppInfo.commonDic[@"대출계좌번호"],
    AppInfo.commonDic[@"출금계좌번호"],
    AppInfo.commonDic[@"대출잔액"],
    AppInfo.commonDic[@"상환원금"],
    AppInfo.commonDic[@"중도상환수수료"],
    AppInfo.commonDic[@"(정상이자금액)"],
    AppInfo.commonDic[@"(연체이자금액)"],
    AppInfo.commonDic[@"상환이자금액"],
    AppInfo.commonDic[@"환출이자금액"],
    AppInfo.commonDic[@"상환금액합계"],
    AppInfo.commonDic[@"상환후 대출잔액"],
    AppInfo.commonDic[@"출금금액"],
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
        secretotpView.nextSVC = @"L1222";
        
        _secretView.frame = CGRectMake(0.0f, 376.0f, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317.0f, 376 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, 376.0f, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317.0f, 376 + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        secretcardView.nextSVC = @"L1222";
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
    [_lblAccName release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setInfoView:nil];
    [self setSecretView:nil];
    [self setLblData:nil];
    [self setLblAccName:nil];
    [super viewDidUnload];
}
@end
