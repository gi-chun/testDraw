//
//  SHBCardSSOAgreeViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 17..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBCardSSOAgreeViewController.h"
#import "SHBCardSSOAgreeContentsViewController.h"
#import "SHBCardSSOAgreeSecurityViewController.h"

@interface SHBCardSSOAgreeViewController ()

- (void)initNotification;
@end

@implementation SHBCardSSOAgreeViewController
@synthesize isInfoSee;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"신한카드"];
    self.strBackButtonTitle = @"신한카드 서비스 이용동의 안내";
    
    self.isInfoSee = NO;
}
- (void)viewDidUnload
{
    [self setAgreeCheck:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Center

- (void)cardAgreeSecurityCancel
{
    [self initNotification];
    
    self.isInfoSee = NO;
    
    [_agreeCheck setSelected:NO];
    
    [self.navigationController fadePopViewController];
}

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    self.isInfoSee = NO;
    
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

-(void)setagreeValue:(BOOL)agreeValue
{
    self.isInfoSee = agreeValue;
}
#pragma mark - Button
/// 보기
- (IBAction)infoBtn:(UIButton *)sender
{
    self.isInfoSee = YES;
    SHBCardSSOAgreeContentsViewController *viewController = [[SHBCardSSOAgreeContentsViewController alloc] initWithNibName:@"SHBCardSSOAgreeContentsViewController" bundle:nil];
    //viewController.superViewController = self;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
}

/// 예, 동의합니다.
- (IBAction)checkBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    if (!self.isInfoSee) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신한카드 서비스 이용동의를 읽고\n확인버튼을 선택하여 주십시오."];
        return;
    }
    
    if (![_agreeCheck isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"서비스 이용에 동의하셔야 신한카드\n메뉴를 이용하실 수 있습니다."];
        return;
    }
    
    SHBCardSSOAgreeSecurityViewController *viewController = [[[SHBCardSSOAgreeSecurityViewController alloc] initWithNibName:@"SHBCardSSOAgreeSecurityViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopViewController];
}
@end
