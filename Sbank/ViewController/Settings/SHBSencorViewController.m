//
//  SHBSencorViewController.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSencorViewController.h"

@interface SHBSencorViewController ()

@end

@implementation SHBSencorViewController

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
	[self setTitle:@"가속도센서 설정"];
	
	BOOL isOn = [[NSUserDefaults standardUserDefaults]isUsingLandscapeMode];
	[self.landscapeSwitch setOn:isOn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[_landscapeLabel release];
	[_landscapeSwitch release];
	[_confirmButton release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setLandscapeLabel:nil];
	[self setLandscapeSwitch:nil];
	[self setConfirmButton:nil];
	[super viewDidUnload];
}

#pragma mark - Action
- (IBAction)confirmButtonAction:(UIButton *)sender {
	BOOL isOn = [self.landscapeSwitch isOn];
	
	[[NSUserDefaults standardUserDefaults]setIsUsingLandscapeMode:isOn];
	
	[self.navigationController fadePopViewController];
}

@end
