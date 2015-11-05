//
//  SHBForexRequestInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBDateField.h"
#import "SHBSecureTextField.h"
#import "SHBButton.h"

/**
 외환/골드 - 외화환전신청
 외화환전신청 정보입력(2) 화면
 */

@interface SHBForexRequestInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, SHBDateFieldDelegate, SHBSecureDelegate, UITextFieldDelegate>

@property (retain, nonatomic) OFDataSet *dataSetF3780; // F3780

@property (retain, nonatomic) IBOutlet UIButton *tourPurposeBtn; // 여행비용
@property (retain, nonatomic) IBOutlet UIButton *savePurposeBtn; // 외화보유
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UILabel *balance; // 출금가능잔액
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 외화수령일
@property (retain, nonatomic) IBOutlet SHBSecureTextField *passwd; // 계좌비밀번호
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber1; // 연락전화번호1
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber2; // 연락전화번호2
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber3; // 연락전화번호3
@property (retain, nonatomic) IBOutlet SHBButton *place1; // 외화수령지점1
@property (retain, nonatomic) IBOutlet SHBButton *place2; // 외화수령지점2
@property (retain, nonatomic) IBOutlet SHBButton *place3; // 외화수령지점3
@property (retain, nonatomic) IBOutlet SHBButton *accountNumber; // 출금계좌번호
@property (retain, nonatomic) IBOutlet UIView *placeInfo; // 외화수령지점 안내
@property (retain, nonatomic) IBOutlet UIImageView *placeInfoDot;
@property (retain, nonatomic) IBOutlet UILabel *placeInfoLabel;

@end
