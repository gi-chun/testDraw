//
//  SHBGiroInpuCompleteViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroInpuCompleteViewController.h"

@interface SHBGiroInpuCompleteViewController ()

@end

@implementation SHBGiroInpuCompleteViewController

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
    
    self.title = @"지로입력납부";
    
    [self navigationBackButtonHidden];
    
    label1.text = [self.dicDataDictionary objectForKey:@"지로번호"];
    label2.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label3.text = [self.dicDataDictionary objectForKey:@"고객조회번호"];
    label4.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.dicDataDictionary objectForKey:@"납부금액"]]];
    label5.text = [self.dicDataDictionary objectForKey:@"납부연월"];
    label7.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    label8.text = [self.dicDataDictionary objectForKey:@"납부자명"];
    label9.text = [self.dicDataDictionary objectForKey:@"전화번호"];
    
    if ( ![self.dicDataDictionary[@"장표종류"] isEqualToString:@"M"] )      // MICR이 아닌경우만 표시됨(OCR, QCR의 경우)
    {
        label6.text = [self.dicDataDictionary objectForKey:@"금액검증번호"];
    }
    
    if ( [self.dicDataDictionary[@"장표종류"] isEqualToString:@"Q"] )       // 납부자 확인번호로 표시
    {
        labelChanged.text = @"납부자확인번호";
    }
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
