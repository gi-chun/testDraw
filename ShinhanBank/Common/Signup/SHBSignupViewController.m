//
//  SHBSignupViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupViewController.h"
#import "SHBAttentionLabel.h"
#import "SHBUnder14yearsViewController.h"
#import "SHBSignupStep1ViewController.h"

@interface SHBSignupViewController ()

@end

@implementation SHBSignupViewController

- (void)dealloc{
    
    
	[super dealloc];
    [boxImageView release];
    [topView release];
    [btmView release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	self.title = @"회원가입";
    self.strBackButtonTitle = @"회원가입";
    
    boxImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	SHBAttentionLabel* descTopLabel = [[SHBAttentionLabel alloc] initWithFrame:CGRectMake(8.0f, 3.0f, 301.0f, 51.0f)];
	descTopLabel.backgroundColor = [UIColor clearColor];
	descTopLabel.offsety = -7;
	descTopLabel.text = @"<midGray_13>회원가입을 하시면 계좌조회가 가능합니다.\n이체 서비스 이용을 위해서는 영업점을 방문하시어 온라인\n서비스를 신청해 주시기 바랍니다.</midGray_13>";
	[topView addSubview:descTopLabel];
	[descTopLabel release];
	
	
	SHBAttentionLabel* descMainLabel = [[SHBAttentionLabel alloc] initWithFrame:CGRectMake(8.0f, 10.0f, 300.0f, 190.0f)];
	descMainLabel.backgroundColor = [UIColor clearColor];
	descMainLabel.offsety = -7;
	descMainLabel.text = @"<midBlue_12>본 사이트는 정보통신망 이용촉진에 관한 법률에 따라 고객님의\n동의를 받은 후 회원가입을 받고 있습니다.</midBlue_12><lightGray_12>\n\n2006년 9월 24일부터 개정된 주민등록법에 의해 타인의\n주민등록번호를 도용하여 홈페이지 회원가입을 하는 등 </lightGray_12><darkGray_12>타인의\n주민등록번호 부정사용자는 3년 이하의 징역 또는 1천만원\n이하의 벌금이 부과됩니다.</darkGray_12><lightGray_12> (관련법률:주민등록법 제21조(벌칙)\n제2항9호(시행일2006.9.24))\n\n만약, 타인의 주민등록번호를 도용하여 홈페이지 회원가입을\n하신 회원이 있으시다면, 즉시 명의도용을 중지하여 주시길\n바랍니다.</lightGray_12>";
	[btmView addSubview:descMainLabel];
	[descMainLabel release];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)buttonPressed:(UIButton*)sender{
	if (sender.tag == 10){
		// 개인회원(만14세이상)
		SHBSignupStep1ViewController *viewController = [[SHBSignupStep1ViewController alloc] initWithNibName:@"SHBSignupStep1ViewController" bundle:nil];
		[viewController executeWithStep:1 StepCnt:6 NextControllerName:@"SHBOver14yearsStep2ViewController"];
        
		[self.navigationController pushFadeViewController:viewController];
		[viewController release];
		
	}else if (sender.tag == 20){
		// 만14세 미만
		SHBUnder14yearsViewController *viewController = [[SHBUnder14yearsViewController alloc] initWithNibName:@"SHBUnder14yearsViewController" bundle:nil];
		[self.navigationController pushFadeViewController:viewController];
		[viewController release];
		
	}else if (sender.tag == 30){
		// 외국인
		SHBSignupStep1ViewController *viewController = [[SHBSignupStep1ViewController alloc] initWithNibName:@"SHBSignupStep1ViewController" bundle:nil];
		[viewController executeWithStep:1 StepCnt:3 NextControllerName:@"SHBForeignerStep2ViewController"];
		[self.navigationController pushFadeViewController:viewController];
		[viewController release];
		
	}
	
	
}


@end
