//
//  SHBForexFavoritDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritDetailViewController.h"
#import "SHBExchangeService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBForexFavoritExecuteInputViewController.h" // 자주쓰는 해외송금 정보입력

@interface SHBForexFavoritDetailViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBForexFavoritDetailViewController

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
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    self.strBackButtonTitle = @"자주쓰는 해외송금 상세";
    
    [self.binder bind:self dataSet:_detailData];
    
    // 가변 길이 설정
    CGFloat yy = _consignee.frame.origin.y;
    
    [self adjustToView:_consignee originX:_consignee.frame.origin.x originY:yy text:_consignee.text];
    
    yy += _consignee.frame.size.height + 9;
    
    [self adjustToView:_bankNameLabel originX:8 originY:yy text:_bankNameLabel.text];
    [self adjustToView:_bankName originX:_bankName.frame.origin.x originY:yy text:_bankName.text];
    
    yy += _bankName.frame.size.height + 9;
    
    [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x,
                                    yy,
                                     _bottomView.frame.size.width,
                                     _bottomView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.detailData = nil;
    
    [_bottomView release];
    [_consignee release];
    [_bankNameLabel release];
    [_bankName release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setBottomView:nil];
    [self setConsignee:nil];
    [self setBankNameLabel:nil];
    [self setBankName:nil];
	[super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
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
                              labelSize.height + 2)];
}

#pragma mark - Button
/// 해외송금 실행
- (IBAction)okBtn:(UIButton *)sender
{
    
    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    if (![SHBUtility isOPDate:date] || time < 90000 || time > 160000) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeTwoButton
                           tag:100
                         title:@""
                       message:@"은행 영업시간 이외의 시간에 송금신청을 하시면, 신청시점의 고시환율(직전 최종영업일의 최종고시환율)을 적용하여 송금대금(수수료포함)이 인출되며, 해외은행으로의 전신문은 최초 도래하는 은행영업일의 오전 영업시간에 이루어집니다.\n\n해외송금을 계속 진행하시려면 확인버튼을 선택하여 주십시오."];
    }
    else {
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                               @"조회일자" : AppInfo.tran_Date,
                               @"고시회차" : @"1",
                               }];
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3732_SERVICE
                                                       viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
    }
}

#pragma mark - Response

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    Debug(@"%@", aDataSet);
    
    switch (self.service.serviceId) {
        case EXCHANGE_F3732_SERVICE:
        {
            SHBForexFavoritExecuteInputViewController *viewController = [[[SHBForexFavoritExecuteInputViewController alloc] initWithNibName:@"SHBForexFavoritExecuteInputViewController" bundle:nil] autorelease];
            [viewController setDataSetF3732:aDataSet];
            [viewController setPreDataSet:_detailData];
            [viewController setNeedsCert:YES];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if ([alertView tag] == 100) {
        if (buttonIndex == 0) {
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"조회일자" : AppInfo.tran_Date,
                                   @"고시회차" : @"1",
                                   }];
            
            self.service = nil;
            self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3732_SERVICE
                                                           viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
    }
}

@end
