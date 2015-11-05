//
//  SHBELD_BA17_10ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_10ViewController.h"
#import "SHBGoodsSubTitleView.h"

#import "SHBELD_BA17_11ViewController.h"
#import "SHB_GoldTech_ManualViewController.h"

@interface SHBELD_BA17_10ViewController ()

@end

@implementation SHBELD_BA17_10ViewController

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
    
    // 골드상품
    if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
        
        self.strBackButtonTitle = @"투자자 유형보다 위험도가 높은 금융투자상품";
    }
    else {
        
        self.strBackButtonTitle = @"투자자 유형보다 위험도가 높은 금융투자상품(투자자정보 확인서 작성) 선택시 확인서";
    }
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:self.strBackButtonTitle maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    [_contentLabel initFrame:_contentLabel.frame];
    [_contentLabel setText:@"<midBoldGray_13>투자자 유형보다 위험도가 높은 금융투자상품 선택\n </midBoldGray_13><midGray_13>본인의 투자자성향보다 위험도가 높은 금융투자상품임에도 불구하고, 신한은행으로부터 투자 권유를 받지 않고 본인의 판단에 따라 투자를 하고자 하며,</midGray_13> <midLightBlue_13>해당 금융투자상품 계좌의 추가매수 등 모든 거래에 있어서 본인의 자발적인 의사에 따라 투자한다는 사실에 동의합니다.</midLightBlue_13> <midGray_13>또한, 신한은행으로부터 해당 금융투자상품에 대한 투자의 위험성을 고지 받았음을 확인합니다.</midGray_13>"]; // 270
    
    // 골드상품
    if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
        
        [_goldInfoView setHidden:NO];
        
        [_goldInfoLabel initFrame:_contentLabel.frame];
        [_goldInfoLabel setText:@"<midBoldGray_13>위험도가 높은 파생결합증권 상품 선택\n </midBoldGray_13><midGray_13>해당 파생결합증권(골드리슈 포함)의 투자위험정도가 본인의 연령 및 파생상품 투자경험 등에 비해 높아 본인에게 부적합하므로 신한은행이 투자권유를 할 수 없다는 점을 알고 있으며, 그럼에도 본인의 판단과 책임으로 투자를 하고자 하며, 상기 투자가 본인의 소신으로 결정된 것으로서 이와 관련하여 발생할 수 있는 모든 위험은 본인이 감수할 것임을 확인합니다. 또한</midGray_13> <midLightBlue_13>해당 금융상품 계좌의 추가 매입 등 모든 거래에 있어서 본인의 자발적인 의사에 따라 투자한다는 사실에 동의합니다.</midLightBlue_13> <midGray_13>해당 파생결합증권에 대한 투자의 위험성을 고지 받았음을 확인합니다.</midGray_13>"];
    }
    else {
        
        [_goldInfoView setHidden:YES];
        
        FrameResize(_contentView, width(_contentView), height(_contentView) - height(_goldInfoView));
    }
    
    [self.contentScrollView addSubview:_contentView];
    [self.contentScrollView setContentSize:_contentView.frame.size];
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
    [_goldInfoView release];
    [_goldInfoLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAgree:nil];
    [self setContentLabel:nil];
    [self setContentView:nil];
    [self setGoldInfoView:nil];
    [self setGoldInfoLabel:nil];
    [super viewDidUnload];
}

@end
