//
//  SHBForexRequestCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestCompleteViewController.h"
#import "SHBExchangeService.h" // 서비스

@interface SHBForexRequestCompleteViewController ()

@end

@implementation SHBForexRequestCompleteViewController

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
    
    [self setTitle:@"외화환전신청"];
    [self navigationBackButtonHidden];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    
    if ([dataSet[@"_쿠폰번호"] length] != 0) {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"고객번호" : AppInfo.customerNo,
                                @"일련번호" : dataSet[@"_쿠폰번호"],
                                @"계속사용여부" : @"1",
                                }];
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_E2613_SERVICE
                                                       viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
	[super viewDidUnload];
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    AppInfo.indexQuickMenu = 0;
    
    [self.navigationController fadePopToRootViewController];
}

@end
