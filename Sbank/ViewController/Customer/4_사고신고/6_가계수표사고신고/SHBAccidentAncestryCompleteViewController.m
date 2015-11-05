//
//  SHBAccidentAncestryCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentAncestryCompleteViewController.h"

@interface SHBAccidentAncestryCompleteViewController ()

@end

@implementation SHBAccidentAncestryCompleteViewController

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
    
    [self setTitle:@"사고신고"];
    [self navigationBackButtonHidden];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
