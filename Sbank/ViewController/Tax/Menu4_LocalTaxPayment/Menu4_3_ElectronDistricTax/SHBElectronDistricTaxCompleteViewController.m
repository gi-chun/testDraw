//
//  SHBElectronDistricTaxCompleteViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 21..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBElectronDistricTaxCompleteViewController.h"

@interface SHBElectronDistricTaxCompleteViewController ()

@end

@implementation SHBElectronDistricTaxCompleteViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 21:                // 확인 버튼
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
    
    self.title = @"지방세납부";
    
    [self navigationBackButtonHidden];
    
    label1.text = [self.dicDataDictionary objectForKey:@"납부자성명"];
    label2.text = [self.dicDataDictionary objectForKey:@"세목명"];
    label3.text = [self.dicDataDictionary objectForKey:@"전자납부번호"];
    label4.text = [NSString stringWithFormat:@"%@원", [self.dicDataDictionary objectForKey:@"과세표준금액"]];
    label5.text = [self.dicDataDictionary objectForKey:@"과세대상"];
    label6.text = [self.dicDataDictionary objectForKey:@"납기내납기일"];
    label7.text = [self.dicDataDictionary objectForKey:@"납기후납기일"];
    label8.text = [NSString stringWithFormat:@"%@원", [self.dicDataDictionary objectForKey:@"납부금액"]];
    label9.text = [self.dicDataDictionary objectForKey:@"출금계좌번호"];
    label10.text = [NSString stringWithFormat:@"%@(%@)", [self.dicDataDictionary objectForKey:@"거래일자"], [self.dicDataDictionary objectForKey:@"거래시간"]];
    
    // 납기 내후에 따라 강조 처리
    if ([self.dicDataDictionary[@"납기내후구분"] isEqualToString:@"B"])
    {
        [view1 setHidden:NO];
    }
    else
    {
        [view2 setHidden:NO];
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
