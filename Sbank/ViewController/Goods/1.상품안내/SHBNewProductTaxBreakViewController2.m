//
//  SHBNewProductTaxBreakViewController2.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 28..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBNewProductTaxBreakViewController2.h"
#import "SHBGoodsSubTitleView.h"            // 서브 타이틀
#import "SHBProductService.h"           // 상품 서비스
#import "SHBNewProductSignUpViewController.h"
#import  "SHBNewProductRegEndViewController.h"
@interface SHBNewProductTaxBreakViewController2 ()

@end

@implementation SHBNewProductTaxBreakViewController2

#pragma mark -
#pragma mark Synthesize

@synthesize dicSelectedData;
@synthesize userItem;
@synthesize stepNumber;


#pragma mark -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString *strErrorMessage = @"입력값을 확인해 주세요.";
    
    NSString *strTemp = [SHBUtility commaStringToNormalString:strMaxAmount];
    NSString *strTemp2 = [SHBUtility commaStringToNormalString:((UITextField*)textField1).text];
    
    NSString *strDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *strTime = [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *strAmount = [((UITextField *)textField1).text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *strAutoAmount = [((UITextField *)textField2).text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *strStartDate  = [dateField1.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *strEndDate    = [dateField2.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ( [strTemp intValue] < [strTemp2 intValue] )
    {
        strErrorMessage = @"분기당 납입한도는 한도잔여액을 초과할 수 없습니다.";
        goto errorCase;
    }
    else if( nil == ((UITextField*)textField1).text || [((UITextField*)textField1).text isEqualToString:@""])
    {
        strErrorMessage = @"분기당 납입한도를 입력해 주세요.";
        goto errorCase;
    }
    else if ( [strAmount intValue] < 10000 )
    {
        strErrorMessage = @"분기당납입한도를 확인하세요. 재형저축상품의 분기당납입한도는 1만원이상 입니다.";
        goto errorCase;
    }
    else if ( [SHBUtility isOPDate:strDate] && [strTime intValue] > 155500 && [strTime intValue] < 160000 )
    {
        // 특이 케이스
        strErrorMessage = @"당일 신규 신청시간이 종료되었습니다. 16시 이후에 신청하십시오. 단, 16시 이후에는 익일로 신규처리 됩니다. 익일이 휴일인 경우 16시 이후 신규거래가 제한됩니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:888 title:@"" message:strErrorMessage];
        
        return YES;
    }
    else if ( [strStartDate intValue] > [strEndDate intValue] || ([strEndDate intValue] - [strStartDate intValue]) < 100 )
    {
        strErrorMessage = @"자동이체 종료일은 적어도 자동이체 시작일의 한달 후가 입력되어야 합니다.";
        goto errorCase;
    }
    else if ( [strAmount intValue] > 3000000 )
    {
        strErrorMessage = @"분기당 납입한도는 한도잔여액을 초과할 수 없습니다.";
        goto errorCase;
    }
    else if ( ((UIButton*)[self.view viewWithTag:11]).selected == YES && (nil == ((UITextField *)textField2).text || [((UITextField *)textField2).text isEqualToString:@""]) )
    {
        strErrorMessage = @"자동이체금액을 입력해 주십시오.";
        goto errorCase;
    }
    else if ( ((UIButton*)[self.view viewWithTag:11]).selected == YES && [strAutoAmount intValue] < 10000 )
    {
        strErrorMessage = @"자동이체금액은 만원 이상입니다.";
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


#pragma mark -
#pragma mark Button Actions

- (IBAction)radioButtonDidPush:(id)sender
{
    [((UIButton*)[self.view viewWithTag:11]) setSelected:NO];
    [((UIButton*)[self.view viewWithTag:12]) setSelected:NO];
    
    [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:YES];
    
    [dateField1 setEnabled:YES];
    [dateField2 setEnabled:YES];
    [((UITextField*)textField2) setEnabled:YES];
    
    if ([sender tag] == 12)
    {
        [dateField1 setEnabled:NO];
        [dateField2 setEnabled:NO];
        [((UITextField*)textField2) setEnabled:NO];
        ((UITextField*)textField2).text = @"";
    }
}

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag])
    {
        case 21:            // 확인 버튼     4월 1일 기준 금액, 합계, 연동지급금액이 자동신청금액인지, 신규금액인지 파악
        {   
            if ([self checkException])
            {
                return;
            }
            
            self.service = nil;
            
           // NSString *strAmountString = [SHBUtility commaStringToNormalString:((UITextField *)textField2).text];
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"상품코드" : self.dicSelectedData[@"상품코드"],
                                   @"은행구분" : @"1",
                                   @"거래점계좌번호" : self.userItem[@"출금계좌번호"],
                                   @"금액" : self.userItem[@"신규금액"],   
                                   @"합계" : self.userItem[@"신규금액"],
                                   @"계약기간_개월" : @"84",
                                   @"입금주기구분" : @"8",
                                   @"입금주기" : @"0",
                                   @"세금우대한도금액" : strMaxAmount,
                                   @"이자지급방법" : @"03",
                                   @"지급주기구분" : @"",
                                   @"지급주기" : @"",
                                   @"회전주기" : @"", // @"회전주기" : @"12",
                                   @"재예치재원구분" : @"",
                                   @"연동지급계좌은행구분" : @"1",
                                   @"연동지급계좌번호" : self.userItem[@"출금계좌번호"],
                                   @"연동지급금액" : self.userItem[@"신규금액"], //strAmountString,//((UITextField*)textField2).text,
                                   @"인터넷가산이율구분" : @"",
                                   @"신규전조회" : @"1",
                                   @"연동지급계좌은행구분" : @"1",
                                   }];
   
          if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"]) // 변동
          {
              [dataSet insertObject:@"12" forKey:@"회전주기" atIndex:0];
          }
          else
          {
              [dataSet insertObject:@"" forKey:@"회전주기" atIndex:0];
          }
          
            
            AppInfo.serviceOption = @"재형저축";

            self.service = [[[SHBProductService alloc]initWithServiceId:kD5022Id viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
            break;
            
        case 22:            // 취소 버튼
        {
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
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"D4222"])
    {
        [aDataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:aDataSet[@"저축종류별가입금액"]]] forKey:@"가입총액" atIndex:0];
        [aDataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:aDataSet[@"저축종류별미사용금액"]]] forKey:@"한도잔여액" atIndex:0];
        
        strMaxAmount = aDataSet[@"저축종류별미사용금액"];
    }
    
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"D5022"])
    {
        
        strLimitAmount = ((UITextField*)textField1).text;  //분기당 납인한도
        strdateStart = dateField1.textField.text; //자동이체시작일
        strdateEnd = dateField2.textField.text; //자동이체종료일
        strautoAmount = ((UITextField*)textField2).text; //자동이체금액
        strPercent = aDataSet[@"대고객이율"];
        
        // [self.userItem setObject:self.tfTaxBreakAmount.text forKey:@"세금우대_신청금액"];
        [self.userItem setObject:strLimitAmount forKey:@"분기당납입한도"];
        [self.userItem setObject:strPercent forKey:@"적용이율"];
        
        if (![((UITextField*)textField2).text isEqualToString:@""]) {
            [self.userItem setObject:strautoAmount forKey:@"자동이체금액"];  // 자동이체금액
            [self.userItem setObject:strdateStart forKey:@"자동이체시작일"];
            [self.userItem setObject:strdateEnd forKey:@"자동이체종료일"];
            [self.userItem setObject:@"자동이체신청" forKey:@"자동이체신청"];
        }
       
   
        [self.userItem setObject:@"재형저축가입신청" forKey:@"재형저축가입신청"];
        
     
   
        
        
//        //임시 완료페이지 이동
//        SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
//        viewController.dicSelectedData = self.dicSelectedData;
//        viewController.userItem = self.userItem;
//         viewController.needsLogin = YES;
//      //  viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
//        [self checkLoginBeforePushViewController:viewController animated:YES];
//        [viewController release];
//
//
        
        SHBNewProductSignUpViewController *viewController = [[SHBNewProductSignUpViewController alloc]initWithNibName:@"SHBNewProductSignUpViewController" bundle:nil];
        viewController.dicSelectedData = self.dicSelectedData;
        viewController.userItem = self.userItem;
        viewController.needsLogin = YES;
        viewController.stepNumber = @"예금적금 가입 4단계";

        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
        
    }
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == (UITextField *)textField1 || textField == (UITextField *)textField2)
    {
        if ([textField.text length] > 7)        // 9자리 까지만 입력 가능
        {
            if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [textField.text substringToIndex:8];
                
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

        
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
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
    
    return YES;
}

#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 888)
    {
        [self.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
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
    
    [self setTitle:@"예금/적금 가입"];
    
    self.strBackButtonTitle = self.stepNumber;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    contentViewHeight = realView.frame.size.height;
    
    // 서브 타이틀 설정
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청",[self.dicSelectedData objectForKey:@"상품명"]] maxStep:5 focusStepNumber:3] autorelease]]; // 가입신청
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [scrollView1 setContentSize:CGSizeMake(0, realView.frame.size.height)];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           //@"주민번호" : AppInfo.ssn,
                           //@"주민번호" : [AppInfo getPersonalPK],
                           @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                           @"저축종류" : [self.dicSelectedData objectForKey:@"세금우대_D4222저축종류"],
                           }];
    self.service = [[[SHBProductService alloc]initWithServiceId:kD4222Id viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    // 자동이체시작일
    [dateField1 initFrame:dateField1.frame];
    [dateField1.textField setFont:[UIFont systemFontOfSize:15]];
    [dateField1.textField setTextColor:RGB(44, 44, 44)];
    [dateField1.textField setTextAlignment:UITextAlignmentLeft];
    
    // 자동이체종료일
    [dateField2 initFrame:dateField2.frame];
    [dateField2.textField setFont:[UIFont systemFontOfSize:15]];
    [dateField2.textField setTextColor:RGB(44, 44, 44)];
    [dateField2.textField setTextAlignment:UITextAlignmentLeft];
    
    NSString *strDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *strTime = [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    // 16시 이후의 경우 +1일 더
    int intDayPlus = 1;
    
    if ( [SHBUtility isOPDate:strDate] && [strTime intValue] < 160000 )     // 16시 이전의 경우 +1달만
    {
        intDayPlus = 0;
    }
    
    [dateField1 setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:intDayPlus+1]]];
    [dateField2 setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:intDayPlus+1]]];
    
    [dateField1 selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:1 toDay:intDayPlus]] animated:NO];
    [dateField2 selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:84 toDay:intDayPlus]] animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicSelectedData = nil;
    self.userItem = nil;
    self.stepNumber = nil;
    
    [super dealloc];
}

@end
