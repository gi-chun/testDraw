//
//  SHBCardAgreeViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardAgreeViewController.h"
#import "SHBCardService.h" // 서비스

#import "SHBWebViewConfirmViewController.h" // webView
#import "SHBCardAgreeSecurityViewController.h" // 신한카드 서비스 이용동의 보안카드, OTP

@interface SHBCardAgreeViewController ()

/// Notification 등록
- (void)initNotification;

@end

@implementation SHBCardAgreeViewController
{
    BOOL _isInfoSee; // 신한카드 서비스 이용동의 확인 여부
}

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
    
    [self initNotification];
    
    [self setTitle:@"신한카드"];
    self.strBackButtonTitle = @"신한카드 서비스 이용동의 안내";
    
    _isInfoSee = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_agreeCheck release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAgreeCheck:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)cardAgreeSecurityCancel
{
    [self initNotification];
    
    _isInfoSee = NO;
    
    [_agreeCheck setSelected:NO];
    
    [self.navigationController fadePopViewController];
}

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    _isInfoSee = NO;
    
    [_agreeCheck setSelected:NO];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

#pragma mark - 

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 보안매체 입력 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardAgreeSecurityCancel)
                                                 name:@"cardAgreeSecurityCancel"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

#pragma mark - Button
/// 보기
- (IBAction)infoBtn:(UIButton *)sender
{
    _isInfoSee = YES;
    
    SHBWebViewConfirmViewController *viewController = [[[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil] autorelease];
    
     if (!AppInfo.realServer) {
         [viewController executeWithTitle:@"신한카드" SubTitle:@"신한카드 서비스 이용동의" RequestURL:[NSString stringWithFormat:@"%@/sbank/prod/s_yak_scard.html", URL_IMAGE_TEST]];
     }
     else{
         [viewController executeWithTitle:@"신한카드" SubTitle:@"신한카드 서비스 이용동의" RequestURL:[NSString stringWithFormat:@"%@/sbank/prod/s_yak_scard.html", URL_IMAGE]];
     }
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 예, 동의합니다.
- (IBAction)checkBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    if (!_isInfoSee) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신한카드 서비스 이용동의를 읽고 확인버튼을 선택하여 주십시오."];
        return;
    }
    
    if (![_agreeCheck isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"서비스 이용에 동의하셔야 신한카드 메뉴를 이용하실 수 있습니다."];
        return;
    }
    
    SHBCardAgreeSecurityViewController *viewController = [[[SHBCardAgreeSecurityViewController alloc] initWithNibName:@"SHBCardAgreeSecurityViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopToRootViewController];
}

@end
