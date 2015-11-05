//
//  SHBSmithingSecureMediaViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingSecureMediaViewController.h"
#import "SHBSecurityCenterService.h"

@interface SHBSmithingSecureMediaViewController ()

- (void)setSecretMediaView;

@end

@implementation SHBSmithingSecureMediaViewController
@synthesize deviceIndex;

- (void)dealloc
{
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
    if (AppInfo.smithingType == 1)
    {
        [self setTitle:@"안심거래 서비스 신청"];
        self.strBackButtonTitle = @"이체비밀번호 및 보안매체 입력";
    }else if (AppInfo.smithingType == 2)
    {
        [self setTitle:@"안심거래 서비스 기기등록"];
        self.strBackButtonTitle = @"안심거래 서비스 기기 등록";
        
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
        
    }else if (AppInfo.smithingType == 3)
    {
        [self setTitle:@"안심거래 서비스 기기 삭제"];
        self.strBackButtonTitle = @"안심거래 서비스 기기 삭제";
        
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
    }else if (AppInfo.smithingType == 4)
    {
        [self setTitle:@"안심거래 서비스 해지"];
        self.strBackButtonTitle = @"안심거래 서비스 해지";
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
        
    }
    
    
    [self setSecretMediaView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSecretMediaView
{
	//UIView *secretMediaView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
	//[self.contentScrollView addSubview:secretMediaView];
	
	NSInteger secutryType = [[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue];
    
    if (secutryType == 1 || secutryType == 2 || secutryType == 3 || secutryType == 4)
    {           //보안카드
        
        SHBSecretCardViewController *vc = [[[SHBSecretCardViewController alloc] init] autorelease];
        vc.targetViewController = self;
        [self.contentScrollView addSubview:vc.view];
        //[vc.view setFrame:CGRectMake(0, 100, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
        //[secretMediaView addSubview:vc.view];
        
        //[vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		//[secretMediaView setFrame:CGRectMake(0, 0, 317, vc.view.bounds.size.height)];
		
		vc.selfPosY = 0;
        [vc setMediaCode:secutryType previousData:nil];
        vc.delegate = self;
        
        if (AppInfo.smithingType == 1)
        {
            vc.nextSVC = @"E2811";
        }else if (AppInfo.smithingType == 2)
        {
            vc.nextSVC = @"E2812";
        }else if (AppInfo.smithingType == 3)
        {
            vc.nextSVC = @"E2813";
        }else if (AppInfo.smithingType == 4)
        {
            vc.nextSVC = @"E2814";
        }
        
        //self.cardViewController = vc;
		
		
    }
}

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    NSLog(@"smsinfo:%@",AppInfo.smsInfo);
    
    if (AppInfo.smithingType == 1)
    {
        //신청 전자서명문을 만든다
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"안심거래 서비스 신청";
        
        AppInfo.electronicSignCode = @"E2811";
        AppInfo.electronicSignTitle = @"다음과 같이 안심거래 서비스를 신청합니다.";
        
        
        //if (AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"] > 0)
        //{
            //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
            //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
            //NSLog(@"aaaa:%@",number);
            //NSLog(@"aaaa:%@",[SHBUtilFile getModel]);
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일: %@", AppInfo.tran_Date]];
            //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", number]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", @"정보없음"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)모델명: %@", [SHBUtilFile getModel]]];
            
            
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)구분: %@",@"신한S뱅크에서 신청"]];
                
        
        //}
        self.service = nil;
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E2811_SERVICE viewController:self] autorelease];
        SHBDataSet *dataSet = [[SHBDataSet dictionaryWithDictionary:@{
                                @"CUSNO" : AppInfo.customerNo,
                                @"DEVICE_ID" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"MASTER_YN" : @"Y",
                                @"PHONE_NO" : @"",
                                @"PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                                @"PHONE_MODEL" : [SHBUtilFile getModel],
                                @"NICK_NAME" : @"",
                                @"ETC1" : @"IN",
                                @"ETC2" : @"",
                                @"ETC3" : @"",
                                @"ETC4" : @"",
                                @"ETC5" : @"",
                               }] autorelease];
        self.service.requestData = dataSet;
        
        [self.service start];
    }else if (AppInfo.smithingType == 2)
    {
        //신청 전자서명문을 만든다
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"안심거래 서비스 기기 등록";
        
        AppInfo.electronicSignCode = @"E2812";
        AppInfo.electronicSignTitle = @"다음과 같이 안심거래 서비스 기기를 등록합니다.";
        
        
        //if (AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"] > 0)
        //{
            //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
            //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
            //NSLog(@"aaaa:%@",number);
            //NSLog(@"aaaa:%@",[SHBUtilFile getModel]);
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일: %@", AppInfo.tran_Date]];
            //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", number]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", @"정보없음"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)모델명: %@", [SHBUtilFile getModel]]];
            
            
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)구분: %@",@"영업점에서 신청"]];
                
        
        //}
        self.service = nil;
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E2812_SERVICE viewController:self] autorelease];
        SHBDataSet *dataSet = [[SHBDataSet dictionaryWithDictionary:@{
                                @"CUSNO" : AppInfo.customerNo,
                                @"DEVICE_ID" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"MASTER_YN" : @"N",
                                @"PHONE_NO" : @"",
                                @"PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                                @"PHONE_MODEL" : [SHBUtilFile getModel],
                                @"NICK_NAME" : @"",
                                @"ETC1" : @"IY",
                                @"ETC2" : @"",
                                @"ETC3" : @"",
                                @"ETC4" : @"",
                                @"ETC5" : @"",
                                }] autorelease];
        self.service.requestData = dataSet;
        
        [self.service start];
    }else if (AppInfo.smithingType == 3)
    {
        self.dataList = AppInfo.smsInfo[@"smsdeviceinfo"];
        NSDictionary *tmpDic = self.dataList[deviceIndex];
        AppInfo.commonDic = nil;
        AppInfo.commonDic = tmpDic;
        
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"안심거래 서비스 기기 삭제";
        
        AppInfo.electronicSignCode = @"E2814";
        AppInfo.electronicSignTitle = @"다음과 같이 안심거래 서비스 기기를 삭제합니다.";
        //if (AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"] > 0)
        //{
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        //NSLog(@"aaaa:%@",number);
        //NSLog(@"aaaa:%@",[SHBUtilFile getModel]);
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)삭제 신청일: %@", AppInfo.tran_Date]];
        //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", number]];
        if ([tmpDic[@"PHONE_NO"] length] == 0)
        {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", @"정보없음"]];
            
        }else
        {
            NSString *number = tmpDic[@"PHONE_NO"];
            number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", number]];
        }
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)모델명: %@", tmpDic[@"PHONE_MODEL"]]];
        
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)구분: %@",@"영업점에서 신청"]];
        
        self.service = nil;
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E2813_SERVICE viewController:self] autorelease];
        SHBDataSet *dataSet = [[SHBDataSet dictionaryWithDictionary:@{
                                @"CUSNO" : AppInfo.customerNo,
                                @"DEVICE_ID" : tmpDic[@"DEVICE_ID"],
                                }] autorelease];
        self.service.requestData = dataSet;
        
        [self.service start];
    }else if (AppInfo.smithingType == 4)
    {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"안심거래 서비스 해지";
        
        AppInfo.electronicSignCode = @"E2814";
        AppInfo.electronicSignTitle = @"다음과 같이 안심거래 서비스를 해지합니다.";
        //if (AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"] > 0)
        //{
        //NSString *number = AppInfo.smsInfo[@"smse114info"][@"휴대폰번호"];
        //number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
        //NSLog(@"aaaa:%@",number);
        //NSLog(@"aaaa:%@",[SHBUtilFile getModel]);
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)해지신청일: %@", AppInfo.tran_Date]];
        //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", number]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)휴대폰 번호: %@", @"정보없음"]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)모델명: %@", [SHBUtilFile getModel]]];
        
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)구분: %@",@"신한S뱅크에서 신청"]];
        
        
        //}
        self.service = nil;
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E2814_SERVICE viewController:self] autorelease];
        SHBDataSet *dataSet = [[SHBDataSet dictionaryWithDictionary:@{
                                @"CUSNO" : AppInfo.customerNo,
                                @"DEVICE_ID" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                }] autorelease];
        self.service.requestData = dataSet;
        
        [self.service start];
    }

}

- (void) cancelSecretMedia
{
    NSLog(@"aaaa:%i",AppInfo.smithingType);
    if (AppInfo.smithingType == 1)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }else if (AppInfo.smithingType == 2)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }else if (AppInfo.smithingType == 3)
    {
        
        [AppDelegate.navigationController fadePopViewController];
    }else if (AppInfo.smithingType == 4)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
}
@end
