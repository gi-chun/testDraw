//
//  SHBSearchPopupSettingViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 25..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSearchPopupSettingViewController.h"

@interface SHBSearchPopupSettingViewController ()
{
    BOOL isSearchPopupUse;
}
@end

@implementation SHBSearchPopupSettingViewController

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

	[self setTitle:@"검색팝업 설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    
    isSearchPopupUse = [[[NSUserDefaults standardUserDefaults] getSearchPopup] isEqualToString:@"Y"];
    _btnNoSet.selected = !isSearchPopupUse;
    _btnSet.selected = isSearchPopupUse;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[_btnSet release];
	[_btnNoSet release];
	[super dealloc];
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
	[self.btnNoSet setSelected:NO];
	[self.btnSet setSelected:NO];
	[sender setSelected:YES];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] setSearchPopup:self.btnSet.isSelected ? @"Y" : @"N"];
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:337337 title:@"" message:@"검색팝업 설정이 변경 되었습니다."];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
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
