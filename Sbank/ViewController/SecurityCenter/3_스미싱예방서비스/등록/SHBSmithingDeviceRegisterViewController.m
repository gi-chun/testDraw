//
//  SHBSmithingDeviceRegisterViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingDeviceRegisterViewController.h"
#import "SHBSmithingSecureMediaViewController.h"
#import "SHBMobileCertificateService.h"

@interface SHBSmithingDeviceRegisterViewController ()
{
    int falseCount;
}
@end

@implementation SHBSmithingDeviceRegisterViewController
@synthesize authField;

- (void)dealloc
{
    [authField release];
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
    [self setTitle:@"안심거래 서비스 기기등록"];
    self.strBackButtonTitle = @"안심거래 서비스 기기등록";
    falseCount = 0;
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    startTextFieldTag = 1000;
    endTextFieldTag = 1000;
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
    if([string length] > 1)
    {
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	
    // 숫자이외에는 입력안되게 체크
    NSString *NUMBER_SET = @"0123456789";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (!basicTest && [string length] > 0 )
    {
        return NO;
    }
    if (dataLength + dataLength2 > 6)
    {
        return NO;
    }
	
	
    return YES;
}

- (IBAction)buttonTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    
    switch (tmpBtn.tag)
    {
        case 1001:
        {
            if ([self.authField.text length] == 0) {
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
                                    @"인증번호" : self.authField.text
                                    }];
            
            self.service = nil;
            self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E3019 viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];

            

        }
            break;
        case 1002:
        {
            //취소
            [AppDelegate.navigationController fadePopViewController];
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSLog(@"aaaa:%@",aDataSet);
    self.data = aDataSet;
    if (!AppInfo.errorType) {
        //확인
        SHBSmithingSecureMediaViewController *viewController = [[SHBSmithingSecureMediaViewController alloc]initWithNibName:@"SHBSmithingSecureMediaViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    
    return NO;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    return YES;
}
@end
