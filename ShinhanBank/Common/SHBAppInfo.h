//
//  SHBAppInfo.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 SHBAppInfo는 싱클턴 인스턴스를 반환하는 클래스로 앱에 필요한 전역(글로벌) 메서드 및 프라퍼티를 제공한다.
 */




#import <Foundation/Foundation.h>
#import "SHBHTTPClient.h"
#import "SHBCodeList.h"
#import "CertificateInfo.h"
#import "CertificateInfomation.h"
#import "SHBSMSAlertPopupView.h"

@interface SHBAppInfo : NSObject <SHBHTTPClientDelegate>

/**
 connect server
 */
@property (nonatomic, retain) NSString *serverIP;
@property (nonatomic, assign) BOOL realServer;
/**
 UDID
 */
@property (nonatomic, retain) NSString *openUDID;
/**
 Mac address
 */
@property (nonatomic, retain) NSString *macAddress;

/**
 nFilter 공개키.
 */
@property (nonatomic, retain) NSString *bankCodeVersion;

/**
 iPhone5 여부.
 */
@property (nonatomic, assign) BOOL isiPhoneFive;

/**
 nFilter 공개키.
 */
@property (nonatomic, retain) NSString *nfilterPK;
@property (nonatomic, assign) BOOL isNfilterPK;
/**
 로그인 여부.
 
 LoginTypeNo = 0,    // 로그인 필요 없음/로그인 안됨
 LoginTypeIDPW = 1,  // ID/PW 로그인.
 LoginTypeCert = 2   // 인증서 로그인.
 */
@property (nonatomic, assign) LoginType isLogin;
@property (nonatomic, retain) NSString *ssnForIDPWD;

//이용자 비밀번호 필드 처치시 특수 문자 안보이게 처리하기 위해
@property (nonatomic, assign) BOOL *isUserPwdRegister;
/**
 인증서 처리 과정 유형.
 
 CertProcessTypeLogin = 1,       // 인증서 로그인.
 CertProcessTypeSign = 2,        // 전자서명.
 CertProcessTypeIssue = 3,       // 인증서 발급/재발급.
 CertProcessTypeRenew = 4,       // 인증서 갱신.
 CertProcessTypeRegOrExpire = 5, // 타행/타기관 인증서 등록/해제
 CertProcessTypeDel = 6,         // 인증서 삭제
 CertProcessTypeCopySmart = 7,   // pc->스맛폰저장
 CertProcessTypeCopyPC = 8,      // 스맛폰->pc저장
 CertProcessTypeManage = 9,      // 인증서 관리
 CertProcessTypePwdChange = 10,  // 암호 변경
 CertProcessTypeIDConfirm = 11,  // 본인 확인
 CertProcessTypeInfo = 12,  // 인증서 정보
 CertProcessTypeInFotterLogin = 13,  //푸터 메뉴에서 로그인
 CertProcessTypeCopyQR = 14,  //QR코드로 인증서 복사
 CertProcessTypeCopySHCard = 15,  //신한카드앱으로로 인증서 복사
 CertProcessTypeCopySHInsure = 16,  //신한생명앱으로로 인증서 복사
 CertProcessTypeMoasignLogin = 17, //모아사인 로그인
 CertProcessTypeMoasignSign = 18, //모아사인 사인
 CertProcessTypeIntroduce = 19, //인증서 안내
 CertProcessTypeCopySHCardEasyPay = 20,  //신한카드 모바일 결제 인증서 복사
 CertProcessTypeNo = 0           // 인증센터 처리 아님
 
 */
@property (nonatomic, assign) CertProcessType certProcessType;

@property (nonatomic, assign) LanguageType LanguageProcessType;
/**
 현재 선택된 인증서.
 */

@property (nonatomic, retain) CertificateInfo *selectedCertificate;
@property (nonatomic, retain) CertificateInfo *loginCertificate;
@property (nonatomic, assign) BOOL isSettingServiceView;
@property (nonatomic, assign) BOOL isLoginView;
/**
 모아사인용 현재 선택된 인증서.
 */
@property (nonatomic, retain) CertificateInfomation *selectCertificateInfomation;

/**
 로그인 및 서명을 위한 데이타 저장.
 */

//@property (nonatomic, retain) CertificateInfo *signedData;
@property (nonatomic, retain) NSString *signedData;

/**
 전자서명.
 */
@property (nonatomic, retain) NSString *electronicSignString;
@property (nonatomic, retain) NSString *electronicSignCode;
@property (nonatomic, retain) NSString *electronicSignTitle;
/**
 인증서 개수.
 */
@property (nonatomic, assign) int certificateCount;

/**
 전자서명 네비게이션바 타이틀을 받는다.
 */
@property (nonatomic, retain) NSString *eSignNVBarTitle;

/**
 인증서 처리 과정 예러.
 */
@property (nonatomic, retain) NSError *certError;
/**
 
 
 ID/PW 로그인 후 받은 사용자 정보를 저장할 딕셔너리.
 
 TODO: 인증서 로그인 개발 후, 추가 정리해야 함!
 !!!: 필요한 경우 User 모델 클래스를 사용할 것!
 */
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, retain) NSString *secretChar1; //보안카드 확인 1
@property (nonatomic, retain) NSString *secretChar2; //보안카드 확인 2
/**
 고객번호.
 */
@property (nonatomic, retain) NSString *customerNo;

/**
 고객전화번호.
 */
@property (nonatomic, retain) NSString *phoneNumber;

/**
 주민등록번호.
 */
@property (nonatomic, retain) NSString *ssn;

/**
 로그인 아이디, 이름.
 */
@property (nonatomic, retain) NSString *loginID;
@property (nonatomic, retain) NSString *loginName;

/**
 로그인 유무에 따른 화면 이동을 위해...
 */
@property (nonatomic, retain) UIViewController *lastViewController;
@property (nonatomic, assign) BOOL lastViewControllerNeedCert;
@property (nonatomic, assign) BOOL isFirstOpen;
@property (nonatomic, assign) BOOL isSingleLogin;
@property (nonatomic, assign) BOOL isSignupService;

/**
 앱의 버전정보.
 */
@property (nonatomic, retain) NSDictionary *versionInfo;
@property (nonatomic, retain) NSString	*bundleVersion;
/**
 가장 최근 실행된 전문 번호
 */
@property (nonatomic, retain) NSString *serviceCode;

/**
 보안 키패드가 떠있는지 확인
 */
@property (nonatomic, assign) BOOL isSecurityKeyPad;
@property (nonatomic, assign) BOOL isSecurityKeyClose;

/**
 SHBBaseview의 회전 상태를 저장해 둔다
 */
@property (nonatomic, assign) BOOL isForceRotate;
@property (nonatomic, assign) BOOL isLandScapeKeyPadBolck;
@property (nonatomic, assign) UIInterfaceOrientation beforeRotateDirect;

/**
 앱실행 로딩 화면 안보이게 체크
 */
@property (nonatomic, assign) BOOL isStartApp;

// 하단 퀵메뉴용 구분자
@property (nonatomic, assign) int indexQuickMenu;

/**
 전문송신을 위한 url 경로를 얻기 위한 조건이 필요할 경우 사용.
 */
@property (nonatomic, retain) IBOutlet NSString *serviceOption;

/** 확인성 전문 송신 후 결과값
 */
@property (nonatomic, retain) NSString *errorType;

/**
 마지막 전문 통신 날짜 및 시간
 */
@property (nonatomic, retain) NSString *tran_Date;
@property (nonatomic, retain) NSString *tran_Time;

/**
 각종 CODE값(은행코드, 국가코드...)
 */
@property (nonatomic, retain) SHBCodeList *codeList;

/**
 Controller 간에 공유 하고 싶은 데이타를 넣어둔다.
 */
@property (nonatomic, retain) NSDictionary *commonDic;

/** 상품권 종류
 */
@property (nonatomic, retain) NSString *giftType;


/** 올레모바일페이지 쿠폰번호
 */
@property (nonatomic, retain) NSString *ollehCoupon;





//예담보대출 구분 값
@property (nonatomic, retain) NSDictionary *commonLoanDic;

//이체시 추가인증을 위한 정보를 담는다
@property (nonatomic, retain) NSDictionary *transferDic;
/**
 viewWillAppear시 데이타 초기화가 필요한지 체크.
 viewDidLoad에서 기본값 NO를 설정한다.
 */
@property (nonatomic        ) BOOL isNeedClearData;

/**
 Error발생시 이전 ViewController로 이동해야 하는지 여부
 */
@property (nonatomic        ) BOOL isNeedBackWhenError;

/**
 SHBBaseview의 회전 상태를 저장해 둔다
 */
@property (nonatomic, assign) UIInterfaceOrientation rotateDirect;

// schema URL
@property (nonatomic, retain) NSString *schemaUrl;

//신한카드 이용 동의 여부
@property (nonatomic, assign) BOOL isCardAgree;

@property (nonatomic, retain) NSString *certPlainPwd;


// 앱 더보기 및 링크시 필요한 앱리스트
@property (nonatomic, retain) NSMutableArray	*otherAppArray;

// 스마트레터, 쿠폰함 새로운 메시지 여부
@property (assign, nonatomic) BOOL isSmartLetterNew;
@property (assign, nonatomic) BOOL isCouponNew;


@property(nonatomic,assign) int noticeState;

//전체해지만 가능한 상품 여부
@property (nonatomic, retain) NSString *Close_type;

//스마트펀드의 무슨 메뉴를 눌렀는지
@property(nonatomic,assign) int smartFundType;

// 간편조회 최초 접근여부
@property (nonatomic, assign) BOOL isEasyInquiry;

/**
 서버에러메시지를 뿌려주지 않고 업무단에서 처리한다.
 */
@property (nonatomic, assign) BOOL isBolckServerErrorDisplay;
@property (nonatomic, retain) NSMutableString *serverErrorMessage;

/**
 websso 연동 처리 여부.
 */
@property (nonatomic, assign) BOOL isWebSSOLogin;
@property (nonatomic, retain) NSString *webSSOUrl;
@property (nonatomic, assign) BOOL isWebSchemeCall;
/**
 sso로 로그인 했는지 여부
 */
@property (nonatomic, assign) BOOL isSSOLogin;

@property (nonatomic, assign) BOOL isBackGroundCall;

//회원가입후 로그인 화면으로 갔을때는 선택된 인증서를 초기화하지 않기 위해...
@property (nonatomic, assign) BOOL isRegisterAccountService;

//사기예방동의 여부
@property (nonatomic, assign) BOOL isCheatDefanceAgree;

//구 pc 등록여부
@property (nonatomic, assign) BOOL isOldPCRegister;

//버젼정보를 얻어왔는지
@property (nonatomic, assign) int isGetVersionInfo;

//예금, 적금 해지시 추가인증변경(영업일 오전 9시~ 오후 6시일경우 SMS + ARS 인증 모두 진행
@property (nonatomic, assign) BOOL isAllIdenty; //모두 인증을 받아야 되는지 플래그
@property (nonatomic, assign) BOOL isSMSIdenty; //sms 인증을 받았는지
@property (nonatomic, assign) BOOL isARSIdenty; //ars 인증을 받았는지
@property (nonatomic, assign) BOOL isAllIdentyDone;

@property (nonatomic, assign) BOOL isTapSmithingMenu;

@property(nonatomic, assign) int smithingType; //1:서비스신청, 2:기기등록, 3:기기 삭제, 4:서비스해지
@property (nonatomic, retain) NSMutableDictionary *smsInfo;

@property (nonatomic, assign) BOOL scrollBlock;

//스마트케어용 푸시 메시지를 받았는지
@property (nonatomic, assign) BOOL isSmartCareNoti;

@property (nonatomic, retain) NSString *dummyStr;

@property (nonatomic, assign) BOOL liveAlert;

@property (nonatomic, assign) BOOL isSetPKForMobi;

//NSData형태의 암호화rkqt
@property (nonatomic, retain) NSData *eccData;

//피싱방지 보안설정 여부
@property (nonatomic, assign) BOOL isFishingDefence;

//공지조건
//피싱방지 보안설정 여부
@property (nonatomic, assign) int commonNotiOption;

//D0011 계좌 배열
@property (nonatomic, retain) NSMutableDictionary *accountD0011;

@property (nonatomic, assign)  BOOL isShowSearchView;

//D0011 전문을 날려랴 될지 판단(메인메뉴에서 조회 이체를 누르고 게죄 리스트 들어갈 경우 태우지 않는다)
@property (nonatomic, assign) BOOL isD0011Start;

//유효한 인증서 개수
@property (nonatomic, assign) int validCertCount;

@property (nonatomic, assign) double arsLimtTime;

@property (nonatomic, assign) BOOL isHotSpot; //핫스팟 또는 통화중일때 화면이 내려가 잇는지 알려주는 값
/**
 싱글턴 인스턴스 반환.
 
 @return SHBAppInfo 싱글턴 인스턴스 반환.
 */
+ (SHBAppInfo *)sharedSHBAppInfo;

/**
 앱 초기화 작업.
 */
- (void)initProcess;

/**
 앱 종로 작업.
 */
- (void)finishProcess;

/**
 nFilter 보안키패드에서 사용하는 공개키를 가져온다.
 */
- (BOOL)loadPublicKeyForNFilter;
//@property (nonatomic, assign) BOOL isGetKeyNFilter;

/**
 동적 화면 구성을 위한 자원을 서버에서 다운로드 한다.
 */
- (void)updateResources;

/**
 로그아웃. 서버 세션 삭제, 로컬 로그아웃 처리 등을 한다.
 */
- (void)logout;

/**
 번들 디렉토리 경로를 가져온다
 */
- (NSString *)getMainBundleDirectory:(NSString *) fileNmae;

/**
 전자 서명을 위한 문자열을 저장한다.
 */
- (void)addElectronicSign:(NSString *)str;

/**
 디바이스 정보를 가져온다.
 */
- (void)getDeviceInfo;

- (NSMutableArray *)loadCertificates;

- (void)reSession;

- (void)getNFilterPK;
- (void)logoutAlert;
- (void)differentUserAlert;
- (void)moveLoginAlert;
- (BOOL)getServerType;
- (void)updateAlert:(NSString *)sVer;
- (NSString *)getPersonalPK;
- (void)smithingAlert;
- (NSString *)sungsikjunsik0402:(NSString *)a1008;
//- (NSString *)eunheeya0225:(NSString *)asdf12073;
- (void)changeFishingState;
- (void)xkfdhrAlert;

/**
 확장 E2E를 위해
 */
- (NSString *)encNfilterData:(NSString *)aStr;
@end
