//
//  SHBIdentity2ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 13. 8. 2..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBIdentity2ViewController.h"
#import "SHBMobileCertificateViewController.h"
#import "SHBARSCertificateViewController.h"
#import "SHBDeviceRegistServiceViewController.h"
#import "SHBForeignCertificateViewController.h"

@interface SHBIdentity2ViewController () <SHBMobileCertificateDelegate, SHBARSCertificateDelegate>
{
    int btnStatus;
    int nextStep;
	int totalStep;
    NSString *nextViewControlName;
    NSString *titleName;
}
@end

@implementation SHBIdentity2ViewController
@synthesize serviceSeq;

- (void)dealloc
{
    [_confirmButton release];
    [_cancelButton release];
    [_foreignButton release];
    [_subTitleLabel release];
    [_arsButton release];
    [_smsButton release];
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
    btnStatus = 1;
    [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    btnStatus = 1;
    
    AppInfo.isAllIdentyDone = NO;
    AppInfo.isAllIdenty = NO;
    
   if ([self.data[@"해외IP여부"] isEqualToString:@"Y"])
   {
       //이체, 인증센터 해외체류중이라면
       if (serviceSeq == SERVICE_CERT || serviceSeq == SERVICE_300_OVER)
       {
           self.foreignButton.hidden = NO;
       }else
       {
           self.foreignButton.hidden = YES;
       }
       
       self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, 450);
       
       
   }else
   {
        [self.confirmButton setFrame:CGRectMake(self.confirmButton.frame.origin.x, self.confirmButton.frame.origin.y - 20, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height)];
        [self.cancelButton setFrame:CGRectMake(self.cancelButton.frame.origin.x, self.cancelButton.frame.origin.y - 20, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height)];
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, 430);
        
    }
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
            btnStatus = 1;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        }
            break;
        case 1001:
        {
            btnStatus = 2;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        }
            break;
        case 1002:
            
            if (btnStatus == 1)
            {
                SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
                
                [viewController setServiceSeq:serviceSeq];
                viewController.delegate = self;
                viewController.data = self.data;
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"추가인증 (SMS 인증)" infoViewCount:MOBILE_INFOVIEW_1];
                
                [viewController release];
            }else if (btnStatus == 2)
            {
                SHBARSCertificateViewController *viewController = [[SHBARSCertificateViewController alloc]initWithNibName:@"SHBARSCertificateViewController" bundle:nil];
                
                [viewController setServiceSeq:serviceSeq];
                viewController.data = self.data;
                viewController.delegate = self;
                
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"추가인증 (ARS 인증)" infoViewCount:ARS_INFOVIEW_1];
                
                [viewController release];
                
            }else if (btnStatus == 3)
            {
                SHBForeignCertificateViewController *viewController = [[SHBForeignCertificateViewController alloc]initWithNibName:@"SHBForeignCertificateViewController" bundle:nil];
                [viewController setServiceSeq:serviceSeq];
                //viewController.delegate = self;
                viewController.data = self.data;
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"해외체류확인" infoViewCount:ARS_INFOVIEW_1];
                
                
                
                [viewController release];
            }
            break;
        case 1003:
        {
            if ([_delegate respondsToSelector:@selector(identity2ViewControllerCancel)]) {
                [_delegate identity2ViewControllerCancel];
            }
            
            [self.navigationController fadePopViewController];
        }
            break;
        case 1004:
        {
            SHBDeviceRegistServiceViewController *viewController = [[[SHBDeviceRegistServiceViewController alloc] initWithNibName:@"SHBDeviceRegistServiceViewController" bundle:nil] autorelease];
            [viewController setNeedsCert:YES];
            
            [self.navigationController fadePopToRootViewController];
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 1005:
        {
            btnStatus = 3;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 퍼블릭메서드

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName
{
	self.title = aTitle;
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
	
	nextStep = step + 1;
	totalStep = stepCnt;
	
    
	if (nextCtrlName) {
		SafeRelease(nextViewControlName);
		nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
	/*
     // Max 10개까지만 Step 단계표시
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
     */
    titleName = [[NSString alloc] initWithString:aTitle];
	
}

- (void)subTitle:(NSString *)subTitle
{
    [self.subTitleLabel setText:subTitle];
    
}

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController
{
    [self executeWithTitle:aTitle Step:step StepCnt:stepCount NextControllerName:nextViewController];
    [self subTitle:subTitle];
}


#pragma mark - cancel delegate

- (void)mobileCertificateCancel
{
    btnStatus = 1;
    [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
    [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
}

- (void)ARSCertificateCancel
{
    btnStatus = 1;
    [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
    [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
}

@end
