//
//  SHBDisposableCertificateViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDisposableCertificateViewController.h"
#import "SHBMobileCertificateService.h"

@interface SHBDisposableCertificateViewController ()

@end

@implementation SHBDisposableCertificateViewController

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
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    startTextFieldTag = 3331;
    endTextFieldTag = 3331;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[_nextViewControlName release];
	
    [_stepView release];
    [_textField release];
    [subTitleLabel release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [subTitleLabel release];
    subTitleLabel = nil;
    [_stepView release];
    _stepView = nil;
    [_textField release];
    _textField = nil;
    [super viewDidUnload];
}

#pragma mark - 

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController
{
    [self setTitle:aTitle];
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
	
	nextStep = step + 1;
	totalStep = stepCount;
	
	if (nextViewController) {
		SafeRelease(_nextViewControlName);
		_nextViewControlName = [[NSString alloc] initWithString:nextViewController];
	}
	
	// Max 10개까지만 Step 단계표시
	if (stepCount < 11){
		UIButton	*stepButtn;
		
		for (int i=stepCount; i>=1; i --) {
			stepButtn = (UIButton*)[self.view viewWithTag:i];
			float stepWidth = stepButtn.frame.size.width;
			float stepX = 311 - ((stepWidth+2) * ((stepCount+1) - i));
			[stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
			[stepButtn setHidden:NO];
			
			if (step >= i){
				stepButtn.selected = YES;
			}else{
				stepButtn.selected = NO;
			}
		}
	}
    
    [subTitleLabel setText:subTitle];
}

#pragma mark - Button

- (IBAction)okBtn:(id)sender
{
    if ([_textField.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"영업점에서 발급받은 1회용 인증번호를 입력하여 주십시오."];
        return;
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                            @"서비스코드" : @"T01421",
                            @"고객번호" : AppInfo.customerNo,
                            @"인증번호" : _textField.text
                            }];
    
    self.service = nil;
    self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E3019 viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (IBAction)cancelBtn:(id)sender
{
    [self.navigationController fadePopViewController];
    
    if ([_delegate respondsToSelector:@selector(disposableCertificateCancel)]) {
        [_delegate disposableCertificateCancel];
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (_nextViewControlName) {
        // 다음에 열릴 클래스 오픈
        
        SHBBaseViewController *viewController = [[[[NSClassFromString(_nextViewControlName) class] alloc] initWithNibName:_nextViewControlName bundle:nil] autorelease];
        
        viewController.needsLogin = NO;
        [self checkLoginBeforePushViewController:viewController animated:NO];
        
    } else {
        int objectIndex = [[AppDelegate.navigationController viewControllers] count] - 2;
        [[[AppDelegate.navigationController viewControllers] objectAtIndex:objectIndex] viewControllerDidSelectDataWithDic:nil];
    }
    
    return YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if ([textField.text length] >= 6 && range.length == 0) {
        return NO;
    }
    
	return YES;
}

@end
