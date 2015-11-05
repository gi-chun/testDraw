//
//  SHBTRConstants.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 일반 전문의 서비스코드(전문번호)와 URL.
 */

// ID/PW 로그인.
#define SC_H1001 @"H1001"

// 회원 가입
#define SC_H0011 @"H0011"

// 계좌 확인
#define SC_C2097 @"C2097"

// 공인인증 로그인.
//#define SC_A0010 @"A0010"
//개인화 이미지적용에 의한 변경
#define SC_A0010 @"A1000"

// SMS전송
#define SC_D2010 @"D2010"

// 가입해지
#define	SC_C2098 @"C2098"	// 가입1단계, 보안->보안카드, 신용카드->현금서비스이체->2.이체비밀번호확인, 외화환전신청->3.외화환전신청, 즉시이체->이체비밀번호보안카드확인, 지로지방세->지로납부내역조회취소->2.지로납부내역조회취소, 지로지방세->지로입력납부->3.지로입력납부, 지로지방세->지로조회납부 -> 3.지로조회납부, 지로지방세->지방세납부->3.지방세납부서울시
#define	SC_E4302 @"E4302"	// 가입2단계
#define	SC_C2090 @"C2090"	// 해지1단계, 신탁출금->2-신탁출금계좌확인, 지로지방세->지로입력납부->2.지로입력납부, 지로지방세->지로조회납부->2.지로조회납부, 지로지방세->지방세납부->2.지방세납부서울시, 펀드수익증권입금->펀드입금계좌비밀번호확인
#define SC_E4303 @"E4303"	// 해지2단계

// 경조금이체
#define	SC_D2023 @"D2023"	// 경조금이체
#define	SC_D2021 @"D2021"	// 경조금이체수취인조회

// 긴급출금
#define	SC_E1702 @"E1702"	// 긴급출금등록 취소시
#define	SC_E1703 @"E1703"	// 긴급출금등록 취소시SMS
#define SC_E1700 @"E1700"	// 긴급출금등록시
#define SC_E1701 @"E1701"	// 긴급출금등록시

// 대출조회상환
#define SC_L1110 @"L1110"	// 대출계좌거래명세
#define SC_L0010 @"L0010"	// 대출계좌목록
#define SC_L1222 @"L1222"	// 대출원금동시상환실행
#define SC_L1221 @"L1221"	// 대출원금동시상환실행가능조회
#define SC_L1220 @"L1220"	// 대출원리금상환조회
#define SC_L1211 @"L1211"	// 대출이자납부
#define SC_L1210 @"L1210"	// 대출이자조회
#define SC_L1120 @"L1120"	// 한도대출계좌조회

// 보안
#define SC_C2099 @"C2099"	// OTP
#define SC_D2003 @"D2003"	// OTP전자서명_당행이체, 전자서명이체, 즉시이체->당행계좌이체
//#define SC_C2098 @"C2098"	// 보안카드
//#define SC_D2003 @"D2003"	// 전자서명_이체

/*
 #define SC_D2010 @"D2010"	// 송금알림서비스
 */

// 수익증권
#define SC_D6100 @"D6100"	// 3-펀드수익증권정보조회, 펀드수익증권입금->3-펀드수익증권정보조회, 펀드수익증권입금->신탁입금정보조회2
#define SC_D6020 @"D6020"	// 수익증궈계좌정보거래내역조회
#define SC_D6010 @"D6010"	// 수익증권계좌조회, 펀드수익증권입금->1-펀드계좌목록, 펀드수익증권입금->펀드계좌목록, 펀드수익증권출금->1-펀드계좌목록
#define SC_D6090 @"D6090"	// 수익증권기준가조회

// 신용카드
#define SC_E2904 @"E2904"	// 결제내역조회
#define SC_E2906 @"E2906"	// 교통카드내역조회
#define SC_E2905 @"E2905"	// 승인내역조회
#define SC_E2902 @"E2902"	// 이용내역조회
#define SC_E2915 @"E2915"	// 이용대금명세서조회 -> 결제예정금액조회
#define SC_E2916 @"E2916"	// 이용대금명세서조회 -> 결제예정금액조회(내역있을경우)
#define SC_E2913 @"E2913"	// 이용대금명세서조회 -> 월별청구금액조회1단계
#define SC_E2914 @"E2914"	// 이용대금명세서조회 -> 월별청구금액조회2단계
#define SC_E2901 @"E2901"	// 이용한도조회, 현금서비스이체->1.한도및이용금액조회
#define SC_E2911 @"E2911"	// 카드목록조회
#define SC_E2919 @"E2919"	// 카드비밀번호확인
#define SC_E4304 @"E4304"	// 카드이용약관동의
#define SC_E2907 @"E2907"	// 포인트조회
//#define SC_E2901 @"E2901"	// 현금서비스이체 -> 1.한도및이용금액조회
//#define SC_C2098 @"C2098"	// 현금서비스이체 -> 2.이체비밀번호확인
#define SC_E2917 @"E2917"	// 현금서비스이체 -> 3.현금서비스

// 신탁출금
#define SC_D2035 @"D2035"	// 1-신탁출금계좌정보조회
//#define SC_C2090 @"C2090"	// 2-신탁출금계좌확인
//#define SC_D2037 @"D2037"	// 3-신탁출금최종실행_오류

// 예약이체
#define SC_D2105 @"D2105"	// 예약이체가상계좌수취인조회
#define SC_D2113 @"D2113"	// 예약이체결과조회
#define SC_D2101 @"D2101"	// 예약이체당행계좌수취인조회
#define SC_D2103 @"D2103"	// 예약이체등록
#define SC_D2110 @"D2110"	// 예약이체등록내역조회
#define SC_D2111 @"D2111"	// 예약이체취소
#define SC_D2104 @"D2104"	// 예약이체타행계좌수취인조회

// 예적금조회
#define SC_D1110 @"D1110"	// 거래내역기간입력시, 예적금조회(일반)
#define SC_D0010 @"D0010"	// 예금조회
#define SC_D1170 @"D1170"	// 예적금조회(가계당좌)
#define SC_D1130 @"D1130"	// 예적금조회(고정성)
#define SC_D1140 @"D1140"	// 예적금조회(신탁)
#define SC_D1150 @"D1150"	// 예적금조회(양도성예금표지어음)
//#define SC_D1110 @"D1110"	// 예적금조회(일반)
#define SC_D1143 @"D1143"	// 예적금조회(재정신탁)
#define SC_D1120 @"D1120"	// 예적금조회(정기예금)
#define SC_D1185 @"D1185"	// 예적금조회(주택청약부금)
#define SC_D1180 @"D1180"	// 예적금조회(주택청약예금)
#define SC_D1160 @"D1160"	// 예적금조회(환매채국공재금융채)

// 외환
#define SC_D7011 @"D7011"	// 외화예금조회 -> 1.외화예금조회_d7011
#define SC_D7012 @"D7012"	// 외화예금조회 -> 1.외화예금조회_d7012
#define SC_D7013 @"D7013"	// 외화예금조회 -> 1.외화예금조회_d7013
#define SC_F0010 @"F0010"	// 외화예금조회 -> 1.외화예금조회_f0010
#define SC_F1110 @"F1110"	// 외화예금조회 -> 1.외화예금조회_f1110
#define SC_F1112 @"F1112"	// 외화예금조회 -> 2.외화예금상세조회
#define SC_F3770 @"F3770"	// 외화환전신청 -> 1.외화환전신청
#define SC_F3111 @"F3111"	// 외화환전신청 -> 2.외화환전신청
//#define SC_C2098 @"C2098"	// 외화환전신청 -> 3.외화환전신청
#define SC_F3112 @"F3112"	// 외화환전신청 -> 4.외화환전신청
#define SC_F2021 @"F2021"	// 자주쓰는해외송금조회 -> F2021
#define SC_F2022 @"F2022"	// 자주쓰는해외송금조회 -> 자주쓰는해외송금조회_F2022
#define SC_F2025 @"F2025"	// 자주쓰는해외송금조회 -> 자주쓰는해외송금조회
#define SC_F3120 @"F3120"	// 환전신청내역조회

// 이체결과조회
#define SC_D4110 @"D4110"

// 자주쓰는계좌
#define SC_C2222 @"C2222"	// 자주쓰는입금계좌 삭제
#define SC_C2231 @"C2231"	// 자주쓰는입금계좌등록

// 즉시이체
#define SC_D2043 @"D2043"	// 가상계좌이체
#define SC_D2041 @"D2041"	// 가상계좌이체수취인조회
//#define SC_D2003 @"D2003"	// 당행계좌이체
#define SC_D2001 @"D2001"	// 당행계좌이체수취인조회
//#define SC_C2098 @"C2098"	// 이체비밀번호보안카드확인
#define SC_C2210 @"C2210"	// 자주쓰는입금계좌조회
#define SC_D2013 @"D2013"	// 타행계좌이체
#define SC_D2011 @"D2011"	// 타행계좌이체수취인조회
#define SC_D2049 @"D2049"	// 평생계좌조회

// 지로지방세
#define SC_G0161 @"G0161"	// 지로납부내역조회취소 -> 1.지로납부내역조회취소
//#define SC_C2098 @"C2098"	// 지로납부내역조회취소 -> 2.지로납부내역조회취소
#define SC_G0163 @"G0163"	// 지로납부내역조회취소 -> 3.지로납부내역조회취소
#define SC_G0120 @"G0120"	// 지로입력납부 -> 1.지로입력납부
//#define SC_C2090 @"C2090"	// 지로입력납부 -> 2.지로입력납부
//#define SC_C2098 @"C2098"	// 지로입력납부 -> 3.지로입력납부
#define SC_G0123 @"G0123"	// 지로입력납부 -> 4.지로입력납부, 지로조회납부 -> 4.지로조회납부
#define SC_G0111 @"G0111"	// 지로조회납부 -> 1.지로조회납부
//#define SC_C2090 @"C2090"	// 지로조회납부 -> 2.지로조회납부
//#define SC_C2098 @"C2098"	// 지로조회납부 -> 3.지로조회납부
//#define SC_G0123 @"G0123"	// 지로조회납부 -> 4.지로조회납부
#define SC_G0113 @"G0113"	// 지로조회납부 -> g0013
#define SC_G0312 @"G0312"	// 지방세납부 -> 1.지방세납부서울시
//#define SC_C2090 @"C2090"	// 지방세납부 -> 2.지방세납부서울시
//#define SC_C2098 @"C2098"	// 지방세납부 -> 3.지방세납부서울시
#define SC_G0315 @"G0315"	// 지방세납부 -> 4.지방세납부서울시
#define SC_G0322 @"G0322"	// 지방세납부내역조회

// 첫접속시비보안정보
#define SC_E4301 @"E4301"

// 최근입금계좌
#define SC_C2520 @"C2520"

// 펀드수익증권입금
//#define SC_D6010 @"D6010"	// 1-펀드계좌목록
#define SC_D6210 @"D6210"	// 2-펀드계좌조회(입금타입), 입금정보조회, 펀드계좌조회(입금타입)
//#define SC_D6100 @"D6100"	// 3-펀드수익증권정보조회
#define SC_D6230 @"D6230"	// 4-입금항목확인
//#define SC_D6100 @"D6100"	// 신탁입금정보조회2
//#define SC_D6210 @"D6210"	// 입금정보조회
//#define SC_D6010 @"D6010"	// 펀드계좌목록
//#define SC_D6210 @"D6210"	// 펀드계좌조회(입금타입)
//#define SC_C2090 @"C2090"	// 펀드입금계좌비밀번호확인

// 펀드수익증권출금
//#define SC_D6010 @"D6010"	// 1-펀드계좌목록
#define SC_D6310 @"D6310"	// 2-펀드계좌조회(출금타입)
#define SC_D6320 @"D6320"	// 3-펀드계좌출금2단계
#define SC_D6340 @"D6340"	// 4-펀드계좌출금4단계
#define SC_C2092 @"C2092"	// 펀드출금계좌비밀번호확인

// 환율조회
#define SC_D5220 @"D5220"	// 수표조회
#define SC_D5230 @"D5230"	// 타행수표조회
#define SC_F3730 @"F3730"	// 통화목록조회, 환율선택조회
//#define SC_F3730 @"F3730"	// 환율선택조회

// 서비스 별 URL.
#define SERVICE_URL             @"/common/smt/jsp/callSmtCommonService.jsp?serviceCode="
#define GUEST_SERVICE_URL       @"/common/smt/jsp/callSmtGuestCommonService.jsp?serviceCode="
#define CODE_URL                @"/common/smt/jsp/callSmtCodeService.jsp?"
#define LOGIN_URL               @"/common/smt/jsp/callSmtLoginService.jsp?serviceCode="
//#define LOGIN_URL               @"/common/smt/jsp/callSmtLoginService2.jsp?serviceCode="
#define IDPW_LOGIN_URL          @"/common/smt/jsp/callSmtIDLoginService.jsp?"
//#define IDPW_LOGIN_URL          @"/common/smt/jsp/callSmtIDLoginService2.jsp?"
#define TRANSFER_URL            @"/common/smt/jsp/signView/callSmtCommonService.jsp?serviceCode="
#define D2111_TRANSFER_URL      @"/common/smt/jsp/signView/callSmtD2111Service.jsp?serviceCode="    // 예약이체 취소 전문
#define D0011_SERVICE_URL       @"/common/smt/jsp/callSmtD0011Service.jsp?serviceCode="
#define NEW_DEPOSIT_SIGN_URL    @"/common/smt/jsp/signView/callSmtDepositService.jsp?serviceCode="
#define TAX_SERVICE_URL         @"/common/smt/jsp/callSmtTaxService.jsp?serviceCode="
//#define LOCAL_TAX_LIST_URL      @"/common/smt/jsp/callSmtG1411Service.jsp?serviceCode="              // 지방세 최근내역 all 리스트 url
#define G0161_SERVICE_URL       @"/common/smt/jsp/callSmtG0161Service.jsp?serviceCode="
#define CARD_SERVICE_URL        @"/common/smt/jsp/callSmtCardService.jsp?serviceCode="
#define DATE_TIME_URL           @"/common/currentTime.jsp?pattern="
#define DATE_URL                @"/common/smt/jsp/getAddDate.jsp?"
#define BUSINESS_CHECK_URL      @"/common/smt/jsp/isOPDate.jsp?day="
#define PRE_OP_DATE_URL         @"/common/smt/jsp/getPreOPDate.jsp?day="
#define POST_OP_DATE_URL        @"/common/smt/jsp/getNextOPDate.jsp?day="
#define NEXT_MONTH_OPDATE_URL   @"/common/smt/jsp/getNextMonthOPDate.jsp?day="
#define VERSION_CHECK_URL       @"/common/smt/jsp/callSmtSimpleService.jsp?serviceCode="
#define RENEW_SESSION           @"/common/smt/jsp/callSmtRefreshSession.jsp"

#define MULTI_TRANSFER_URL      @"/common/smt/jsp/signView/callSmtMultiService.jsp?serviceCode="
#define REMOVE_TRANSFER_URL     @"/common/smt/jsp/callSmtRemoveListRow.jsp?serviceCode="

#define CERT_ISSUE_URL          @"/common/smt/jsp/callSmtCertService.jsp?serviceCode="      // 인증서 발급 URL
#define CERT_VID_URL            @"/common/smt/jsp/callSmtCertServiceVid.jsp?serviceCode="   // 인증서 - VID_VERIFY

#define ELD_SERVICE_URL         @"/common/smt/jsp/callSmtELDService.jsp?"                    // ELD 리스트 URL
#define ELD_STANDARDINDEX_URL   @"/common/smt/jsp/callSmtD1125Service.jsp?"                 // ELD 기준지수조회 URL

// 휴대폰인증 URL
#define MOBILE_CERT_SMS_GUEST_URL       @"/common/smt/jsp/callSmtAuthSmsGuestService.jsp?"
#define MOBILE_CERT_SMS_URL             @"/common/smt/jsp/callSmtAuthSmsService.jsp?"
#define MOBILE_CERT_CODE_GUEST_URL      @"/common/smt/jsp/callSmtAuthCodeGuestService.jsp?"
#define MOBILE_CERT_CODE_URL            @"/common/smt/jsp/callSmtAuthCodeService.jsp?"

//휴대폰ARS 인증
#define MOBILE_CERT_SMSARS_URL            @"/common/smt/jsp/callSmtArsSmsService.jsp?"
#define MOBILE_CERT_SMSARS_GUEST_URL            @"/common/smt/jsp/callSmtArsSmsGuestService.jsp?"
#define MOBILE_CERT_SMSARS_VERIFY_URL     @"/common/smt/jsp/callSmtArsSmsVerifyService.jsp?"
#define MOBILE_CERT_SMSARS_VERIFY_GUEST_URL     @"/common/smt/jsp/callSmtArsSmsVerifyGuestService.jsp?"
//300만원 이상 이체시
#define MOBILE_CERT_300OVER_SMSARS_URL            @"/common/smt/jsp/callSmtIcheCertService.jsp?"

#define MOBILE_CERT_URL_OLD       @"/common/smt/jsp/callSmtSimpleService_Androboy.jsp?serviceCode="

// 고객정보변경 본인여부 확인 URL
#define LOGIN_CID_CHECK_URL     @"/common/smt/jsp/callSmtLoginCidCheck.jsp?"

// 금리조회 URL
#define D5020_SERVICE_URL		@"/common/smt/jsp/callSmtD5020Service.jsp?"


//고객별산출금리 조회 (쿠폰상품신규)
#define D5022_SERVICE_URL             @"/common/smt/jsp/callSmtD5022Service.jsp?"


// 스마트레터, 쿠폰함 URL
#define SMARTLETTER_COUPON_URL		@"/common/smt/jsp/callSmtLetterCouponService.jsp?serviceCode="

//
#define SIGN_REQUEST_URL		@"/common/smt/jsp/callSmtSignCreateService.jsp?signCode="

// E2114 전문
#define E2114_SERVICE_URL       @"/common/smt/jsp/callSmtE2114Service.jsp?serviceCode="

// 스마트신규
#define MULTI_SERVICE_URL       @"/common/smt/jsp/callSmtMultiService.jsp?"

// 직장인무방문대출
#define LOAN_SERVICE_URL        @"/common/smt/jsp/callSmtLoanService.jsp?serviceCode="

/**
 Task 전문(전문의 시작이 Task의 유형명으로 시작한다.)의 유형 구분.
 */

// 태스크 전문 관련 키.
#define TASK_NAME_KEY @"taskName"
#define TASK_ACTION_KEY @"taskAction"
//#define TASK_SIGN @"task"
#define COM_SUBCHN_KBN_KEY @"COM_SUBCHN_KBN"
#define SHB_DEVICE_TYPE @"02" // COM_SUBCHN_KBN_KEY의 값이다.

// Task 전문 공통 URL.
#define TASK_COMMON_URL @"/common/smt/jsp/callSmtTaskService.jsp?"

// Task 전자서명 공통 URL.
#define TASK_SIGN_URL @"/common/smt/jsp/signView/callSmtTaskService.jsp?"

//그룹사SSO
#define TASK_CARDSSO_URL @"/common/smt/jsp/callGroupSSOService.jsp?"

//앱리스트를 가져온다
#define TASK_GETAPPLIST_URL @"/common/smt/jsp/callSmtAppListService.jsp?"

//쿠폰함 전문 URL 3.8.5부터 사용 (3.8.4전은 공통URL적용)
#define COUPON_COMMON_URL @"/common/smt/jsp/callSmtCouponService.jsp?"


//쿠폰으로 상품신규 가입시 상품정보
#define COUPON_INOF_URL @"/common/smt/jsp/callSmtCouponProdInfo.jsp?"

//스마트케어 조회전문
#define SMARTCARE_URL @"/common/smt/jsp/callSmtTaskLogin.jsp?"

//자동이체등록시 만료일 체크
#define AUTO_TRANSFER_URL @"/common/smt/jsp/callSmtCheckAutoTran.jsp?"

// 미성년자 체크
#define MAN_AGE_CHECK_URL @"/common/smt/jsp/getManAgeCheck.jsp?"

// Task 전문 공통 URL.
#define TASK_AGE_URL @"/common/smt/jsp/getManAgeCal.jsp?"

// Task 대출 예상 한도 조회의 직업 조회 전문
#define TASK_JOB_URL @"/common/smt/jsp/callSmtJobService.jsp?"

// 위젯등록
#define WIDGET_SERVICE_URL @"/app/widget/widget.jsp?"

// 우편번호(구).
// 예: <ZIP task="sfg.rib.task.common.ZipTask" action="getZipList"><DONG_NM value="%@"/><COM_SUBCHN_KBN value= "%@"/></ZIP>
#define TASK_ZIP @"ZIP"
#define TASK_ZIP_NAME @"sfg.rib.task.common.ZipTask"
#define TASK_ZIP_ACTION @"getZipList"
#define TASK_ZIP_URL TASK_COMMON_URL

// 우편번호(신).
// 예: <NEWZIP task=\"sfg.rib.task.common.ZipTask\" action=\"getZipList\"><DONG_NM value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></NEWZIP>
#define TASK_NEWZIP @"NEWZIP"
#define TASK_NEWZIP_NAME @"sfg.rib.task.common.ZipTask"
#define TASK_NEWZIP_ACTION @"getZipList"
#define TASK_NEWZIP_URL @"/common/rib/O_RIBZIPSEARCH_NEW.jsp?" 

// 휴대폰 본인인증.
// 예: <PHONE_AUTH_REQ task=\"sfg.rib.task.common.PhoneAuthTask\" action=\"checkPhone\"><PHONE_G value=\"%@\"/><PHONE_NO1 value=\"%@\"/><PHONE_NO2 value=\"%@\"/><PHONE_NO3 value=\"%@\"/><AUTH_RRNO value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></PHONE_AUTH_REQ>
#define TASK_PHONE_AUTH_REQ @"PHONE_AUTH_REQ"
#define TASK_PHONE_AUTH_REQ_NAME @"sfg.rib.task.common.PhoneAuthTask"
#define TASK_PHONE_AUTH_REQ_ACTION @"checkPhone"
#define TASK_PHONE_AUTH_REQ_URL TASK_COMMON_URL

// 메인계좌 조회.
// 예: <메인계좌조회 task=\"sfg.sphone.task.sbmini.SBMini\" action=\"Main_Select\"><고객번호 value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></메인계좌조회>
#define TASK_INQUIRY_MAIN_ACCOUNT @"메인계좌조회"
#define TASK_INQUIRY_MAIN_ACCOUNT_NAME @"Main_Select"
#define TASK_INQUIRY_MAIN_ACCOUNT_ACTION @"메인계좌조회"
#define TASK_INQUIRY_MAIN_ACCOUNT_URL @"/common/smt/jsp/callSmtTaskLogin.jsp?"

// 메인계좌 삭제.
// 예: <maindelete task=\"sfg.sphone.task.sbmini.SBMini\" action=\"Main_Delete\"> <고객번호 value=\"%@\"/><메인계좌번호 value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></maindelete>
#define TASK_MAIN_DELETE @"maindelete"
#define TASK_MAIN_DELETE_NAME @"sfg.sphone.task.sbmini.SBMini"
#define TASK_MAIN_DELETE_ACTION @"Main_Delete"
#define TASK_MAIN_DELETE_URL TASK_INQUIRY_MAIN_ACCOUNT_URL

// 메인계좌 업데이트.
// 예: <xdaresult task=\"sfg.sphone.task.sbmini.SBMini\" action=\"Main_Update\"> <고객번호 value=\"%@\"/><메인계좌번호 value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></xdaresult>
#define TASK_XDARESULT @"xdaresult"
#define TASK_XDARESULT_NAME @"sfg.sphone.task.sbmini.SBMini"
#define TASK_XDARESULT_ACTION @"Main_Update"
#define TASK_XDARESULT_ACTION_URL TASK_INQUIRY_MAIN_ACCOUNT_URL

// 메인계좌 업데이트_2.
// 예: <xdaresult_2 task=\"sfg.sphone.task.sbmini.SBMini\" action=\"Main_Update\"> <고객번호 value=\"%@\"/><메인계좌번호 value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></xdaresult_2>
#define TASK_XDARESULT_2 @"xdaresult_2"
#define TASK_XDARESULT_2_NAME @"sfg.sphone.task.sbmini.SBMini"
#define TASK_XDARESULT_2_ACTION @"Main_Update"
#define TASK_XDARESULT_2_URL TASK_INQUIRY_MAIN_ACCOUNT_URL

// 직업조회(중(3)/소(4)는 JIKEOB_LEVEL 엘리먼트의 value 속성값으로 구분한다.)
// 예: <JOBCODE task=\"sfg.rib.task.common.DBTask\" action=\"getJobCode\"><FROM_JIKEOB_CODE value=\"%d\"/><TO_JIKEOB_CODE value=\"%d\"/><JIKEOB_LEVEL value=\"3\"/><COM_SUBCHN_KBN value= \"%@\"/></JOBCODE>
#define TASK_JOBCODE @"JOBCODE"
#define TASK_JOBCODE_NAME @"sfg.rib.task.common.DBTask"
#define TASK_JOBCODE_ACTIONT TASK_COMMON_URL

// 직위조회.
// 예: <JIKWICODE task=\"sfg.rib.task.common.DBTask\" action=\"getJikwiCode\"><FROM_JIKWI_CODE value=\"%@\"/><TO_JIKWI_CODE value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></JIKWICODE>
#define TASK_JIKWICODE @"JIKWICODE"
#define TASK_JIKWICODE_NAME @"sfg.rib.task.common.DBTask"
#define TASK_JIKWICODE_ACTION @"getJikwiCode"
#define TASK_JIKWICODE_URL TASK_COMMON_URL

// 버전정보.
// 예: <selectVersionInfo task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"selectVersionInfo\"><서비스구분 value=\"%@\"/><OS구분 value=\"1\"/><Client버젼 value=\"%@\"/><COM_SUBCHN_KBN value=\"%@\"/></selectVersionInfo>
//#define TASK_SELECT_VERSION_INFO @"selectVersionInfo"
#define TASK_SELECT_VERSION_INFO @"request"
#define TASK_SELECT_VERSION_INFO_NAME @"sfg.sphone.task.sbank.Sbank_info"
#define TASK_SELECT_VERSION_INFO_ACTION @"doStart"
#define TASK_SELECT_VERSION_INFO_URL @"/common/smt/jsp/callSmtStartService.jsp"
#define TASK_SELECT_VERSION_INFO_URL2 @"/common/smt/jsp/callAppVersion.jsp"

//폰정보전송.
// 예: <selectVersionInfo task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"selectVersionInfo\"><서비스구분 value=\"%@\"/><OS구분 value=\"1\"/><Client버젼 value=\"%@\"/><COM_SUBCHN_KBN value=\"%@\"/></selectVersionInfo>
//#define TASK_SELECT_VERSION_INFO @"selectVersionInfo"
#define TASK_SELECT_VERSION_INFO_INPUT @"request"
#define TASK_SELECT_VERSION_INFO_INPUT_NAME @"sfg.sphone.task.sbank.Sbank_info"
#define TASK_SELECT_VERSION_INFO_INPUT_ACTION @"doStart"
#define TASK_SELECT_VERSION_INFO_INPUT_URL @"/common/smt/jsp/callSmtPhoneInfoNew.jsp"

// 폰정보.
// 예: <REQUEST task='sfg.sphone.task.sbank.Sbank_info' action='phoneInfoInsert'><SBANK_SVC_CODE value = \"%@\"/><SBANK_CUSNO value = \"%@\"/><SBANK_PHONE_ETC1 value = \"%@\"/><SBANK_RRNO value = \"%@\"/><SBANK_SBANKVER value = \"%@\"/><SBANK_PHONE_OS value = \"%@\"/><SBANK_PHONE_NO value=\"\"/><SBANK_PHONE_COM value = \"%@\"/><SBANK_PHONE_MODEL value = \"%@\"/><SBANK_UID1 value = \"%@\"/><SBANK_MAC1 value=\"%@\"/><COM_SUBCHN_KBN value= \"%@\"/></REQUEST>
#define TASK_REQUEST_PHONE_INFO_INSERT @"REQUEST"
#define TASK_REQUEST_PHONE_INFO_INSERT_NAME @"sfg.sphone.task.sbank.Sbank_info"
#define TASK_REQUEST_PHONE_INFO_INSERT_ACTION @"phoneInfoInsert"
#define TASK_REQUEST_PHONE_INFO_URL @"/common/smt/jsp/callSmtPhoneInfoNew.jsp?"

// SSO관련
#define SSO_URL	@"/common/smt/jsp/callCheckSSOService.jsp?"
#define SSO_TICKET_URL	@"/common/smt/jsp/callTicketSSOService.jsp?"

//ios7 대응으로  2013.10.07에 추가
#define SSO_URL2	@"/common/smt/jsp/callSSOService.jsp?"
/**
 Request 전문 유형 URL.
 */

// 실명확인.
// 예: <Request><X value=\"0.0\" /><Y value=\"0.0\" /><UDID value=\"%@\" /><userIdentifier value=\"%@\" /><username value=\"%@\" /><COM_SUBCHN_KBN value= \"%@\"/></Request>
#define CHECK_REAL_NAME_URL @"/coupon_s/usernameCheck.jsp"

// ID 확인.
// 예: <Request><X value=\"0.0\" /><Y value=\"0.0\" /><UDID value=\"%@\" /><userid value=\"%@\" /><COM_SUBCHN_KBN value= \"%@\"/></Request>
#define CHECK_ID_URL @"/coupon_s/idCheck.jsp"

// 로그아웃.
#define LOGOUT @"logout"
#define LOGOUT_URL @"/common/smt/jsp/goSphoneLogout.jsp?"

// 공인인증서 등록 및 갱신.
#define REG_OR_RENEW_CERT @"regOrRenewCert"

// 공인인증서 폐기.
#define EXPIRE_CERT @"expireCert"

// 타기관/타행 공인인증서 등록
#define REG_OTHERS_CERT @"regOthersCert"

/**
 Request 전문 유형 URL.
 */


/**
 약관관련 URL
 */

#ifdef TEST_SERVER
    #define IMAGE_URL           @"http://imgdev.shinhan.com/sbank/deposit"		//2010.10.13  -  상품신규 이미지 URL
    #define CONTRACT_URL        @"http://mdev.shinhan.com/yak"					//2010.10.27 - 상품신규 약관 URL
    #define MENUAL_URL          @"http://mdev.shinhan.com/seol"					//2010.10.27 - 상품신규 약관 URL2  상품설명서
#else
    #define IMAGE_URL			@"http://imgdev.shinhan.com/sbank/deposit"			//2010.10.13  -  상품신규 이미지 URL
    #define CONTRACT_URL		@"http://m2013.shinhan.com/yak"						//2010.10.27 - 상품신규 약관 URL
    #define MENUAL_URL			@"http://m2013.shinhan.com/seol"					//2010.10.27 - 상품신규 약관 URL2  상품설명서
#endif


// 20121220_sjbae : 바뀐 URL 추가
//++++++++++test+++++++++++

#define URL_YAK_TEST				@"http://imgdev.shinhan.com/sbank/yak/"			// 약관URL 테스트서버
#define URL_PRODUCT_TEST			@"http://imgdev.shinhan.com/sbank/prodSumm/"	// 상품정보 URL 테스트서버
//#define URL_INTEREST		@"http://dev-m.shinhan.com/pages/financialPrdt/deposit/irate_online.jsp?"	// 금리보기
#define URL_INTEREST_TEST		@"http://dev-m.shinhan.com/pages/financialPrdt/deposit/irate.jsp?"	// 금리보기
#define URL_IMAGE_TEST           @"http://imgdev.shinhan.com"
#define URL_M_TEST               @"http://dev-m.shinhan.com"


//+++++++++real++++++++++

#define URL_YAK				@"http://img.shinhan.com/sbank/yak/"			// 약관URL
#define URL_PRODUCT			@"http://img.shinhan.com/sbank/prodSumm/"		// 상품정보 URL
//    #define URL_INTEREST		@"http://m2013.shinhan.com/pages/financialPrdt/deposit/irate_online.jsp?"	// 금리보기
#define URL_INTEREST		@"http://m.shinhan.com/pages/financialPrdt/deposit/irate.jsp?"	// 금리보기
#define URL_IMAGE           @"http://img.shinhan.com"
#define URL_M               @"http://m.shinhan.com"



