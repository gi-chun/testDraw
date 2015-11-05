//
//  SHB_GoldTech_ManualInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHB_GoldTech_ManualInfoViewController.h"
#import "SHBGoodsSubTitleView.h"

#import "SHBNewProductSeeStipulationViewController.h" // 약관보기
#import "SHB_GoldTech_ManualViewController.h" // 투자설명서 및 간이투자설명서
#import "SHB_GoldTech_InputViewcontroller.h" // 골드리슈 골드테크 가입

@interface SHB_GoldTech_ManualInfoViewController ()

@end

@implementation SHB_GoldTech_ManualInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"예금적금 가입 2단계";
    
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"안내"
                                                               maxStep:5
                                                       focusStepNumber:2] autorelease]];
    
    [self.contentScrollView addSubview:_contentView];
    [self.contentScrollView setContentSize:_contentView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_contentView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 10: {
            
            // 고시가격변동내역
            
            NSString *strURL = [NSString stringWithFormat:@"%@/sbank/goldprod/sb_gosi_price.jsp", AppInfo.realServer ? URL_M : URL_M_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"고시가격변동내역";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 20: {
            
            // 골드리슈가격추이
            
            NSString *strURL = [NSString stringWithFormat:@"%@/sbank/goldprod/sb_gold_price.jsp", AppInfo.realServer ? URL_M : URL_M_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"골드리슈가격추이";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 30: {
            
            // 국제금가격추이
            
            NSString *strURL = [NSString stringWithFormat:@"%@/sbank/goldprod/sb_gold_price_inter.jsp", AppInfo.realServer ? URL_M : URL_M_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"국제금가격추이";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 1000: {
            
            // 확인
            
            SHB_GoldTech_InputViewcontroller *viewController = [[[SHB_GoldTech_InputViewcontroller alloc] initWithNibName:@"SHB_GoldTech_InputViewcontroller" bundle:nil] autorelease];
            
            viewController.dicSelectedData = self.dicSelectedData;
            viewController.userItem = self.userItem;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 2000: {
            
            // 취소
            
            for (SHB_GoldTech_ManualViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHB_GoldTech_ManualViewController class]]) {
                    
                    [self.navigationController fadePopToViewController:viewController];
                    [viewController resetUI];
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}

@end
