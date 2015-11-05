//
//  SHBNewProductTaxBreakViewController3.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 5. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNewProductTaxBreakViewController3.h"
#import "SHBGoodsSubTitleView.h"            // 서브 타이틀
#import "SHBProductService.h"           // 상품 서비스
#import "SHBNewProductSignUpViewController.h"
#import  "SHBNewProductRegEndViewController.h"

#import "SHBListPopupView.h" // list popup

@interface SHBNewProductTaxBreakViewController3 ()
<SHBListPopupViewDelegate>
@end

@implementation SHBNewProductTaxBreakViewController3

#pragma mark -
#pragma mark Synthesize

@synthesize dicSelectedData;
@synthesize userItem;
@synthesize stepNumber;
@synthesize textField3;

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString *strErrorMessage = @"입력값을 확인해 주세요.";
    

    NSString *strTemp2 = [SHBUtility commaStringToNormalString:((UITextField*)textField1).text]; //지급기간
 
    NSString *strAmount = [((UITextField *)textField2).text stringByReplacingOccurrencesOfString:@"," withString:@""]; //적립한도
    NSString *strAutoAmount = [((UITextField *)textField3).text stringByReplacingOccurrencesOfString:@"," withString:@""]; //자동이체금액
    

    
    //한달 구분 validation
    NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:1 AgoDay:0];
    
    
    NSString *currentDate = [dates objectAtIndex:1];
    NSString *strStartDate  = [dateField1.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
   
    if( nil == ((UITextField*)textField1).text || [((UITextField*)textField1).text isEqualToString:@""])
    {
        strErrorMessage = @"연금지급기간을 입력해 주세요.";
        goto errorCase;
    }
    else if ( 10 > [strTemp2 intValue] )
    {
        strErrorMessage = @"연금지급기간은 10년 이상이어야 합니다.";
        goto errorCase;
    }
    else if( nil == ((UITextField*)textField2).text || [((UITextField*)textField2).text isEqualToString:@""])
    {
        strErrorMessage = @"연간적립한도를 입력해 주세요.";
        goto errorCase;
    }
    else if ( [strAmount intValue] < 10000 ||  [strAmount intValue] > 18000000 )
    {
        strErrorMessage = @"연간적립한도는 10,000원 이상 18,000,000원 이하 이어야 합니다.";
        goto errorCase;
    }
    
    
    else if (((UIButton*)[self.view viewWithTag:11]).selected == YES &&  [dateField1.textField.text isEqualToString:@""] )
    {
        strErrorMessage = @"자동이체시작일을 입력해 주십시오.";
        goto errorCase;
    }
    
       else if (((UIButton*)[self.view viewWithTag:11]).selected == YES &&
             [strStartDate intValue] <= [currentDate intValue])
    {
        strErrorMessage = @"자동이체 시작일이 현재일이거나 과거일자 입니다.";
        goto errorCase;
        
    }
    
   
    else if ( ((UIButton*)[self.view viewWithTag:11]).selected == YES && (nil == ((UITextField *)textField3).text || [((UITextField *)textField3).text isEqualToString:@""]) )
    {
        strErrorMessage = @"자동이체금액을 입력해 주십시오.";
        goto errorCase;
    }
    else if ( ((UIButton*)[self.view viewWithTag:11]).selected == YES && [strAutoAmount intValue] < 10000 )
    {
        strErrorMessage = @"자동이체금액은 만원 이상입니다.";
        goto errorCase;
    }
    else if ( [strAmount intValue] < [strAutoAmount intValue])
    {
        strErrorMessage = @"자동이체금액이 연간적립한도를 초과합니다.";
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
    [((UITextField*)textField3) setEnabled:YES];
     [(UITextField *)textField3 setText:[self.userItem objectForKey:@"신규금액"]];
    
    if ([sender tag] == 12)
    {
        [dateField1 setEnabled:NO];

        [((UITextField*)textField3) setEnabled:NO];
        ((UITextField*)textField3).text = @"";
    }
}

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag])
    {
        case 21:           
        {
            if ([self checkException])
            {
                return;
            }
            
            strTerm = ((UITextField*)textField1).text; // 지급기간
            strMaxAmount = ((UITextField*)textField2).text; // 적립한도
            strdateStart = dateField1.textField.text; //자동이체시작일
            strautoAmount = ((UITextField*)textField3).text; //자동이체금액
            

            
            
            if([selectType.titleLabel.text isEqualToString:@"자택"])
            {
                strType = [NSString stringWithFormat:@"자택"];
                strTypeCode = [NSString stringWithFormat:@"1"];
            }
            
            else if([selectType.titleLabel.text isEqualToString:@"직장"])
            {
                strType = [NSString stringWithFormat:@"직장"];
                strTypeCode = [NSString stringWithFormat:@"2"];
            }

            
            else if([selectType.titleLabel.text isEqualToString:@"E-mail"])
            {
                strType = [NSString stringWithFormat:@"E-mail"];
                strTypeCode = [NSString stringWithFormat:@"3"];
            }

            
            else if([selectType.titleLabel.text isEqualToString:@"불필요"])
            {
                strType = [NSString stringWithFormat:@"불필요"];
                strTypeCode = [NSString stringWithFormat:@"9"];
            }

            
            [self.userItem setObject:strTerm forKey:@"지급기간"];
            [self.userItem setObject:strMaxAmount forKey:@"적립한도"];
            [self.userItem setObject:strType forKey:@"통보방법"];
            [self.userItem setObject:strTypeCode forKey:@"통보방법코드"];
            
            [self.dicSelectedData setObject:@"신탁상품가입" forKey:@"신탁상품가입"];
            
            if (![((UITextField*)textField3).text isEqualToString:@""]) {
                [self.userItem setObject:strautoAmount forKey:@"자동이체금액"];  // 자동이체금액
                [self.userItem setObject:strdateStart forKey:@"자동이체시작일"];
                [self.userItem setObject:@"자동이체신청" forKey:@"자동이체신청"];
            }
            
            
           
            
            SHBNewProductSignUpViewController *viewController = [[SHBNewProductSignUpViewController alloc]initWithNibName:@"SHBNewProductSignUpViewController" bundle:nil];
            viewController.dicSelectedData = self.dicSelectedData;
            viewController.userItem = self.userItem;
            viewController.needsLogin = YES;
            viewController.stepNumber = @"예금적금 가입 4단계";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];

          
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
    
    
    if (textField == (UITextField *)textField1)
    {
        if ([textField.text length] > 2)        // 9자리 까지만 입력 가능
        {
            if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [textField.text substringToIndex:2];
                
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
    
    
    
    if (textField == (UITextField *)textField2 || textField == (UITextField *)textField3)
    {
        if ([textField.text length] > 8)        // 9자리 까지만 입력 가능
        {
            if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [textField.text substringToIndex:9];
                
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
    endTextFieldTag = 222002;
    
    contentViewHeight = realView.frame.size.height ;
    
    // 서브 타이틀 설정
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청",[self.dicSelectedData objectForKey:@"상품명"]] maxStep:5 focusStepNumber:3] autorelease]]; // 가입신청
    
     [scrollView1 setContentSize:CGSizeMake(0, realView.frame.size.height)];
    
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    // 자동이체시작일
    [dateField1 initFrame:dateField1.frame];
    [dateField1.textField setFont:[UIFont systemFontOfSize:15]];
    [dateField1.textField setTextColor:RGB(44, 44, 44)];
    [dateField1.textField setTextAlignment:UITextAlignmentLeft];
    

    //int intDayPlus = 0;
    //[dateField1 setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:intDayPlus+1]]];
    [dateField1 selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:+1 toDay:0]] animated:YES];
    

    // NSLog(@"신규 금액 %@",[self.userItem objectForKey:@"신규금액"]);
     [(UITextField *)textField3 setText:[self.userItem objectForKey:@"신규금액"]];
    

    self.dataList = [NSMutableArray arrayWithArray:
                     @[
                       @{ @"1" : @"자택", @"code" : @"1", },
                       @{ @"1" : @"직장", @"code" : @"2", },
                       @{ @"1" : @"E-mail", @"code" : @"3", },
                       @{ @"1" : @"불필요", @"code" : @"9", },
                       ]];
    
    self.selectDic = self.dataList[2];
}

/// 운영내역통보
- (IBAction)selectTypeBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"운영내역통보"
                                                                   options:self.dataList
                                                                   CellNib:@"SHBBankListPopupCell"
                                                                     CellH:32
                                                               CellDispCnt:4
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}



#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectDic = self.dataList[anIndex];
    
    [selectType setTitle:self.selectDic[@"1"] forState:UIControlStateNormal];
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
