//
//  SHBLoanInterestPayCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanInterestPayCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanInterestPayCompleteViewController ()

@end

@implementation SHBLoanInterestPayCompleteViewController

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

    self.title = @"이자조회/납입";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이자납입 완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    [_lblAccName initFrame:_lblAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblAccName setCaptionText:AppInfo.commonDic[@"대출계좌명"]];
    
    NSArray *dataArray = @[
    AppInfo.commonDic[@"대출계좌번호"],
    AppInfo.commonDic[@"대출계좌번호"],
    AppInfo.commonDic[@"이자금액"],
    AppInfo.commonDic[@"이자금액"],
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
