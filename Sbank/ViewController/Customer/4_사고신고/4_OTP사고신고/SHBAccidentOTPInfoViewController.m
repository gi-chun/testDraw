//
//  SHBAccidentOTPInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentOTPInfoViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBAccidentOTPCompleteViewController.h" // OTP카드 사고신고 완료

@interface SHBAccidentOTPInfoViewController ()

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

@implementation SHBAccidentOTPInfoViewController

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
    
    CGFloat y = _infoLabel1.frame.origin.y;
    
    [self adjustToView:_infoLabel1 originX:_infoLabel1.frame.origin.x originY:y text:_infoLabel1.text];
    
    y += _infoLabel1.frame.size.height + 10;
    
    [self adjustToView:_infoLabel2 originX:_infoLabel2.frame.origin.x originY:y text:_infoLabel2.text];
    
    [_infoImage2 setFrame:CGRectMake(_infoImage2.frame.origin.x,
                                     y + 2,
                                     _infoImage2.frame.size.width,
                                     _infoImage2.frame.size.height)];
    
    y += _infoLabel2.frame.size.height + 10;
    
    [self adjustToView:_infoLabel3 originX:_infoLabel3.frame.origin.x originY:y text:_infoLabel3.text];
    
    [_infoImage3 setFrame:CGRectMake(_infoImage3.frame.origin.x,
                                     y + 2,
                                     _infoImage3.frame.size.width,
                                     _infoImage3.frame.size.height)];
    
    y += _infoLabel3.frame.size.height + 10;
    
    [self adjustToView:_infoLabel4 originX:_infoLabel4.frame.origin.x originY:y text:_infoLabel4.text];
    
    [_infoImage4 setFrame:CGRectMake(_infoImage4.frame.origin.x,
                                     y + 2,
                                     _infoImage4.frame.size.width,
                                     _infoImage4.frame.size.height)];
    
    y += _infoLabel4.frame.size.height + 5;
    
    [_bgBox setFrame:CGRectMake(_bgBox.frame.origin.x,
                                _bgBox.frame.origin.y,
                                _bgBox.frame.size.width,
                                y - _bgBox.frame.origin.y)];
    
    [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x,
                                     _bgBox.frame.origin.y + _bgBox.frame.size.height,
                                     _bottomView.frame.size.width,
                                     _bottomView.frame.size.height)];
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
    [_infoLabel3 release];
    [_infoImage3 release];
    [_infoLabel3 release];
    [_infoImage4 release];
    [_infoLabel4 release];
    [_bgBox release];
    [_bottomView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoLabel1:nil];
    [self setInfoImage2:nil];
    [self setInfoLabel3:nil];
    [self setInfoImage3:nil];
    [self setInfoLabel3:nil];
    [self setInfoImage4:nil];
    [self setInfoLabel4:nil];
    [self setBgBox:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        SHBAccidentOTPCompleteViewController *viewController = [[[SHBAccidentOTPCompleteViewController alloc] initWithNibName:@"SHBAccidentOTPCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    [self.navigationController fadePopViewController];
}

#pragma mark -

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
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

/// 예
- (IBAction)yesBtn:(UIButton *)sender
{
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"사고신고";
    
    AppInfo.electronicSignCode = CUSTOMER_E4122;
    AppInfo.electronicSignTitle = @"OTP카드 사고신고";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)고객성명: %@", AppInfo.userInfo[@"고객성명"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)거래시간: %@", AppInfo.tran_Time]];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           //@"주민등록번호" : AppInfo.ssn,
                           //@"주민등록번호" : [AppInfo getPersonalPK],
                             @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                           }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4122
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 아니오
- (IBAction)noBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopViewController];
}

@end
