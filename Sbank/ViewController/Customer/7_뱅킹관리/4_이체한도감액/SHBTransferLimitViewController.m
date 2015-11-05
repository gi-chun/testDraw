//
//  SHBTransferLimitViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBTransferLimitViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"
#import "SHBTransferLimitStep2ViewController.h"

@interface SHBTransferLimitViewController ()

- (void)alertViewShow:(NSString *)aMessage; // 알럿뷰 호출

@end

@implementation SHBTransferLimitViewController

#pragma mark -
#pragma mark Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"C2141"]) {
        
        // 전문결과 데이타셋에 저장
        self.viewDataSet = aDataSet;
        
        // 전문결과 반영
        self.label1.text = [NSString stringWithFormat:@"%@원", aDataSet[@"변경전1일이체한도"]];
        self.label2.text = [NSString stringWithFormat:@"%@원", aDataSet[@"변경전1회이체한도"]];
    }
    
    return NO;
}


#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            // 확인버튼 선택 시
            NSString *stringTemp1 = [self.textField1.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSString *stringTemp2 = [self.textField2.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            // (1) 감액할 1일 이체한도를 미 입력 시
            if (![self.textField1.text length]) {
                
                [self alertViewShow:@"변경 후 1일 이체한도를 입력하여 주십시오."];
                return;
            }
            
            // (2) 감액할 1회 이체한도를 미 입력 시
            if (![self.textField2.text length]) {
                
                [self alertViewShow:@"변경 후 1회 이체한도를 입력하여 주십시오."];
                return;
            }
            
            // (3) 감액할 두 개의 이체한도 (1일/1회)와 변경 전 이체한도가 동일한 경우
            if ([stringTemp1 longLongValue] == [self.viewDataSet[@"변경전1일이체한도->originalValue"] longLongValue] &&
                [stringTemp2 longLongValue] == [self.viewDataSet[@"변경전1회이체한도->originalValue"] longLongValue]) {
                
                [self alertViewShow:@"변경 전 이체한도와 변경 후 이체한도가 동일합니다."];
                return;
            }
            
            // (4) 감액할 이체한도가 현재 입력한 이체한도보다 클 경우
            if ([stringTemp1 longLongValue] > [self.viewDataSet[@"변경전1일이체한도->originalValue"] longLongValue] ||
                [stringTemp2 longLongValue] > [self.viewDataSet[@"변경전1회이체한도->originalValue"] longLongValue]) {
                
                [self alertViewShow:@"감액 이체한도는 현재 이체한도를 초과할 수 없습니다."];
                return;
            }
            
            // (5) 1회 이체한도가 1일 이체한도보다 클 경우
            if ([stringTemp1 longLongValue] < [stringTemp2 longLongValue]) {
                
                [self alertViewShow:@"1회 이체한도는 1일 이체한도를 초과하여 변경할 수 없습니다."];
                return;
            }
            
            // 보안매체에서 사용할 데이타셋 초기화
            self.viewDataSet[@"a감액할1일이체한도"] = self.textField1.text;
            self.viewDataSet[@"a감액할1회이체한도"] = self.textField2.text;
            
            AppInfo.commonDic = self.viewDataSet;
            
            // 다음화면으로 이동
            SHBTransferLimitStep2ViewController *viewController = [[SHBTransferLimitStep2ViewController alloc] initWithNibName:@"SHBTransferLimitStep2ViewController" bundle:nil];
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }   break;
        case 1:
            // 취소버튼 선택 시
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if([string length] > 1) {
        
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
	if (textField == self.textField1 || textField == self.textField2) {
        
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 ) {
            
			return NO;
		}
        
		if (dataLength + dataLength2 > 14) {
            
			return NO;
		}
		else {
            
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]]) {
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
                
				return NO;
			}
            else {
                
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


#pragma mark -
#pragma mark Private Methods

- (void)alertViewShow:(NSString *)aMessage
{
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:aMessage];
}


#pragma mark -
#pragma mark SHBTextFieldDelegate Methods

- (void)didCompleteButtonTouch
{
    // 키보드 완료 버튼 선택 시, 스크롤 원복 - 예외처리
    [UIView animateWithDuration:0.4f animations:^(){
       
        self.contentScrollView.contentSize = self.contentView.frame.size;
        [super didCompleteButtonTouch];
    }];
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }    
    return self;
}

- (void)dealloc
{
    self.contentView = nil;
    self.label1 = nil;
    self.label2 = nil;
    self.textField1 = nil;
    self.textField2 = nil;
    self.securityCenterService = nil;
    self.viewDataSet = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // 입력필드 초기화 여부 체크
    if ([AppInfo.commonDic[@"INPUT_VALUE_INIT"] isEqualToString:@"YES"]) {
        
        self.textField1.text = @"";
        self.textField2.text = @"";
    }
    
    // 이체한도조회
    self.securityCenterService = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_C2141_SERVICE viewController:self] autorelease];
    
    [self.securityCenterService start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 네비게이션 바 타이틀 초기화
    [self setTitle:@"이체한도감액"];
    
    // 서브 타이틀 초기화
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이체한도감액" maxStep:3 focusStepNumber:1] autorelease]];
    
    // 화면 초기화
    self.contentScrollView.contentSize = self.contentView.frame.size;
    
    // 텍스트필드 태그 초기화
    startTextFieldTag = 1000;
    endTextFieldTag = 1001;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
