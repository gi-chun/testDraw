//
//  SHBSecureKeyPadSettingViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 8. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSecureKeyPadSettingViewController.h"

@interface SHBSecureKeyPadSettingViewController ()
{
    BOOL isSearchPopupUse;
}
@end

@implementation SHBSecureKeyPadSettingViewController

- (void)dealloc
{
    [_btnSet release];
	[_btnNoSet release];
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
    [self setTitle:@"보안키패드 설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    
    isSearchPopupUse = [[[NSUserDefaults standardUserDefaults] getSecureSetting] isEqualToString:@"Y"];
    _btnNoSet.selected = !isSearchPopupUse;
    _btnSet.selected = isSearchPopupUse;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
	[self.btnNoSet setSelected:NO];
	[self.btnSet setSelected:NO];
	[sender setSelected:YES];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    if (self.btnSet.isSelected)
    {
        [[NSUserDefaults standardUserDefaults] setSecureSetting:@"Y"];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setSecureSetting:@"N"];
    }
    //[[NSUserDefaults standardUserDefaults] setSecureSetting:self.btnSet.isSelected ? @"Y" : @"N"];
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:337337 title:@"" message:@"보안키패드 설정이\n변경 되었습니다."];
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 337337) {
		[self.navigationController fadePopViewController];
	}
}
@end
