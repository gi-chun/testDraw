//
//  SHBCloseProductConfirmViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
일부해지일 경우 : 해지상품 리스트 > 일부해지 화면 > 해지내용확인 화면 
전액해지일 경우 : 해지상품 리스트 > 해지내용확인 화면 
 */

#import "SHBBaseViewController.h"
#import "SHBAccidentPopupView.h" // popup

@interface SHBCloseProductConfirmViewController : SHBBaseViewController <SHBSecureDelegate>

@property (nonatomic, retain) SHBSecureTextField *tfAccountPW;

@property (retain, nonatomic) IBOutlet SHBButton *guide;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *bottomView_1;
@property (nonatomic, retain) NSDictionary *D3280;  // 일부, 전체 해지

@property (nonatomic, retain)  NSString *account_D3342;  // 신탁
@property (nonatomic, retain)  NSString *name_D3342;  // 신탁
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

@property (retain, nonatomic) SHBAccidentPopupView *popupView;


/**
 일부해지금액 : D3285 전문 태울때 사용
 */
@property (nonatomic, retain) NSString *strPartCloseAmount;

/**
 서비스코드 : D3281(전체해지로 진입) 혹은 D3285(일부해지로 진입)
 */
@property NSInteger nServiceCode;

/**
 지급항목 : 존재하는 데이터만 가공한 데이터
 */
@property (nonatomic, retain) NSMutableArray *marrPayment;

/**
 공제항목 : 존재하는 데이터만 가공한 데이터
 */
@property (nonatomic, retain) NSMutableArray *marrDeduction;

/**
 예적금 담보대출 해지인가?
 */
@property BOOL isCloseTypeLoan;

/**
 SHBCloseProductSecurityViewController에서 사용할 dataSet
 */
@property (nonatomic, retain) SHBDataSet *dataSet;

@property NSInteger nMaxStep;
@property NSInteger nFocusStep;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;
- (IBAction)infoPressed:(id)sender;

@end
