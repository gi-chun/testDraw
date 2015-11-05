//
//  SHBCloseProductInputAmountViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 해지상품 리스트 > 일부해지 화면
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBCloseProductInputAmountViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>

/**
 상품부기명 or 상품명
 */
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;

/**
 신계좌번호
 */
@property (retain, nonatomic) IBOutlet UILabel *lblAccountNumber;

/**
 잔액
 */
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;

/**
 신규일자
 */
@property (retain, nonatomic) IBOutlet UILabel *lblNewDate;

/**
 만기일자
 */
@property (retain, nonatomic) IBOutlet UILabel *lblExpirationDate;

/**
 일부해지 횟수
 */
@property (retain, nonatomic) IBOutlet UILabel *lblPartCloseCount;

/**
 전액해지 라디오버튼
 */
@property (retain, nonatomic) IBOutlet UIButton *btnAllClose;

/**
 일부해지(원금기준) 라디오버튼
 */
@property (retain, nonatomic) IBOutlet UIButton *btnPartClose;

/**
 일부해지 금액
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfCloseAmount;

/**
 하단 InfoBox
 */
@property (retain, nonatomic) IBOutlet UIImageView *ivInfoBox;

@property (retain, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, retain) NSDictionary *D3280;

- (IBAction)closeTypeRadioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
