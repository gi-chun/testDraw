//
//  SHBNoticeSmartCardDetailViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 15..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//
#import "SHBBaseViewController.h"
#import <UIKit/UIKit.h>


@protocol SHBSmartCardDetailDelegate <NSObject>


- (void)smartCardDetailBack;

@optional
- (BOOL)isTelephoneConsultationRequest;

@end


@interface SHBNoticeSmartCardDetailViewController : SHBBaseViewController

{
    IBOutlet UIScrollView   *scrollView1;
    IBOutlet UILabel        *label1; // 이름
    IBOutlet UILabel        *label2; // 별명
    IBOutlet UILabel        *label3; // 주소
    IBOutlet UILabel        *label4; // 대표전화
    IBOutlet UILabel        *label5; // 직통전화
    IBOutlet UILabel        *label6; // 이메일
    IBOutlet UILabel        *label7; // 핸드폰번호
    IBOutlet UILabel        *label8; // 팩스
    
    IBOutlet UILabel        *labelbig1; // 이름
    IBOutlet UILabel        *labelbig2; // 별명
    IBOutlet UILabel        *labelbig3; // 주소
    IBOutlet UILabel        *labelbig4; // 대표전화
    IBOutlet UILabel        *labelbig5; // 직통전화
    IBOutlet UILabel        *labelbig6; // 이메일
    IBOutlet UILabel        *labelbig7; // 핸드폰번호
    IBOutlet UILabel        *labelbig8; // 팩스
    IBOutlet UILabel        *labelbig10; // 전담직원
    IBOutlet UILabel        *labelbig12; // 소속
    
    IBOutlet UIButton       *btnBig4; // 대표전화
    IBOutlet UIButton       *btnBig5; // 직통전화
    IBOutlet UIButton       *btnBig6; // 이메일
    IBOutlet UIButton       *btnBig7; // 핸드폰번호
    
    IBOutlet UILabel        *label9;  // 조회기간
    IBOutlet UILabel        *label10;  // 전담직원
    IBOutlet UILabel        *label11;  // 스마트명함메세지
    IBOutlet UILabel        *label12;  // 소속
    IBOutlet UIButton       *btn_massege;  // 메세지
    IBOutlet UIButton       *btn_tel;  // 전화
    IBOutlet UIButton       *btn_big;  // 확대
    IBOutlet UIView         *bigView;  // 확대

    
}
@property (assign, nonatomic) id<SHBSmartCardDetailDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;
@property (nonatomic, retain) UIView       *bigView;
@end
