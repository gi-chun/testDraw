//
//  SHBParser.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/** 
 SHBDataParser 클래스는 XML 포맷의 신한은행 통신 전문을 파싱하여 SHBDataSet 데이터 타입으로 변환과 
 전문을 생성하는 역할을 한다.
 
 클래스 메서드인 dictionaryWithXMLNode:와 dictionaryWithXMLData:를 제공한다.
 사용법은 다음과 같다.
 
 [SHBDataParser dictionaryWithXMLNode:element];
 [SHBDataParser dictionaryWithXMLData:data];
 
 각각 메서드 인자의 데이터 포맷이 XML 또는 NSData인 경우 사용할 수 있다.
 */

#import <Foundation/Foundation.h>
#import "OFXMLDataParser.h"
//#import "APXML.h"

// 서비스 전문 관련 키.
#define ITERATE_ELEMENT_KEY @"data"
#define XML_VALUE_KEY @"value"

@interface SHBXmlDataParser : OFXMLDataParser {
    
    BOOL ishash;
}

/**
 @name 신한은행 통신 전문 포맷 중 XML 타입1을 파싱한다.
 */

/** 
 TBXML 파서로 파싱된 XML을 SHBDataSet 타입으로 변환한다.
 
 @param element TBXML의 TEXMLElement 타입.
 @return SHBDataSet 반환.
 @see TBXML 파서에 관해서는 다음 (http://tbxml.co.uk/TBXML/TBXML_Free.html)을 참고하라.
 */
- (OFDataSet *) parseWithXMLElement: (TBXMLElement *)element;

/** 
 NSData 타입의 XML을 SHBDataSet 타입으로 변환한다.
 
 @param data NSData 타입.
 @return SHBDataSet 반환.
 */
- (OFDataSet *) parse: (NSData *) aData;

/** 
 XML 헤더가 포함된 전문(전문유형: SHBTRTypeServiceCode)을 생성한다.
 
 @param serviceCode  서비스 코드.
 @param dict 데이터. 
 @return NSString XML 형식의 전문.
 */
- (NSString *)generate:(SHBDataSet *)aDataSet;// withSign:(NSString*)electronicSign;

/** 
 전문의 개별 엘리먼트 생성
 
 @param key 전문의 필드 키.
 @param value 값.
 @return NSString XML 형식의 엘리먼트.
 */
- (NSString *)stringForKeyValue:(NSString *)key andValue:(NSString *)value;
- (NSString *)stringSafeForXML:(NSString *)elementValue;
/**
 XML 전문을 생성한다.
 
 @param dict 데이터. 
 @return NSString XML 형식의 전문.
 */
- (NSString *)stringForDataSet:(SHBDataSet *)aDataSet;

/**
 Task 전문(전문유형: SHBTRTypeTask)을 생성한다.
 
 @param task Task 전문의 태스크.
 @param dict 데이터.
 @return NSString XML 형식의 전문.
 */
- (NSString *)genTaskTR:(NSString *)task dictionary:(NSMutableDictionary *)dict;
- (NSString *)genTaskAndVectorTR:(NSString *)task dictionary:(SHBDataSet *)aDataSet;
/**
 Request 전문(전문유형: SHBTRTypeRequest)을 생성한다.
 
 @param dict 데이터.
 @return NSString XML 형식의 전문.
 */
- (NSString *)genRequestTR:(NSMutableDictionary *)dict;

/**
 백터방식 전문 생성(예약 이체 취소등..)
 
 @param dict 데이터.
 @return NSString XML 형식의 전문.
 */
- (NSString *)genRequestVector:(NSMutableDictionary *)dict;
@end
