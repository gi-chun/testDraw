//
//  SHBUtility.h
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBUtility : NSObject

+ (int) countMultiByteStringFromUTF8String:(NSString*)str;

+ (NSString *) substring:(NSString*)str ToMultiByteLength:(int)length;
+ (NSString *)getDateWithDash:(NSString *)date;

+ (NSString *)phoneNumber;
+ (NSString *)getDateMonthAgo:(NSString *)currentDate month:(int)ago;
+ (NSArray *)getCurrentDateAgoYear:(int)yy AgoMonth:(int)mm AgoDay:(int)dd;
+ (BOOL) isOPDate:(NSString *)str;
+ (int)getCurrentHour;
+ (NSString *)getPreOPDate:(NSString *)str;
+ (int)getCurrentSecond;
+ (int)checkDateValidation:(NSString *)yyyyMMdd;
+ (NSString *)normalStringTocommaString:(NSString *)normalString;
+ (NSString *)getPostOPDate:(NSString *)str;
+ (NSString *)getNextMonthOPDate:(NSString *)str;
+ (NSArray *)getCurrentDateAgoYear:(int)yy AgoMonth:(int)mm AgoDay:(int)dd SDate:(NSString*)str;
+ (NSString *)cardnumToHiddenView:(NSString *)str;
+ (NSString *)commaStringToNormalString:(NSString *)commaString;

+ (NSString *)getCurrentTime;//2011.02.01  서버에서 시간 가져오는 메소드 추가
+ (NSString *)getCurrentTime:(BOOL) Hyphen;//2011.02.01  서버에서 시간 가져오는 메소드 추가
+ (NSString *)getCurrentDate;/////// 2011.02.01  기존에 안쓰던 소스 변경
+ (NSString *)getCurrentDate:(BOOL) Hyphen;/////// 2011.02.01  기존에 안쓰던 소스 변경

+ (NSString *)birthYearString;          // 출생년도를 반환하는 method
+ (NSString *)changeNumberStringToKoreaAmountString:(NSString*)amountString;            // 숫자를 받아 한글로 변환 (ex) 1234 -> 천이백삼십사
+ (NSString *)dateStringToMonth:(int)month toDay:(int)day;       // 입력된 값의 날짜를 계산해주는 method
+ (NSString *)nilToString:(NSString *)str; // nil을 @""로 변경
+ (NSString *) getDocumentsDirectory; //도큐먼트 디렉토리 경로를 가져온다.
+ (NSString *) getCachesDirectory; //캐시 디렉토리 경로를 가져온다
+ (BOOL) isExistFile:(NSString *)sPath; //파일이 존재하는지?
+ (NSTextCheckingResult *)isPhoneNumberCheck:(NSString *)number1 number2:(NSString *)number2 number3:(NSString *)number3; // 전화번호 국번체크
+ (NSTextCheckingResult *)isPhoneNumberCheck:(NSString *)phoneNumber; // 전화번호 국번체크
+ (BOOL)isExistAlpabet:(NSString *)stringStr; //스트링에 영문자가 포함되어 있는지 체크(정규식 사용)
+ (BOOL)isExistNumber:(NSString *)stringStr;  //스트링에 숫자가 포함되어 있는지 체크(정규식 사용)
+ (int) getDDay:(NSString *)fromStr; //인자로 넘겨주는 일자와 현재 일자의 차이를 넘겨준다. 2012-11-21 식으로 변수로 넘겨줘 남은 일자를 int로 넘겨줌.

+ (NSString *)getMacAddress:(BOOL)isColon;
+ (NSString *)getSecureMacAddress:(NSString *)mac;

+ (NSTextCheckingResult *)emailVaildCheck:(NSString *)email; // 이메일주소 체크

+ (BOOL)isFindString:(NSString *)str find:(NSString *)findStr; // str에서 findStr 찾기

+ (NSString *)addTimeStamp:(NSString *)URL; // URL끝에 타임스탬프 넣기

+ (NSString *)getCarrier; // 통신사 알아오기

+ (NSString *)dateStringToDate:(NSString *)date toMonth:(int)month toDay:(int)day;

+ (NSString *)setAccountNumberMinus:(NSString *)accountNumber; // 계좌번호에 - 기호 넣기

+ (BOOL)writeErrorLog:(NSString *)errMsg;
@end
