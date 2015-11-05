//
//  SHBExceptionDeviceCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 2. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBExceptionDeviceCompleteViewController.h"

#import "SHBExceptionDeviceViewController.h" // 예외 기기 로그인 알림 안내

@interface SHBExceptionDeviceCompleteViewController ()

@end

@implementation SHBExceptionDeviceCompleteViewController

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
    
    [self setTitle:@"예외 기기 로그인 알림"];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (IBAction)okPressed:(id)sender
{
    for (SHBExceptionDeviceViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBExceptionDeviceViewController") class]])
        {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
