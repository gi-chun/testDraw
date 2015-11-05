//
//  SHBSmithingFinishViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingFinishViewController.h"
#import "SHBSmithingDeviceQueryDelViewController.h"

@interface SHBSmithingFinishViewController ()

@end

@implementation SHBSmithingFinishViewController
@synthesize askDate;
@synthesize phoneNumber;
@synthesize phoneModel;
@synthesize askType;
@synthesize subMsg;
@synthesize askDateLabel;
@synthesize mainMsg;
@synthesize btn;

- (void)dealloc
{
    [btn release];
    [mainMsg release];
    [askDateLabel release];
    [subMsg release];
    [askDate release];
    [phoneNumber release];
    [phoneModel release];
    [askType release];
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
    [self navigationBackButtonHidden];
    if (AppInfo.smithingType == 1)
    {
        [self setTitle:@"안심거래 서비스 신청"];
        self.strBackButtonTitle = @"안심거래 서비스 신청";
        
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        self.askDate.text = AppInfo.tran_Date;
        //self.phoneNumber.text = number;
        self.phoneNumber.text = @"정보없음";
        self.phoneModel.text = [SHBUtilFile getModel];
        self.askType.text = @"신한S뱅크에서 신청";
        
    }else if (AppInfo.smithingType == 2)
    {
        [self setTitle:@"안심거래 서비스 기기 등록"];
        self.strBackButtonTitle = @"안심거래 서비스 기기등록";
        self.mainMsg.text = @"기기 등록 완료"; 
        self.subMsg.text = @"다음과 같이 안심거래 서비스 기기가 등록되었습니다.";
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        self.askDate.text = AppInfo.tran_Date;
        //self.phoneNumber.text = number;
        self.phoneNumber.text = @"정보없음";
        self.phoneModel.text = [SHBUtilFile getModel];
        self.askType.text = @"영업점에서 신청";
        
        [self.view viewWithTag:3].hidden = YES;
        [self.view viewWithTag:4].hidden = YES;
        [self.view viewWithTag:5].hidden = YES;
        [self.view viewWithTag:6].hidden = YES;
        UILabel *step3label = (UILabel*)[self.view viewWithTag:8];
        step3label.text = @"1";
        UILabel *step4label = (UILabel*)[self.view viewWithTag:10];
        step4label.text = @"2";
        UILabel *step5label = (UILabel*)[self.view viewWithTag:12];
        step5label.text = @"3";
        
        [[self.view viewWithTag:13] setFrame:CGRectMake([self.view viewWithTag:13].frame.origin.x, [self.view viewWithTag:13].frame.origin.y, [self.view viewWithTag:13].frame.size.width, 83)];
        [self.view viewWithTag:18].hidden = YES;
        [self.view viewWithTag:19].hidden = YES;
        
    }else if (AppInfo.smithingType == 3)
    {
        [self setTitle:@"안심거래 서비스 기기 삭제"];
        self.strBackButtonTitle = @"안심거래 서비스 기기등록";
        self.mainMsg.text = @"기기 삭제 완료"; 
        self.subMsg.text = @"다음과 같이 안심거래 서비스 기기가 삭제되었습니다.";
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        self.askDate.text = AppInfo.tran_Date;
        //self.phoneNumber.text = number;
        if ([AppInfo.commonDic[@"PHONE_NO"] length] == 0)
        {
            self.phoneNumber.text = @"정보없음";
        }else
        {
            NSString *number = AppInfo.commonDic[@"PHONE_NO"];
            number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
            self.phoneNumber.text = number;
        }
        
        self.phoneModel.text = AppInfo.commonDic[@"PHONE_MODEL"];
        self.askType.text = @"영업점에서 신청";
        self.askDateLabel.text = @"삭제신청일";
        [self.view viewWithTag:1].hidden = YES;
        [self.view viewWithTag:2].hidden = YES;
        [self.view viewWithTag:3].hidden = YES;
        [self.view viewWithTag:4].hidden = YES;
        [self.view viewWithTag:5].hidden = YES;
        [self.view viewWithTag:6].hidden = YES;
        [self.view viewWithTag:7].hidden = YES;
        [self.view viewWithTag:8].hidden = YES;
        [self.view viewWithTag:9].hidden = YES;
        [self.view viewWithTag:10].hidden = YES;
        [self.view viewWithTag:11].hidden = YES;
        [self.view viewWithTag:12].hidden = YES;
        [self.view viewWithTag:13].hidden = YES;
        [self.view viewWithTag:14].hidden = YES;
        [self.view viewWithTag:15].hidden = YES;
        [self.view viewWithTag:16].hidden = YES;
        [self.view viewWithTag:17].hidden = YES;
        [self.view viewWithTag:18].hidden = YES;
        [self.view viewWithTag:19].hidden = YES;
        //[btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 40, btn.frame.size.width, btn.frame.size.height)];
        
    }else if (AppInfo.smithingType == 4)
    {
        [self setTitle:@"안심거래 서비스 해지"];
        self.strBackButtonTitle = @"안심거래 서비스 해지";
        self.mainMsg.text = @"서비스 해지 완료"; 
        self.subMsg.text = @"다음과 같이 안심거래 서비스가 해지되었습니다.";
        self.askDateLabel.text = @"해지일";
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        self.askDate.text = AppInfo.tran_Date;
        //self.phoneNumber.text = number;
        self.phoneNumber.text = @"정보없음";
        self.phoneModel.text = [SHBUtilFile getModel];
        self.askType.text = @"신한S뱅크에서 신청";
        
        [self.view viewWithTag:3].hidden = YES;
        [self.view viewWithTag:4].hidden = YES;
        
        UILabel *step2label = (UILabel*)[self.view viewWithTag:6];
        step2label.text = @"1";
        UILabel *step3label = (UILabel*)[self.view viewWithTag:8];
        step3label.text = @"2";
        UILabel *step4label = (UILabel*)[self.view viewWithTag:10];
        step4label.text = @"3";
        UILabel *step5label = (UILabel*)[self.view viewWithTag:12];
        step5label.text = @"4";
        
        [self.view viewWithTag:13].hidden = YES;
        [self.view viewWithTag:14].hidden = YES;
        [self.view viewWithTag:15].hidden = YES;
        [self.view viewWithTag:16].hidden = YES;
        [self.view viewWithTag:17].hidden = YES;
        [self.view viewWithTag:18].hidden = YES;
        [self.view viewWithTag:19].hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(id)sender
{
    //안심거래 초기화면으로 이동한다.
    if (AppInfo.smithingType == 1)
    {
        [AppInfo.userInfo setValue:@"1" forKey:@"안심거래가입여부"];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
    }if (AppInfo.smithingType == 2)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }if (AppInfo.smithingType == 3)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [(SHBSmithingDeviceQueryDelViewController*)(AppDelegate.navigationController.viewControllers[2]) performSelector:@selector(refreshDevice) withObject:nil afterDelay:0.05f];
        
    }if (AppInfo.smithingType == 4)
    {
        [AppInfo.userInfo setValue:@"4" forKey:@"안심거래가입여부"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"SMSNotiType"];
        [defaults setObject:@"" forKey:@"SMSNotiDate"];
        [defaults synchronize];
        NSLog(@"aaaa:%@",AppInfo.userInfo);
        //[AppDelegate.navigationController fadePopToRootViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
}
@end
