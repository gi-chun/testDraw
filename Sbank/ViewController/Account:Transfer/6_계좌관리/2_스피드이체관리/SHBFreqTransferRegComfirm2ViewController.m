//
//  SHBFreqTransferRegComfirm2ViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqTransferRegComfirm2ViewController.h"
#import "SHBAccountService.h"

@interface SHBFreqTransferRegComfirm2ViewController ()

@end

@implementation SHBFreqTransferRegComfirm2ViewController
@synthesize pViewController;
@synthesize pSelector;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
        case 100:
        {
            if(_txtNickName.text != nil && [_txtNickName.text length] > 0)
            {
                int checkCount = 0;
                for (int i = 0; i < [_txtNickName.text length]; i++) {
                    NSInteger ch = [_txtNickName.text characterAtIndex:i];
                    /**
                     A~Z : 65 ~ 90
                     a~z : 97 ~ 122
                     0~9 : 48 ~ 57
                     ㄱ ~ ㅣ : 12593 ~ 12643
                     가~ 힣(Hangul Syllabales): 44032 ~ 55203
                     **/
                    if (!((32 == ch) || (48 <= ch && ch <= 57) || (65 <= ch && ch <=92) || (97 <= ch && ch <= 122) || (44032 <= ch && ch <= 55203) || (12593 <= ch && ch <= 12643))) {
                        checkCount++;
                        break;
                    }
                }
                
                if (checkCount > 0 ) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"이체계좌별명은 한글과 영숫자만 입력이 가능합니다."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
            }
            
            NSDictionary *dic = @{
            @"입금계좌별명" : (_txtNickName.text != nil && [_txtNickName.text length] > 0) ? _txtNickName.text : self.data[@"입금자명"],
            @"출금계좌번호" : self.data[@"출금계좌번호"],
            @"입금은행" : self.data[@"입금은행"],
            @"입금은행코드" : self.data[@"입금은행코드"],
            @"입금계좌번호" : self.data[@"입금계좌번호"],
            @"입금자명" : self.data[@"입금자명"],
            @"이체금액" : self.data[@"이체금액"],
            @"받는분통장메모" : [SHBUtility substring:self.data[@"받는분통장메모"] ToMultiByteLength:14],
            @"보내는분통장메모" : [SHBUtility substring:self.data[@"보내는분통장메모"] ToMultiByteLength:14],
            };
            
            self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_INSERT viewController:self] autorelease];
            self.service.previousData = (SHBDataSet *)dic;
            [self.service start];
        }
            break;
        case 200:
        {
            [self.navigationController fadePopViewController];
        }
            break;
    }
    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSString *strMessage = [NSString stringWithFormat:@"스피드이체가 등록되었습니다."];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:strMessage
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
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
    
	if (textField == _txtNickName)
    {
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
		//한글 7자 제한(영문 14자)
		if (dataLength + dataLength2 > 22)
        {
			return NO;
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if(_txtNickName.text != nil && [_txtNickName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘이체계좌별명’ 내용이 입력한도를 초과했습니다.(한글 10자, 영숫자 20자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtNickName.text = [SHBUtility substring:_txtNickName.text ToMultiByteLength:20];
	}
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [self.pViewController performSelector:self.pSelector];
        [self.navigationController fadePopViewController];
	}
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
    
    self.title = @"계좌관리";
    
    NSArray *dataArray = @[
    self.data[@"출금계좌번호"],
    self.data[@"입금은행"],
    self.data[@"입금계좌번호"],
    self.data[@"입금자명"],
    [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:self.data[@"이체금액"]]],
    [SHBUtility substring:self.data[@"받는분통장메모"] ToMultiByteLength:14],
    [SHBUtility substring:self.data[@"보내는분통장메모"] ToMultiByteLength:14],
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtNickName release];
    [_lblData release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtNickName:nil];
    [self setLblData:nil];
    [super viewDidUnload];
}
@end
