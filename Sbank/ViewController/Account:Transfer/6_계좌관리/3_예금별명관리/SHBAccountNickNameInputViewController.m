//
//  SHBAccountNickNameInputViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccountNickNameInputViewController.h"

@interface SHBAccountNickNameInputViewController ()
{
    
//    SHBTextField *currentTextField;
    int serviceType;
    
}
//@property (assign, nonatomic) SHBTextField *currentTextField;

@end

@implementation SHBAccountNickNameInputViewController
@synthesize service;
@synthesize outAccInfoDic;
//@synthesize currentTextField;

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
	if(_txtInNickName.text == nil || [_txtInNickName.text length] == 0 || [_txtInNickName.text length] > 15 )
	{
        strAlertMessage = @"계좌별명을 입력하세요.";
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

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
            // 은행선택
        case 10:
        {
            if (![self validationCheck]) {
                return;
            }
            
            serviceType = 0;
            
            // C2351 전문호출SHBAccountService
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"계좌번호" : [outAccInfoDic objectForKey:@"계좌번호"],
                                    @"은행구분" : @"0",
                                    @"등록해제구분" : @"1",
                                    @"등록해제코드" : @"21004",
                                    @"반복횟수" : @"1",
                                    @"변경후문자" : _txtInNickName.text,
                                    @"reservationField1" : @"update",
                                    }];
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2351" viewController: self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
            // 취소버튼
        case 20:
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    [_btnOk release];
    [_btnCancel release];
    [_txtInNickName release];
    
    [super dealloc];
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

    startTextFieldTag = 222000;
    endTextFieldTag = 222000;

    self.title = @"계좌관리";
    
    self.strBackButtonTitle = @"예금별명관리 입력";
    
    _txtInNickName.accDelegate = self;
    _lblData01.text = [outAccInfoDic objectForKey:@"과목명"];
    _lblData02.text = [outAccInfoDic objectForKey:@"계좌번호"];
    _txtInNickName.text = [outAccInfoDic objectForKey:@"상품부기명"];

    _txtInNickName.strLableFormat = @"입력된 계좌별명은 %@ 입니다";
    _txtInNickName.strNoDataLable = @"입력된 계좌별명이 없습니다. 한글 12자리, 영문24자리 이내 입력";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
	if (textField == _txtInNickName)
    {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()-_=+{}|[]\\;:\'\"<>?,./`~";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		//한글 12자 제한(영문 24자)
		if (dataLength + dataLength2 > 26)
        {
			return NO;
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_txtInNickName.text != nil && [_txtInNickName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 24 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘계좌별명'은 한글 12자, 영숫자 24자 이상을 입력할 수 없습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];

        [alert show];
        [alert release];
        _txtInNickName.text = [SHBUtility substring:_txtInNickName.text ToMultiByteLength:24];
	}
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
            if([strController isEqualToString:@"SHBAccountNickNameListViewController"])
            {
                [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
            break;
            
        default:
            break;
    }

    return NO;
}

@end
