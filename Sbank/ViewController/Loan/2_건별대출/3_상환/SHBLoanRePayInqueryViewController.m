//
//  SHBLoanRePayInqueryViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanRePayInqueryViewController.h"
#import "SHBLoanRePayViewController.h"

@interface SHBLoanRePayInqueryViewController ()
- (BOOL)validationCheck;
@end

@implementation SHBLoanRePayInqueryViewController
@synthesize service;
@synthesize accountInfo;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
        case 100:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
        }
            break;
        case 200:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
        }
            break;
        case 300:
        {
            if(![self validationCheck]) return;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1220" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                         @"여신계좌번호" : self.accountInfo[@"대출계좌번호"],
                                         @"거래금액" : _txtRePayAmount.text,
                                         }] autorelease];
            [self.service start];
            
        }
            break;
        case 400:
        {
            AppInfo.isNeedClearData = YES;
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    SHBLoanRePayViewController *nextViewController = [[[SHBLoanRePayViewController alloc] initWithNibName:@"SHBLoanRePayViewController" bundle:nil] autorelease];
    nextViewController.accountInfo = self.accountInfo;
    nextViewController.data = aDataSet;
    nextViewController.nType = _btnSelector1.isSelected ? 0 : 1;
    [self.navigationController pushFadeViewController:nextViewController];
    return NO;
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtRePayAmount )
    {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 14)
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
				return NO;
			}
		}
	}
	
    return YES;
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지

    if(_txtRePayAmount.text == nil || [_txtRePayAmount.text length] == 0){
        strAlertMessage = @"상환원금을 입력해 주십시오.";
        goto ShowAlert;
    }

    if([_txtRePayAmount.text isEqualToString:@"0"]){
        strAlertMessage = @"상환원금은 0원을 입력하실 수 없습니다.";
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
    
    self.title = @"대출조회/상환";
    self.strBackButtonTitle = @"대출원리금 상환";
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        _btnSelector1.selected = YES;
        _btnSelector2.selected = NO;
        
        _txtRePayAmount.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnSelector1 release];
    [_btnSelector2 release];
    [_txtRePayAmount release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnSelector1:nil];
    [self setBtnSelector2:nil];
    [self setTxtRePayAmount:nil];
    [super viewDidUnload];
}
@end
