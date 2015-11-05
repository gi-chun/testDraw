//
//  SHBForeignCertificateViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBForeignCertificateViewController.h"
#import "SHBSettingsService.h"

#import "SHBTransferInfoInputViewController.h"
#import "SHBAutoTransferViewController.h"

@interface SHBForeignCertificateViewController ()

@end

@implementation SHBForeignCertificateViewController

@synthesize serviceSeq;

- (void)dealloc
{
    
    [numberBtn release];
    [titleName release];
	[_nextViewControlName release];
	
    [subTitleLabel release];
    [bottomView release];
    
    [infoView1 release];
    
    [agreeButton release];
    [_stepView release];
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
    
    [self.scrollView setContentSize:infoView1.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
    titleName = [[NSString alloc] initWithString:aTitle];
}

- (void)subTitle:(NSString *)subTitle infoViewCount:(FOREIGN_INFOVIEW_COUNT)infoViewCount
{
    [subTitleLabel setText:subTitle];
    
    infoCount = infoViewCount;
    
    UIView *infoView = nil;
    
    switch (infoCount) {
        case FOREIGN_INFOVIEW_1:
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
           infoViewCount:(FOREIGN_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController
{
    [self executeWithTitle:aTitle Step:step StepCnt:stepCount NextControllerName:nextViewController];
    [self subTitle:subTitle infoViewCount:infoViewCount];
}

- (IBAction)checkButton:(id)sender
{
    [sender setSelected:![sender isSelected]];
}
- (IBAction)okButton:(id)sender
{
    
    if (![_checkBtn isSelected])
    {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"해외체류 확인을 위한 개인정보 이용에 동의 하신 후 진행하실 수 있습니다."];
        
        return;
    }
    
     if (AppInfo.isLogin)   //이체
     {
         NSLog(@"정보:%@", AppInfo.commonDic);
         SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                  @{
                                  TASK_NAME_KEY : @"sfg.rib.task.common.DepartureControlTask",
                                  TASK_ACTION_KEY : @"checkDeparture",
                                  @"조회자한글성명" : AppInfo.realServer ? AppInfo.userInfo[@"고객성명"] : @"금결원", //성명이 금결원일때 테스트 정상 넘어감
                                  @"조회자주민등록번호" : [AppInfo getPersonalPK],
                                  //@"조회자주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                  @"고객번호" : AppInfo.customerNo,
                                  }] autorelease];
         
         
         for (UIViewController *viewController in self.navigationController.viewControllers)
         {
             if ([viewController isKindOfClass:[SHBTransferInfoInputViewController class]])
             {
                 // 즉시이체
                 
                 SHBTransferInfoInputViewController *vc = (SHBTransferInfoInputViewController *)viewController;
                 
                 switch (vc.processFlag) {
                     case 1:
                     {
                         // 당행이체
                         [aDataSet insertObject:@"D2003" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     case 2:
                     {
                         // 타행이체
                         [aDataSet insertObject:@"D2013" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     case 3:
                     {
                         // 가상이체
                         [aDataSet insertObject:@"D2043" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     case 4:
                     {
                         // 평생이체
                         [aDataSet insertObject:@"D2003" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     default:
                         break;
                 }
                 
                 break;
             }
             if ([viewController isKindOfClass:[SHBAutoTransferViewController class]])
             {
                 // 자동이체
                 
                 SHBAutoTransferViewController *vc = (SHBAutoTransferViewController *)viewController;
                 
                 switch (vc.processFlag) {
                     case 1:
                     case 3:
                     {
                         // 당행이체, 가상이체
                         [aDataSet insertObject:@"D2203" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     case 2:
                     {
                         // 타행이체
                         [aDataSet insertObject:@"D2233" forKey:@"거래구분" atIndex:0];
                     }
                         break;
                     default:
                         break;
                 }
                 
                 break;
             }
             if ([viewController isKindOfClass:NSClassFromString(@"SHBReservationTransferInfoInputViewController")])
             {
                 // 예약이체
                 [aDataSet insertObject:@"D2103" forKey:@"거래구분" atIndex:0];
                 
                 break;
             }
             if ([viewController isKindOfClass:NSClassFromString(@"SHBCelebrationTransferInfoInputViewController")])
             {
                 // 경조금이체
                 [aDataSet insertObject:@"D2023" forKey:@"거래구분" atIndex:0];
                 
                 break;
             }
         }
         
         self.service = [[[SHBSettingsService alloc] initWithServiceId:XDA_FOREIG viewController:self] autorelease];
         self.service.requestData = aDataSet;
         [self.service start];
     }
     else
     {
         NSLog(@"정보:%@", AppInfo.commonDic);  // 인증센터 
         SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                  @{
                                     TASK_NAME_KEY : @"sfg.rib.task.common.DepartureControlTask",
                                     TASK_ACTION_KEY : @"checkDeparture",
                                  @"조회자한글성명" : AppInfo.realServer ? AppInfo.commonDic[@"고객명"] : @"금결원", //성명이 금결원일때 테스트 정상 넘어감
                                  //@"조회자주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? AppInfo.commonDic[@"실명번호"] : @"",
                                  @"조회자주민등록번호" : AppInfo.commonDic[@"실명번호"],
                                  @"고객번호" : AppInfo.commonDic[@"고객번호"],
                                  @"거래구분" : @"C1101",
                                  }] autorelease];
         
         self.service = [[[SHBSettingsService alloc] initWithServiceId:XDA_FOREIG viewController:self] autorelease];
         self.service.requestData = aDataSet;
         [self.service start];
     
     }
    
       
}

- (IBAction)cancelButton:(id)sender
{
    [self.navigationController fadePopViewController];
}


#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
    
	
    //해외체류 XDA 전문 후  아래 연결해야함~
    
    
     if (_nextViewControlName)
     {
     // 다음에 열릴 클래스 오픈
     
     SHBBaseViewController *viewController = [[[[NSClassFromString(_nextViewControlName) class] alloc] initWithNibName:_nextViewControlName bundle:nil] autorelease];
     
     viewController.needsLogin = NO;
     [self checkLoginBeforePushViewController:viewController animated:YES];
     
     }
    
     else
     {
     int objectIndex = [[AppDelegate.navigationController viewControllers] count] - 3;
     [[[AppDelegate.navigationController viewControllers] objectAtIndex:objectIndex] viewControllerDidSelectDataWithDic:nil];
     }
     
     
	return NO;
}

@end
