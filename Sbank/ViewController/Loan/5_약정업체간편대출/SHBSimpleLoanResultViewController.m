//
//  SHBSimpleLoanResultViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanResultViewController.h"
#import "SHBLoanService.h" // service

@interface SHBSimpleLoanResultViewController ()

@end

@implementation SHBSimpleLoanResultViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"업무구분" : @"1",
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3223_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_productName release];
    [_hiddenView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setProductName:nil];
    [self setHiddenView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    self.dataList = [aDataSet arrayWithForKey:@"승인내역"];
    
    if ([self.dataList count] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신청결과조회 내역이 없습니다."];
        return NO;
    }
    
    [_hiddenView setHidden:YES];
    
    for (NSMutableDictionary *dic in self.dataList) {
        
        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"대출신청정수금액"]]
                forKey:@"_신청금액"];
    }
    
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
    
    NSSortDescriptor *sortOrder = [[[NSSortDescriptor alloc] initWithKey:@"신청일자" ascending:NO] autorelease];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
    
    self.dataList = (NSArray *)tempArray;
    
    self.data = self.dataList[0];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    [_productName initFrame:_productName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_productName setCaptionText:self.data[@"상품명"]];
    
    return YES;
}

@end
