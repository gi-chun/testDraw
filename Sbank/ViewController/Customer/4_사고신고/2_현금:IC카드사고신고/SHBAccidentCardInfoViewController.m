//
//  SHBAccidentCardInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentCardInfoViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBAccidentCardSelViewController.h" // 현금/IC카드 사고신고

#import "SHBListPopupView.h" // list popup

@interface SHBAccidentCardInfoViewController ()
<SHBAccidentCardSelViewControllerDelegate, SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectCardDic; // 선택된 신고카드

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

@implementation SHBAccidentCardInfoViewController

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
    self.strBackButtonTitle = @"현금/IC카드 사고신고 1단계";
    
    self.selectCardDic = [NSMutableDictionary dictionary];
    
    CGFloat y = _infoLabel1.frame.origin.y;
    
    [self adjustToView:_infoLabel1 originX:_infoLabel1.frame.origin.x originY:y text:_infoLabel1.text];
    
    y += _infoLabel1.frame.size.height + 10;
    
    [self adjustToView:_infoLabel2 originX:_infoLabel2.frame.origin.x originY:y text:_infoLabel2.text];
    
    [_infoImage2 setFrame:CGRectMake(_infoImage2.frame.origin.x,
                                     y + 3,
                                     _infoImage2.frame.size.width,
                                     _infoImage2.frame.size.height)];
    
    y += _infoLabel2.frame.size.height + 5;
    
    [self adjustToView:_infoLabel3 originX:_infoLabel3.frame.origin.x originY:y text:_infoLabel3.text];
    
    
    [_infoImage3 setFrame:CGRectMake(_infoImage3.frame.origin.x,
                                     y + 3,
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
                           @"거래구분" : @"1",
                           @"은행CODE" : @"0",
                           @"금융IC항목CODE" : @"1121",
                           @"입력_정보구분" : @"1",
                           @"입력_상태구분" : @"1",
                           @"입력_카드종류" : @"99",
                           @"입력_조회범위" : @"1",
                           @"입력_MS_IC구분" : @"9",
                           }];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4140
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
    
    [_infoLabel1 release];
    [_infoImage2 release];
    [_infoLabel2 release];
    [_infoImage3 release];
    [_infoLabel3 release];
    [_bgBox release];
    [_bottomView release];
    [_card release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoLabel1:nil];
    [self setInfoImage2:nil];
    [self setInfoLabel2:nil];
    [self setInfoImage3:nil];
    [self setInfoLabel3:nil];
    [self setBgBox:nil];
    [self setBottomView:nil];
    [self setCard:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    [self accidentCardSelCancel];
    
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
                              labelSize.height + 2)];
}

#pragma mark - Button

/// 신고카드선택
- (IBAction)cardBtn:(UIButton *)sender
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 가능한 현금/IC카드가 없습니다."];
        return;
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"신고카드 선택"
                                                                   options:(NSMutableArray *)self.dataList
                                                                   CellNib:@"SHBAccidentCardInfoCell"
                                                                     CellH:69
                                                               CellDispCnt:5
                                                                CellOptCnt:3] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    if ([_card.titleLabel.text length] == 0 || [_card.titleLabel.text isEqualToString:@"선택하세요"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 할 카드를 선택하여 주십시오."];
        return;
    }
    
    AppInfo.commonDic = _selectCardDic;
    
    SHBAccidentCardSelViewController *viewController = [[[SHBAccidentCardSelViewController alloc] initWithNibName:@"SHBAccidentCardSelViewController" bundle:nil] autorelease];
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
    
    Debug(@"%@", aDataSet);
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", [aDataSet[@"실명번호"] substringToIndex:6]]
                    forKey:@"_주민등록번호"
                   atIndex:0];
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"시작라인"]) {
        if ([dic[@"금융IC매체종류"] isEqualToString:@"1"]) {
            [dic setObject:@"현금카드"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"11"]) {
            [dic setObject:@"직불카드"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"21"]) {
            [dic setObject:@"K-CASH"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"22"]) {
            [dic setObject:@"몬덱스"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"31"]) {
            [dic setObject:@"금융IC"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"32"]) {
            [dic setObject:@"모바일IC"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"51"]) {
            [dic setObject:@"신용카드"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"52"]) {
            [dic setObject:@"신용카드IC"
                    forKey:@"_카드종류"];
        }
        else if ([dic[@"금융IC매체종류"] isEqualToString:@"53"]) {
            [dic setObject:@"금융IC"
                    forKey:@"_카드종류"];
        }
        
        [dic setObject:[NSString stringWithFormat:@"카드종류 : %@", dic[@"_카드종류"]]
                forKey:@"1"];
        [dic setObject:[NSString stringWithFormat:@"카드번호 : %@", dic[@"카드번호"]]
                forKey:@"2"];
        [dic setObject:[NSString stringWithFormat:@"계좌번호 : %@", dic[@"계좌번호"]]
                forKey:@"3"];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    self.dataList = [aDataSet arrayWithForKey:@"시작라인"];
    
    return YES;
}

#pragma mark - SHBAccidentCardSelViewController

- (void)accidentCardSelCancel
{
    self.selectCardDic = [NSMutableDictionary dictionary];
    
    [_card setTitle:@"선택하세요" forState:UIControlStateNormal];
}


#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectCardDic = self.dataList[anIndex];
    
    [_card setTitle:_selectCardDic[@"카드번호"] forState:UIControlStateNormal];
}

- (void)listPopupViewDidCancel
{
    
}

@end
