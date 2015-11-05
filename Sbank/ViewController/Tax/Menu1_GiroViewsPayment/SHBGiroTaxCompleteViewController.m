//
//  SHBGiroTaxCompleteViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxCompleteViewController.h"

@interface SHBGiroTaxCompleteViewController ()

@end

@implementation SHBGiroTaxCompleteViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 21:
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
    
    self.title = @"지로조회납부";
    
    [self navigationBackButtonHidden];
    
    label1.text = [self.dicDataDictionary objectForKey:@"지로번호"];
    label2.text = [self.dicDataDictionary objectForKey:@"전자납부번호"];
    label3.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [self.dicDataDictionary objectForKey:@"고객조회번호"];
    label5.text = [self.dicDataDictionary objectForKey:@"납부자성명"];
    label6.text = [NSString stringWithFormat:@"%@원", [self.dicDataDictionary objectForKey:@"납부금액"]];
    label7.text = [self.dicDataDictionary objectForKey:@"고지형태->display"];
    label8.text = [self.dicDataDictionary objectForKey:@"부과년월"];
    label9.text = [self.dicDataDictionary objectForKey:@"납부기한"];
    
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
