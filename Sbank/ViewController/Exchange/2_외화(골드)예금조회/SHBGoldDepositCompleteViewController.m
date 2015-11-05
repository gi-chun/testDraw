//
//  SHBGoldDepositCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 8..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldDepositCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

#define GOLD_186 186 // 신한골드리슈금적립
#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldDepositCompleteViewController ()
{
    UIView *contentsView;
    UIView *infoView;
    UIView *confirmView;
    
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
    
    int accType;
}
@property (retain, nonatomic) IBOutlet UIView *contentsView;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *confirmView;

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
@end

@implementation SHBGoldDepositCompleteViewController
@synthesize contentsView;
@synthesize infoView;
@synthesize confirmView;
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

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:
        {
            NSString *strSelfName1 = @"SHBForexGoldListViewController";
            NSString *strSelfName2 = @"SHBAccountMenuListViewController";
            
            for(UIViewController *controller in AppDelegate.navigationController.viewControllers)
            {
                if([NSStringFromClass([controller class]) isEqualToString:strSelfName1] ||
                   [NSStringFromClass([controller class]) isEqualToString:strSelfName2])
                {
                    [AppDelegate.navigationController fadePopToViewController:controller];
                    [controller performSelector:@selector(refresh)];
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
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

    [self navigationBackButtonHidden];
    
    accType = [AppInfo.commonDic[@"AccType"] intValue];
    
    switch (accType) {
        case GOLD_186:{
            self.title = @"골드적립";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드적립 완료" maxStep:4 focusStepNumber:4] autorelease]];

            lblCaption01.text = @"골드리슈계좌번호";
            lblCaption02.text = @"적립량(g)";
            lblCaption03.text = @"적용가격";
            lblCaption04.text = @"원화출금계좌번호";
            lblCaption05.text = @"통화";
            lblCaption06.text = @"인출 원화금액";
            [lblCaption07 removeFromSuperview];
            [lblCaption08 removeFromSuperview];
            [lblCaption09 removeFromSuperview];
            [lblCaption10 removeFromSuperview];
            [lblCaption11 removeFromSuperview];
            
            lblData01.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData02.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"적립량(g)"]];
            lblData03.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"적용가격"]];
            lblData04.text = AppInfo.commonDic[@"원화출금계좌번호"];
            lblData05.text = AppInfo.commonDic[@"통화"];
            lblData06.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"인출 원화금액"]];
            [lblData07 removeFromSuperview];
            [lblData08 removeFromSuperview];
            [lblData09 removeFromSuperview];
            [lblData10 removeFromSuperview];
            [lblData11 removeFromSuperview];
        }
            break;
        case GOLD_187:{
            self.title = @"골드입금";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 완료" maxStep:4 focusStepNumber:4] autorelease]];
            
            contentsView.frame = CGRectMake(0, 0, 317, 285 + 29 + 30);

            infoView.frame = CGRectMake(0, 0, 317, 285);
            confirmView.frame = CGRectMake(0, 295, 317, 29);
            
            lblCaption01.text = @"원화출금계좌번호";
            lblCaption02.text = @"원화계좌 고객명";
            lblCaption03.text = @"거래가격";
            lblCaption04.text = @"원화금액";
            lblCaption05.text = @"원화계좌잔액";
            lblCaption06.text = @"골드상품명";
            lblCaption07.text = @"골드리슈계좌번호";
            lblCaption08.text = @"골드리슈계좌 고객명";
            lblCaption09.text = @"통화";
            lblCaption10.text = @"입금량(g)";
            lblCaption11.text = @"골드리슈계좌잔량(g)";
            
            lblData01.text = AppInfo.commonDic[@"원화출금계좌번호"];
            lblData02.text = AppInfo.commonDic[@"원화계좌 고객명"];
            lblData03.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"거래가격"]];
            lblData04.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화금액"]];
            lblData05.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화계좌잔액"]];
            lblData06.text = AppInfo.commonDic[@"골드상품명"];
            lblData07.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData08.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData09.text = AppInfo.commonDic[@"통화"];
            lblData10.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"입금량(g)"]];
            lblData11.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"골드리슈계좌잔량(g)"]];
        }
            break;
        case GOLD_188:{
            self.title = @"골드입금";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 완료" maxStep:4 focusStepNumber:4] autorelease]];
            
            contentsView.frame = CGRectMake(0, 0, 317, 285 + 29 + 30);

            infoView.frame = CGRectMake(0, 0, 317, 285);
            confirmView.frame = CGRectMake(0, 295, 317, 29);

            lblCaption01.text = @"외화출금계좌번호";
            lblCaption02.text = @"외화출금계좌 고객명";
            lblCaption03.text = @"거래가격(USD)";
            lblCaption04.text = @"외화출금액(USD)";
            lblCaption05.text = @"외화출금계좌잔액(USD)";
            lblCaption06.text = @"골드상품명";
            lblCaption07.text = @"골드리슈계좌번호";
            lblCaption08.text = @"골드리슈계좌 고객명";
            lblCaption09.text = @"통화";
            lblCaption10.text = @"입금량(g)";
            lblCaption11.text = @"골드리슈계좌잔량(g)";
            
            lblData01.text = AppInfo.commonDic[@"외화출금계좌번호"];
            lblData02.text = AppInfo.commonDic[@"외화계좌 고객명"];
            lblData03.text = AppInfo.commonDic[@"거래가격"];
            lblData04.text = AppInfo.commonDic[@"외화출금액(USD)"];
            lblData05.text = AppInfo.commonDic[@"외화출금계좌잔액(USD)"];
            lblData06.text = AppInfo.commonDic[@"골드상품명"];
            lblData07.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData08.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData09.text = AppInfo.commonDic[@"통화"];
            lblData10.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"입금량(g)"]];
            lblData11.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"골드리슈계좌잔량(g)"]];
        }
            break;
            
        default:
            break;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(317, contentsView.frame.size.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
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
    
    [contentsView release];
    [infoView release];
    [confirmView release];
    
    [super dealloc];
}

@end
