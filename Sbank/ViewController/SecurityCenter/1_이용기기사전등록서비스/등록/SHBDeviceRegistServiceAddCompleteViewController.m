//
//  SHBDeviceRegistServiceAddCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceAddCompleteViewController.h"

@interface SHBDeviceRegistServiceAddCompleteViewController ()

@end

@implementation SHBDeviceRegistServiceAddCompleteViewController

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
    
    [self setTitle:@"이용기기 등록 서비스"];
    [self navigationBackButtonHidden];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    [AppInfo.userInfo setObject:@"1" forKey:@"이용기기등록여부"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
	[self.navigationController fadePopToRootViewController];
}

@end
