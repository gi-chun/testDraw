//
//  SHBNewProductTaxBreakViewController2.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 28..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBDateField.h"                // dateField

@interface SHBNewProductTaxBreakViewController2 : SHBBaseViewController <UITextFieldDelegate>//<SHBDateFieldDelegate>
{
    IBOutlet UIScrollView       *scrollView1;
    
    IBOutlet UIView             *realView;          // 실제 view
    
    IBOutlet SHBTextField       *textField1;        // 분기당납입한도
    IBOutlet SHBTextField       *textField2;        // 자동이체금액
    
    IBOutlet SHBDateField       *dateField1;        // 자동이체시작일
    IBOutlet SHBDateField       *dateField2;        // 자동이체종료일
    
    NSString                    *strMaxAmount;      // 한도잔여액
    NSString                    *strPercent;      // 적용이율
    
    NSString                    *strdateStart;      // 자동이체시작일
    NSString                    *strdateEnd;      // 자동이체종료일
    NSString                    *strautoAmount;      // 자동이체금액
    NSString                    *strLimitAmount;      // 자동이체금액
    
}

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
