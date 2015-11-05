//
//  SHBDepositCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBDepositCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBDepositCompleteViewController ()

@end

@implementation SHBDepositCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:
        {
            if ([self.data[@"isSmartTransfer"] isEqualToString:@"YES"]) {
                
                [self.navigationController fadePopToRootViewController];
                return;
            }
            
            NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
            if([strController isEqualToString:@"SHBAccountMenuListViewController"]
               || [strController isEqualToString:@"SHBAccountListViewController"])
            {
                [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self.navigationController fadePopToRootViewController];
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
    
    
    if ([self.data[@"isSmartTransfer"] isEqualToString:@"YES"]) {
        
        self.title = @"스마트이체";
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예금입금 완료" maxStep:2 focusStepNumber:2] autorelease]];
    }
    else {
        
        self.title = @"즉시이체/예금입금";
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예금입금 완료" maxStep:3 focusStepNumber:3] autorelease]];
    }
    
    [self navigationBackButtonHidden];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    
    [_lblData02 initFrame:_lblData02.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblData02 setCaptionText:AppInfo.commonDic[@"계좌명"]];
    
    _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData04.text = AppInfo.commonDic[@"입금금액"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [super viewDidUnload];
}
@end
