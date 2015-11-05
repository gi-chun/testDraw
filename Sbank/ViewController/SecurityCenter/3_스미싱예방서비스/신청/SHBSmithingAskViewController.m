//
//  SHBSmithingAskViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingAskViewController.h"


@interface SHBSmithingAskViewController ()

@end

@implementation SHBSmithingAskViewController
@synthesize checkBtn;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [checkBtn release];
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
    [self setCheckBtn:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"안심거래 서비스 신청"];
    self.strBackButtonTitle = @"안심거래 서비스 신청";
    
    
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
            //동의 체크박스 체크
            [sender setSelected:![sender isSelected]];
        }
            break;
        case 1001:
        {
            //확인
            if (![self.checkBtn isSelected])
            {
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:nil message:@"안심거래 서비스 주의사항을 읽고 동의하셔야 등록이 가능합니다."];
                
                return;
            }
            
            SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
            [viewController setServiceSeq:SERVICE_CHEET_DEFENCE_RE];
            viewController.needsLogin = YES;
            viewController.delegate = self;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"안심거래 서비스 신청" Step:2 StepCnt:5 NextControllerName:@"SHBSmithingSecureMediaViewController"];
            [viewController subTitle:@"서비스 신청(SMS 인증)"];
            [viewController release];
            
 
        }
            break;
        case 1002:
        {
            //취소
            [AppDelegate.navigationController fadePopViewController];
        }
            break;
        default:
            break;
    }
}


@end
