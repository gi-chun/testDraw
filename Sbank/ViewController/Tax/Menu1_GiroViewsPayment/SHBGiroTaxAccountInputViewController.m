//
//  SHBGiroTaxAccountInputViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 18..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxAccountInputViewController.h"
#import "SHBAccountService.h"                   // 계좌조회 service
#import "SHBGiroTaxListService.h"               // 지로지방세 service
#import "SHBSecurityCardViewController.h"       // 다음 view


@interface SHBGiroTaxAccountInputViewController ()

@end

@implementation SHBGiroTaxAccountInputViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;
@synthesize arrayCanTransferAccountList;
@synthesize encriptedPW;


#pragma makr -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString    *strErrorMessage = @"입력값을 확인해 주세요.";
    
    if ( nil == buttonAccount.titleLabel.text || [buttonAccount.titleLabel.text isEqualToString:@""] || [buttonAccount.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다"] )
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
        strErrorMessage = @"출금계좌비밀번호는 4자리를 입력해 주십시오";
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
    [textFieldPassword resignFirstResponder];
    [textFieldPhoneNumber resignFirstResponder];
    
    switch ([sender tag]) {
        case 11:        // 계좌번호
        {
            [self getOutAccountList];
            
            // 계좌 리스트팝업
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:(NSMutableArray *)self.dataList CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 12:        // 잔액조회
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
            
        case 21:        // 납부
        {
            if ([self checkException])
            {
                return;
            }
            
            SHBDataSet     *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                                           @{
                                           @"출금계좌비밀번호"          : textFieldPassword.text,
                                           @"출금계좌번호"            : buttonAccount.titleLabel.text,
                                           @"은행구분"              : [dicAccountDic objectForKey:@"은행코드"],     // (!주의)신, 구 계좌에 따른 값 변경 있음 정보처리되어서 옴
                                           @"납부금액"              : dicDataDictionary[@"납부금액"],
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonDidPush" object:nil];
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D2004"] )           // 잔액을 넣는다
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            label10.text = [NSString stringWithFormat:@"출금가능잔액 %@원", [aDataSet objectForKey:@"지불가능잔액"]];
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    
    if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2090"])      // 계좌가 확인된 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            // 날짜
            NSString *strToday      = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            // 현재 dictionary에 없는 정보 추가
            [self.dicDataDictionary setObject:strToday forKey:@"납부일자"];
            [self.dicDataDictionary setObject:buttonAccount.titleLabel.text forKey:@"출금계좌번호"];
            [self.dicDataDictionary setObject:self.encriptedPW forKey:@"출금계좌비밀번호"];
            [self.dicDataDictionary setObject:textFieldPhoneNumber.text forKey:@"연락전화번호"];
            [self.dicDataDictionary setObject:label5.text forKey:@"납부자성명"];
            
            SHBSecurityCardViewController       *viewController = [[SHBSecurityCardViewController alloc] initWithNibName:@"SHBSecurityCardViewController" bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
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
#pragma mark - SHBListPopupView

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
        
        label10.text = @"";
    }
    
    textFieldPassword.text = @"";
}

- (void)listPopupViewDidCancel
{
    
}


#pragma mark -
#pragma mark Notifications

- (void)textFieldDidChange
{
    if (curTextField == textFieldPhoneNumber)
    {
        if ( [curTextField.text length] > 12 )
        {
            curTextField.text = [curTextField.text substringToIndex:12];
        }
    }
}

- (void)cancelButtonPushed:(NSNotification *)noti
{
    if ([[noti object] isEqualToString:@"0"])
    {
        curTextField = nil;
        
        textFieldPassword.text = @"";       // 비밀번호
        textFieldPhoneNumber.text = @"";    // 전화번호
        label10.text = @"";
    }
    else if ([[noti object] isEqualToString:@"1"])
    {
        // 취소 버튼 실행
        UIButton *trickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        trickButton.tag = 22;
        
        [self buttonDidPush:trickButton];
    }
    
    [self listPopupView:nil didSelectedIndex:0];
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
    
    self.title = @"지로조회납부";
    self.strBackButtonTitle = @"지로조회납부 1단계";
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    // realView가 더 클경우 지정
    contentViewHeight = viewRealView.frame.size.height;
    
    [textFieldPassword showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    textFieldPhoneNumber.accDelegate = self;
    
    arrayCanTransferAccountList = [[NSMutableArray alloc] initWithCapacity:0];
    
    label1.text = [self.dicDataDictionary objectForKey:@"지로번호"];
    label2.text = [self.dicDataDictionary objectForKey:@"전자납부번호"];
    label3.text = [self.dicDataDictionary objectForKey:@"수납기관명"];
    label4.text = [self.dicDataDictionary objectForKey:@"고객조회번호"];
    label5.text = [self.dicDataDictionary objectForKey:@"납부자성명"];
    label6.text = [self.dicDataDictionary objectForKey:@"납부금액원"];
    label7.text = [self.dicDataDictionary objectForKey:@"고지형태->display"];
    label8.text = [self.dicDataDictionary objectForKey:@"부과년월->originalValue"];
    label9.text = [self.dicDataDictionary objectForKey:@"납부기한"];
    
    // 계좌정보 set
    [self getOutAccountList];
    [self listPopupView:nil didSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonDidPushFromSummit" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPushed:) name:@"cancelButtonDidPushFromSummit" object:nil];
    
    [scrollView1 setContentSize:CGSizeMake(viewRealView.frame.size.width, viewRealView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    self.arrayCanTransferAccountList = nil;
    
    self.encriptedPW = nil;

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonDidPushFromSummit" object:nil];
    
    [super dealloc];
}

@end
