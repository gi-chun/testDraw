//
//  SHBCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBCancelCompleteViewController.h"

@interface SHBCancelCompleteViewController ()

@end

@implementation SHBCancelCompleteViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 21:            // 확인 버튼
        {
            [self.navigationController fadePopToRootViewController];
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
    
    // title 설정
    self.title = @"지로납부내역 조회취소";
    
    // back 버튼 없애기
    [self navigationBackButtonHidden];
    
    label1.text = [self.dicDataDictionary objectForKey:@"납부일자"];
    label2.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    label3.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [self.dicDataDictionary objectForKey:@"이용기관지로번호"];
    label5.text = [NSString stringWithFormat:@"%@원", [self.dicDataDictionary objectForKey:@"납부금액"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
