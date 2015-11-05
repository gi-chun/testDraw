//
//  SHBDeviceRegistServiceDeleteCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceDeleteCompleteViewController.h"
#import "SHBDeviceRegistServiceViewController.h" // 등록폰 조회/삭제

@interface SHBDeviceRegistServiceDeleteCompleteViewController ()

@end

@implementation SHBDeviceRegistServiceDeleteCompleteViewController

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
    
    if ([AppInfo.commonDic[@"data"] count] == 1) {
        [_infoView1 setFrame:CGRectMake(0, 37 + 95, _infoView1.frame.size.width, _infoView1.frame.size.height)];
        [_infoView addSubview:_infoView1];
    }
    else {
        [_infoView2 setFrame:CGRectMake(0, 37 + 95, _infoView2.frame.size.width, _infoView2.frame.size.height)];
        [_infoView addSubview:_infoView2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_infoView1 release];
    [_infoView2 release];
    [_infoView release];
    [super dealloc];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    for (SHBDeviceRegistServiceViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBDeviceRegistServiceViewController") class]]) {
            [viewController deviceRegistServiceDeleteCompleteOK];
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

- (IBAction)cancelBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
