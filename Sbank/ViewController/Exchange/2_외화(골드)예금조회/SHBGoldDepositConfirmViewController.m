//
//  SHBGoldDepositConfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 8..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldDepositConfirmViewController.h"
#import "SHBGoldDepositCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBExchangeService.h"

#define GOLD_186 186 // 신한골드리슈금적립
#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldDepositConfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
    
    UIView *contentsView;
    UIView *infoView;
    UIView *secretView;
    
    UILabel *lblCaption01;
    UILabel *lblCaption02;
    UILabel *lblCaption03;
    UILabel *lblCaption04;
    UILabel *lblCaption05;
    UILabel *lblCaption06;
    UILabel *lblCaption07;
    UILabel *lblCaption08;
    UILabel *lblCaption09;
    
    UILabel *lblData01;
    UILabel *lblData02;
    UILabel *lblData03;
    UILabel *lblData04;
    UILabel *lblData05;
    UILabel *lblData06;
    UILabel *lblData07;
    UILabel *lblData08;
    UILabel *lblData09;
    
    int accType;
}
@property (retain, nonatomic) SHBSecretCardViewController *secretcardView;
@property (retain, nonatomic) SHBSecretOTPViewController *secretotpView;

@property (retain, nonatomic) IBOutlet UIView *contentsView;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;

@property (nonatomic, retain) IBOutlet UILabel *lblCaption01;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption02;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption03;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption04;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption05;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption06;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption07;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption08;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption09;
@property (nonatomic, retain) IBOutlet UILabel *lblData01;
@property (nonatomic, retain) IBOutlet UILabel *lblData02;
@property (nonatomic, retain) IBOutlet UILabel *lblData03;
@property (nonatomic, retain) IBOutlet UILabel *lblData04;
@property (nonatomic, retain) IBOutlet UILabel *lblData05;
@property (nonatomic, retain) IBOutlet UILabel *lblData06;
@property (nonatomic, retain) IBOutlet UILabel *lblData07;
@property (nonatomic, retain) IBOutlet UILabel *lblData08;
@property (nonatomic, retain) IBOutlet UILabel *lblData09;
@end

@implementation SHBGoldDepositConfirmViewController
@synthesize secretcardView;
@synthesize secretotpView;
@synthesize contentsView;
@synthesize infoView;
@synthesize secretView;
@synthesize lblCaption01;
@synthesize lblCaption02;
@synthesize lblCaption03;
@synthesize lblCaption04;
@synthesize lblCaption05;
@synthesize lblCaption06;
@synthesize lblCaption07;
@synthesize lblCaption08;
@synthesize lblCaption09;
@synthesize lblData01;
@synthesize lblData02;
@synthesize lblData03;
@synthesize lblData04;
@synthesize lblData05;
@synthesize lblData06;
@synthesize lblData07;
@synthesize lblData08;
@synthesize lblData09;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
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
    
    switch (accType) {
        case GOLD_186:{
            AppInfo.eSignNVBarTitle = @"골드적립";
            AppInfo.electronicSignCode = @"D7032_A";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7032" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{}] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
            
        }
            break;
        case GOLD_187:{
            AppInfo.eSignNVBarTitle = @"골드입금";
            AppInfo.electronicSignCode = @"D7141_A";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7141" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{@"원화계좌" : AppInfo.commonDic[@"원화출금계좌번호"],
                                                                             @"골드리슈계좌" : AppInfo.commonDic[@"골드리슈계좌번호"],
                                                                             @"고객환율" : AppInfo.commonDic[@"거래가격"],
                                                                             @"통화코드" : AppInfo.commonDic[@"통화"],
                                                                             @"포지션" : AppInfo.commonDic[@"입금량(g)"],
                                                                             @"외화합계" : AppInfo.commonDic[@"입금량(g)"],
                                                                             @"원화합계" : AppInfo.commonDic[@"원화금액"],
                                                                             @"입금고객명_로그" : AppInfo.commonDic[@"골드리슈계좌 고객명"],
                                                                             @"지급고객명_로그" : AppInfo.commonDic[@"원화계좌 고객명"],
                                                                             }] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        case GOLD_188:{
            AppInfo.eSignNVBarTitle = @"골드입금";
            AppInfo.electronicSignCode = @"D7441_A";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7441" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{@"외화연동금액" : AppInfo.commonDic[@"외화출금액(USD)"],
                                                                             @"골드리슈계좌" : AppInfo.commonDic[@"골드리슈계좌번호"],
                                                                             @"외화연동계좌번호" : AppInfo.commonDic[@"외화출금계좌번호"],
                                                                             @"고객환율" : AppInfo.commonDic[@"거래가격"],
                                                                             @"통화코드" : AppInfo.commonDic[@"통화"],
                                                                             @"포지션" : AppInfo.commonDic[@"입금량(g)"],
                                                                             @"외화합계" : AppInfo.commonDic[@"입금량(g)"],
                                                                             @"달러대체" : AppInfo.commonDic[@"외화출금액(USD)"],
                                                                             @"입금고객명_로그" : AppInfo.commonDic[@"골드리슈계좌 고객명"],
                                                                             @"지급고객명_로그" : AppInfo.commonDic[@"외화계좌 고객명"],
                                                                             }] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    
    switch (accType) {
        case GOLD_186:{
        }
            break;
        case GOLD_187:{
            NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] initWithDictionary:AppInfo.commonDic] autorelease];
            resultDic[@"원화계좌잔액"] = dic[@"원화연동계좌잔액"];
            resultDic[@"골드리슈계좌잔량(g)"] = dic[@"계좌잔액"];
            AppInfo.commonDic = (NSDictionary *)resultDic;
        }
            break;
        case GOLD_188:{
            NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] initWithDictionary:AppInfo.commonDic] autorelease];
            resultDic[@"외화출금계좌잔액(USD)"] = dic[@"외화연동계좌잔액"];
            resultDic[@"골드리슈계좌잔량(g)"] = dic[@"계좌잔액"];
            AppInfo.commonDic = (NSDictionary *)resultDic;
        }
            break;
            
        default:
            break;
    }
    
    
    SHBGoldDepositCompleteViewController *nextViewController = [[[SHBGoldDepositCompleteViewController alloc] initWithNibName:@"SHBGoldDepositCompleteViewController" bundle:nil] autorelease];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //NSLog(@"abcd:%@",AppDelegate.navigationController.viewControllers);
    AppInfo.isNeedClearData = YES;

    NSString *strSelfName = @"SHBGoldDepositInputViewController";
    
    for(UIViewController *controller in AppDelegate.navigationController.viewControllers)
    {
        if([NSStringFromClass([controller class]) isEqualToString:strSelfName])
        {
            [AppDelegate.navigationController fadePopToViewController:controller];
            break;
        }
    }
    
//    [AppDelegate.navigationController popToViewController:[AppDelegate.navigationController.viewControllers objectAtIndex:curIndex - 1] animated:YES];
//    [AppDelegate.navigationController performSelector:@selector(fadePopViewController) withObject:nil afterDelay:0.1 ];
    
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppInfo.isNeedClearData = YES;
    [AppDelegate.navigationController fadePopViewController];
}

// 보안에서 완료 시
- (void)resetFormPosition
{
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    accType = [AppInfo.commonDic[@"AccType"] intValue];
    
    switch (accType) {
        case GOLD_186:{
            self.title = @"골드적립";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드적립 정보확인" maxStep:4 focusStepNumber:3] autorelease]];
            
            lblCaption01.text = @"골드리슈계좌번호";
            lblCaption02.text = @"적립량(g)";
            lblCaption03.text = @"적용가격";
            lblCaption04.text = @"원화출금계좌번호";
            lblCaption05.text = @"인출 원화금액";
            [lblCaption06 removeFromSuperview];
            [lblCaption07 removeFromSuperview];
            [lblCaption08 removeFromSuperview];
            [lblCaption09 removeFromSuperview];
            
            lblData01.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData02.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"적립량(g)"]];
            lblData03.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"적용가격"]];
            lblData04.text = AppInfo.commonDic[@"원화출금계좌번호"];
            lblData05.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"인출 원화금액"]];
            [lblData06 removeFromSuperview];
            [lblData07 removeFromSuperview];
            [lblData08 removeFromSuperview];
            [lblData09 removeFromSuperview];
            
            infoView.frame = CGRectMake(0, 0, 317, 135);
        }
            break;
        case GOLD_187:{
            self.title = @"골드입금";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 정보확인" maxStep:4 focusStepNumber:3] autorelease]];

            lblCaption01.text = @"원화출금계좌번호";
            lblCaption02.text = @"원화계좌 고객명";
            lblCaption03.text = @"거래가격";
            lblCaption04.text = @"원화금액";
            lblCaption05.text = @"골드상품명";
            lblCaption06.text = @"골드리슈계좌번호";
            lblCaption07.text = @"골드리슈계좌 고객명";
            lblCaption08.text = @"통화";
            lblCaption09.text = @"입금량(g)";
            
            lblData01.text = AppInfo.commonDic[@"원화출금계좌번호"];
            lblData02.text = AppInfo.commonDic[@"원화계좌 고객명"];
            lblData03.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"거래가격"]];
            lblData04.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화금액"]];
            lblData05.text = AppInfo.commonDic[@"골드상품명"];
            lblData06.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData07.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData08.text = AppInfo.commonDic[@"통화"];
            lblData09.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"입금량(g)"]];
            
            infoView.frame = CGRectMake(0, 0, 317, 235);
        }
            break;
        case GOLD_188:{
            self.title = @"골드입금";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 정보확인" maxStep:4 focusStepNumber:3] autorelease]];

            lblCaption01.text = @"외화출금계좌번호";
            lblCaption02.text = @"외화출금계좌 고객명";
            lblCaption03.text = @"거래가격(USD)";
            lblCaption04.text = @"외화출금액(USD)";
            lblCaption05.text = @"골드상품명";
            lblCaption06.text = @"골드리슈계좌번호";
            lblCaption07.text = @"골드리슈계좌 고객명";
            lblCaption08.text = @"통화";
            lblCaption09.text = @"입금량(g)";
            
            lblData01.text = AppInfo.commonDic[@"외화출금계좌번호"];
            lblData02.text = AppInfo.commonDic[@"외화계좌 고객명"];
            lblData03.text = AppInfo.commonDic[@"거래가격"];
            lblData04.text = AppInfo.commonDic[@"외화출금액(USD)"];
            lblData05.text = AppInfo.commonDic[@"골드상품명"];
            lblData06.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData07.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData08.text = AppInfo.commonDic[@"통화"];
            lblData09.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"입금량(g)"]];
            
            infoView.frame = CGRectMake(0, 0, 317, 235);
        }
            break;
            
        default:
            break;
    }
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;
        
        contentsView.frame = CGRectMake(0, 0, 317, infoView.frame.size.height + secretView.frame.size.height);
        secretView.frame = CGRectMake(0.0f, infoView.frame.size.height, 317.0f, secretotpView.view.frame.size.height);
        
        [secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        switch (accType) {
            case GOLD_186:{
                secretotpView.nextSVC = @"D7032";
            }
                break;
            case GOLD_187:{
                secretotpView.nextSVC = @"D7141";
            }
                break;
            case GOLD_188:{
                secretotpView.nextSVC = @"D7441";
            }
                break;
                
            default:
                break;
        }
        secretotpView.selfPosY = secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        contentsView.frame = CGRectMake(0, 0, 317, infoView.frame.size.height + secretView.frame.size.height);
        secretView.frame = CGRectMake(0.0f, infoView.frame.size.height, 317.0f, secretcardView.view.frame.size.height);
        
        [secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        switch (accType) {
            case GOLD_186:{
                secretcardView.nextSVC = @"D7032";
            }
                break;
            case GOLD_187:{
                secretcardView.nextSVC = @"D7141";
            }
                break;
            case GOLD_188:{
                secretcardView.nextSVC = @"D7441";
            }
                break;
                
            default:
                break;
        }
        secretcardView.selfPosY = secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(317, contentsView.frame.size.height + 44.0f);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    // 보안키패드 완료
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"secureMediaKeyPadClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFormPosition) name:@"secureMediaKeyPadClose" object:nil];
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

    [lblCaption01 release];
    [lblCaption02 release];
    [lblCaption03 release];
    [lblCaption04 release];
    [lblCaption05 release];
    [lblCaption06 release];
    [lblCaption07 release];
    [lblCaption08 release];
    [lblCaption09 release];
    [lblData01 release];
    [lblData02 release];
    [lblData03 release];
    [lblData04 release];
    [lblData05 release];
    [lblData06 release];
    [lblData07 release];
    [lblData08 release];
    [lblData09 release];
    
    [contentsView release];
    [infoView release];
    [secretView release];

    [super dealloc];
}

@end
