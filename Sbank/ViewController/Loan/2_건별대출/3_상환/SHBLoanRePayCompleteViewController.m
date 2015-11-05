//
//  SHBLoanRePayCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanRePayCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanRePayCompleteViewController ()

@end

@implementation SHBLoanRePayCompleteViewController

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

    self.title = @"대출조회/상환";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"대출상환 완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    self.contentScrollView.contentSize = CGSizeMake(314, 414);
    
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
    [NSString stringWithFormat:@"%@원", self.data[@"거래후출금계좌잔액"]]
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
