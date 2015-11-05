//
//  SHBGoldDepositInfoViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 1..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldDepositInfoViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBGoldDepositInputViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBGoldDepositInfoViewController ()
{
    IBOutlet UIView *contentsView;
    IBOutlet UIView *view186;
    IBOutlet UIView *view188;
    
    BOOL isRead3; // 설명확인서 보기
}
@property (nonatomic, retain) UIView *contentsView;
@property (nonatomic, retain) UIView *view186;
@property (nonatomic, retain) UIView *view188;
@end

@implementation SHBGoldDepositInfoViewController
@synthesize accountInfo;
@synthesize contentsView;
@synthesize view186;
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

    if([accountInfo[@"계좌번호"] hasPrefix:@"186"] || [accountInfo[@"계좌번호"] hasPrefix:@"187"]){
        if([accountInfo[@"계좌번호"] hasPrefix:@"186"]){
            self.title = @"골드적립";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드적립안내" maxStep:4 focusStepNumber:1] autorelease]];
        }else{
            self.title = @"골드입금";
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금안내" maxStep:4 focusStepNumber:1] autorelease]];
        }
        view186.frame = CGRectMake(0, 0, 317, 331);
        contentsView.frame = CGRectMake(0, 0, 320, 543);
        [contentsView addSubview:view186];
        self.contentScrollView.contentSize = CGSizeMake(317, 543);
    }else{
        self.title = @"골드입금";
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금안내" maxStep:4 focusStepNumber:1] autorelease]];
        
        view188.frame = CGRectMake(0, 0, 317, 393);
        contentsView.frame = CGRectMake(0, 0, 320, 605);
        [contentsView addSubview:view188];
        self.contentScrollView.contentSize = CGSizeMake(317, 605);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSString *server = @"";
    
    if (AppInfo.realServer) {
        
        server = URL_IMAGE;
    }
    else {
        
        server = URL_IMAGE_TEST;
    }
    
    switch (sender.tag) {
        case 20401:{
            SHBWebViewConfirmViewController *nextViewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];
            [nextViewController executeWithTitle:@"투자설명서" SubTitle:@"" RequestURL:[NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol1.pdf", server, accountInfo[@"상품코드"]]];
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 20402:{
            SHBWebViewConfirmViewController *nextViewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];
            [nextViewController executeWithTitle:@"간이 투자설명서" SubTitle:@"" RequestURL:[NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol2.pdf", server, accountInfo[@"상품코드"]]];
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 20403:{
            

            if (!isRead3) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"설명확인서 보기를 읽고 확인을 선택하시기 바랍니다."];
                
                return;
            }

            
            
            SHBGoldDepositInputViewController *nextViewController = [[[SHBGoldDepositInputViewController alloc] initWithNibName:@"SHBGoldDepositInputViewController" bundle:nil] autorelease];
            nextViewController.inAccInfoDic = self.accountInfo;
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }
            break;
        case 20404:{
            [self.navigationController fadePopViewController];
        }
            break;
            
        case 20405:{  //설명확인서 보기
            
            isRead3 = YES;
            SHBWebViewConfirmViewController *nextViewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];
            
            NSString *URL = @"";
            
            if (AppInfo.realServer) {
                URL = [NSString stringWithFormat:@"http://img.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
            }
            else {
                URL = [NSString stringWithFormat:@"http://imgdev.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
            }

            [nextViewController executeWithTitle:@"설명확인서" SubTitle:@"" RequestURL:[NSString stringWithFormat:@"%@",URL]];
            [self checkLoginBeforePushViewController:nextViewController animated:YES];
        }

            
        default:
            break;
    }
}

@end
