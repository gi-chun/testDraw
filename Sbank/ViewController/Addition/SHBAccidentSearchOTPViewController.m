//
//  SHBAccidentSearchOTPViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchOTPViewController.h"
#import "SHBCustomerService.h"

@interface SHBAccidentSearchOTPViewController ()

@end

@implementation SHBAccidentSearchOTPViewController

#pragma mark - Button

// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

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
	[self setTitle:@"사고신고 조회"];

	// E4120 전문호출
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_E4120_SERVICE viewController: self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
    
    // 등록된 분실 OTP카드가 없을때의 서버얼럿을 받았을때를 처리하기 위한 노티
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(okBtn:) name:@"notiServerError" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSString *tmp = aDataSet[@"분실일"];
	
	if ([tmp isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"사고신고된 OTP카드가 없습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
        [self.navigationController fadePopToRootViewController];
        
		return NO;
	} else {
        [aDataSet insertObject:[NSString stringWithFormat:@"%@(%@)",aDataSet[@"분실일"], aDataSet[@"분실시간"]] forKey:@"사고등록일자" atIndex:0];
    }
    
    NSLog(@"aDataSet : %@", aDataSet);
    
    return YES;
}

@end
