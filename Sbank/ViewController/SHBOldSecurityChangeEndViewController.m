//
//  SHBOldSecurityChangeEndViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOldSecurityChangeEndViewController.h"

@interface SHBOldSecurityChangeEndViewController ()

@end

@implementation SHBOldSecurityChangeEndViewController


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
    
    [self setTitle:@"구 사기예방 서비스 변경"];
    self.strBackButtonTitle = @"구 사기예방 서비스 변경";
     [self navigationBackButtonHidden];
}

- (IBAction)okButton:(id)sender
{
      [self.navigationController fadePopToRootViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}



@end
