//
//  SHBForexFavoritExecuteConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 자주쓰는 해외송금/조회
 자주쓰는 해외송금 정보확인 화면
 */

@interface SHBForexFavoritExecuteConfirmViewController : SHBBaseViewController

@property (retain, nonatomic) OFDataSet *detailData;

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *securityView;
@property (retain, nonatomic) IBOutlet UILabel *name; // 성명
@property (retain, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumber; // 전화번호
@property (retain, nonatomic) IBOutlet UILabel *juminLabel;
@property (retain, nonatomic) IBOutlet UILabel *jumin; // 유학생주민등록번호
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *address; // 주소
@property (retain, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *bankName; // 은행명
@property (retain, nonatomic) IBOutlet UILabel *branchNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *branchName; // 지점명
@property (retain, nonatomic) IBOutlet UILabel *bankAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *bankAddress; // 은행주소
@property (retain, nonatomic) IBOutlet UIView *addressBottomView;
@property (retain, nonatomic) IBOutlet UIView *lineView;

@end
