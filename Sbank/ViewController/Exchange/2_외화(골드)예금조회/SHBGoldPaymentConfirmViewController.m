//
//  SHBGoldPaymentConfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldPaymentConfirmViewController.h"
#import "SHBGoldPaymentCompleteViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBExchangeService.h"

#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldPaymentConfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
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
    UILabel *lblCaption10;
    UILabel *lblCaption11;
    UILabel *lblCaption12;
    
    UILabel *lblData01;
    UILabel *lblData02;
    UILabel *lblData03;
    UILabel *lblData04;
    UILabel *lblData05;
    UILabel *lblData06;
    UILabel *lblData07;
    UILabel *lblData08;
    UILabel *lblData09;
    UILabel *lblData10;
    UILabel *lblData11;
    UILabel *lblData12;
    
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
@property (nonatomic, retain) IBOutlet UILabel *lblCaption10;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption11;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption12;
@property (nonatomic, retain) IBOutlet UILabel *lblData01;
@property (nonatomic, retain) IBOutlet UILabel *lblData02;
@property (nonatomic, retain) IBOutlet UILabel *lblData03;
@property (nonatomic, retain) IBOutlet UILabel *lblData04;
@property (nonatomic, retain) IBOutlet UILabel *lblData05;
@property (nonatomic, retain) IBOutlet UILabel *lblData06;
@property (nonatomic, retain) IBOutlet UILabel *lblData07;
@property (nonatomic, retain) IBOutlet UILabel *lblData08;
@property (nonatomic, retain) IBOutlet UILabel *lblData09;
@property (nonatomic, retain) IBOutlet UILabel *lblData10;
@property (nonatomic, retain) IBOutlet UILabel *lblData11;
@property (nonatomic, retain) IBOutlet UILabel *lblData12;
@end

@implementation SHBGoldPaymentConfirmViewController
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
@synthesize lblCaption10;
@synthesize lblCaption11;
@synthesize lblCaption12;
@synthesize lblData01;
@synthesize lblData02;
@synthesize lblData03;
@synthesize lblData04;
@synthesize lblData05;
@synthesize lblData06;
@synthesize lblData07;
@synthesize lblData08;
@synthesize lblData09;
@synthesize lblData10;
@synthesize lblData11;
@synthesize lblData12;

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
        case GOLD_187:{
            AppInfo.eSignNVBarTitle = @"골드출금";
            AppInfo.electronicSignCode = @"D7131_A";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7131" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{@"골드리슈계좌" : AppInfo.commonDic[@"골드리슈계좌번호"],
                                                                             @"원화계좌" : AppInfo.commonDic[@"원화입금계좌번호"],
                                                                             @"고객환율" : AppInfo.commonDic[@"거래가격"],
                                                                             @"소득세" : AppInfo.commonDic[@"소득세"],
                                                                             @"지방소득세" : AppInfo.commonDic[@"지방소득세"],
                                                                             @"세후지급금액" : AppInfo.commonDic[@"원화 입금금액"],
                                                                             @"통화코드" : AppInfo.commonDic[@"통화"],
                                                                             @"외화합계" : AppInfo.commonDic[@"지급량(g)"],
                                                                             @"POSITION" : AppInfo.commonDic[@"지급량(g)"],
                                                                             @"원화합계" : AppInfo.commonDic[@"원화 평가금액"],
                                                                             @"입금고객명_로그" : AppInfo.commonDic[@"골드리슈계좌 고객명"],
                                                                             @"지급고객명_로그" : AppInfo.commonDic[@"원화계좌 고객명"],
                                                                             }] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        case GOLD_188:{
            AppInfo.eSignNVBarTitle = @"골드출금";
            AppInfo.electronicSignCode = @"D7431_C";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7431" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{@"골드리슈계좌" : AppInfo.commonDic[@"골드리슈계좌번호"],
                                                                             @"외화입금계좌번호" : AppInfo.commonDic[@"외화입금계좌번호"],
                                                                             @"외화연동금액" : AppInfo.commonDic[@"외화입금액(USD)"],
                                                                             @"고객환율" : AppInfo.commonDic[@"거래가격(USD)"],
                                                                             @"소득세" : AppInfo.commonDic[@"소득세"],
                                                                             @"지방소득세" : AppInfo.commonDic[@"지방소득세"],
                                                                             @"통화코드" : AppInfo.commonDic[@"통화"],
                                                                             @"달러대체" : AppInfo.commonDic[@"외화입금액(USD)"],
                                                                             @"POSITION" : AppInfo.commonDic[@"지급량(g)"],
                                                                             @"외화합계" : AppInfo.commonDic[@"지급량(g)"],
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
        case GOLD_187:{
            NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] initWithDictionary:AppInfo.commonDic] autorelease];
            resultDic[@"원화계좌잔액"] = dic[@"연동원화거래후잔액"];
            resultDic[@"골드리슈계좌잔량(g)"] = dic[@"거래후잔액"];
            AppInfo.commonDic = (NSDictionary *)resultDic;
        }
            break;
        case GOLD_188:{
            NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] initWithDictionary:AppInfo.commonDic] autorelease];
            resultDic[@"외화입금계좌잔액(USD)"] = dic[@"연동외화거래후잔액"];
            resultDic[@"골드리슈계좌잔량(g)"] = dic[@"거래후잔액"];
            AppInfo.commonDic = (NSDictionary *)resultDic;
        }
            break;
            
        default:
            break;
    }
    
    
    SHBGoldPaymentCompleteViewController *nextViewController = [[[SHBGoldPaymentCompleteViewController alloc] initWithNibName:@"SHBGoldPaymentCompleteViewController" bundle:nil] autorelease];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //NSLog(@"abcd:%@",AppDelegate.navigationController.viewControllers);
    AppInfo.isNeedClearData = YES;

    NSString *strSelfName = @"SHBGoldPaymentInputViewController";
    
    for(UIViewController *controller in AppDelegate.navigationController.viewControllers)
    {
        if([NSStringFromClass([controller class]) isEqualToString:strSelfName])
        {
            [AppDelegate.navigationController fadePopToViewController:controller];
            break;
        }
    }
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
    
    self.title = @"골드출금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드출금 정보확인" maxStep:4 focusStepNumber:3] autorelease]];
    switch (accType) {
        case GOLD_187:{
            lblCaption01.text = @"골드상품명";
            lblCaption02.text = @"골드리슈계좌번호";
            lblCaption03.text = @"골드리슈계좌 고객명";
            lblCaption04.text = @"통화";
            lblCaption05.text = @"지급량(g)";
            lblCaption06.text = @"거래가격";
            lblCaption07.text = @"원화 평가금액";
            lblCaption08.text = @"소득세";
            lblCaption09.text = @"지방소득세";
            lblCaption10.text = @"원화입금계좌번호";
            lblCaption11.text = @"원화계좌 고객명";
            lblCaption12.text = @"원화 입금금액";
            
            lblData01.text = AppInfo.commonDic[@"골드상품명"];
            lblData02.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData03.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData04.text = AppInfo.commonDic[@"통화"];
            lblData05.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"지급량(g)"]];
            lblData06.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"거래가격"]];
            lblData07.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화 평가금액"]];
            lblData08.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"소득세"]];
            lblData09.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"지방소득세"]];
            lblData10.text = AppInfo.commonDic[@"원화입금계좌번호"];
            lblData11.text = AppInfo.commonDic[@"원화계좌 고객명"];
            lblData12.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화 입금금액"]];
            
            infoView.frame = CGRectMake(0, 0, 317, 310);
        }
            break;
        case GOLD_188:{
            lblCaption01.text = @"골드상품명";
            lblCaption02.text = @"골드리슈계좌번호";
            lblCaption03.text = @"골드리슈계좌 고객명";
            lblCaption04.text = @"통화";
            lblCaption05.text = @"지급량(g)";
            lblCaption06.text = @"거래가격(USD)";
            lblCaption07.text = @"외화 입금액(USD)";
            lblCaption08.text = @"소득세";
            lblCaption09.text = @"지방소득세";
            lblCaption10.text = @"외화입금계좌번호";
            lblCaption11.text = @"외화계좌 고객명";
            [lblCaption12 removeFromSuperview];
            
            lblData01.text = AppInfo.commonDic[@"골드상품명"];
            lblData02.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData03.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData04.text = AppInfo.commonDic[@"통화"];
            lblData05.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"지급량(g)"]];
            lblData06.text = AppInfo.commonDic[@"거래가격(USD)"];
            lblData07.text = AppInfo.commonDic[@"외화입금액(USD)"];
            lblData08.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"소득세"]];
            lblData09.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"지방소득세"]];
            lblData10.text = AppInfo.commonDic[@"외화입금계좌번호"];
            lblData11.text = AppInfo.commonDic[@"외화계좌 고객명"];
            [lblData12 removeFromSuperview];
            
            infoView.frame = CGRectMake(0, 0, 317, 285);
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
            case GOLD_187:{
                secretotpView.nextSVC = @"D7131";
            }
                break;
            case GOLD_188:{
                secretotpView.nextSVC = @"D7431";
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
            case GOLD_187:{
                secretcardView.nextSVC = @"D7131";
            }
                break;
            case GOLD_188:{
                secretcardView.nextSVC = @"D7431";
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
    [lblCaption10 release];
    [lblCaption11 release];
    [lblCaption12 release];
    [lblData01 release];
    [lblData02 release];
    [lblData03 release];
    [lblData04 release];
    [lblData05 release];
    [lblData06 release];
    [lblData07 release];
    [lblData08 release];
    [lblData09 release];
    [lblData10 release];
    [lblData11 release];
    [lblData12 release];
    
    [contentsView release];
    [infoView release];
    [secretView release];
    
    [super dealloc];
}

@end
