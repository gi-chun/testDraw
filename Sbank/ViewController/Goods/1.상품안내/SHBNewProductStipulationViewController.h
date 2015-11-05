//
//  SHBNewProductStipulationViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 18..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 상세 > 가입 > 약관 화면
 */

#import "SHBBaseViewController.h"

@interface SHBNewProductStipulationViewController : SHBBaseViewController <UIWebViewDelegate>
{
    IBOutlet UIView     *viewTaxBreak;
    IBOutlet UIView     *viewTaxBreak_1;
    
    IBOutlet UIButton   *buttonTaxBreak;
    
    BOOL                isChecked;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIButton *btn_lastAgreeCheck;
//@property (retain, nonatomic) IBOutlet UIWebView *marketingWV;
@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;

@property (getter = isReadStipulation1) BOOL readStipulation1;		// 상품 약관
@property (getter = isReadStipulation2) BOOL readStipulation2;		// 마케팅활용동의 약관
@property (getter = isReadStipulation3) BOOL readStipulation3;		// 필수정보동의 약관

@property (nonatomic, retain) NSMutableDictionary *mdicPushInfo;	// 푸쉬데이터

/**
 약관 이름 배열
 */
@property (nonatomic, retain) NSMutableArray *marrStipulations;

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;
/**
 쿠폰에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicReceiveData;
/**
 스마트신규에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSmartNewData;
/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

/**
 마지막 약관 동의 체크 여부
 */
@property (getter = isLastAgreeCheck) BOOL lastAgreeCheck;


//나이정보
@property (nonatomic, retain) OFDataSet *xda_age;


/**
 각각의 약관 탭했을 때의 제스쳐
 */
- (void)stipulationItemPressed:(UITapGestureRecognizer *)sender;

/**
 보기 버튼 액션
 */
- (void)seeBtnAction:(UIButton *)sender;

/**
 보기 버튼 액션
 */
- (void)see_1BtnAction:(UIButton *)sender;

/**
 동의여부 체크 버튼 액션
 */
- (IBAction)agreeCheckBtnAction:(UIButton *)sender;

/**
 전송 버튼 액션
 */
- (IBAction)sendBtnAction:(UIButton *)sender;

/**
 취소 버튼 액션
 */
- (IBAction)cancelBtnAction:(UIButton *)sender;

@end
