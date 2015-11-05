//
//  SHBForexFavoritInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritInfoViewController.h"
#import "SHBExchangeService.h" // 서비스

#import "SHBForexFavoritListViewController.h" // 자주쓰는 해외송금 목록

@interface SHBForexFavoritInfoViewController ()

@end

@implementation SHBForexFavoritInfoViewController

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
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    self.strBackButtonTitle = @"자주쓰는 해외송금/조회 안내";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    SHBForexFavoritListViewController *viewController = [[[SHBForexFavoritListViewController alloc] initWithNibName:@"SHBForexFavoritListViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
