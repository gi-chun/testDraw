//
//  SHBConstants.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 신한S뱅크의 상수를 정의 한다.
 */

// 로그인 유형
typedef enum
{
    KoreaLan = 0,    //한글
	EnglishLan = 1,  //영어
    JapanLan = 2, //일본어
    
} LanguageType;


// 로그인 유형
typedef enum
{
    LoginTypeNo = 0,    // 로그인 필요 없음/로그인 안됨
	LoginTypeIDPW = 1,  // ID/PW 로그인.
    LoginTypeCert = 2   // 인증서 로그인.
} LoginType;

// 모바일 인증 관련
typedef enum
{
    SERVICE_CERT = 1,               // 인증서 발급/재발급
    SERVICE_OTHER_CERT,             // 타기관 공인인증서 등록/해지
    SERVICE_SIGN_UP,                // 조회회원서비스 가입
    SERVICE_PASSWORD,               // 이용자 비밀번호 등록
    SERVICE_USER_INFO,              // 고객정보변경
    SERVICE_CANCEL_GOODS,           // 예/적금 해지
    SERVICE_LOAN,                   // 예/적금 담보대출
    SERVICE_DEVICE_REGIST,          // 이용기기 등록 서비스
    SERVICE_300_OVER,               // 300만원 이상 이체시
    SERVICE_FRAUD_PREVENTION_SMS,   // 사기예방 SMS 통지 서비스 신청/해제
    SERVICE_DEVICE_REGIST_ADD,      // 이용기기 외 추가인증 신청/해제
    SERVICE_CHEET_DEFENCE_RE,       // 안심거래신청
    SERVICE_CHEET_DEFENCE_CA,       // 안심거래해지
    SERVICE_CARDSSO_AGREE,          // 신한카드 sso 동의
    SERVICE_EXCEPTION_DEVICE,       // 예외 기기 로그인 알림
    SERVICE_IP_CHECK,               // 국내IP<->해외IP 허용시간 체크 인증ARS
    SERVICE_SSHIELD,                // S-Shield 체크 인증ARS
    SERVICE_2MONTH_OVER,            // 2개월이상 이체 거래가 없는 계좌 추가인증
    SERVICE_USER_INFO_USE_SUPPLY,   // 본인정보 이용제공 조회시스템
    SERVICE_BIZ_LOAN_ITEMIZE,       // 직장인 무방문대출 신청 (건별)
    SERVICE_BIZ_LOAN_LIMIT          // 직장인 무방문대출 신청 (한도)
}SERVICE_TYPE_SEQUENCE;

// 인증서 처리 과정.
typedef enum
{
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
    CertProcessTypeIssueLogin = 21,  //신한카드 모바일 결제 인증서 복사
    CertProcessTypeSpotIssue = 22,  // 창구 발급
    CertProcessTypeNo = 0           // 인증센터 처리 아님
} CertProcessType;

// 전문 유형.
typedef enum
{
	SHBTRTypeServiceCode = 1,   // 서비스코드가 있는 일반 전문.
    SHBTRTypeTask = 2,          // Task가 있는 전문.
    SHBTRTypeRequst = 3,        // Request가 있는 전문.
    SHBTRTypeCert = 4,          // 공인인증서 전문.
    
    SHBTRTypeEtc = 0            // 기타(로그아웃 등).
} SHBTRType;

// TODO: 상수를 사용하지 않는 방법으로 수정할 것!
// 앱의 버전정보 관련.
#define SERVICE_TYPE @"SBANK"
//#define OS_TYPE @"1"
//#define CLIENT_VERSION @"3.7.8"
#define CHANNEL_CODE @"02"

// 상품 버전 : 신규 상품이 개발되었을 시 상품리스트에서 진입여부를 체크하기 위함.
#define SIB_NEWDEPOSITVERSION @"3.2"

// 메인화면의 메뉴들이 변경될 시 초기화를 위함. (서브메뉴의 변경은 초기화 안해도 됨)
#define MAINMENU_VERSION @"1.5"

// 마이메뉴의 메뉴들이 변경될 시 초기화를 위함. (마이메뉴의 경우는 조금이라도 변경시 초기화 해야됨, 추가만 된 경우엔 안해도 됨)
#define MYMENU_VERSION @"1.5"

// 프로토콜.
#define PROTOCOL_HTTP @"http://"
#define PROTOCOL_HTTPS @"https://"

// 서버 IP.
//#define REAL_SERVER_IP @"s-bank.shinhan.com"        // 리얼.
//#define TEST_SERVER_IP @"125.130.60.170"            // 테스트.

// HTTPS로 바뀌면서 서버 IP.
#define REAL_SERVER_IP @"sbk.shinhan.com"        // 리얼.
#define TEST_SERVER_IP @"dev-sbank2013.shinhan.com"        // 테스트.

//앱스토어 배포시 주석처리 !@#$!@#$
#define TEST_SERVER
#define DEVELOPER_MODE
///////////////////////

//#if ConnectServerType
//  
//#else
//#endif
/*
#ifdef DEBUG
    #define SERVER_IP TEST_SERVER_IP
#else
    #define SERVER_IP REAL_SERVER_IP
#endif
*/

// 로그인 클래스 이름.
#define LOGIN_CLASS @"SHBLoginViewController"

// NSHC보안키패드 공개키 URL.
#define NFILTER_PK_URL @"/nfilter/npublickey.jsp"

#define NSEUCKRStringEncoding -2147481280 //EUC-KR
//#define NSEUCKRStringEncoding -2147482590 //EUC-KR 확장형

// 공인인증센터.
#define REAL_CERT_IMPORT_IP     @"scert.shinhan.com"    // 아이폰 구모듈 간소화(3.4.1), 신모듈 인증서가져오기 상용서버
#define TEST_CERT_IMPORT_IP     @"125.130.60.153"		// 아이폰 인증서 가져오기 테스트 서버
#define CERT_IMPORT_URL         @"/MoaChkClientVer.jsp"	// 아이폰 구모듈 간소화(3.4.1), 신모듈 인증서가져오기 페이지
#define CERT_TIME_URL           @"/common/smt/jsp/Time.jsp"
#define CERT_RENEW_URL           @"/common/smt/jsp/callSmtCertServiceRenew.jsp?serviceCode="

#ifdef DEBUG
    #define CERT_IMPORT_IP REAL_CERT_IMPORT_IP  // 테스트 서버에서 인증서 못가져오는 문제로 리얼에서 받아오도록 처리
#else
    #define CERT_IMPORT_IP REAL_CERT_IMPORT_IP 
#endif