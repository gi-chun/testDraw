//
//  SHBELD_BA17_15_EndViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 6. 14..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//



#import "SHBBaseViewController.h"

@interface SHBELD_BA17_15_EndViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

/**
 가입완료 후 받아온 데이터 (D3604)
 */
@property (nonatomic, retain) NSMutableDictionary *completeData;




/**
 확인 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomBackView;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
