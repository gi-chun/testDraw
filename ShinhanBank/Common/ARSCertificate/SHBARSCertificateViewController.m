//
//  SHBARSCertificateViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBARSCertificateViewController.h"
#import "SHBARSCertificateStep2ViewController.h"

#import "SHBListPopupView.h" // list popup
#import "SHBMobileCertificateService.h"
#import "Encryption.h"
@interface SHBARSCertificateViewController () <SHBListPopupViewDelegate, SHBARSCertificateStep2Delegate>
{
   
}
@property (retain, nonatomic) NSMutableArray *numberArray;
//- (void)requestPhoneNumber;
- (NSString *)getCodeValue:(NSInteger)value;
- (void)requestPhoneCert;
@end

@implementation SHBARSCertificateViewController
@synthesize serviceSeq;
@synthesize homeNumber;
@synthesize jobNumber;
@synthesize phoneNumber;
@synthesize mobileNumber;
@synthesize isAllidentity;
@synthesize subTitleLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)navigationButtonPressed:(id)sender
{
    [super navigationButtonPressed:sender];
    
    if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
    {
        UIButton *btnSender = (UIButton*)sender;
        switch (btnSender.tag)
        {
            case NAVI_BACK_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
                [AppDelegate.navigationController fadePopViewController];
            }
                break;
            case NAVI_CLOSE_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
            case QUICK_HOME_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.serviceSeq == SERVICE_IP_CHECK || self.serviceSeq == SERVICE_2MONTH_OVER)
    {
        [self navigationBackButtonHidden];
        [self quickMenuHidden];
        self.subTitleLabel.text = @"의심거래 방지를 위한 본인 확인 절차 강화";
        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:NAVI_NOTI_BTN_TAG];
        [tmpBtn setHidden:YES];
    }
    
    if (self.serviceSeq == SERVICE_USER_INFO_USE_SUPPLY) {
        
        [self navigationBackButtonHidden];
    }
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    startTextFieldTag = 3331;
    endTextFieldTag = 3333;
    
        
    self.numberArray = [NSMutableArray array];
    //[self requestPhoneNumber];
    NSLog(@"data%@",self.data);
    NSLog(@"transferdic%@",AppInfo.transferDic);
    if ([self.data[@"회사전화번호"] length] > 0)
    {
        self.jobNumber = self.data[@"회사전화번호"];
        self.jobNumber = [self.jobNumber substringToIndex:([self.jobNumber length] -4)];
        self.jobNumber = [NSString stringWithFormat:@"회사 %@****",self.jobNumber];
        
    }
    
    if ([self.data[@"휴대폰번호"] length] > 0)
    {
        self.mobileNumber = self.data[@"휴대폰번호"];
        self.mobileNumber = [self.mobileNumber substringToIndex:([self.mobileNumber length] -4)];
        self.mobileNumber = [NSString stringWithFormat:@"휴대폰 %@****",self.mobileNumber];
        
    }
    
    if ([self.data[@"자택전화번호"] length] > 0 && ![self.data[@"자택전화상이"] isEqualToString:@"1"])
    {
        self.homeNumber = self.data[@"자택전화번호"];
        self.homeNumber = [self.homeNumber substringToIndex:([self.homeNumber length] -4)];
        self.homeNumber = [NSString stringWithFormat:@"자택 %@****",self.homeNumber];
        [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
        [numberBtn1 setTitle:self.homeNumber forState:UIControlStateNormal];
        if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
        {
            [numberBtn1 setTitle:self.homeNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
        }
        self.phoneNumber = self.data[@"자택전화번호"];
    }else
    {
        self.homeNumber = @"";
        if ([self.data[@"회사전화번호"] length] > 0 && ![self.data[@"회사전화상이"] isEqualToString:@"1"])
        {
            [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
            [numberBtn1 setTitle:self.jobNumber forState:UIControlStateNormal];
            if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
            {
                [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
                [numberBtn1 setTitle:self.jobNumber forState:UIControlStateNormal];
            }
            self.phoneNumber = self.data[@"회사전화번호"];
        }else
        {
            if (!AppInfo.isAllIdenty)
            {
                if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_DEVICE_REGIST || serviceSeq == SERVICE_USER_INFO || serviceSeq == SERVICE_SSHIELD || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
                {
                    if ([self.data[@"휴대폰번호"] length] > 0)
                    {
                        [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
                        [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
                        if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
                        {
                            [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
                            [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
                        }
                        self.phoneNumber = self.data[@"휴대폰번호"];
                    }else
                    {
                        [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                        [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                        if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
                        {
                            [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                            [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                        }
                        numberBtn.enabled = NO;
                        numberBtn1.enabled = NO;
                    }
                }else
                {
                    [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                    numberBtn.enabled = NO;
                    numberBtn1.enabled = NO;
                }
                
            }else
            {
                //예금 담보대출 실행, 예적금 해지일경우 휴대폰 번호까지 보여준다
                if ([self.mobileNumber length] > 0)
                {
                    [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
                    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
                    {
                        [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
                        [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
                        numberBtn.enabled = NO;
                        numberBtn1.enabled = NO;
                    }
                    self.phoneNumber = self.data[@"휴대폰번호"];
                    //정과장 요청으로 예적금, 담보 해지시 무조건 휴대폰 번호로 세팅한다.
                    //numberBtn.enabled = NO;
                    //numberBtn1.enabled = NO;
                }else
                {
                    [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                    [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                    numberBtn.enabled = NO;
                    numberBtn1.enabled = NO;
                }
            }
            
        }
    }
    
    
    //2014.10.08 로직 변경
    //서비스 가능시간 및 영업일인지 체크
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    //예/적금해지, 예/적금 담보대출
    if (AppInfo.isAllIdenty && [SHBUtility isOPDate:[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""]] && time > 90000 && time < 180000)
    {
        //영업시간에는 ars 인증때 휴대폰 번호만 선택하게 한다
        if ([self.mobileNumber length] > 0)
        {
            [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"휴대폰번호"];
            //정과장 요청으로 예적금, 담보 해지시 무조건 휴대폰 번호로 세팅한다.
            numberBtn.enabled = NO;
            numberBtn1.enabled = NO;
        }else
        {
            [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            numberBtn.enabled = NO;
            numberBtn1.enabled = NO;
        }
    }else if (AppInfo.isAllIdenty && (![SHBUtility isOPDate:[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""]] || time < 90000 || time > 180000))
    {
        numberBtn.enabled = YES;
        numberBtn1.enabled = YES;
        //영업시간 외에는 휴대폰, 자택, 회사 순으로
        if ([self.mobileNumber length] > 0)
        {
            [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"휴대폰번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] > 0)
        {
            [numberBtn1 setTitle:self.homeNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"자택전화번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] == 0 && [self.jobNumber length] > 0)
        {
            [numberBtn1 setTitle:self.jobNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"회사전화번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] == 0 && [self.jobNumber length] == 0)
        {
            [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            numberBtn.enabled = NO;
            numberBtn1.enabled = NO;
        }
    }
    
    //고객정보변경, 이용기기등록 서비스
    if (serviceSeq == SERVICE_USER_INFO || serviceSeq == SERVICE_DEVICE_REGIST || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        if ([self.mobileNumber length] > 0)
        {
            [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"휴대폰번호"];
            numberBtn.enabled = NO;
            numberBtn1.enabled = NO;
        }else
        {
            
            numberBtn.enabled = YES;
            numberBtn1.enabled = YES;
            if ([self.homeNumber length] > 0)
            {
                [numberBtn1 setTitle:self.homeNumber forState:UIControlStateNormal];
                [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
                self.phoneNumber = self.data[@"자택전화번호"];
            }else if ([self.jobNumber length] > 0)
            {
                [numberBtn1 setTitle:self.jobNumber forState:UIControlStateNormal];
                [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
                self.phoneNumber = self.data[@"회사전화번호"];
            }else
            {
                [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
                numberBtn.enabled = NO;
                numberBtn1.enabled = NO;
            }
            
        }
    }
    
    //블랙리스트차단, S-Shield
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_SSHIELD)
    {
        numberBtn.enabled = YES;
        numberBtn1.enabled = YES;
        //영업시간 외에는 휴대폰, 자택, 회사 순으로
        if ([self.mobileNumber length] > 0)
        {
            [numberBtn1 setTitle:self.mobileNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.mobileNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"휴대폰번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] > 0)
        {
            [numberBtn1 setTitle:self.homeNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"자택전화번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] == 0 && [self.jobNumber length] > 0)
        {
            [numberBtn1 setTitle:self.jobNumber forState:UIControlStateNormal];
            [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
            self.phoneNumber = self.data[@"회사전화번호"];
        }else if ([self.mobileNumber length] == 0 && [self.homeNumber length] == 0 && [self.jobNumber length] == 0)
        {
            [numberBtn1 setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            numberBtn.enabled = NO;
            numberBtn1.enabled = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.numberArray removeAllObjects];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.numberArray = nil;
    [numberBtn1 release];
    [agreeButton1 release];
    [numberBtn release];
    [titleName release];
	[_nextViewControlName release];
	
    [subTitleLabel release];
    [bottomView release];
    [bottomView1 release];
    [infoView1 release];
    [infoView2 release];
    [infoView3 release];
    [agreeButton release];
    [_stepView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [subTitleLabel release];
    subTitleLabel = nil;
    [bottomView release];
    bottomView = nil;
    [bottomView1 release];
    bottomView1 = nil;
    [infoView1 release];
    infoView1 = nil;
    [infoView2 release];
    infoView2 = nil;
    [numberBtn release];
    infoView3 = nil;
    [infoView3 release];
    [agreeButton release];
    agreeButton = nil;
    [_stepView release];
    _stepView = nil;
    [numberBtn1 release];
    [agreeButton1 release];
    numberBtn1 = nil;
    agreeButton1 = nil;
    [super viewDidUnload];
}

#pragma mark - 

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName
{
	[self setTitle:aTitle];
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
	
	nextStep = step + 1;
	totalStep = stepCnt;
	
	if (nextCtrlName) {
		SafeRelease(_nextViewControlName);
		_nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
	
	// Max 10개까지만 Step 단계표시
    //sms, ars 모두 인증이라면...
    if (!self.isAllidentity)
    {
        if (stepCnt < 11){
            UIButton	*stepButtn;
            
            for (int i=stepCnt; i>=1; i --) {
                stepButtn = (UIButton*)[self.view viewWithTag:i];
                float stepWidth = stepButtn.frame.size.width;
                float stepX = 311 - ((stepWidth+2) * ((stepCnt+1) - i));
                [stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
                [stepButtn setHidden:NO];
                
                if (step >= i){
                    stepButtn.selected = YES;
                }else{
                    stepButtn.selected = NO;
                }
            }
        }
    }
	
	
    titleName = [[NSString alloc] initWithString:aTitle];
}

- (void)subTitle:(NSString *)subTitle infoViewCount:(ARS_INFOVIEW_COUNT)infoViewCount
{
    [self.subTitleLabel setText:subTitle];
    
    infoCount = infoViewCount;
    
    if (AppInfo.isAllIdenty)
    {
        infoView1 = infoView2;
    }
    
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER)
    {
        infoView1 = infoView3;
        bottomView = bottomView1;
    }
    
    UIView *infoView = nil;
    
    switch (infoCount) {
        case ARS_INFOVIEW_1:
        {
            infoView = infoView1;
        }
            break;
            
        default:
            break;
    }
    
    [self.contentScrollView addSubview:infoView];
    [self.contentScrollView addSubview:bottomView];
    
    [bottomView setFrame:CGRectMake(0,
                                    infoView.frame.size.height,
                                    bottomView.frame.size.width,
                                    bottomView.frame.size.height)];
    
    [self.contentScrollView setContentSize:CGSizeMake(317, bottomView.frame.origin.y + bottomView.frame.size.height)];
    
    contentViewHeight = self.contentScrollView.contentSize.height;
}

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
           infoViewCount:(ARS_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController
{
    [self executeWithTitle:aTitle Step:step StepCnt:stepCount NextControllerName:nextViewController];
    [self subTitle:subTitle infoViewCount:infoViewCount];
}

#pragma mark - Button

- (IBAction)ARSNumberBtn:(id)sender
{

    [self.numberArray removeAllObjects];
    
    if ([self.homeNumber length] > 0 && [self.jobNumber length] > 0)
    {
        NSMutableDictionary *mDic1 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic1 setObject:[NSString stringWithFormat:@"%@",self.homeNumber]	forKey:@"1"];
        
        NSMutableDictionary *mDic2 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic2 setObject:[NSString stringWithFormat:@"%@",self.jobNumber]	forKey:@"1"];
        
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        if (AppInfo.isAllIdenty && [self.mobileNumber length] > 0) //예적금 해지, 담보 대출
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_IP_CHECK && [self.mobileNumber length] > 0) //블랙리스트
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO && [self.mobileNumber length] > 0) //고객정보변경
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_DEVICE_REGIST && [self.mobileNumber length] > 0) //이용기기등록
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_SSHIELD && [self.mobileNumber length] > 0) //s-shield
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_2MONTH_OVER && [self.mobileNumber length] > 0) //블랙리스트
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO_USE_SUPPLY && [self.mobileNumber length] > 0) //본인정보 이용제공 조회시스템
        {
            [self.numberArray addObject:mDic3];
        }
        
        [self.numberArray addObject:mDic1];
        [self.numberArray addObject:mDic2];
    }
    
    if ([self.homeNumber length] > 0 && [self.jobNumber length] == 0)
    {
        NSMutableDictionary *mDic1 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic1 setObject:[NSString stringWithFormat:@"%@",self.homeNumber]	forKey:@"1"];
        
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        
        if (AppInfo.isAllIdenty && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_IP_CHECK && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_DEVICE_REGIST && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_SSHIELD && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_2MONTH_OVER && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO_USE_SUPPLY && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }
        [self.numberArray addObject:mDic1];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] > 0)
    {
        NSMutableDictionary *mDic2 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic2 setObject:[NSString stringWithFormat:@"%@",self.jobNumber]	forKey:@"1"];
        
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        if (AppInfo.isAllIdenty && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_IP_CHECK && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_DEVICE_REGIST && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_SSHIELD && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_2MONTH_OVER && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }else if (serviceSeq == SERVICE_USER_INFO_USE_SUPPLY && [self.mobileNumber length] > 0)
        {
            [self.numberArray addObject:mDic3];
        }
        
        [self.numberArray addObject:mDic2];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_IP_CHECK)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_USER_INFO)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_DEVICE_REGIST)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_SSHIELD)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_2MONTH_OVER)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    if ([self.homeNumber length] == 0 && [self.jobNumber length] == 0 && serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        NSMutableDictionary *mDic3 = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mDic3 setObject:[NSString stringWithFormat:@"%@",self.mobileNumber]	forKey:@"1"];
        
        [self.numberArray addObject:mDic3];
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"ARS 수신 전화번호"
                                                                   options:self.numberArray
                                                                   CellNib:@"SHBExchangePopupNoMoreCell"
                                                                     CellH:32
                                                               CellDispCnt:7
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

// 동의여부
- (IBAction)agreeBtn:(id)sender
{
    [sender setSelected:![sender isSelected]];
}

// 확인
- (IBAction)okBtn:(id)sender
{
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        if (numberBtn1.enabled == NO && [self.data[@"휴대폰번호"] length] == 0)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"고객정보에 등록된 전화번호가 없습니다. 인근 신한은행 영업점에서 고객정보를 변경하신 후 진행하시기 바랍니다."];
            return;
        }
        
        if (![agreeButton1 isSelected]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"추가인증 진행에 동의하신 후, 진행하실 수 있습니다."];
            return;
        }
    }else
    {
        if (numberBtn.enabled == NO && [self.data[@"휴대폰번호"] length] == 0)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"고객정보에 등록된 전화번호가 없습니다. 인근 신한은행 영업점에서 고객정보를 변경하신 후 진행하시기 바랍니다."];
            return;
        }
        
        if (![agreeButton isSelected]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"추가인증 진행에 동의하신 후, 진행하실 수 있습니다."];
            return;
        }
    }
    
    //ars 요청
    [self requestPhoneCert];
    
}

// 취소
- (IBAction)cancelBtn:(id)sender
{
    if (serviceSeq == SERVICE_IP_CHECK)
    {
        [AppInfo logout];
        [AppDelegate.navigationController fadePopToRootViewController];
        return;
    }
    
    if (serviceSeq == SERVICE_2MONTH_OVER)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
        return;
    }
    
    [self.navigationController fadePopViewController];
    
    if ([self.delegate respondsToSelector:@selector(ARSCertificateCancel)]) {
        [self.delegate ARSCertificateCancel];
    }
    if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
    {
        AppInfo.isAllIdenty = NO;
        AppInfo.isAllIdentyDone = NO;
        AppInfo.isSMSIdenty = NO;
        AppInfo.isARSIdenty = NO;
        [AppDelegate.navigationController fadePopViewController];
    }
}

#pragma mark - List popup

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    //NSLog(@"aaaa:%i",[self.numberArray count]);
    //NSLog(@"bbbb:%@",self.numberArray);
//    if ([self.numberArray count] == 3)
//    {
//        if (anIndex == 0)
//        {
//            self.phoneNumber = self.data[@"자택전화번호"];
//        }else if (anIndex == 1)
//        {
//            self.phoneNumber = self.data[@"회사전화번호"];
//        }else if (anIndex == 2)
//        {
//            if (AppInfo.isAllIdenty)
//            {
//                self.phoneNumber = self.data[@"휴대폰번호"];
//            }
//        }
//    }else
//    {
        NSString *arsStr = self.numberArray[anIndex][@"1"];
        if ([SHBUtility isFindString:arsStr find:@"회사"])
        {
            self.phoneNumber = self.data[@"회사전화번호"];
        }else if ([SHBUtility isFindString:arsStr find:@"자택"])
        {
            self.phoneNumber = self.data[@"자택전화번호"];
        }else if ([SHBUtility isFindString:arsStr find:@"휴대폰"])
        {
            if (AppInfo.isAllIdenty)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_IP_CHECK)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_USER_INFO)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_DEVICE_REGIST)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_SSHIELD)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_2MONTH_OVER)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }else if (serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
            {
                self.phoneNumber = self.data[@"휴대폰번호"];
            }
            
        }
    //}

    [numberBtn1 setTitle:self.numberArray[anIndex][@"1"] forState:UIControlStateNormal];
    [numberBtn setTitle:self.numberArray[anIndex][@"1"] forState:UIControlStateNormal];
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        [numberBtn1 setTitle:self.numberArray[anIndex][@"1"] forState:UIControlStateNormal];
    }
}

//- (void)requestPhoneNumber
//{
//    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
//                           @{
//                           @"업무구분" : @"4",
//                           @"검색구분" : @"1",
//                           @"검색번호" : AppInfo.customerNo,
//                           @"은행구분" : @"1",
//                           @"거래구분" : @"01",
//                           @"공인IP" : @"",
//                           @"사설IP" : @"",
//                           @"MACADDRESS1" : @"",
//                           @"MACADDRESS2" : @"",
//                           @"MACADDRESS3" : @"",
//                           @"프록시사용유무" : @"",
//                           @"프록시서버IP" : @"",
//                           @"프록시서버PORT" : @"",
//                           @"프록시설정상태" : @"",
//                           @"하드디스크정보" : @"",
//                           @"모바일뱅킹폰번호" : @"",
//                           @"UID" : @"",
//                           @"FILLER" : @"",
//                           }];
//    
//    
//    NSInteger serviceID = 0;
//    
//    if ([[self getCodeValue:3] isEqualToString:@"E2114"]) {
//        serviceID = MOBILE_CERT_E2114;
//    }
//    else if ([[self getCodeValue:3] isEqualToString:@"E2116"]) {
//        serviceID = MOBILE_CERT_E2116;
//    }
//    else if ([[self getCodeValue:3] isEqualToString:@"E4001"]) {
//        serviceID = MOBILE_CERT_E4001;
//    }
//    
//    self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:serviceID
//                                                            viewController:self] autorelease];
//    self.service.requestData = dataSet;
//    [self.service start];
//}

- (NSString *)getCodeValue:(NSInteger)value
{
    NSString *serviceCode = @""; // 서비스코드
    NSString *separation = @""; // 구분
    NSString *code = @""; // 전문코드
    NSString *arsType = @"";
	switch (serviceSeq) {
		case SERVICE_CERT:                  // 인증서 발급/재발급
			serviceCode = @"C1102";
            separation = @"A1";
            code = @"E2116";
            arsType = @"03";
            //code = @"S00001";
			break;
		case SERVICE_SIGN_UP:               // 조회회원서비스 가입
			serviceCode = @"H1009";
            separation = @"A3";
            code = @"E4001";
            arsType = @"08";
            //code = @"S00001";
			break;
		case SERVICE_PASSWORD:              // 이용자 비밀번호 등록
			serviceCode = @"A0052";
            separation = @"A4";
            code = @"E4001";
            arsType = @"08";
            //code = @"S00001";
			break;
		case SERVICE_USER_INFO:             // 고객정보변경
			serviceCode = @"C2310";
            separation = @"A5";
            code = @"E2114";
            arsType = @"07";
            //code = @"S00002";
			break;
		case SERVICE_CANCEL_GOODS:      // 예/적금 전체해지
			serviceCode = @"D3286";
            separation = @"A6";
            code = @"E2114";
            arsType = @"01";
            //code = @"S00002";
			break;
		
		case SERVICE_LOAN:                  // 예/적금 담보대출
			serviceCode = @"L1310";
            separation = @"A7";
            code = @"E2114";
            arsType = @"02";
            //code = @"S00002";
			break;
		case SERVICE_DEVICE_REGIST:          // 이용기기 등록 서비스
			serviceCode = @"E3012";
            separation = @"A8";
            code = @"E2114";
            arsType = @"04";
            //code = @"S00002";
			break;
		case SERVICE_300_OVER:              // 300만원 이상 이체시
			//serviceCode = @"E3012";
            serviceCode = @"D2003"; //2014.08.05 수정
            separation = @"A9";
            code = @"E2114";
            arsType = @"05";
			break;
        case SERVICE_FRAUD_PREVENTION_SMS:  // 사기예방 SMS 통지 서비스 신청/해제
			serviceCode = @"E4149";
            separation = @"A10";
            code = @"E2114";
            arsType = @"08";
            break;
        case SERVICE_DEVICE_REGIST_ADD:     // 이용기기 외 추가인증 신청/해제
			serviceCode = @"E4149";
            separation = @"A11";
            code = @"E2114";
            arsType = @"08";
            break;
        case SERVICE_IP_CHECK: //블랙리스트
            serviceCode = @"D1000";
            separation = @"A14";
            code = @"E2114";
            arsType = @"08";
            break;
        case SERVICE_SSHIELD: //s-shield
            serviceCode = @"E7011";
            separation = @"A16";
            code = @"E2114";
            arsType = @"08";
            break;
        case SERVICE_2MONTH_OVER: //2개월이상 이체거래 없는 통장이체 추가인증
            serviceCode = @"D2003";
            separation = @"A17";
            code = @"E2001";
            arsType = @"08";
            break;
		case SERVICE_USER_INFO_USE_SUPPLY:  // 본인정보 이용제공 조회시스템
			serviceCode = @"C2310";
            separation = @"A5";
            code = @"E2114";
            arsType = @"07";
			break;
		case SERVICE_BIZ_LOAN_ITEMIZE:              // 직장인 무방문대출 신청 (건별)
			serviceCode = @"L3225";
            separation = @"A20";
            code = @"E2114";
            arsType = @"02";
			break;
		case SERVICE_BIZ_LOAN_LIMIT:              // 직장인 무방문대출 신청 (한도)
			serviceCode = @"L3224";
            separation = @"A20";
            code = @"E2114";
            arsType = @"02";
			break;
		default:
			break;
	}
    
    NSString *returnValue = @"";
    
    switch (value) {
        case 1: // 서비스코드
            returnValue = serviceCode;
            
            break;
        case 2: // 구분
            returnValue = separation;
            
            break;
        case 3: // 전문코드
            returnValue = code;
            
            break;
        case 4: // 거래구분
            returnValue = arsType;
        default:
            break;
    }
    
    return returnValue;
}

- (void)requestPhoneCert
{
    AppInfo.serviceCode = @"ARS_CERT";

    if (self.serviceSeq == SERVICE_300_OVER)
    {
        
        //300만원이상 이체 거래시 전문 변경
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"거래구분" : [self getCodeValue:4],
                               @"인증구분" : @"02",
                               @"전화번호" : self.phoneNumber,
                               @"계좌번호_상품코드" : @"",
                               @"거래금액" : @"",
                               @"NEXT서비스코드" : AppInfo.transferDic[@"서비스코드"],
                               @"입금은행명" : AppInfo.transferDic[@"입금은행명"],
                               @"이체건수" : AppInfo.transferDic[@"추가이체건수"],
                               @"추가_입금은행코드" : AppInfo.transferDic[@"추가_입금은행코드"],
                               @"추가_입금은행명" : AppInfo.transferDic[@"추가_입금은행명"],
                               @"추가_입금계좌번호" : AppInfo.transferDic[@"추가_입금계좌번호"],
                               @"추가_입금계좌성명" : AppInfo.transferDic[@"추가_입금계좌성명"],
                               @"추가_이체금액" : AppInfo.transferDic[@"추가_이체금액"],
                               @"서비스코드" : [self getCodeValue:1],
                               }];
        
        //SendData(SHBTRTypeServiceCode, @"E3029", MOBILE_CERT_300OVER_SMSARS_URL, self, dataSet);
        //SendData(SHBTRTypeServiceCode, @"C2406", SERVICE_URL, self, dataSet);
        SendData(SHBTRTypeServiceCode, @"C2406", MOBILE_CERT_300OVER_SMSARS_URL, self, dataSet);
        Debug(@"request : %@", dataSet);
         
    }else
    {
        NSString *goodsCode = AppInfo.transferDic[@"계좌번호_상품코드"];
        NSString *amount = AppInfo.transferDic[@"거래금액"];
        NSLog(@"고객번호:%@",AppInfo.customerNo);
        NSLog(@"주민번호:%@",[AppInfo getPersonalPK]);
        NSLog(@"self.phoneNumber:%@",self.phoneNumber);
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"구분" : [self getCodeValue:2],
                               @"서비스코드" : [self getCodeValue:1],
                               @"휴대폰번호" : self.phoneNumber,
                               @"고객번호" : AppInfo.customerNo,
                               //@"주민번호" : AppInfo.ssn,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               //ARS 인증전문 추가
                               @"계좌번호_상품코드" : [SHBUtility nilToString:goodsCode],
                               @"거래금액" : [SHBUtility nilToString:amount],
                               @"거래구분" : [self getCodeValue:4],
                               @"인증구분" : @"02",
                               @"전화번호" : self.phoneNumber,
                               @"NEXT서비스코드" : [self getCodeValue:1],
                               //@"NEXT서비스코드" : [SHBUtility nilToString:AppInfo.transferDic[@"서비스코드"]],
                               }];
        
        
        
        
        if (AppInfo.isLogin != 0)
        {
            [dataSet insertObject:AppInfo.userInfo[@"고객성명"] forKey:@"성명" atIndex:0];
            
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_URL, self, dataSet);
        }
        else {
            [dataSet insertObject:AppInfo.commonDic[@"고객명"] forKey:@"성명" atIndex:0];
            
            //SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMS_GUEST_URL, self, dataSet);
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_GUEST_URL, self, dataSet);
        }
        
        Debug(@"request : %@", dataSet);
    }
    
}

#pragma mark - SHBARSCertificateStep2 Delegate

- (void)ARSCertificateStep2Back
{
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        [agreeButton1 setSelected:NO];
    }else
    {
        [agreeButton setSelected:NO];
    }
    
}

#pragma mark - Network

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    /*
    if (AppInfo.errorType) {
        return NO;
    }
    */
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    /*
    if ([aDataSet[@"회사전화번호"] length] > 0)
    {
        self.jobNumber = aDataSet[@"회사전화번호"];
        self.jobNumber = [self.jobNumber substringToIndex:([self.jobNumber length] -4)];
        self.jobNumber = [NSString stringWithFormat:@"회사 %@****",self.jobNumber];
    
    }
    
    if ([aDataSet[@"자택전화번호"] length] > 0 && ![aDataSet[@"자택전화상이"] isEqualToString:@"1"])
    {
        self.homeNumber = aDataSet[@"자택전화번호"];
        self.homeNumber = [self.homeNumber substringToIndex:([self.homeNumber length] -4)];
        self.homeNumber = [NSString stringWithFormat:@"자택 %@****",self.homeNumber];
        [numberBtn setTitle:self.homeNumber forState:UIControlStateNormal];
        self.phoneNumber = aDataSet[@"자택전화번호"];
    }else
    {
        self.homeNumber = @"";
        if ([aDataSet[@"회사전화번호"] length] > 0 && ![aDataSet[@"회사전화상이"] isEqualToString:@"1"])
        {
            [numberBtn setTitle:self.jobNumber forState:UIControlStateNormal];
            self.phoneNumber = aDataSet[@"회사전화번호"];
        }else
        {
            [numberBtn setTitle:@"등록된 전화번호가 없습니다." forState:UIControlStateNormal];
            numberBtn.enabled = NO;
        }
    }
    
    self.data = aDataSet;
     */
    return YES;
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    if (serviceSeq == SERVICE_IP_CHECK || serviceSeq == SERVICE_2MONTH_OVER || serviceSeq == SERVICE_USER_INFO_USE_SUPPLY)
    {
        infoDic = [NSMutableDictionary dictionaryWithDictionary:
                   @{ @"전화번호" : numberBtn1.titleLabel.text }];
    }else
    {
        infoDic = [NSMutableDictionary dictionaryWithDictionary:
                   @{ @"전화번호" : numberBtn.titleLabel.text }];
    }
    
    
    SHBARSCertificateStep2ViewController *viewController = [[[SHBARSCertificateStep2ViewController alloc] initWithNibName:@"SHBARSCertificateStep2ViewController" bundle:nil] autorelease];
    
    
    //viewController.realNumber = self.phoneNumber;
    viewController.realNumber = dataSet[@"신청번호"];
    viewController.certCode = [self getCodeValue:2];
    viewController.arsType = [self getCodeValue:4];
    viewController.serviceSeq = self.serviceSeq;
    viewController.delegate = self;
    viewController.serviceCode = [self getCodeValue:1];
    if (self.isAllidentity)
    {
        viewController.isAllidentity = YES;
    }
    
    [self checkLoginBeforePushViewController:viewController animated:NO];
    
    [viewController executeWithTitle:titleName
                                Step:nextStep
                             StepCnt:totalStep
                  NextControllerName:_nextViewControlName
                                Info:infoDic];
    
    [viewController.subTitleLabel setText:self.subTitleLabel.text];
}
@end
