//
//  SHBLoanBizNoVisitListDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitListDetailViewController.h"

#import "SHBLoanBizNoVisitViewController.h" // 직장인 최적상품(무방문대출) 신청 안내

@interface SHBLoanBizNoVisitListDetailViewController ()

@end

@implementation SHBLoanBizNoVisitListDetailViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인신용대출상품 안내";
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:self.data[@"C_PROD_NAME"]];
    
    [[[_contentWV subviews] lastObject] setBounces:NO];
    [_contentWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:self.data[@"WEB_VIEW_URL"]]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_contentWV release];
    [_subTitleView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentWV:nil];
    [self setSubTitleView:nil];
    [super viewDidUnload];
}
#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    SHBLoanBizNoVisitViewController *viewController = [[[SHBLoanBizNoVisitViewController alloc] initWithNibName:@"SHBLoanBizNoVisitViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}
@end
