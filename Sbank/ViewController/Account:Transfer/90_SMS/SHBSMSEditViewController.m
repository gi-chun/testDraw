//
//  SHBSMSEditViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSMSEditViewController.h"
#import "SHBUtility.h"

@interface SHBSMSEditViewController ()
{
    SHBTextField *currentTextField;
}
@property (nonatomic, retain) SHBTextField *currentTextField;

@end

@implementation SHBSMSEditViewController
@synthesize pViewController;
@synthesize pSelector;
@synthesize currentTextField;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
        case 100:
        {
            if(![self validationCheck]) return;
            
            [self.pViewController performSelector:self.pSelector withObject:@{@"Sender" : _txtSenderName.text}];
            
            [self.navigationController fadePopViewController];
        }
            break;
        case 200:
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
	if(_txtSenderName.text == nil || [_txtSenderName.text length] <= 0 || [_txtSenderName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 80 )
	{
        strAlertMessage = @"‘의뢰인 성명’ 입력한도를 초과했습니다.(한글 5자, 영숫자 10자)";
        goto ShowAlert;
	}
    
ShowAlert:
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:nil
												   cancelButtonTitle:@"확인"
												   otherButtonTitles:nil] autorelease];
		[alertView show];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = (SHBTextField*)textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
    //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
    NSString *SPECIAL_CHAR = @"$₩€£¥•";
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (basicTest && [string length] > 0 )
    {
        return NO;
    }
    //한글 5자 제한(영문 10자)
    if (dataLength + dataLength2 > 12)
    {
        return NO;
    }
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _txtSenderName && [_txtSenderName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 10 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘의뢰인 성명’이 입력한도를 초과했습니다.(한글 5자, 영숫자 10자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtSenderName.text = [SHBUtility substring:_txtSenderName.text ToMultiByteLength:10];
	}
}

#pragma mark -
#pragma mark SHBTextFieldDelegate

- (void)didPrevButtonTouch          // 이전버튼
{
	[currentTextField resignFirstResponder];
}

- (void)didNextButtonTouch          // 다음버튼
{
	[currentTextField resignFirstResponder];
}

- (void)didCompleteButtonTouch      // 완료버튼
{
	[currentTextField resignFirstResponder];
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
    
    self.title = AppInfo.eSignNVBarTitle;
    _txtSenderName.accDelegate = self;
    
    _txtSenderName.strLableFormat = @"입력된 의뢰인 성명은 %@ 입니다";
    _txtSenderName.strNoDataLable = @"입력된 의뢰인 성명이 없습니다";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_txtSenderName release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTxtSenderName:nil];
    [super viewDidUnload];
}
@end
