//
//  SHBLoanCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanCancelCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanCancelCompleteViewController ()

@end

@implementation SHBLoanCancelCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
            if([strController isEqualToString:@"SHBAccountMenuListViewController"]
               || [strController isEqualToString:@"SHBLoanAccountListViewController"])
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
    
    self.title = @"대출조회/한도해지";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"한도대출 해지 완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    
    NSArray *dataArray = @[
                           [self.L1241 objectForKey:@"고객명"],
                           [self.L1241 objectForKey:@"상품명"],
                           [self.L1241 objectForKey:@"담보계좌번호"],
                           AppInfo.commonDic[@"대출계좌번호"],
                           [self.L1241 objectForKey:@"종통대신청구분설명"],

                           ];
    
   
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblData release];
    [_lblAccName release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLblData:nil];
    [self setLblAccName:nil];
    [super viewDidUnload];
}

@end
