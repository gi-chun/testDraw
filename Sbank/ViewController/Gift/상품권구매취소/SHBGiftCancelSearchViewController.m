//
//  SHBGiftCancelSearchViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelSearchViewController.h"
#import "SHBGiftService.h" // service
#import "SHBListPopupView.h" // list popup

#import "SHBGiftCancelDetailViewController.h" // 상품권 취소

@interface SHBGiftCancelSearchViewController () <SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *accountList; // 입금계좌번호
@property (retain, nonatomic) NSMutableDictionary *selectAccountDic; // 선택한 입금계좌번호

@end

@implementation SHBGiftCancelSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"모바일상품권 구매취소"];
    self.strBackButtonTitle = @"모바일상품권 구매취소 건별조회";
    
    // 대출희망일
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField setDate:[NSDate date]];
    [_dateField.textField setAccessibilityLabel:@"구매일자 입력창"];
    [_dateField setDelegate:self];
    
    startTextFieldTag = 30301;
    endTextFieldTag = 30301;
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    self.accountList = [self outAccountList];
    
    if ([_accountList count] == 0) {
        
        [_accountNumber setEnabled:NO];
        [_accountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        [_accountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateHighlighted];
        [_accountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateSelected];
        [_accountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountList = nil;
    self.selectAccountDic = nil;
    
    [_emartBtn release];
    [_cultuBtn release];
    [_dateField release];
    [_approvalNumber release];
    [_accountNumber release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setEmartBtn:nil];
    [self setCultuBtn:nil];
    [self setDateField:nil];
    [self setApprovalNumber:nil];
    [self setAccountNumber:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPresssed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 10: {
            
            // 계좌번호
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"본인계좌"
                                                                          options:_accountList
                                                                          CellNib:@"SHBAccountListPopupCell"
                                                                            CellH:50
                                                                      CellDispCnt:5
                                                                       CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 21:
        case 22: {
            
            // 상품권 종류
            
            [_emartBtn setSelected:NO];
            [_cultuBtn setSelected:NO];
            
            [sender setSelected:YES];
        }
            break;
            
        case 100: {
            
            // 조회
            
            if (!_selectAccountDic ||
                [_accountNumber.titleLabel.text length] == 0 ||
                [_accountNumber.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"조회할 출금계좌번호를 선택해 주세요."];
                return;
            }
            
            if (![_emartBtn isSelected] && ![_cultuBtn isSelected]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"조회할 상품권 종류를 선택해 주세요."];
                return;
            }
            
            if ([_approvalNumber.text length] != 8) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"조회할 거래승인번호를 입력해 주세요."];
                return;
            }
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"거래구분" : @"5",
                                      @"업무유형" : @"1",
                                      @"판매금액" : @"",
                                      @"계좌구분" : _selectAccountDic[@"은행구분"],
                                      @"지급계좌번호" : _selectAccountDic[@"2"],
                                      @"계좌비밀번호" : @"",
                                      @"센터처리번호" : @"",
                                      @"구매자휴대폰" : @"",
                                      @"받는분휴대폰" : @"",
                                      @"구매자성명" : AppInfo.userInfo[@"고객성명"],
                                      @"받는분성명" : @"",
                                      @"전달메세지" : @"",
                                      @"취소시구매일자" : [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                                      @"취소시구매승인번호" : _approvalNumber.text
                                      }];
            
            if ([_emartBtn isSelected]) {
                
                [aDataSet insertObject:@"EMART" forKey:@"기관코드" atIndex:0];
            }
            else if ([_cultuBtn isSelected]) {
                
                [aDataSet insertObject:@"CULTU" forKey:@"기관코드" atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBGiftService alloc] initWithServiceId:GIFT_E1720 viewController:self] autorelease];
            
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 200: {
            
            // 취소
            
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    self.dataList = [aDataSet arrayWithForKey:@"상품권취소대상"];
    
    for (NSMutableDictionary *dic in self.dataList) {
        
        if ([dic[@"승인번호"] isEqualToString:_approvalNumber.text]) {
            
            // 아래 내용 수정시 SHBGiftCancelListViewController 에서도 동일하게 수정 필요
            
            if ([_emartBtn isSelected]) {
                
                [dic setObject:@"신세계상품권" forKey:@"_상품권명"];
                [dic setObject:@"EMART" forKey:@"상품권명"];
            }
            else if ([_cultuBtn isSelected]) {
                
                [dic setObject:@"문화상품권" forKey:@"_상품권명"];
                [dic setObject:@"CULTU" forKey:@"상품권명"];
            }
            
            [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"구매금액"]] forKey:@"_구매금액"];
            [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"환급금액"]] forKey:@"_환급금액"];
            
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            
            NSDate *date = [dateFormatter dateFromString:dic[@"판매일자"]];
            
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            
            NSString *dateStr = [dateFormatter stringFromDate:date];
            
            [dic setObject:dateStr forKey:@"_구매일자"];
            
            [dic setObject:_selectAccountDic[@"2"] forKey:@"_계좌번호"];
            [dic setObject:_selectAccountDic[@"은행구분"] forKey:@"_계좌구분"];
            
            self.data = dic;
            
            break;
        }
    }
    
    if ([self.dataList count] == 0 || [[self.data allKeys] count] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"고객님이 취소하고자 하는 구매 정보가 없습니다.\n상품권 종류, 구매일자, 거래승인번호를 확인하여 주시기 바랍니다."];
        return NO;
    }
    
    SHBGiftCancelDetailViewController *viewController = [[[SHBGiftCancelDetailViewController alloc] initWithNibName:@"SHBGiftCancelDetailViewController" bundle:nil] autorelease];
    
    viewController.data = self.data;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
    if (textField == _approvalNumber) {
        
        if ([textField.text length] >= 8 && range.length == 0) {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([_dateField.textField.text length] == 0) {
        
        [_dateField setDate:[NSDate date]];
    }
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectAccountDic = _accountList[anIndex];
    
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateHighlighted];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateSelected];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateDisabled];
}

@end
