//
//  SHBCardLimitInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardLimitInfoViewController.h"
#import "SHBCardService.h" // 서비스

#import "SHBListPopupView.h" // list popup

@interface SHBCardLimitInfoViewController ()
<SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectCardDic; // 선택한 카드번호

@end

@implementation SHBCardLimitInfoViewController

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
    
    [self setTitle:@"이용한도조회"];
    
    self.selectCardDic = [NSMutableDictionary dictionary];
    
    // 카드가 1개인 경우
    if ([AppInfo.codeList.creditCardList count] == 1) {
        self.selectCardDic = AppInfo.codeList.creditCardList[0];
        
        [_cardNumber setTitle:_selectCardDic[@"2"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCardDic = nil;
    
    [_cardNumber release];
    [_bottomView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCardNumber:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)cardNumberBtn:(UIButton *)sender
{
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"카드목록"
                                                                   options:AppInfo.codeList.creditCardList
                                                                   CellNib:@"SHBAccountListPopupCell"
                                                                     CellH:50
                                                               CellDispCnt:5
                                                                CellOptCnt:4] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

- (IBAction)searchBtn:(UIButton *)sender
{
    if ([_cardNumber.titleLabel.text length] == 0 ||
        [_cardNumber.titleLabel.text isEqualToString:@"선택하세요"]) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"카드번호를 선택해 주십시오."];
        return;
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"신한카드번호" : _selectCardDic[@"카드번호"],
                           @"카드비밀번호" : @"0000",
                           @"거래구분" : @"1",
                           }];
    
    self.service = nil;
    self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2901
                                                 viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    Debug(@"%@", aDataSet);
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"총한도금액"]]
                    forKey:@"_총한도금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"사용금액"]]
                    forKey:@"_사용금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"사용가능금액"]]
                    forKey:@"_사용가능금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"현금서비스한도"]]
                    forKey:@"_현금서비스한도"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"현금서비스사용금액"]]
                    forKey:@"_현금서비스사용금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"현금서비스잔여한도"]]
                    forKey:@"_현금서비스잔여한도"
                   atIndex:0];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    [_bottomView setHidden:NO];
    
    return YES;
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectCardDic = AppInfo.codeList.creditCardList[anIndex];
    
    [_cardNumber setTitle:_selectCardDic[@"2"] forState:UIControlStateNormal];
    
    [_bottomView setHidden:YES];
}

- (void)listPopupViewDidCancel
{
    
}

@end
