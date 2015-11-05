//
//  SHBUserInfoEditCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserInfoEditCompleteViewController.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBGoodsSubTitleView.h" // 서브타이틀

@interface SHBUserInfoEditCompleteViewController ()
{
    NSInteger _serverRequestCount;
}

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBUserInfoEditCompleteViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 서버 에러 발생시
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotiServerError)
                                                 name:@"notiServerError"
                                               object:nil];
    
    NSInteger step = 6;
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        [self setTitle:@"본인정보 이용제공 조회시스템"];
        
        step = 2;
    }
    else {
        
        [self setTitle:@"고객정보변경"];
        
        step = 6;
    }
    
    SHBGoodsSubTitleView *titleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"고객정보변경 완료" maxStep:step focusStepNumber:step] autorelease];
    FrameReposition(titleView, 0, 0);
    
    [_mainView addSubview:titleView];
    
    [self navigationBackButtonHidden];
    
    [self.contentScrollView addSubview:_mainView];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    CGFloat yy = _homeAddress.frame.origin.y;
    
    [self adjustToView:_homeAddress originX:_homeAddress.frame.origin.x originY:yy text:_homeAddress.text];
    
    yy += _homeAddress.frame.size.height + 9;
    
    [self adjustToView:_homeNumberLabel originX:_homeNumberLabel.frame.origin.x originY:yy text:_homeNumberLabel.text];
    [self adjustToView:_homeNumber originX:_homeNumber.frame.origin.x originY:yy text:_homeNumber.text];
    
    yy += _homeNumber.frame.size.height + 9;
    
    [self adjustToView:_homeFAXLabel originX:_homeFAXLabel.frame.origin.x originY:yy text:_homeFAXLabel.text];
    [self adjustToView:_homeFAX originX:_homeFAX.frame.origin.x originY:yy text:_homeFAX.text];
    
    yy += _homeFAX.frame.size.height + 9;
    
    [self adjustToView:_officeAddressLabel originX:_officeAddressLabel.frame.origin.x originY:yy text:_officeAddressLabel.text];
    [self adjustToView:_officeAddress originX:_officeAddress.frame.origin.x originY:yy text:_officeAddress.text];
    
    yy += _officeAddress.frame.size.height + 9;
    
    [self adjustToView:_officeNumberLabel originX:_officeNumberLabel.frame.origin.x originY:yy text:_officeNumberLabel.text];
    [self adjustToView:_officeNumber originX:_officeNumber.frame.origin.x originY:yy text:_officeNumber.text];
    
    yy += _officeNumber.frame.size.height + 9;
    
    [self adjustToView:_officeNameLabel originX:_officeNameLabel.frame.origin.x originY:yy text:_officeNameLabel.text];
    [self adjustToView:_officeName originX:_officeName.frame.origin.x originY:yy text:_officeName.text];
    
    yy += _officeName.frame.size.height + 9;
    
    [self adjustToView:_officeFAXLabel originX:_officeFAXLabel.frame.origin.x originY:yy text:_officeFAXLabel.text];
    [self adjustToView:_officeFAX originX:_officeFAX.frame.origin.x originY:yy text:_officeFAX.text];
    
    yy += _officeFAX.frame.size.height + 9;
    
    [self adjustToView:_deptLabel originX:_deptLabel.frame.origin.x originY:yy text:_deptLabel.text];
    [self adjustToView:_dept originX:_dept.frame.origin.x originY:yy text:_dept.text];
    
    yy += _dept.frame.size.height + 9;
    
    [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x,
                                     yy,
                                     _bottomView.frame.size.width,
                                     _bottomView.frame.size.height)];
    
    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   yy + _bottomView.frame.size.height)];
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    if (![AppInfo.commonDic[@"_이전휴대폰번호"] isEqualToString:AppInfo.commonDic[@"_휴대폰번호"]]) {
        _serverRequestCount = 1;
        
        AppInfo.isBolckServerErrorDisplay = YES;
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"휴대폰번호" : [AppInfo.commonDic[@"_이전휴대폰번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                               @"MSG" : [NSString stringWithFormat:@"[신한은행] %@님, 휴대폰번호 변경 완료! 본인외 변경시 즉시 신고바랍니다.",
                                         AppInfo.commonDic[@"_고객성명"]],
                               }];
        
        self.service = nil;
        self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E2115
                                                         viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_homeAddress release];
    [_homeNumberLabel release];
    [_homeNumber release];
    [_officeAddressLabel release];
    [_officeAddress release];
    [_officeNumberLabel release];
    [_officeNumber release];
    [_officeNameLabel release];
    [_officeName release];
    [_deptLabel release];
    [_dept release];
    [_bottomView release];
    [_mainView release];
    [_officeFAXLabel release];
    [_officeFAX release];
    [_homeFAXLabel release];
    [_homeFAX release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setHomeAddress:nil];
    [self setHomeNumberLabel:nil];
    [self setHomeNumber:nil];
    [self setOfficeAddressLabel:nil];
    [self setOfficeAddress:nil];
    [self setOfficeNumberLabel:nil];
    [self setOfficeNumber:nil];
    [self setOfficeNameLabel:nil];
    [self setOfficeName:nil];
    [self setDeptLabel:nil];
    [self setDept:nil];
    [self setBottomView:nil];
    [self setMainView:nil];
    [self setOfficeFAXLabel:nil];
    [self setOfficeFAX:nil];
    [self setHomeFAXLabel:nil];
    [self setHomeFAX:nil];
    [super viewDidUnload];
}

#pragma mark - Notification

- (void)getNotiServerError
{
    if (_serverRequestCount == 1) {
        _serverRequestCount = 2;
        
        AppInfo.isBolckServerErrorDisplay = YES;
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"휴대폰번호" : [AppInfo.commonDic[@"_휴대폰번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                               @"MSG" : [NSString stringWithFormat:@"[신한은행] %@님, 휴대폰번호 변경 완료! 본인외 변경시 즉시 신고바랍니다.",
                                         AppInfo.commonDic[@"_고객성명"]],
                               }];
        
        self.service = nil;
        self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E2115
                                                         viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
    }
    else if (_serverRequestCount == 2) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    if ([[SHBUtilFile getOSVersion] integerValue] >= 7) {
        
        CGRect labelRect = [text boundingRectWithSize:CGSizeMake(view.frame.size.width, 999)
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] }
                                              context:nil];
        
        if (labelRect.size.height > 30) {
            labelRect.size.height = 37;
        }
        else {
            labelRect.size.height = 16;
        }
        
        [view setFrame:CGRectMake(xx,
                                  yy,
                                  view.frame.size.width,
                                  labelRect.size.height + 5)];
    }
    else {
        
        UILabel *label = [[[UILabel alloc] init] autorelease];
        [label setText:text];
        [label setFont:[UIFont systemFontOfSize:15]];
        
        CGSize labelSize = [text sizeWithFont:label.font
                            constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                                lineBreakMode:label.lineBreakMode];
        
        if (labelSize.height > 36) {
            labelSize.height = 36;
        }
        else {
            labelSize.height = 16;
        }
        
        [view setFrame:CGRectMake(xx,
                                  yy,
                                  view.frame.size.width,
                                  labelSize.height + 5)];
    }
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopToRootViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (_serverRequestCount == 2) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        return NO;
    }
    
    _serverRequestCount = 2;
    
    AppInfo.isBolckServerErrorDisplay = YES;
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"휴대폰번호" : [AppInfo.commonDic[@"_휴대폰번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                           @"MSG" : [NSString stringWithFormat:@"[신한은행] %@님, 휴대폰번호 변경 완료! 본인외 변경시 즉시 신고바랍니다.",
                                     AppInfo.commonDic[@"_고객성명"]],
                           }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E2115
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
    
    return NO;
}

@end
