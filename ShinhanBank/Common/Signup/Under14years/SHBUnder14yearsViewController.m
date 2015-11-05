//
//  SHBUnder14yearsViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUnder14yearsViewController.h"
#import "SHBAttentionLabel.h"

@interface SHBUnder14yearsViewController ()

@end

@implementation SHBUnder14yearsViewController

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
	
	self.title = @"회원가입";
	boxImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	SHBAttentionLabel* descMainLabel = [[SHBAttentionLabel alloc] initWithFrame:CGRectMake(8.0f, 15.0f, 300.0f, 160.0f)];
	descMainLabel.backgroundColor = [UIColor clearColor];
	descMainLabel.offsety = -7;
	descMainLabel.text = @"<lightGray_12>만 14세 미만의 고객은 회원가입시 정보통신망 이용촉진 및\n정보 등에 관한 법률 및 개인정보취급방침에 따라 법정대리인의\n정보활용 동의가 필요합니다. 당행 영업점을 통한 보호자분의\n홈페이지 회원법정대리인 등록이 완료된 고객에 한하여 회원\n등록이 가능하므로 홈페이지 회원 대리인 등록이 안된 고객님의\n보호자분께서는 먼저 가까운 영업점을 방문해 주시기 바랍니다.\n\n</lightGray_12><midBlue_12>[구비서류]\n</midBlue_12><lightGray_12>보호자(법정대리인) 실명확인 증표, 본인과 법정 대리인의\n관계입증 서류\n(미성년자 본인기준의 기본증명서와 가족관계 증명서)</lightGray_12>";
	[mainView addSubview:descMainLabel];
	[descMainLabel release];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)buttonPressed:(UIButton*)sender{
	[self.navigationController fadePopViewController];
}


@end
