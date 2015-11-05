//
//  SHBNewProductInfoViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 > 상품 정보화면
 */

#import "SHBBaseViewController.h"
#import "SHBPopupView.h"


@protocol SHBproductCouponCancelDelegate <NSObject>

- (void)productCouponCancel;

@end


@interface SHBNewProductInfoViewController : SHBBaseViewController


@property (assign, nonatomic) id<SHBproductCouponCancelDelegate> delegate;

//@property (nonatomic, retain) NSString *strProductCode;		// 상품코드 : 푸쉬로 왔을때 사용
@property (nonatomic, retain) NSMutableDictionary *mdicPushInfo;	// 푸쉬데이터 : 푸쉬로 들어왔을때 사용

@property (retain, nonatomic) IBOutlet UIView *baseView;	// 웹뷰와 Bottom의 상위뷰

@property (nonatomic, retain) SHBPopupView *popupView;
@property (retain, nonatomic) IBOutlet UIView *popupContentView;
- (IBAction)confirmBtnActionInPopupView:(SHBButton *)sender;
- (IBAction)cancelBtnActionInPopupView:(SHBButton *)sender;

@property (retain, nonatomic) IBOutlet UILabel *lblDuration;
@property (retain, nonatomic) IBOutlet UILabel *lblInterest1;
@property (retain, nonatomic) IBOutlet UILabel *lblInterest2;

@property (nonatomic, retain) IBOutlet UILabel *smallRate;
@property (nonatomic, retain) IBOutlet UILabel *bigRate;

/**
 금리정보
 */
@property (retain, nonatomic) IBOutlet UIView *TopView;

/**
 상품정보 웹뷰
 */
@property (retain, nonatomic) IBOutlet UIWebView *wvProductInfo;

/**
 하단 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomBackView;

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
쿠폰에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicReceiveData;

@property (nonatomic, retain) IBOutlet UIButton *button1; // 전화상담요청 버튼
@property (nonatomic, retain) IBOutlet UIButton *video; // 동영상  버튼
/**
 스마트신규에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSmartNewData;

/**
 동영상 버튼 액션
 */
- (IBAction)videoBtnAction:(UIButton *)sender;

/**
 금리상세 버튼 액션
 */
- (IBAction)interestDetailBtnAction:(UIButton *)sender;

/**
 가입 버튼 액션
 */
- (IBAction)joinBtnAction:(UIButton *)sender;

- (IBAction)buttonDidPush:(id)sender; // 전화상담요청 버튼 이벤트

@end
