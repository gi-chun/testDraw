//
//  SHBProductService.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 16..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#define kD3622Id	7000	// 상품리스트
#define kD3602Id	7001	// 세금우대 안내문구
#define kC2315Id	7002	// 필수정보동의여부 및 마케팅활용동의여부 확인용
#define kD4220Id	7003	// 세금우대 가입정보
#define kC2090Id	7004
#define kE1826Id	7005	// 권유직원 조회
#define kD4222Id	7006	// 비과세(생계형) 라디오버튼 선택했을때
#define kD3604Id	7007	// 상품가입 최종확인

#define kD9501Id	7008	// 권유직원 메일발송
#define kC2316Id	7009	// 정보동의여부 내용전송
#define kC2800Id	7010	// 고객유형정보?
#define kE2650Id	7011	// U드림전환 대상 계좌 배열
#define kD5520Id	7012	// U드림전환신청
#define kD3280Id	7013	// 예적금 해지 1단계 계좌정보 조회
#define kD3611Id	7014	// 조회일자?
#define kD3281Id	7015	// 전체해지 예상조회
#define kD3285Id	7016	// 일부해지 예상조회
#define kD3286Id	7017	// 일부해지
#define kD3282Id	7018	// 전체해지
#define kD3606Id	7019	// 담보대출 안내문구
#define kL1310Id	7020	// 대출가능 한도조회
#define kC2092Id	7021	// 출금계좌 잔액 및 비밀번호 체크
#define kL1311Id	7022	// 예적금 담보대출 건별 1차 확인
#define kL1312Id	7023	// 예적금 담보대출 건별 1차 확인
#define kD3607Id	7024	// 담보대출 확인(OTP/보안카드) 화면 안내문구
#define kD3608Id	7025	// 담보대출 완료 화면 안내문구
#define kD3609Id	7044	// 담보대출 완료 화면 안내문구 구분5
#define kD3610Id	7045	// 담보대출 담보대출 확인(OTP/보안카드) 화면 안내문구 구분 6
#define kD3612Id	7046	// 담보대출 완료 화면 안내문구 구분 7
#define kE4903Id	7026	// 쿠폰조회
#define kD5020Id	7027	// 금리조회

#define kD3300Id	7028	// 재형저축 등록
#define kD3310Id	7029	// 재형저축 등록/취소내역 조회
#define kD3320Id	7030	// 재형저축 정정/취소 전 조회
#define kD3321Id	7031	// 재형저축 정정/취소 실행
#define kD5022Id    7032    // 재형저축 적용 가산금리 조회
#define kD3603Id	7033    // 상품신규시 신규로 등록할 비밀번호 체크
#define kD4380Id    7041    // 상품해지완료 리스트
#define kD4381Id    7042    // 상품해지 
#define kD4390Id    7043    // 상품신규시 신규로 등록할 비밀번호 체크
#define kL1411Id	7047	// 예적금 담보대출 한도 
#define kD3112Id	7048	// 신탁상품 신규
#define kD3342Id	7049	// 신탁상품 해지조회
#define kD3343Id	7050	// 신탁상품 해지실행


// ELD
#define kD3276Id    7034    // ELD 상품목록 조회
#define kD6011Id    7035    // ELD 투자자 정보분석 조회
#define kD6012Id    7036    // ELD 투자자 정보분석 등록
#define kD3277Id    7037    // ELD 신규 완료
#define kD6115Id	7038	// Email

// 스마트신규
#define kD3250Id	    7039    // 쿠폰으로 상품신규(영업점 승인)
#define kD3251Id        7040    // 스마트신규 등록내역조회

// 신한e-간편해지
#define kE2670Id	7051    // 예적금 기일도래명세조회
#define kD3287Id    7052    // 신한e-간편해지 실행

// XDA 전문으로 바뀜
#define XDA_S00004			kD3622Id	// 상품리스트
#define XDA_S00004_1		6999		// 상품리스트 단건 조회 (푸쉬등오로 왔을 때)
#define XDA_S00001_1		kD3602Id	// 세금우대 안내문구 : (param : 구분=1)
#define XDA_S00001_2		kD3606Id	// 담보대출 안내문구 : (param : 구분=2)
#define XDA_S00001_3		kD3607Id	// 담보대출 확인(OTP/보안카드) 화면 안내문구 : (param : 구분=3)
#define XDA_S00001_4		kD3608Id	// 담보대출 완료 화면 안내문구 (param : 구분=4)
#define XDA_S00001_5		kD3609Id	// 담보대출 안내문구 : (param : 구분=5)
#define XDA_S00001_6		kD3610Id	// 담보대출 확인(OTP/보안카드) 화면 안내문구 : (param : 구분=6)
#define XDA_S00001_7		kD3612Id	// 담보대출 완료 화면 안내문구 (param : 구분=7)

#define XDA_SelectEmpInfo	6998		// 푸쉬등으로 타고왔을때 권유직원 확인
// 전화상담요청
#define XDA_InsertPhb       8000        // 전화상담요청

//나이요청
#define XDA_AGE         8001        // 상품가입시 나이 비교위해 나이 받음

#define XDA_CHECK_MON   8002        // 상품신규 자동이체 종료일과 만기일 체크
#define XDA_TICKER      8003        // 올레 티커

#define kE4903Id_olleh	8004	// 올레쿠폰조회
#define kE4904Id	    8005	// 올레쿠폰등록

#define SMART_NEW_LIST    8006    // 스마트신규 (D3249, D3251, D6170 한번에 조회)


#import "SHBBankingService.h"

@interface SHBProductService : SHBBankingService

@property (nonatomic, retain) NSString *strDepositKind;	// 세금우대_D4222저축종류

@end
