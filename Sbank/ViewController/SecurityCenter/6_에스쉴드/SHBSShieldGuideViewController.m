//
//  SHBSShieldGuideViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSShieldGuideViewController.h"
#import "SHBSShieldSetViewController.h"

@interface SHBSShieldGuideViewController ()
{
    int processStep;
}
@end

@implementation SHBSShieldGuideViewController
@synthesize mainView;
@synthesize myView;
- (void)dealloc
{
    //[_encryptSsn release];
    //[_ssnPwdTextField release];
    [mainView release];
    [myView release];
    [_confirmBtn release];
    [_shbDayMaxCnt release];
    [_shbDayAvgCnt release];
    [_shbNightMaxCnt release];
    [_shbNightAvgCnt release];
    [_shbSatDayMaxCnt release];
    [_shbSatDayAvgCnt release];
    [_shbSatNightMaxCnt release];
    [_shbSatNightAvgCnt release];
    [_shbSunDayMaxCnt release];
    [_shbSunDayAvgCnt release];
    [_shbSunNightMaxCnt release];
    [_shbSunNightAvgCnt release];
    [_myDayMaxCnt release];
    [_myDayAvgCnt release];
    [_myNightMaxCnt release];
    [_myNightAvgCnt release];
    [_mySatDayMaxCnt release];
    [_mySatDayAvgCnt release];
    [_mySatNightMaxCnt release];
    [_mySatNightAvgCnt release];
    [_mySunDayMaxCnt release];
    [_mySunDayAvgCnt release];
    [_mySunNightMaxCnt release];
    [_mySunNightAvgCnt release];
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
    
    //NSLog(@"AppInfo.userInfo:%@",AppInfo.userInfo);
    [self setTitle:@"S-Shield "];
    self.strBackButtonTitle = @"에스쉴드";
    
    [self.contentScrollView addSubview:self.mainView];
    [self.contentScrollView setContentSize:self.mainView.frame.size];
    
    processStep = 1;
    NSDictionary *forwardDic =
    @{
      
      };
    
    SendData(SHBTRTypeServiceCode, @"E7010", SERVICE_URL, self, forwardDic);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirmClick:(id)sender
{
    SHBSShieldSetViewController *viewController = [[SHBSShieldSetViewController alloc]initWithNibName:@"SHBSShieldSetViewController" bundle:nil];
    viewController.data = self.data;
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}

//#pragma mark - SHBSecureDelegate
//
//- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
//{
//    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
//    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
//    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
//    self.encryptSsn = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
//}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client:(OFHTTPClient *)aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    self.data = aDataSet;
    if (processStep == 1)
    {

        if ([aDataSet[@"상태"] isEqualToString:@"1"])
        {
            
            self.myView.hidden = NO;
            [self.confirmBtn setTitle:@"S-Shield 변경" forState:UIControlStateNormal];
            
            if ([aDataSet[@"평일주간이체가능건수"] length] > 0)
            {
                self.shbDayMaxCnt.text = aDataSet[@"평일주간이체가능건수"];
            }
            
            if ([aDataSet[@"평일야간이체가능건수"] length] > 0)
            {
                self.shbNightMaxCnt.text = aDataSet[@"평일야간이체가능건수"];
            }
            
            
            if ([aDataSet[@"토요일주간이체가능건수"] length] > 0)
            {
                self.shbSatDayMaxCnt.text = aDataSet[@"토요일주간이체가능건수"];
            }
            
            if ([aDataSet[@"토요일야간이체가능건수"] length] > 0)
            {
                self.shbSatNightMaxCnt.text = aDataSet[@"토요일야간이체가능건수"];
            }
            
            
            if ([aDataSet[@"일요일주간이체가능건수"] length] > 0)
            {
                self.shbSunDayMaxCnt.text = aDataSet[@"일요일주간이체가능건수"];
            }
            
            if ([aDataSet[@"일요일야간이체가능건수"] length] > 0)
            {
                self.shbSunNightMaxCnt.text = aDataSet[@"일요일야간이체가능건수"];
            }
            
            AppInfo.commonDic = nil;
            
            AppInfo.commonDic = @{
                                  @"평일주간이체가능건수" : ([aDataSet[@"평일주간이체가능건수"] length] > 0) ? aDataSet[@"평일주간이체가능건수"] : @"",
                                  @"평일야간이체가능건수" : ([aDataSet[@"평일야간이체가능건수"] length] > 0) ? aDataSet[@"평일야간이체가능건수"] : @"",
                                  @"토요일주간이체가능건수" : ([aDataSet[@"토요일주간이체가능건수"] length] > 0) ? aDataSet[@"토요일주간이체가능건수"] : @"",
                                  @"토요일야간이체가능건수" : ([aDataSet[@"토요일야간이체가능건수"] length] > 0) ? aDataSet[@"토요일야간이체가능건수"] : @"",
                                  @"일요일주간이체가능건수" : ([aDataSet[@"일요일주간이체가능건수"] length] > 0) ? aDataSet[@"일요일주간이체가능건수"] : @"",
                                  @"일요일야간이체가능건수" : ([aDataSet[@"일요일야간이체가능건수"] length] > 0) ? aDataSet[@"일요일야간이체가능건수"] : @"",
                                  };
            
        }else
        {
            self.myView.hidden = YES;
            [self.confirmBtn setTitle:@"S-Shield 설정" forState:UIControlStateNormal];
            [self.mainView setFrame:CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, 772)];
            [self.contentScrollView setContentSize:self.mainView.frame.size];
            [self.confirmBtn setFrame:CGRectMake(self.confirmBtn.frame.origin.x, 723, self.confirmBtn.frame.size.width, self.confirmBtn.frame.size.height)];
            
            AppInfo.commonDic = nil;
            
            AppInfo.commonDic = @{
                                  @"평일주간이체가능건수" : @"",
                                  @"평일야간이체가능건수" : @"",
                                  @"토요일주간이체가능건수" : @"",
                                  @"토요일야간이체가능건수" : @"",
                                  @"일요일주간이체가능건수" : @"",
                                  @"일요일야간이체가능건수" : @"",
                                  };
        }
        
        if ([aDataSet[@"평일주간최대건수"] length] > 0)
        {
            self.myDayMaxCnt.text = aDataSet[@"평일주간최대건수"];
        }
        if ([aDataSet[@"평일주간평균건수"] length] > 0)
        {
            self.myDayAvgCnt.text = aDataSet[@"평일주간평균건수"];
        }
        if ([aDataSet[@"평일야간최대건수"] length] > 0)
        {
            self.myNightMaxCnt.text = aDataSet[@"평일야간최대건수"];
        }
        if ([aDataSet[@"평일야간평균건수"] length] > 0)
        {
            self.myNightAvgCnt.text = aDataSet[@"평일야간평균건수"];
        }
        
        if ([aDataSet[@"토요일주간최대건수"] length] > 0)
        {
            self.mySatDayMaxCnt.text = aDataSet[@"토요일주간최대건수"];
        }
        if ([aDataSet[@"토요일주간평균건수"] length] > 0)
        {
            self.mySatDayAvgCnt.text = aDataSet[@"토요일주간평균건수"];
        }
        if ([aDataSet[@"토요일야간최대건수"] length] > 0)
        {
            self.mySatNightMaxCnt.text = aDataSet[@"토요일야간최대건수"];
        }
        if ([aDataSet[@"토요일야간평균건수"] length] > 0)
        {
            self.mySatNightAvgCnt.text = aDataSet[@"토요일야간평균건수"];
        }
        
        if ([aDataSet[@"일요일주간최대건수"] length] > 0)
        {
            self.mySunDayMaxCnt.text = aDataSet[@"일요일주간최대건수"];
        }
        if ([aDataSet[@"일요일주간평균건수"] length] > 0)
        {
            self.mySunDayAvgCnt.text = aDataSet[@"일요일주간평균건수"];
        }
        if ([aDataSet[@"일요일야간최대건수"] length] > 0)
        {
            self.mySunNightMaxCnt.text = aDataSet[@"일요일야간최대건수"];
        }
        if ([aDataSet[@"일요일야간평균건수"] length] > 0)
        {
            self.mySunNightAvgCnt.text = aDataSet[@"일요일야간평균건수"];
        }
        
        
    }
}
@end
