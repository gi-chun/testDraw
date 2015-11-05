//
//  SHBGoldPaymentInfoViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldPaymentInfoViewController.h"
#import "SHBGoldPaymentInputViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBGoldPaymentInfoViewController ()
{
    IBOutlet UIView *contentsView;
    IBOutlet UIView *view187;
    IBOutlet UIView *view188;
}
@property (nonatomic, retain) UIView *contentsView;
@property (nonatomic, retain) UIView *view187;
@property (nonatomic, retain) UIView *view188;
@end

@implementation SHBGoldPaymentInfoViewController
@synthesize accountInfo;
@synthesize contentsView;
@synthesize view187;
@synthesize view188;

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

    self.title = @"골드출금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드출금안내" maxStep:4 focusStepNumber:1] autorelease]];
    
    if([accountInfo[@"계좌번호"] hasPrefix:@"187"]){
        view187.frame = CGRectMake(0, 0, 317, 410);
        contentsView.frame = CGRectMake(0, 0, 320, 410 + 61);
        [contentsView addSubview:view187];
        self.contentScrollView.contentSize = CGSizeMake(317, 410 + 61);
    }else{
        
        view188.frame = CGRectMake(0, 0, 317, 517);
        contentsView.frame = CGRectMake(0, 0, 320, 517 + 61);
        [contentsView addSubview:view188];
        self.contentScrollView.contentSize = CGSizeMake(317, 517 + 61);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 20403:{
            SHBGoldPaymentInputViewController *nextViewController = [[[SHBGoldPaymentInputViewController alloc] initWithNibName:@"SHBGoldPaymentInputViewController" bundle:nil] autorelease];
            nextViewController.accountInfo = self.accountInfo;
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 20404:{
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

@end
