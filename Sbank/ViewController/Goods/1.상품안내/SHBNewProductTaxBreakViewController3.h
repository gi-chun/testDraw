//
//  SHBNewProductTaxBreakViewController3.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 5. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBDateField.h"                // dateField

@interface SHBNewProductTaxBreakViewController3 : SHBBaseViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView       *scrollView1;
    
    IBOutlet UIView             *realView;          // 실제 view
    
    
    IBOutlet SHBTextField       *textField1;        // 지급기간
    IBOutlet SHBTextField       *textField2;        // 적립한도
    IBOutlet SHBTextField       *textField3;        // 자동이체금액
    
    IBOutlet SHBButton           *selectType; // 운영내역 통보
    
    IBOutlet SHBDateField       *dateField1;        // 자동이체시작일
    IBOutlet SHBDateField       *dateField2;        // 자동이체종료일
    
    NSString                    *strTerm;      // 지급기간
    NSString                    *strMaxAmount;      // 한도잔여액
    NSString                    *strdateStart;      // 자동이체시작일
    NSString                    *strType;      // 운영내역 문구
    NSString                    *strTypeCode;      // 운영내역 코드
    NSString                    *strautoAmount;      // 자동이체금액
    
    
}


- (IBAction)selectTypeBtn:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet SHBButton *currency; // 환전통화
@property (retain, nonatomic) NSMutableArray *dataList; // 운영통보 리스트
@property (retain, nonatomic) NSMutableDictionary *selectDic; // 운영통보 선택
@property (retain, nonatomic) SHBTextField *textField3; // 자동이체금액
/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;


//보이스오버 상품단계 표시
@property (nonatomic, retain) NSString *stepNumber;

@end

