//
//  SHBUDreamStipulationViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBUDreamStipulationViewController : SHBBaseViewController <UIWebViewDelegate>



@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIButton *btn_lastAgreeCheck;
//@property (retain, nonatomic) IBOutlet UIWebView *marketingWV;
@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;

@property (getter = isReadStipulation1) BOOL readStipulation1;		// 상품 약관
@property (getter = isReadStipulation2) BOOL readStipulation2;		// 마케팅활용동의 약관
@property (getter = isReadStipulation3) BOOL readStipulation3;		// 필수정보동의 약관

/**
 마지막 약관 동의 체크 여부
 */
@property (getter = isLastAgreeCheck) BOOL lastAgreeCheck;
/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

/**
 동의여부 체크 버튼 액션
 */
- (IBAction)agreeCheckBtnAction:(UIButton *)sender;


- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;



@end
