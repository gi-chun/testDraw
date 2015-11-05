//
//  SHBSShieldSetViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSShieldSetViewController.h"
#import "SHBIdentity4ViewController.h"

#import "SHBSShieldSecuremediaViewController.h"

@interface SHBSShieldSetViewController ()

@end

@implementation SHBSShieldSetViewController
@synthesize mainView;


- (void)dealloc
{
    [_dayCntTextField release];
    [_nightCntTextField release];
    [_satCntTextField release];
    [_satNightCntTextField release];
    [_sunCntTextField release];
    [_sunNightCntTextField release];
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
    
    [self setTitle:@"S-Shield "];
    self.strBackButtonTitle = @"에스쉴드";
    
    startTextFieldTag = 1000;
    endTextFieldTag = 1005;
    [self.contentScrollView addSubview:self.mainView];
    [self.contentScrollView setContentSize:self.mainView.frame.size];
    
    contentViewHeight = self.contentScrollView.frame.size.height;
    
    self.dayCntTextField.text = AppInfo.commonDic[@"평일주간이체가능건수"];
    self.nightCntTextField.text = AppInfo.commonDic[@"평일야간이체가능건수"];
    self.satCntTextField.text = AppInfo.commonDic[@"토요일주간이체가능건수"];
    self.satNightCntTextField.text = AppInfo.commonDic[@"토요일야간이체가능건수"];
    self.sunCntTextField.text = AppInfo.commonDic[@"일요일주간이체가능건수"];
    self.sunNightCntTextField.text = AppInfo.commonDic[@"일요일야간이체가능건수"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cinfirmClick:(id)sender
{
    
    
    if ([self.dayCntTextField.text length] == 0 || [self.nightCntTextField.text length] == 0 || [self.satCntTextField.text length] == 0 || [self.satNightCntTextField.text length] == 0 || [self.sunCntTextField.text length] == 0 || [self.sunNightCntTextField.text length] == 0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"'이체건수'를 입력해 주십시오."];
        return;
    }
    
    //변경내역이 없는지 확인
    if ([self.data[@"상태"] isEqualToString:@"1"])
    {
        BOOL isChange = YES;
        if ([self.dayCntTextField.text isEqualToString:AppInfo.commonDic[@"평일주간이체가능건수"]] && [self.nightCntTextField.text isEqualToString:AppInfo.commonDic[@"평일야간이체가능건수"]] && [self.satCntTextField.text isEqualToString:AppInfo.commonDic[@"토요일주간이체가능건수"]] && [self.satNightCntTextField.text isEqualToString:AppInfo.commonDic[@"토요일야간이체가능건수"]] && [self.sunCntTextField.text isEqualToString:AppInfo.commonDic[@"일요일주간이체가능건수"]] && [self.sunNightCntTextField.text isEqualToString:AppInfo.commonDic[@"일요일야간이체가능건수"]])
        {
            isChange = NO;
        }
        
        if (!isChange)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"변경내역이 없습니다.\nS-Shield 이체 가능건수를\n확인하시기 바랍니다."];
            return;
        }
    }
    
    AppInfo.commonDic = nil;
    
    AppInfo.commonDic = @{
                          @"평일주간이체가능건수" : ([self.dayCntTextField.text length] > 0) ? self.dayCntTextField.text : @"",
            @"평일야간이체가능건수" : ([self.nightCntTextField.text length] > 0) ? self.nightCntTextField.text : @"",
            @"토요일주간이체가능건수" : ([self.satCntTextField.text length] > 0) ? self.satCntTextField.text : @"",
            @"토요일야간이체가능건수" : ([self.satNightCntTextField.text length] > 0) ? self.satNightCntTextField.text : @"",
            @"일요일주간이체가능건수" : ([self.sunCntTextField.text length] > 0) ? self.sunCntTextField.text : @"",
            @"일요일야간이체가능건수" : ([self.sunNightCntTextField.text length] > 0) ? self.sunNightCntTextField.text : @"",
            };
    
    
    
    SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
    [viewController setServiceSeq:SERVICE_SSHIELD];
    viewController.needsLogin = YES;
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
    [viewController executeWithTitle:@"S-Shield" Step:2 StepCnt:5 NextControllerName:@"SHBSShieldSecuremediaViewController"];
    [viewController subTitle:@"ARS 인증"];
    [viewController release];
     
    /*
    SHBSShieldSecuremediaViewController *viewController = [[SHBSShieldSecuremediaViewController alloc]initWithNibName:@"SHBSShieldSecuremediaViewController" bundle:nil];
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
    */
}

- (IBAction)cancelClick:(id)sender
{
    [AppDelegate.navigationController fadePopViewController];
}

#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.text length] == 5 && range.length == 0)
    {
        return NO;
    }
    return YES;
}


@end
