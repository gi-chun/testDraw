//
//  SHBRetirementTermsViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 10..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementTermsViewController.h"

@interface SHBRetirementTermsViewController ()

@end

@implementation SHBRetirementTermsViewController


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 21:
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"퇴직연금";
    self.strBackButtonTitle = @"퇴직연금 동의서약관 보기";
    
    NSString *strURL = [NSString stringWithFormat:@"%@/yak/yak_agree.jsp", URL_M];
    
    if(!AppInfo.realServer)
    {
        strURL = @"http://dev-m.shinhan.com/yak/yak_agree.jsp";
    }
//    NSString *strURL = @"http://mdev.shinhan.com/yak/yak_agree.jsp";      // test 서버용
    NSURL *url = [NSURL URLWithString:[SHBUtility addTimeStamp:strURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView1 loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
