//
//  SHBBaseViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>

//#import "SHBHTTPClient.h"
#import "OFServiceViewController.h"
#import "SHBXmlDataParser.h"
#import "OFDataParser.h"
#import "OFDataBinder.h"
//아래메뉴
#import "SHBBottomViewDelegate.h"
#import "SHBBottomView.h"

#define NAVI_VIEW_TAG		100000
#define NAVI_BACK_BTN_TAG	110000
#define NAVI_MENU_BTN_TAG	120000
#define NAVI_NOTI_BTN_TAG	121000

#define NAVI_CLOSE_BTN_TAG	130000
#define NAVI_TITLE_TAG		140000
#define NAVI_DIMM_BTN_TAG	180000

#define MAIN_DIMM_BTN_TAG	190000

#define QUICK_LINE_TAG		191000
#define QUICK_VIEW_TAG		200000
#define QUICK_HOME_TAG		210000
#define QUICK_NOTICE_TAG		220000
#define QUICK_MYMENU_TAG		230000
#define QUICK_APPMORE_TAG		240000
#define QUICK_SETTING_TAG		250000
#define QUICK_LOGOUT_TAG		260000
#define QUICK_CONNECTINFO_TAG	270000

#define HELLO_VIEW	190011

@class SHBTextField;
@class SHBSecureTextField;


//#import "SHBCertElectronicSignViewController.h"
//@class SHBCertElectronicSignViewController;

//@protocol SHBRotateViewDelegate
//
//@required
//
//
//@optional
//- (void) rotateView;
//@end

/// 호출한 곳(필요한 경우 추가할 것, 메뉴명 기준!!).
typedef enum
{
    FromLogin,          // 로그인에서...
    FromCertCenter,     // 공인인증센터에서...
} WhereAreYouFrom;

@interface SHBBaseViewController : OFServiceViewController <SHBHTTPClientDelegate, SHBBottomViewDelegate, UIGestureRecognizerDelegate>
{
	NSMutableArray	*overClassArray;
	
	SHBBottomView	*_bottomMenuView;
    UIView *loginInfoView;
	UIPanGestureRecognizer	*panRecognizer;
    
    UITextField *curTextField;
    CGPoint offset;
    int contentViewHeight;
    BOOL displayKeyboard;
    
    int startTextFieldTag;
    int endTextFieldTag;
    NSString *strBackButtonTitle;
}
@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, assign) UITextField *curTextField;
//회전 되었는지 알려준다
//@property (nonatomic, assign) id<SHBRotateViewDelegate> rotateViewDelegate;

/**
 Gesture
 */
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer;

/**
 현재 뷰컨트롤러를 호출한 곳(메뉴, 버튼 등).
 */
@property (nonatomic, assign) WhereAreYouFrom whereAreYouFrom;

/**
 로그인 필요 유무.
 */
@property (nonatomic, assign) BOOL needsLogin;
@property (nonatomic, assign) BOOL needsCert;
//@property (nonatomic, assign) BOOL needsEasyAccountQuery;

/**
 XML을 파싱한 후 변환한 데이터.
 */
@property (nonatomic, retain) NSDictionary *data;

/**
 데이터 중의 반복부.
 */
@property (nonatomic, retain) NSArray *dataList;

@property (nonatomic, retain) SHBHTTPClient *client;
@property (nonatomic, retain) SHBXmlDataParser *dataParser;
@property (nonatomic, retain) OFDataBinder *dataBinder;

/**
 viewWillAppear 시 데이터 클리어 여부
 */
@property (nonatomic, assign) BOOL needClearData;

// 푸쉬 및 스키마 연동 여부
@property (nonatomic, assign) BOOL isPushAndScheme;

// Voice Over로 읽을때 이전버튼의 Label에 들어갈 값
@property (nonatomic, retain) NSString *strBackButtonTitle;
/**
 ViewController 간의 데이터 전송
 */
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary*)mDic;
- (void)executeWithDic:(NSMutableDictionary*)mDic;
- (void)helloCustomer;

/**
 Navigation Controller
 */
@property (nonatomic, retain) SHBBottomView *bottomMenuView;

- (void)navigationButtonPressed:(id)sender;		//네비게이션 및 퀵메뉴 버튼 클릭시
- (void)navigationViewHidden;					//네비게이션뷰 숨기기
- (void)navigationBackButtonShow;               //네비게이션뷰 이전버튼 보이기
- (void)navigationBackButtonHidden;				//네비게이션 이전버튼 숨기기
- (void)navigationBackButtonEnglish;				    //영문버젼
- (void)navigationBackButtonJapnes;				    //일문버젼
- (void)quickMenuHidden;						//네비게이션 오른쪽의 퀵메뉴 숨기기
- (void)pushViewControllerQuickMenu:(int)tag;	//퀵메류 화면 오픈
// 배경 딤처리(viewTag: 0-네비/메인 둘다, 1-네비, 2-메인)
- (void)setBackgroundDimm:(int)viewTag DimmFlag:(BOOL)flag;
- (void)setBottomMenuView;						// 아래쪽 퀵메뉴 그리기
- (void)blockAccessBottomMenuView:(BOOL)isBlock;// 아래쪽 퀵메뉴 그리기
//- (void)ttomMenuView;						// 아래쪽 퀵메뉴 그리기

- (void)changeQuickLogin:(BOOL)logIn;			// 하단 퀵메뉴의 로그인아웃 이미지 교체
- (void)changeBottmNotice:(int)notiState;

//알림으로만가기
- (void)notiButtonPressed;

//- (BOOL)sungsikjunsikLove;
/**
 네비게이션컨트롤러에 푸시하기 전에 로그인 유무를 확인한다.
 
 @param viewController 뷰컨트롤러.
 @param animated 애니메이션 여부.
 */
- (void)checkLoginBeforePushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 화면 설정을 위한 메서드. XIB의 컨트롤 재설정 등...
 */
- (void)setUpLayout;

- (void) serviceRequest: (SHBDataSet *)aDataSet;

/**
 PopupView용 출금가능 계좌리스트를 리턴한다.
 */
- (NSMutableArray *)outAccountList;

/**
 전자 서명 최종 후 최종 결과 값을 받아 온다
 */

//- (void) getElectronicSignResult:(NSNotification *)noti;

/**
 텍스트필드 태그값 설정
 @param array 텍스트필드가 들어있는 array
 */
- (void)setTextFieldTagOrder:(NSArray *)array;

//피싱방지 이미지 및 문구 교체
- (void)resetFishingDefence;

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(SHBTextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark SHBTextFieldDelegate
- (void)didPrevButtonTouch;          // 이전버튼
- (void)didNextButtonTouch;          // 다음버튼
- (void)didCompleteButtonTouch;      // 완료버튼

#pragma mark - SHBSecureDelegate
- (IBAction) closeNormalPad:(id)sender;
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField;
- (void)onPreviousClick:(NSData *)pPlainText encText:(NSString*)pEncText;
- (void)onNextClick:(NSData *)pPlainText encText:(NSString*)pEncText;
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:aData didEncriptedVaule:(NSString *)value;
- (void)onPressSecureKeypad:(NSData *)pPlainText encText:(NSString*)pEncText;
@end
