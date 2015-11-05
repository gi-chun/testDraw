//
//  SHBDeviceRegistServiceCloseCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceCloseCompleteViewController.h"

@interface SHBDeviceRegistServiceCloseCompleteViewController ()

@end

@implementation SHBDeviceRegistServiceCloseCompleteViewController
@synthesize sumLimitLabel;

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
    self.sumLimitLabel.text = AppInfo.versionInfo[@"추가인증한도금액_MSG"];
    [_subTitle initFrame:_subTitle.frame];
    [_subTitle setCaptionText:@"이용기기 등록 서비스 해지완료"];
    
    [self navigationBackButtonHidden];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:@{ @"_해지일" : AppInfo.tran_Date }];
    [self.binder bind:self dataSet:dataSet];
    
    [AppInfo.userInfo setObject:@"" forKey:@"이용기기등록여부"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_subTitle release];
    [super dealloc];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
