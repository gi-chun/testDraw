//
//  SHBGiroTaxInputNoViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxInputNoViewController.h"
#import "SHBGiroTaxInputContentViewController.h"        // 다음 view
#import "SHBAccountService.h"                           // 예금계좌 service
#import "SHBGiroTaxListService.h"                       // 지로조회납부 service
#import "SHBAlertPopupView.h"


@interface SHBGiroTaxInputNoViewController ()

@end

@implementation SHBGiroTaxInputNoViewController


#pragma mark -
#pragma mark Synthesize

@synthesize encriptedPW;



#pragma mark -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString    *strErrorMessage    = @"입력값을 확인해 주세요.";
    
    if ( nil == labelGiroNumber.text || [labelGiroNumber.text isEqualToString:@""] )
    {
        strErrorMessage = @"지로번호를 선택해 주십시오.";
        goto errorCase;
    }
    else if ( nil == textFieldAmount.text || [textFieldAmount.text isEqualToString:@""] )
    {
        strErrorMessage = @"납부금액을 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [textFieldAmount.text isEqualToString:@"0"] )
    {
        strErrorMessage = @"'납부금액'은 0원을 입력하실 수 없습니다.";
        goto errorCase;
    }
    else if ( nil == textFieldSearchNumber.text || [textFieldSearchNumber.text isEqualToString:@""] )
    {
        strErrorMessage = @"고객조회번호를 입력해 주십시오.";
        if ([strGiroKind isEqualToString:@"Q"] || [strGiroKind isEqualToString:@"M"])
        {
            strErrorMessage = @"납부자확인번호를 입력해 주십시오.";
        }
        goto errorCase;
    }
    else if ( nil == monthField1.textField.text || [monthField1.textField.text isEqualToString:@""] )
    {
        strErrorMessage = @"납부연월을 선택하십시오.";
        goto errorCase;
    }
    else if ( ![strGiroKind isEqualToString:@"M"] && (nil == textFieldVerificationNumber.text || [textFieldVerificationNumber.text isEqualToString:@""]) )
    {
        strErrorMessage = @"금액검증번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( nil == buttonAccount.titleLabel.text || [buttonAccount.titleLabel.text isEqualToString:@""] || [buttonAccount.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다"] )
    {
        strErrorMessage = @"출금계좌를 선택하여 주십시오.";
        goto errorCase;
    }
    else if ( nil == textFieldPassword.text || [textFieldPassword.text isEqualToString:@""] )
    {
        strErrorMessage = @"출금계좌비밀번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [textFieldPassword.text length] != 4 )
    {
        strErrorMessage = @"출금계좌비밀번호는 4자리를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( nil == textFieldName.text || [textFieldName.text isEqualToString:@""] )
    {
        strErrorMessage = @"납부자성명을 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [textFieldName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 16 )
    {
        strErrorMessage = @"성명이 입력한도를 초과했습니다.(한글 8자, 영숫자 16자)";
        goto errorCase;
    }
    else if ( nil == textFieldPhoneNumber.text || [textFieldPhoneNumber.text isEqualToString:@""] )
    {
        strErrorMessage = @"연락전화번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [textFieldPhoneNumber.text length] < 9 || [textFieldPhoneNumber.text length] > 12 )
    {
        strErrorMessage = @"전화번호를 9~12자 입력하여 주십시오.";
        goto errorCase;
    }
    
    return isError;
    
errorCase:
    {
        isError = YES;
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        
        return isError;
    }
}

- (void)getOutAccountList
{
    NSMutableArray *tableDataArray = [self outAccountList];
    
    if ([tableDataArray count] == 0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"출금가능 계좌가 없습니다."];
        return;
    }
    
    // 계좌 정보 전달을 위해
    self.dataList = (NSArray *)tableDataArray;
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    [self didCompleteButtonTouch];
    
    switch ([sender tag]) {
            
        case 10:        // 지로번호
        {
            //팝업뷰 오픈
            giroNumberSearchPopupView = [[SHBPopupView alloc] initWithTitle:@"지로번호 조회" subView:viewSearchView topHeight:80];
            giroNumberSearchPopupView.delegate = self;
            [giroNumberSearchPopupView showInView:self.navigationController.view animated:YES];
            [giroNumberSearchPopupView release];
        }
            break;
            
        case 11:        // 도움말
        case 12:
        {
            //팝업뷰 오픈
//            SHBAlertPopupView *popupView = //[[SHBAlertPopupView alloc] initWithString:@"블라블라블라" ButtonCount:2 SubViewHeight:160];
//            [[SHBAlertPopupView alloc] initWithString:@"블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라" ButtonCount:2 SubViewHeight:160];
//            [popupView showInView:self.navigationController.view animated:YES];
//            [popupView release];
            //팝업뷰 오픈
            SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"도움말" subView:viewHelpView];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 13:        // 계좌번호 button
        {
            // 계좌 리스트를 얻어온다
            [self getOutAccountList];
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:(NSMutableArray *)self.dataList CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 14:        // 잔액조회
        {
            if ( nil == buttonAccount.titleLabel.text || [buttonAccount.titleLabel.text isEqualToString:@""])
            {
                return;
            }
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : buttonAccount.titleLabel.text}] autorelease];
            [self.service start];
        }
            break;
            
        case 21:        // 확인
        {
            if ([self checkException])
            {
                return;
            }
            
            SHBDataSet     *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                                           @{
                                           @"출금계좌비밀번호"          : textFieldPassword.text,
                                           @"출금계좌번호"            : buttonAccount.titleLabel.text,
                                           @"은행구분"              : [dicAccountDic objectForKey:@"은행코드"], // (!주의)신, 구 계좌에 따른 값 변경 있음 정보처리되어서 옴
                                           @"납부금액"              : textFieldAmount.text,
                                           @"reservationField1"    : @"GiroType1"
                                           }] autorelease];
            
            self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_PAYMENT_ACCOUNT_CONFIRM  viewController: self] autorelease];
            self.service.previousData = dicDataDic;
            [self.service start];
            
            textFieldPassword.text = @"";
            
        }
            break;
            
        case 22:        // 취소
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        case 31:        // 지로검색창 검색 button
        {
            if ( nil == textFieldInputGiro.text || [textFieldInputGiro.text isEqualToString:@""] )
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"지로번호를 입력해 주십시오."];
                return;
            }
            else if ( [textFieldInputGiro.text length] != 7 )
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"지로번호는 7자리를 입력해 주십시오."];
                return;
            }
            
            // 서비스를 실행한다
            OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"전문종별코드"    : @"0200",
                                    @"거래구분코드"    : @"995005",
                                    @"발행기관코드"    : @"90",
                                    @"이용기관지로번호"    : textFieldInputGiro.text,
                                    @"발행기관코드2"    : @"90",
                                    @"이용기관지로번호2"    : textFieldInputGiro.text
                                    }] autorelease];
            
            self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_LIST_ONLY_GIRO_NUMBER viewController: self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
        }
            break;
            
        case 33:        // 지로 선택
        {
            [giroNumberSearchPopupView closePopupViewWithButton:nil];
            
            int intMovedHeight = 72;
            
            // 지로번호, 이용기관 set
            labelGiroNumber.text = labelResult1.text;
            labelCompanyName.text = labelResult2.text;
            
            [textFieldVerificationNumber setEnabled:YES];
            ((UIButton*)[self.view viewWithTag:11]).hidden = YES;
            [viewAmountConfirmView setFrame:CGRectMake(viewAmountConfirmView.frame.origin.x, viewAmountConfirmView.frame.origin.y, viewAmountConfirmView.frame.size.width, intMovedHeight)];
            [viewMovedView setFrame:CGRectMake(viewMovedView.frame.origin.x, 340, viewMovedView.frame.size.width, viewMovedView.frame.size.height)];
            
            if ([strGiroKind isEqualToString:@"O"])
            {
                labelSearchORConfirm.text = @"고객조회번호";
                ((UIButton*)[self.view viewWithTag:11]).hidden = NO;
            }
            else if ([strGiroKind isEqualToString:@"Q"])
            {
                labelSearchORConfirm.text = @"납부자확인번호";
            }
            else if ([strGiroKind isEqualToString:@"M"])
            {
                [textFieldVerificationNumber setEnabled:NO];
                
                labelSearchORConfirm.text = @"납부자확인번호";
                
                [viewAmountConfirmView setFrame:CGRectMake(viewAmountConfirmView.frame.origin.x, viewAmountConfirmView.frame.origin.y, viewAmountConfirmView.frame.size.width, 0)];
                [viewMovedView setFrame:CGRectMake(viewMovedView.frame.origin.x, viewMovedView.frame.origin.y - intMovedHeight, viewMovedView.frame.size.width, viewMovedView.frame.size.height)];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL) onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    return YES;
}

- (BOOL) onBind:(OFDataSet *)aDataSet
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0120"] )        // 지로번호로 검색의 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )      // 자료가 정상적으로 들어온 경우
        {
            buttonSelect.enabled = YES;
            
            // 지로 종류
            strGiroKind = [aDataSet objectForKey:@"장표종류"];
            
            // 결과표시
            labelResult1.hidden = NO;
            labelResult2.hidden = NO;
            labelResult1.text = [aDataSet objectForKey:@"이용기관지로번호"];
            labelResult2.text = [aDataSet objectForKey:@"수납기관명"];
        }
    }
    else if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2090"])        // 계좌정보 확인이 된 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )          // 정상 case
        {
            
            // 정보 setting
            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSString *strDate = [monthField1.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([strGiroKind isEqualToString:@"O"] || [strGiroKind isEqualToString:@"Q"])
            {
                [dicData setObject:textFieldVerificationNumber.text         forKey:@"금액검증번호"];
            }
            
            [dicData setObject:textFieldSearchNumber.text               forKey:@"고객조회번호"];          // 납부자확인번호와 고객조회번호가 같다
            [dicData setObject:labelGiroNumber.text                     forKey:@"지로번호"];
            [dicData setObject:labelCompanyName.text                    forKey:@"수납기관명"];
            [dicData setObject:textFieldAmount.text                     forKey:@"납부금액"];
            [dicData setObject:strDate                                  forKey:@"납부연월"];
            [dicData setObject:buttonAccount.titleLabel.text                  forKey:@"출금계좌번호"];
            [dicData setObject:textFieldName.text                       forKey:@"납부자명"];
            [dicData setObject:textFieldPhoneNumber.text                forKey:@"전화번호"];
            [dicData setObject:strGiroKind                              forKey:@"장표종류"];
            [dicData setObject:self.encriptedPW                         forKey:@"출금계좌비밀번호"];
            
            SHBGiroTaxInputContentViewController    *viewController = [[SHBGiroTaxInputContentViewController alloc] initWithNibName:@"SHBGiroTaxInputContentViewController" bundle:nil];
            viewController.dicDataDictionary = dicData;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            [dicData release];
        }
    }
    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D2004"] )           // 계좌 잔액의 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )              // 정상 case
        {
            labelAmountLeft.text = [NSString stringWithFormat:@"출금가능잔액 %@원", [aDataSet objectForKey:@"지불가능잔액"]];
            labelAmountLeft.accessibilityLabel = labelAmountLeft.text;
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark SecureTextField Delegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // 필요시 super 호출
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}

- (IBAction)closeNormalPad:(id)sender
{
    [super closeNormalPad:sender];
    [textFieldPassword becomeFirstResponder];
}

#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 필요시 super 호출
    [super textFieldDidEndEditing:textField];
    
    if (textField == textFieldAmount)
    {
        if (![textFieldAmount.text isEqualToString:@""])
        {
            labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
            labelAmountString.accessibilityLabel = labelAmountString.text;
        }
        else
        {
            labelAmountString.text = @"";
            //labelAmountString.accessibilityLabel = @"출금가능잔액 0원";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == textFieldAmount)
    {
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
            if ([textField.text length] > 12)
            {
                textField.text = [textField.text substringToIndex:13];
            }
            
            textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
        }
        else
        {
            int nLen = [textField.text length];
            NSString *strStr = [textField.text substringToIndex:nLen - 1];
            textField.text = strStr;
            
            textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
        }
        return NO;
    }
    else if (textField == textFieldInputGiro)
    {
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
            NSString *strString = [NSString stringWithFormat:@"%@%@", textField.text, string];
            
            if ([textField.text length] > 6)
            {
                strString = [textField.text substringToIndex:7];
            }
            
            textField.text = strString;
        }
        else
        {
            int nLen = [textField.text length];
            NSString *strStr = [textField.text substringToIndex:nLen - 1];
            textField.text = strStr;
        }
        
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark SHBTextFieldDelegate

- (void)didCompleteButtonTouch      // 완료버튼
{
    // 필요시 super 호출
    [super didCompleteButtonTouch];
    
    // 팝업의 경우 따로 처리 필요하다
	[textFieldInputGiro focusSetWithLoss:NO];
	[self closeToiOSKeypad];
}

- (void)closeToiOSKeypad
{
	[textFieldInputGiro resignFirstResponder];
}


#pragma mark -
#pragma mark SHBPopupView Delegate

- (void)popupViewDidCancel
{
    textFieldInputGiro.text = @"";
    
    [labelResult1 setHidden:YES];
    [labelResult2 setHidden:YES];
    [buttonSelect setEnabled:NO];
}


#pragma mark -
#pragma mark Notifications

- (void)textFieldDidChange
{
    if (curTextField == textFieldSearchNumber)
    {
        if ([curTextField.text length] > 20)
        {
            curTextField.text = [curTextField.text substringToIndex:20];
        }
        else
        {
            labelSearchNumberPosition.text = [NSString stringWithFormat:@"(%d번째)", [curTextField.text length]];
        }
    }
    else if ( curTextField == textFieldVerificationNumber )
    {
        if ([curTextField.text length] > 1)
        {
            curTextField.text = [curTextField.text substringToIndex:1];
        }
    }
    else if ( curTextField == textFieldName )
    {
        if ( [SHBUtility countMultiByteStringFromUTF8String:textFieldName.text] > 16 )
        {
            curTextField.text = [curTextField.text substringToIndex:[textFieldName.text length] - 1];
        }
    }
    else if ( curTextField == textFieldPhoneNumber )
    {
        if ( [curTextField.text length] > 12 )
        {
            curTextField.text = [curTextField.text substringToIndex:12];
        }
    }
}

// 다른 view에서 취소 버튼으로 오는 경우 입력값 clear
- (void)cancelButtonDidPush
{
    labelGiroNumber.text = @"";
    labelCompanyName.text = @"";
    labelAmountString.text = @"";
    //labelAmountString.accessibilityLabel = @"출금가능잔액 0원";
    
    labelSearchNumberPosition.text = @"(0번째)";
    labelAmountLeft.text = @"";
    labelAmountLeft.accessibilityLabel = @"출금가능잔액 0원";
    monthField1.textField.text = @"";
    
    textFieldInputGiro.text = @"";
    textFieldAmount.text = @"";
    textFieldSearchNumber.text = @"";
    textFieldVerificationNumber.text = @"";
    textFieldPassword.text = @"";
    textFieldName.text = @"";
    textFieldPhoneNumber.text = @"";
    
    buttonSelect.enabled = NO;
    // 결과표시
    labelResult1.hidden = YES;
    labelResult2.hidden = YES;
    
    [self listPopupView:nil didSelectedIndex:0];
    
    if ([strGiroKind isEqualToString:@"O"])
    {
        labelSearchORConfirm.text = @"고객조회번호";
    }
    else
    {
        labelSearchORConfirm.text = @"납부자확인번호";
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark -
#pragma mark - SHBListPopupView Delegate

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    if ( [self.dataList count] < 1 )
    {
        [buttonAccount setTitle:@"출금계좌정보가 없습니다" forState:UIControlStateNormal];
    }
    else
    {
        // 정보 setting
        dicAccountDic = [self.dataList objectAtIndex:anIndex];
        // 계좌번호를 넣는다
        [buttonAccount setTitle:[dicAccountDic objectForKey:@"2"] forState:UIControlStateNormal];
        
        labelAmountLeft.text = @"";
        labelAmountLeft.accessibilityLabel = @"출금가능잔액 0원";
    }
    
    textFieldPassword.text = @"";
}

- (void)listPopupViewDidCancel
{
    
}

#pragma mark -
#pragma mark MonthField Delegate

- (void)monthField:(SHBMonthField*)monthField didConfirmWithMonth:(NSString*)month
{
    monthField1.textField.text = month;
}

- (void)currentMonthField:(SHBMonthField*)monthField					// 현재픽커
{
    [curTextField resignFirstResponder];
}

#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"지로입력납부";
    self.strBackButtonTitle = @"지로입력납부 메인";
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222005;
    
    // realView가 더 클경우 지정
    contentViewHeight = viewRealView.frame.size.height;
    
    // scroll 영역 지정
    [scrollView setContentSize:CGSizeMake(viewRealView.frame.size.width, viewRealView.frame.size.height)];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GiroInputCancelButtonPushed" object:nil];
    // text 수정 notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:@"UITextFieldTextDidChangeNotification" object:nil];
    // cancel button notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonDidPush) name:@"GiroInputCancelButtonPushed" object:nil];
    
    // date field 사용
    [monthField1 initFrame:monthField1.frame];
	monthField1.tag               = 101;
    monthField1.textField.font = [UIFont fontWithName:@"Helvetica" size:15];
    monthField1.textField.textAlignment = UITextAlignmentLeft;
    monthField1.delegate = self;
    
    textFieldAmount.accDelegate = self;
    textFieldSearchNumber.accDelegate = self;
    textFieldInputGiro.accDelegate = self;
    textFieldVerificationNumber.accDelegate = self;
    textFieldName.accDelegate = self;

    [textFieldPassword showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    textFieldPhoneNumber.accDelegate = self;
    
    // 계좌정보 set
    [self getOutAccountList];
    [self listPopupView:nil didSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [giroNumberSearchPopupView release];
    giroNumberSearchPopupView = nil;
    
    self.encriptedPW = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GiroInputCancelButtonPushed" object:nil];
    
    [super dealloc];
}

@end
