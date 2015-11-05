//
//  SHBAccidentBankBookInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentBankBookInfoViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBAccidentBankBookSelViewController.h" // 통장/인감 사고신고

#import "SHBListPopupView.h" // list popup

@interface SHBAccidentBankBookInfoViewController ()
<SHBAccidentBankBookSelViewControllerDelegate, SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectAccountDic; // 선택된 신고계좌번호

/// Notification 등록
- (void)initNotification;

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBAccidentBankBookInfoViewController

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
    
    [self initNotification];
    
    [self setTitle:@"사고신고"];
    self.strBackButtonTitle = @"통장/인감 사고신고 1단계";
    
    self.selectAccountDic = [NSMutableDictionary dictionary];
    
    CGFloat y = _infoLabel1.frame.origin.y;
    
    [self adjustToView:_infoLabel1 originX:_infoLabel1.frame.origin.x originY:y text:_infoLabel1.text];
    
    y += _infoLabel1.frame.size.height + 10;
    
    [self adjustToView:_infoLabel2 originX:_infoLabel2.frame.origin.x originY:y text:_infoLabel2.text];
    
    [_infoImage2 setFrame:CGRectMake(_infoImage2.frame.origin.x,
                                     y + 6,
                                     _infoImage2.frame.size.width,
                                     _infoImage2.frame.size.height)];
    
    y += _infoLabel2.frame.size.height + 10;
    
    [self adjustToView:_infoLabel3 originX:_infoLabel3.frame.origin.x originY:y text:_infoLabel3.text];
    
    [_infoImage3 setFrame:CGRectMake(_infoImage3.frame.origin.x,
                                     y + 6,
                                     _infoImage3.frame.size.width,
                                     _infoImage3.frame.size.height)];
    
    y += _infoLabel3.frame.size.height + 5;
    
    [_bgBox setFrame:CGRectMake(_bgBox.frame.origin.x,
                                _bgBox.frame.origin.y,
                                _bgBox.frame.size.width,
                                y - _bgBox.frame.origin.y)];
    
    [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x,
                                     _bgBox.frame.origin.y + _bgBox.frame.size.height,
                                     _bottomView.frame.size.width,
                                     _bottomView.frame.size.height)];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"고객번호" : AppInfo.customerNo,
                           //@"주민등록번호" : AppInfo.ssn,
                           //@"주민등록번호" : [AppInfo getPersonalPK],
                           @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                           @"거래구분" : @"9",
                           @"보안계좌조회구분" : @"2",
                           @"계좌감추기여부" : @"1",
                           }];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4130
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.selectAccountDic = nil;
    
    [_infoLabel1 release];
    [_infoImage2 release];
    [_infoLabel2 release];
    [_infoImage3 release];
    [_infoLabel3 release];
    [_bottomView release];
    [_bgBox release];
    [_account release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoLabel1:nil];
    [self setInfoImage2:nil];
    [self setInfoLabel2:nil];
    [self setInfoImage3:nil];
    [self setInfoLabel3:nil];
    [self setBottomView:nil];
    [self setBgBox:nil];
    [self setAccount:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    [self accidentBankBookSelCancel];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

#pragma mark -

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:13]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 4)];
}

#pragma mark - Button

/// 신고계좌번호선택
- (IBAction)accountBtn:(UIButton *)sender
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 가능한 통장/인감 계좌가 없습니다."];
        return;
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"신고계좌 선택"
                                                                   options:(NSMutableArray *)self.dataList
                                                                   CellNib:@"SHBAccidentBankBookInfoCell"
                                                                     CellH:69
                                                               CellDispCnt:5
                                                                CellOptCnt:3] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    if ([_account.titleLabel.text length] == 0 || [_account.titleLabel.text isEqualToString:@"선택하세요"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 할 계좌를 선택하여 주십시오."];
        return;
    }
    
    AppInfo.commonDic = _selectAccountDic;
    
    SHBAccidentBankBookSelViewController *viewController = [[[SHBAccidentBankBookSelViewController alloc] initWithNibName:@"SHBAccidentBankBookSelViewController" bundle:nil] autorelease];
    [viewController setDelegate:self];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"계좌목록"]) {
        if (![dic[@"인터넷신규계좌여부"] isEqualToString:@"1"] &&
            ![dic[@"전자통장여부"]  isEqualToString:@"1"] &&
            ![dic[@"U드림통장여부"] isEqualToString:@"1"] &&
            (![dic[@"인감분실여부"] isEqualToString:@"1"] || ![dic[@"통장분실여부"] isEqualToString:@"1"]) &&
            ![dic[@"예금종류"] isEqualToString:@"7"]) {
            
            if ([dic[@"상품부기명"] length] > 0) {
                [dic setObject:dic[@"상품부기명"]
                        forKey:@"1"];
            }
            else {
                [dic setObject:dic[@"과목명"]
                        forKey:@"1"];
            }
            
            if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                [dic setObject:dic[@"계좌번호"]
                        forKey:@"2"];
            }
            else {
                [dic setObject:dic[@"구계좌번호"]
                        forKey:@"2"];
            }
            
            if ([dic[@"잔액"] length] > 0 || [dic[@"펑가금액"] length] > 0 || [dic[@"외환잔액"] length] > 0) {
                if ([dic[@"통화코드"] isEqualToString:@""]) {
                    if ([dic[@"예금종류"] isEqualToString:@"4"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"평가금액"]]
                                forKey:@"3"];
                    }
                    else if ([dic[@"예금종류"] isEqualToString:@"5"] || [dic[@"예금종류"] isEqualToString:@"6"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"외화잔액"]]
                                forKey:@"3"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"잔액"]]
                                forKey:@"3"];
                    }
                    
                    [dic setObject:@"원"
                            forKey:@"_통화코드"];
                }
                else if ([dic[@"통화코드"] isEqualToString:@"KRW"]) {
                    if ([dic[@"예금종류"] isEqualToString:@"4"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)", dic[@"평가금액"]]
                                forKey:@"3"];
                    }
                    else if ([dic[@"예금종류"] isEqualToString:@"5"] || [dic[@"예금종류"] isEqualToString:@"6"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)", dic[@"외화잔액"]]
                                forKey:@"3"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)", dic[@"잔액"]]
                                forKey:@"3"];
                    }
                    
                    [dic setObject:@"원(KRW)"
                            forKey:@"_통화코드"];
                }
                else {
                    if ([dic[@"예금종류"] isEqualToString:@"4"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"평가금액"], dic[@"통화코드"]]
                                forKey:@"3"];
                    }
                    else if ([dic[@"예금종류"] isEqualToString:@"5"] || [dic[@"예금종류"] isEqualToString:@"6"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                                forKey:@"3"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"잔액"], dic[@"통화코드"]]
                                forKey:@"3"];
                    }
                    
                    [dic setObject:dic[@"통화코드"]
                            forKey:@"_통화코드"];
                }
                
                if (![dic[@"예금종류"] isEqualToString:@"4"] &&
                    ![dic[@"예금종류"] isEqualToString:@"5"] &&
                    ![dic[@"예금종류"] isEqualToString:@"6"]) {
                    if ([dic[@"_통화코드"] hasPrefix:@"원"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"잔액"]]
                                forKey:@"_잔액"];
                    }
                    else {
                        [dic setObject:dic[@"잔액"]
                                forKey:@"_잔액"];
                    }
                }
                else if ([dic[@"예금종류"] isEqualToString:@"4"]) {
                    if ([dic[@"_통화코드"] hasPrefix:@"원"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"평가금액"]]
                                forKey:@"_잔액"];
                    }
                    else {
                        [dic setObject:dic[@"평가금액"]
                                forKey:@"_잔액"];
                    }
                }
                else if ([dic[@"예금종류"] isEqualToString:@"5"] || [dic[@"예금종류"] isEqualToString:@"6"]) {
                    if ([dic[@"_통화코드"] hasPrefix:@"원"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"외화잔액"]]
                                forKey:@"_잔액"];
                    }
                    else {
                        [dic setObject:dic[@"외화잔액"]
                                forKey:@"_잔액"];
                    }
                }
                
                if ([dic[@"통장분실여부"] isEqualToString:@"1"]) {
                    [dic setObject:@"통장"
                            forKey:@"_사고신고여부"];
                }
                else if ([dic[@"인감분실여부"] isEqualToString:@"1"]) {
                    [dic setObject:@"인감"
                            forKey:@"_사고신고여부"];
                }
                else {
                    [dic setObject:@"없음"
                            forKey:@"_사고신고여부"];
                }
            }
            
            [array addObject:dic];
        }
    }
    
    self.dataList = (NSArray *)array;
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - SHBAccidentBankBookSelViewController

- (void)accidentBankBookSelCancel
{
    self.selectAccountDic = [NSMutableDictionary dictionary];
    
    [_account setTitle:@"선택하세요" forState:UIControlStateNormal];
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectAccountDic = self.dataList[anIndex];
    
    [_account setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
}

- (void)listPopupViewDidCancel
{
    
}

@end
