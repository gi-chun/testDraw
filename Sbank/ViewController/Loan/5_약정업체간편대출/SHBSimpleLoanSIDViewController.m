//
//  SHBSimpleLoanSIDViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanSIDViewController.h"
#import "SHBLoanService.h" // service
#import "EccEncryptor.h"

#import "SHBSimpleLoanInfoViewController.h" // 약정업체 간편대출 안내
#import "SHBSimpleLoanStipulationViewController.h" // 약정업체 간편대출 약관동의

@interface SHBSimpleLoanSIDViewController ()

@end

@implementation SHBSimpleLoanSIDViewController

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
    self.strBackButtonTitle = @"약정업체 간편대출 주민등록번호 확인";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 100: {
            
            // 확인
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_E1800_SERVICE viewController:self] autorelease];
            self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{ }];
            [self.service start];
        }
            break;
            
        case 200: {
            
            // 취소
            
            for (SHBSimpleLoanInfoViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBSimpleLoanInfoViewController class]]) {
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
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
    
    SHBSimpleLoanStipulationViewController *viewController = [[[SHBSimpleLoanStipulationViewController alloc] initWithNibName:@"SHBSimpleLoanStipulationViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

@end
