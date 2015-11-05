//
//  SHBSurchargeCompleteViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 23..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSurchargeCompleteViewController.h"

@interface SHBSurchargeCompleteViewController ()

@end

@implementation SHBSurchargeCompleteViewController


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
            if (self.dicDataDictionary[@"계좌번호"])        // 조회화면에서 온 경우
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"listSurchargeComplete" object:nil];
            }
            else
            {
                [self.navigationController fadePopToRootViewController];
            }
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
    self.title = @"가입자부담금 입금";
    
    // back 버튼 없애기
    [self navigationBackButtonHidden];
    
    label1.text = [self.dicDataDictionary objectForKey:@"플랜명"];
    label2.text = [self.dicDataDictionary objectForKey:@"입금계좌번호"];
    label3.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    label4.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.dicDataDictionary objectForKey:@"이체금액"]]];
    
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
