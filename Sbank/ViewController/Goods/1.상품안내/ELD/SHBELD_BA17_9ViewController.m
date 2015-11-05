//
//  SHBELD_BA17_9ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_9ViewController.h"
#import "SHBGoodsSubTitleView.h"

#import "SHBELD_BA17_11ViewController.h"
#import "SHB_GoldTech_ManualViewController.h"

@interface SHBELD_BA17_9ViewController ()

@end

@implementation SHBELD_BA17_9ViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
            // 확인
            
            if (![_agree isSelected]) {
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:nil message:@"투자자 확인서 내용에 동의하셔야 합니다."];
                
                return;
            }
            
            // 골드상품
            if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                
                SHB_GoldTech_ManualViewController *viewController = [[[SHB_GoldTech_ManualViewController alloc] initWithNibName:@"SHB_GoldTech_ManualViewController" bundle:nil] autorelease];
                
                viewController.dicSelectedData = self.viewDataSource;
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
                
                return;
            }
            
            // BA17-11로 이동
            SHBELD_BA17_11ViewController *viewController = [[[SHBELD_BA17_11ViewController alloc] initWithNibName:@"SHBELD_BA17_11ViewController" bundle:nil] autorelease];
            
            viewController.viewDataSource = _viewDataSource;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            break;
        case 1:
            // 취소
            [self.navigationController fadePopViewController];
            
            break;
        case 2:
            // 체크박스
            sender.selected = !sender.selected;
            
            break;

        default:
            break;
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"예금/적금 가입"]; // 타이틀
    self.strBackButtonTitle = @"고객투자성향분석(투자자 정보 확인서 작성) 생략시 확인서";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:self.strBackButtonTitle maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    CGFloat height = _contentLabel.frame.size.height;
    
    [_contentLabel initFrame:_contentLabel.frame];
    [_contentLabel setText:@"<midBoldGray_13>고객투자성향분석(투자자 정보 확인서 작성) 생략시 확인서</midBoldGray_13>\n<midGray_13>본인은 투자권유에 필요한 투자자정보를 제공하지 않는 경우, 신한은행은 본인에게 적합한 상품을 투자권유 할 수 없고 신한은행으로부터 보호를 받을 수 없으며 관련 법령에 따라 파생상품 등의 거래가 제한될 수 있다는 점을 통지 받았음에도 불구하고, 신한은행이 제시한 투자권유절차 및 투자자 정보 파악 절차를 거부하고 본인이 지정하는 금융투자상품을 매수하고자 합니다.</midGray_13> <midLightBlue_13>이 경우 자본시장법 제46조 제2항(투자자정보 파악) 및 제3항(적합성 원칙)에 따른 의무를 신한은행이 부담하지 아니하며, 원금 손실 가능성 및 투자에 따른 손익은 모두 본인에게 귀속됨을 확인합니다.</midLightBlue_13> <midGray_13>또한 신한은행으로부터 해당 금융투자상품에 대한 투자의 위험성을 고지 받았음을 확인합니다.</midGray_13>"];
    
    height -= _contentLabel.frame.size.height - 20;
    
    CGRect frame = _contentView.frame;
    
    frame.size.height -= height;
    
    [_contentView setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.viewDataSource = nil;
    
    [_agree release];
    [_contentLabel release];
    [_contentView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAgree:nil];
    [self setContentLabel:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}
@end
