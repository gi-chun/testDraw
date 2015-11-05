//
//  SHBSmithingGuideViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingGuideViewController.h"
#import "SHBSmithingAskViewController.h"
#import "SHBVersionService.h"
#import "SHBSmithingDeviceRegisterViewController.h"
#import "SHBSmithingFinishViewController.h"
#import "SHBSmithingDeviceQueryDelViewController.h"

@interface SHBSmithingGuideViewController ()

@end

@implementation SHBSmithingGuideViewController
@synthesize mainView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [mainView release];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppInfo.smsInfo removeAllObjects];
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                     TASK_ACTION_KEY : @"selectSmishingDeviceList",
                                }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:SMSDEVICE_INFO viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
     
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"AppInfo.userInfo:%@",AppInfo.userInfo);
    [self setTitle:@"안심거래 서비스"];
    self.strBackButtonTitle = @"안심거래 서비스";
    
    [self.contentScrollView addSubview:self.mainView];
    [self.contentScrollView setContentSize:self.mainView.frame.size];
    //안심거래서비스 조회를 한다
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    
    switch (tmpBtn.tag)
    {
        case 1000:
        {
            //안심거래서비스사용여부
            if ([self.data[@"안심거래서비스사용여부"] isEqualToString:@"N"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용에 불편을 드려 죄송합니다.\n현재 서비스 점검중입니다.\n더 나은 서비스로 찾아뵙겠습니다."];
                return;
            }
            
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"] && [self.data[@"SMISHING_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //이용기기등록서비스 가입여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"USE_DEVICE_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용기기 등록 서비스 가입 고객님은 안심거래 서비스 신청이 불가합니다."];
                return;
            }
            //사기예방 SMS 통지 서비스 가입 여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"SAGI_SMS_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"사기예방 SMS 통지 서비스 가입 고객님은 안심거래 서비스 신청이 불가합니다."];
                return;
            }
            
            //OTP  이용 여부 판단 (yes 이용불가 알럿)
            //if ([self.data[@"OTP_YN"] isEqualToString:@"Y"])
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //국내통신사 가입 여부 판단 (NO 영업점 방문 알럿)
            if ([self.data[@"국내통신사YN"] isEqualToString:@"N"])
            {
                
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"국내 통신사 가입자만 이용이 가능합니다."];
                return;
            }
            
            if ([self.data[@"SMISHING_YN"] isEqualToString:@"N"])
            {
                self.dataList = [self.data arrayWithForKey:@"DEVICE_LIST.vector.data"];
                NSLog(@"aaaa:%@",self.dataList);
                //안심거래서비스 해당자고 있고 기기가 없으면 신청화면으로 고고씽
                if ([self.dataList count] == 0)
                {
                    //서비스신청및마스터기기등록화면으로 이동
                    AppInfo.smithingType = 1;
                    SHBSmithingAskViewController *viewController = [[SHBSmithingAskViewController alloc]initWithNibName:@"SHBSmithingAskViewController" bundle:nil];
                    [AppDelegate.navigationController pushFadeViewController:viewController];
                    [viewController release];
                }
                
            }else
            {
                self.dataList = [self.data arrayWithForKey:@"DEVICE_LIST.vector.data"];
                NSLog(@"aaaa:%@",self.dataList);
                BOOL isFind = NO;
                for (int i = 0; i < [self.dataList count]; i++)
                {
                    //이미 등록되어 있는 기기인지 확인한다
                    NSDictionary *tmpDic = self.dataList[i];
                    if ([tmpDic[@"DEVICE_ID"] isEqualToString:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]])
                    {
                        isFind = YES;
                        break;
                    }
                }
                if (isFind)
                {
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스에 등록된 기기입니다."];
                    return;
                }
                //등록대수가 5대인지 확인한다.
                if ([self.dataList count] == 5)
                {
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스 기기는\n5대까지만 등록하실 수 있습니다.\n\n기존에 등록된 기기를 삭제하신 후\n진행하시기 바랍니다."];
                    return;
                }
                NSLog(@"1111:%i",[self.dataList count]);
                //기기등록화면으로 이동
                if ([self.dataList count] < 5)
                {
                    AppInfo.smithingType = 2;
                    SHBSmithingDeviceRegisterViewController *viewController = [[SHBSmithingDeviceRegisterViewController alloc]initWithNibName:@"SHBSmithingDeviceRegisterViewController" bundle:nil];
                    [AppDelegate.navigationController pushFadeViewController:viewController];
                    [viewController release];
                }
            }
             
            
            
        }
            break;
        case 1001:
        {
            if ([self.data[@"안심거래서비스사용여부"] isEqualToString:@"N"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용에 불편을 드려 죄송합니다.\n현재 서비스 점검중입니다.\n더 나은 서비스로 찾아뵙겠습니다."];
                return;
            }
            
            //기기조회 삭제
            if ([self.data[@"SMISHING_YN"] isEqualToString:@"N"])
            {
                //서비스가입여부체크
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스 신청 후 이용하실 수\n있습니다."];
                return;
            }
            
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"] && [self.data[@"SMISHING_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //이용기기등록서비스 가입여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"USE_DEVICE_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용기기 등록 서비스 가입 고객님은 안심거래 서비스 이용이 불가합니다."];
                return;
            }
            //사기예방 SMS 통지 서비스 가입 여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"SAGI_SMS_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"사기예방 SMS 통지 서비스 가입 고객님은 안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            
            
            //OTP  이용 여부 판단 (yes 이용불가 알럿)
            //if ([self.data[@"OTP_YN"] isEqualToString:@"Y"])
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //국내통신사 가입 여부 판단 (NO 영업점 방문 알럿)
            if ([self.data[@"국내통신사YN"] isEqualToString:@"N"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"국내 통신사 가입자만 이용이 가능합니다."];
                return;
            }
            
            //기기등록여부체크
            self.dataList = [self.data arrayWithForKey:@"DEVICE_LIST.vector.data"];
            if ([self.dataList count] == 0)
            {
                //기기대수체크
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스에서 등록하신 기기로만 조회하실 수 있습니다."];
                return;
            }
            [AppInfo.smsInfo setObject:self.dataList forKey:@"smsdeviceinfo"];
            BOOL isFind = NO;
            for (int i = 0; i < [self.dataList count]; i++)
            {
                NSDictionary *tmpDic = self.dataList[i];
                if ([tmpDic[@"DEVICE_ID"] isEqualToString:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]])
                {
                    isFind = YES;
                    break;
                }
            }
            if (!isFind)
            {
            
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스에서 등록하신 기기로만 조회하실수 있습니다."];
                return;
            }
            
            AppInfo.smithingType = 3;
            SHBSmithingDeviceQueryDelViewController *viewController = [[SHBSmithingDeviceQueryDelViewController alloc]initWithNibName:@"SHBSmithingDeviceQueryDelViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
        case 1002:
        {
            if ([self.data[@"안심거래서비스사용여부"] isEqualToString:@"N"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용에 불편을 드려 죄송합니다.\n현재 서비스 점검중입니다.\n더 나은 서비스로 찾아뵙겠습니다."];
                return;
            }
            //서비스해지
            if ([self.data[@"SMISHING_YN"] isEqualToString:@"N"])
            {
               //서비스가입여부체크
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스 신청 고객이 아닙니다."];
                return;
            }
            
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"] && [self.data[@"SMISHING_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //이용기기등록서비스 가입여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"USE_DEVICE_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"이용기기 등록 서비스 가입 고객님은 안심거래 서비스 이용이 불가합니다."];
                return;
            }
            //사기예방 SMS 통지 서비스 가입 여부 판단 (yes 이용불가 알럿)
            if ([self.data[@"SAGI_SMS_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"사기예방 SMS 통지 서비스 가입 고객님은 안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //OTP  이용 여부 판단 (yes 이용불가 알럿)
            //if ([self.data[@"OTP_YN"] isEqualToString:@"Y"])
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"일회용비밀번호기(OTP) 이용 고객님은\n안심거래 서비스 이용이 불가합니다."];
                return;
            }
            
            //국내통신사 가입 여부 판단 (NO 영업점 방문 알럿)
            if ([self.data[@"국내통신사YN"] isEqualToString:@"N"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"국내 통신사 가입자만 이용이 가능합니다."];
                return;
            }
            
            //마스터기기여부체크
            self.dataList = [self.data arrayWithForKey:@"DEVICE_LIST.vector.data"];
            NSLog(@"aaaa:%@",self.dataList);
            BOOL isFind = NO;
            BOOL isDeviceFind = NO;
            for (int i = 0; i < [self.dataList count]; i++)
            {
                NSDictionary *tmpDic = self.dataList[i];
                if ([tmpDic[@"DEVICE_ID"] isEqualToString:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]])
                {
                    //등록된 기기인지...
                    isDeviceFind = YES;
                    
                }
                
                if ([tmpDic[@"DEVICE_ID"] isEqualToString:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]] && [tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
                {
                    //마스터 기기인지...
                    isFind = YES;
                    break;
                }
                
            }
            if (!isDeviceFind)
            {
                //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기에서만 서비스 해지가 가능합니다."];
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 신청 및 등록하신\n기기로만 서비스 해지가 가능합니다."];
                return;
            }
            if (!isFind)
            {
                //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기에서만 서비스 해지가 가능합니다."];
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"해당 기기는 영업점에서 신청 및 등록하신 기기 입니다. 신한S뱅크에서 신청 및 등록하신 기기로만 서비스 해지가 가능합니다."];
                return;
            }
            
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5500 title:nil message:@"안심거래 서비스를 해지하시겠습니까?\n\n(등록된 모든 기기가 삭제됩니다.)"];
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.data = aDataSet;
    [AppInfo.smsInfo setObject:self.data forKey:@"smsbaseinfo"];
    return NO;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    return YES;
}

#pragma mark -
#pragma mark Notifications

- (void)getElectronicSignResult:(NSNotification *)noti
{
    if ([noti userInfo])
    {
        if ([[[noti userInfo] objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"])
        {
            
            // success의 경우
            SHBSmithingFinishViewController *viewController = [[SHBSmithingFinishViewController alloc] initWithNibName:@"SHBSmithingFinishViewController" bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    NSLog(@"vc count:%i",[AppDelegate.navigationController.viewControllers count]);
    NSLog(@"vc name:%@",AppDelegate.navigationController.viewControllers);
    if (AppInfo.smithingType == 1)
    {
        if ([AppDelegate.navigationController.viewControllers count] != 7)
        {
            return;
        }
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }else if (AppInfo.smithingType == 2)
    {
        if ([AppDelegate.navigationController.viewControllers count] != 5)
        {
            return;
        }
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
    }else if (AppInfo.smithingType == 3)
    {
        if ([AppDelegate.navigationController.viewControllers count] != 5)
        {
            return;
        }
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
    }else if (AppInfo.smithingType == 4)
    {
        if ([AppDelegate.navigationController.viewControllers count] != 6)
        {
            return;
        }
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 5500 && buttonIndex == 0)
    {
        AppInfo.smithingType = 4;
        //서비스 해지
        SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
        [viewController setServiceSeq:SERVICE_CHEET_DEFENCE_CA];
        viewController.needsLogin = YES;
        viewController.delegate = self;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"안심거래 서비스 해지" Step:1 StepCnt:4 NextControllerName:@"SHBSmithingSecureMediaViewController"];
        [viewController subTitle:@"서비스 해지(SMS)"];
        [viewController release];
    }
}
@end
