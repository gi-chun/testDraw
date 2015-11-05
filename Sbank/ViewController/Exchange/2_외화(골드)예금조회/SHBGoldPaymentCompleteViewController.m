//
//  SHBGoldPaymentCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldPaymentCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldPaymentCompleteViewController ()
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
    UILabel *lblCaption12;
    UILabel *lblCaption13;
    UILabel *lblCaption14;
    
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
    UILabel *lblData13;
    UILabel *lblData14;
    
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
@property (nonatomic, retain) IBOutlet UILabel *lblCaption12;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption13;
@property (nonatomic, retain) IBOutlet UILabel *lblCaption14;
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
@property (nonatomic, retain) IBOutlet UILabel *lblData13;
@property (nonatomic, retain) IBOutlet UILabel *lblData14;

@end

@implementation SHBGoldPaymentCompleteViewController
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
@synthesize lblCaption12;
@synthesize lblCaption13;
@synthesize lblCaption14;
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
@synthesize lblData13;
@synthesize lblData14;

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
    
    self.title = @"골드출금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드출금 완료" maxStep:4 focusStepNumber:4] autorelease]];

    switch (accType) {
        case GOLD_187:{
            contentsView.frame = CGRectMake(0, 0, 317, 360 + 29 + 30);
            
            infoView.frame = CGRectMake(0, 0, 317, 360);
            confirmView.frame = CGRectMake(0, 370, 317, 29);
            
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
            lblCaption13.text = @"골드리슈계좌잔량(g)";
            lblCaption14.text = @"원화계좌 잔액";
            
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
            lblData13.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"골드리슈계좌잔량(g)"]];
            lblData14.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"원화계좌잔액"]];
        }
            break;
        case GOLD_188:{
            contentsView.frame = CGRectMake(0, 0, 317, 335 + 29 + 30);

            infoView.frame = CGRectMake(0, 0, 317, 335);
            confirmView.frame = CGRectMake(0, 345, 317, 29);
            
            lblCaption01.text = @"골드상품명";
            lblCaption02.text = @"골드리슈계좌번호";
            lblCaption03.text = @"골드리슈계좌 고객명";
            lblCaption04.text = @"통화";
            lblCaption05.text = @"지급량(g)";
            lblCaption06.text = @"거래가격(USD)";
            lblCaption07.text = @"소득세";
            lblCaption08.text = @"지방소득세";
            lblCaption09.text = @"외화입금계좌번호";
            lblCaption10.text = @"외화계좌 고객명";
            lblCaption11.text = @"외화 입금액(USD)";
            lblCaption12.text = @"골드리슈계좌잔량(g)";
            lblCaption13.text = @"외화입금계좌잔액(USD)";
            [lblCaption14 removeFromSuperview];
            
            lblData01.text = AppInfo.commonDic[@"골드상품명"];
            lblData02.text = AppInfo.commonDic[@"골드리슈계좌번호"];
            lblData03.text = AppInfo.commonDic[@"골드리슈계좌 고객명"];
            lblData04.text = AppInfo.commonDic[@"통화"];
            lblData05.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"지급량(g)"]];
            lblData06.text = AppInfo.commonDic[@"거래가격(USD)"];
            lblData07.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"소득세"]];
            lblData08.text = [NSString stringWithFormat:@"%@ 원", AppInfo.commonDic[@"지방소득세"]];
            lblData09.text = AppInfo.commonDic[@"외화입금계좌번호"];
            lblData10.text = AppInfo.commonDic[@"외화계좌 고객명"];
            lblData11.text = AppInfo.commonDic[@"외화입금액(USD)"];
            lblData12.text = [NSString stringWithFormat:@"%@ g", AppInfo.commonDic[@"골드리슈계좌잔량(g)"]];
            lblData13.text = AppInfo.commonDic[@"외화입금계좌잔액(USD)"];
            [lblData14 removeFromSuperview];
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
    [lblCaption12 release];
    [lblCaption13 release];
    [lblCaption14 release];
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
    [lblData13 release];
    [lblData14 release];
    
    [contentsView release];
    [infoView release];
    [confirmView release];
    
    [super dealloc];
}
@end
