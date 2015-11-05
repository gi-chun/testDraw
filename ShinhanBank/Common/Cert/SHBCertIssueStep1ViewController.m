//
//  SHBCertIssueStep1ViewController.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep1ViewController.h"
#import "SHBCertIssueViewController.h"
#import "SHBCertIssueStep2ViewController.h"
#import "SHBWebViewConfirmViewController.h"

@interface SHBCertIssueStep1ViewController ()
{
    int agreeClickCount;
    BOOL isYesTermsView;
    BOOL isBaseTermsView;
}
@end

@implementation SHBCertIssueStep1ViewController
@synthesize contentsLabel;
@synthesize agreeBtn;
@synthesize isFirstLoginSetting;

- (void) dealloc
{
    [agreeBtn release];
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
    
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
       self.title = @"Issue/ Reissue Digital Certificate";
       [self navigationBackButtonEnglish];
       //self.strBackButtonTitle = @"main menu";
    } else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書の発行・再発行";
        [self navigationBackButtonJapnes];
        
    }else
    {
       self.title = @"인증서 발급/재발급";
       self.strBackButtonTitle = @"인증서 발급/재발급 1단계";
       contentsLabel.text = @"Yessign 이용약관 / Yessign 공인인증서 발급에 따른\n개인정보 수집 및 이용동의 / Yessign 공인인증서 발급에\n따른 개인정보 제3자 제공에 대한 동의 / 전자금융거래\n기본약관 / 신한온라인 서비스 기본약관에 동의하고\n스마트기기로 이용하는 인터넷뱅킹 서비스 및 공인인증서\n서비스를 신청하시겠습니까?";
    }
    
    // Do any additional setup after loading the view from its nib.
    
    
    agreeClickCount = 0;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initField) name:@"cancelBtnClick" object:nil];
}
-(void) initField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    agreeClickCount = 0;
    isYesTermsView = NO;
    isBaseTermsView = NO;
    [agreeBtn setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
}
- (void) viewDidUnload
{
    [super viewDidUnload];
    agreeClickCount = 0;
    isYesTermsView = NO;
    isBaseTermsView = NO;
    [agreeBtn setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) yesTermsClick:(id)sender  //yes 약과보기
{
    isYesTermsView = YES;
    
    SHBWebViewConfirmViewController *viewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
    
    if(AppInfo.realServer)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" SubTitle:@"Issue / reissue terms" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_ysign_en.html"];
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [viewController executeWithTitle:@"電子証明書の発行・再発行" SubTitle:@"電子証明書発行・再発行規約" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_ysign_en.html"];
        }
        else
        {
            [viewController executeWithTitle:@"인증서 발급/재발급" SubTitle:@"인증서 발급/재발급 약관" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_ysign.html"];
        }
    }
    else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" SubTitle:@"Issue / reissue terms" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_ysign_en.html"];
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [viewController executeWithTitle:@"電子証明書の発行・再発行" SubTitle:@"電子証明書発行・再発行規約" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_ysign_en.html"];
        }
        else
        {
            [viewController executeWithTitle:@"인증서 발급/재발급" SubTitle:@"인증서 발급/재발급 약관" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_ysign.html"];
        }
    }
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
    
}
- (IBAction) elecBaseTermsClick:(id)sender //전자금융 기본 약관
{
    isBaseTermsView = YES;
//    SHBCertIssueViewController *viewController = [[SHBCertIssueViewController alloc] initWithNibName:@"SHBCertIssueViewController" bundle:nil];
//    viewController.connectURL = @"http://m2013.shinhan.com";
//    [self.navigationController pushFadeViewController:viewController];
//    [viewController release];
    
    SHBWebViewConfirmViewController *viewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
    
    if(AppInfo.realServer)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" SubTitle:@"Issue / reissue terms" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_elect_en.html"];
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [viewController executeWithTitle:@"電子証明書の発行・再発行" SubTitle:@"電子証明書発行・再発行規約" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_elect_en.html"];
        }
        else
        {
            [viewController executeWithTitle:@"인증서 발급/재발급" SubTitle:@"인증서 발급/재발급 약관" RequestURL:@"http://img.shinhan.com/sbank/prod/s_yak_elect.html"];
        }
    }
    else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" SubTitle:@"Issue / reissue terms" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_elect_en.html"];
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [viewController executeWithTitle:@"電子証明書の発行・再発行" SubTitle:@"電子証明書発行・再発行規約" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_elect_en.html"];
        }
        else
        {
            [viewController executeWithTitle:@"인증서 발급/재발급" SubTitle:@"인증서 발급/재발급 약관" RequestURL:@"http://imgdev.shinhan.com/sbank/prod/s_yak_elect.html"];
        }
    }
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

- (IBAction) confirmClick:(id)sender //확인
{
    NSString *msg;
    if (!isYesTermsView)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please review and confirm that you fully understand by clicking the \"Confirm\" button.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"Yessign利用規約/Yessign電子証明書発行に関する個人情報収集及び利用同意/「Yessign電子証明書発行に関する個人情報第３者提供に同意」をお読みの上、確認ボタンを選択してください。";
        }
        else
        {
            msg = @"Yessign 이용약관, Yessig 공인인증서 발급에 따른 개인정보수집 및 이용동의, Yessign 공인인증서 발급에 따른 개인정보 제 3자 제공에 대한 동의를 읽고 확인 버튼을 선택하시기 바랍니다.";
        }
        
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if (!isBaseTermsView)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please reveiw the General Terms and Conditions of Shinhan Online Services, and General Terms and Conditions of electronic financial transactions and click the \"Confirm\" button.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"電子金融取引の基本規約、新韓オンラインサービス基本規約をお読みの上、確認ボタンを選択してください。";
        }
        else
        {
            msg = @"전자금융거래 기본약관, 신한온라인서비스 기본약관을 읽고 확인 버튼을 선택하시기 바랍니다.";
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if (agreeClickCount %2 == 0)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Must agree to the Terms of Use.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"Must agree to the Terms of Use.";
        }else
        {
            msg = @"약관에 동의하셔야 사용이 가능합니다.";
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        SHBCertIssueStep2ViewController *viewController = [[SHBCertIssueStep2ViewController alloc] initWithNibName:@"SHBCertIssueStep2ViewControllerEng" bundle:nil];
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    } else if (AppInfo.LanguageProcessType == JapanLan)
    {
        SHBCertIssueStep2ViewController *viewController = [[SHBCertIssueStep2ViewController alloc] initWithNibName:@"SHBCertIssueStep2ViewControllerJpn" bundle:nil];
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    } else
    {
        SHBCertIssueStep2ViewController *viewController = [[SHBCertIssueStep2ViewController alloc] initWithNibName:@"SHBCertIssueStep2ViewController" bundle:nil];
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    
    
    
    
}
- (IBAction) cancelClick:(id)sender //취소
{
    [self.navigationController fadePopViewController];
}

- (IBAction) agreeClick:(id)sender //동의 클릭
{
    
    agreeClickCount++;
    
    if (agreeClickCount % 2 == 1)
    {
        //[agreeBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
    } else
    {
        //[agreeBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction) testClick:(id)sender
{
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"attributeNamed" : @"mode",
                           @"attributeValue" : @"ECHO",
                           }];
    
    dataSet.serviceCode = @"D3606";
    
    [self serviceRequest:dataSet];
}
@end
