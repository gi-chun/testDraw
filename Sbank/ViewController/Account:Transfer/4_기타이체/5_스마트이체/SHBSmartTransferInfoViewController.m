//
//  SHBSmartTransferInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 2..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartTransferInfoViewController.h"
#import "SHBProductService.h" // 서비스

#import "SHBNewProductInfoViewController.h" // 상품정보 안내

@interface SHBSmartTransferInfoViewController ()

@end

@implementation SHBSmartTransferInfoViewController

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
    
    [self setTitle:@"스마트 이체 안내"];
    self.strBackButtonTitle = @"스마트 이체 안내";
    
    [_info1 initFrame:_info1.frame];
    [_info1 setText:@"<midRed_15>『스마트이체』</midRed_15><midGray_15> 서비스는 </midGray_15><midRed_15>신한 저축습관 만들기 적금</midRed_15><midGray_15>의 부가서비스입니다.</midGray_15>"];
    
    [_productInfoBtn.titleLabel setNumberOfLines:0];
    [_productInfoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_info1 release];
    [_productInfoBtn release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfo1:nil];
    [self setProductInfoBtn:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        [self.navigationController fadePopToRootViewController];
        
        return;
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 상품안내 바로가기
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                                                         TASK_ACTION_KEY : @"getPrdNewList",
                                                                         @"상품코드" : @"230011831",
                                                                         @"attributeNamed" : @"mode",
                                                                         @"attributeValue" : @"ECHO",
                                                                         }];
            
            self.service = nil;
            self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00004_1 viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
            break;
            
        case 200: {
            
            // 확인
            
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    if (self.service.serviceId == XDA_S00004_1) {
        
        NSArray *array = [aDataSet arrayWithForKeyPath:@"data"];
        
        SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
        
        viewController.dicSelectedData = array[0];
        
        [AppDelegate.navigationController pushFadeViewController:viewController];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

@end
