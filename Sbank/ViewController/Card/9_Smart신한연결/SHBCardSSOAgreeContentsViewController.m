//
//  SHBCardSSOAgreeContentsViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 17..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBCardSSOAgreeContentsViewController.h"
#import "SHBNewProductSeeStipulationViewController.h"
#import "SHBCardSSOAgreeViewController.h"
#import "SHBIdentity4ViewController.h"

@interface SHBCardSSOAgreeContentsViewController ()
{
    BOOL isSee;
    BOOL isAgree1;
    BOOL isAgree2;
    BOOL isAgree3;
}
@end

@implementation SHBCardSSOAgreeContentsViewController
@synthesize contents1View;
@synthesize contents2View;
//@synthesize superViewController;
@synthesize useEssentialCollection;
@synthesize useEssentialCollectionNone;
@synthesize usePersonalInfoAgree;
@synthesize useSSOAgree;
@synthesize noEssentialCollection;
@synthesize noEssentialCollectionNone;
@synthesize usePersonalInfoAgreeNone;
@synthesize contentsPView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [contentsPView release];
    [usePersonalInfoAgreeNone release];
    [noEssentialCollectionNone release];
    [useSSOAgree release];
    [useEssentialCollectionNone release];
    [noEssentialCollection release];
    [usePersonalInfoAgree release];
    [contents1View release];
    [contents2View release];
    //[superViewController release];
    [useEssentialCollection release];
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
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.usePersonalInfoAgreeNone = nil;
    self.noEssentialCollection = nil;
    self.noEssentialCollectionNone = nil;
    self.usePersonalInfoAgreeNone = nil;
    self.usePersonalInfoAgree = nil;
    self.contents1View = nil;
    self.contents2View = nil;
    //self.superViewController = nil;
    self.useEssentialCollection = nil;
    [super viewDidUnload];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
//        [self.contentScrollView sendSubviewToBack:self.view];
        [self.contentsPView setFrame:CGRectMake(self.contentsPView.frame.origin.x, self.contentsPView.frame.origin.y - 20, self.contentsPView.frame.size.width, self.contentsPView.frame.size.height)];
        [self.view sendSubviewToBack:self.contentsPView];
    }
    [self setTitle:@"신한카드"];
    self.strBackButtonTitle = @"신한카드 서비스 이용동의 안내";
    
    isSee = NO;
    isAgree1 = YES;
    isAgree2 = YES;
    isAgree3 = NO;
    
    // 보안매체 입력 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardAgreeSecurityCancel)
                                                 name:@"cardAgreeSecurityCancel"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardAgreeSecurityCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardAgreeSecurityCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
    
    [self.contentScrollView addSubview:self.contents1View];
    [self.contentScrollView addSubview:self.contents2View];
    [self.contents2View setFrame:CGRectMake(self.contents1View.frame.origin.x, self.contents1View.frame.size.height, self.contents2View.frame.size.width, self.contents2View.frame.size.height)];
    
    [self.contentScrollView setContentSize:CGSizeMake(317, self.contents1View.frame.size.height + self.contents2View.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)okBtn:(id)sender;
{
    if (!isAgree3)
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"신한카드 서비스 연동 이용에\n동의하셔야 합니다."];
        return;
    }
    
    if (!isSee)
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"개인(신용)정보 수집,이용,제공 동의서\n보기를 선택하여 확인하시기 바랍니다."];
        return;
    }
    
    if (!isAgree1)
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"1번 필수적 정보는 반드시\n동의하셔야 합니다."];
        return;
    }
    if (!isAgree2)
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"2번 고유식별정보는 반드시\n동의하셔야 합니다."];
        return;
    }
    if (isAgree1 && isAgree2 && isAgree3 && isSee)
    {
        //[superViewController setagreeValue:YES];
        //[(SHBCardSSOAgreeViewController*)(AppDelegate.navigationController.viewControllers[1]) setagreeValue:YES];
        AppInfo.smithingType = 10;
        SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
        [viewController setServiceSeq:SERVICE_CARDSSO_AGREE];
        viewController.needsLogin = YES;
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"신한카드" Step:2 StepCnt:5 NextControllerName:@"SHBCardSSOAgreeSecurityViewController"];
        [viewController subTitle:@"휴대폰 인증"];
        [viewController release];
    }
    
    //[AppDelegate.navigationController fadePopViewController];
}
-(IBAction)cancelBtn:(id)sender
{
    //superViewController.isInfoSee = NO;
    
    //[(SHBCardSSOAgreeViewController*)(AppDelegate.navigationController.viewControllers[1]) setagreeValue:NO];
    //[AppDelegate.navigationController fadePopToRootViewController];
    [AppDelegate.navigationController fadePopViewController];
}
- (IBAction)checkBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    if (sender == self.useEssentialCollection)
    {
        isAgree1 = YES;
        [self.useEssentialCollectionNone setSelected:NO];
    }else if (sender == self.useEssentialCollectionNone)
    {
        isAgree1 = NO;
        [self.useEssentialCollection setSelected:NO];
        
    }else if (sender == self.noEssentialCollection)
    {
        [self.noEssentialCollectionNone setSelected:NO];
    }else if (sender == self.noEssentialCollectionNone)
    {
        [self.noEssentialCollection setSelected:NO];
    }else if (sender == self.usePersonalInfoAgree)
    {
        isAgree2 = YES;
        [self.usePersonalInfoAgreeNone setSelected:NO];
    }else if (sender == self.usePersonalInfoAgreeNone)
    {
        isAgree2 = NO;
        [self.usePersonalInfoAgree setSelected:NO];
    }else if (sender == self.useSSOAgree)
    {
        if ([self.useSSOAgree isSelected])
        {
            isAgree3 = YES;
        }else
        {
            isAgree3 = NO;
        }
    }
}

-(IBAction)personalAgreeInfoBtn:(id)sender
{
    NSString *strUrl;
    isSee = YES;
    if (!AppInfo.realServer)
    {
        strUrl = [NSString stringWithFormat:@"%@pci_lending_03.html", URL_YAK_TEST];
    }
    else{
        strUrl = [NSString stringWithFormat:@"%@pci_lending_03.html", URL_YAK];
    }
    
    SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
    
    viewController.strUrl = strUrl;
    viewController.strName = @"스마트 신한 연동 신청";
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)cardAgreeSecurityCancel
{
    isSee = NO;
    isAgree1 = YES;
    isAgree2 = YES;
    isAgree3 = NO;
    [self.useSSOAgree setSelected:NO];
    [self.noEssentialCollection setSelected:NO];
    [self.noEssentialCollectionNone setSelected:YES];
    
}
@end
