//
//  SHBForeignerStep3ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForeignerStep3ViewController.h"
#import "SHBAttentionLabel.h"

@interface SHBForeignerStep3ViewController ()

@end

@implementation SHBForeignerStep3ViewController

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
    self.strBackButtonTitle = @"회원가입 3단계";
	[self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(UIButton*)sender{
	[AppDelegate.navigationController fadePopViewController];	//완료
	[AppDelegate.navigationController fadePopViewController];	//정보입력
	[AppDelegate.navigationController fadePopViewController];	//약관동의
	[AppDelegate.navigationController fadePopViewController];	//회원가입
	
}


@end
