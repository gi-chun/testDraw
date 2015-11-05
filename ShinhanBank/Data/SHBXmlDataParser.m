//
//  SHBParser.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBXmlDataParser.h"

@implementation SHBXmlDataParser
{
    BOOL isNotificationService;     // 알림의 스마트레터, 쿠폰 처리
    BOOL isMobileCertService;       // 모바일인증시 처리
    int hashValueCount;
    int cnt;
    
}


//dictionaryWithXMLData
- (OFDataSet *) parse: (NSData *) aData
{
    
    NSError *error = nil;
    TBXML *tbxml = [[TBXML newTBXMLWithXMLData:aData error:&error] autorelease];
    
    if (!tbxml.rootXMLElement)
    {
        return nil;
    }
    
    //OFDataSet *dataSet =[self parseWithXMLElement:tbxml.rootXMLElement];
    //NSLog(@"rootXMLElement->firstChild:%@",dataSet);
    
    hashValueCount = 0;
    //NSString *s = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    //NSLog(@"original data:%@",s);
    
    
    return [self parseWithXMLElement:tbxml.rootXMLElement->firstChild];
}



//dictionaryWithXMLNode
- (OFDataSet *) parseWithXMLElement: (TBXMLElement *)element
{
    OFDataSet *aDataSet = [[[SHBDataSet alloc] init] autorelease];
    
    if (element == nil) return aDataSet;
    NSString *elementValue;
    
    do
    {
        //        if ([[TBXML elementName:element] isEqualToString:@"대출상품명"]) {
        //            NSLog(@"element name:%@",[TBXML elementName:element]);
        //        }
        //NSLog(@"element name:%@",[TBXML elementName:element]);
        cnt++;
        // 자식 엘리먼트가 있다면...
        if (element->firstChild) //반복부 처리
        {
            //NSLog(@"반복부 찾기:%@",[TBXML elementName:element]);
            if ([aDataSet valueForKey:[TBXML elementName:element]] == nil)
            {
                
                //NSLog(@"firstChild: %@", [TBXML elementName:element]);
                if ([[TBXML elementName:element] isEqualToString:@"hashtable"]) {
                    ishash = YES;
                }
                
                
                
                [aDataSet setObject:[self parseWithXMLElement:element->firstChild] forKey:[TBXML elementName:element]];
                
                
                
            }
            else if ([[aDataSet valueForKey:[TBXML elementName:element]] isKindOfClass:[NSMutableArray class]])
            {
                
                //NSLog(@"addArray: %@", [TBXML elementName:element]);
                //NSLog(@"addArray-object: %@", [self parseWithXMLElement:element->firstChild]);
                
                //                if ([[TBXML elementName:element] isEqualToString:@"data"]) {
                //                    NSLog(@"find data:%@",[self parseWithXMLElement:element->firstChild]);
                //                }
                
                elementValue = [[TBXML elementName:element] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                [[aDataSet valueForKey:elementValue] addObject:[self parseWithXMLElement:element->firstChild]];
                
                //[[aDataSet valueForKey:[TBXML elementName:element]] addObject:[self parseWithXMLElement:element->firstChild]];
                
            }
            else
            {
                
                //Debug(@"createArray: %@", [TBXML elementName:element]);
                NSMutableArray *items = [NSMutableArray new];
                
                elementValue = [[TBXML elementName:element] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                [items addObject:[aDataSet valueForKey:elementValue]];
                
                //[items addObject:[aDataSet valueForKey:[TBXML elementName:element]]];
                [items addObject:[self parseWithXMLElement:element->firstChild]];
                
                //Debug(@"Item Array contents: %@", items);
                //[aDataSet setObject:[items autorelease] forKey:[TBXML elementName:element]];
                [aDataSet setObject:[items autorelease] forKey:[TBXML elementName:element]];
                
                
            }
        }
        else //반복부가 아닌경우 처리
        {
            // 엘리먼트의 첫 번째 속성.
            TBXMLAttribute *attribute = element->firstAttribute;
            
            if (attribute)
            {
                
                // 속성이 있는 경우.
                while (attribute)
                {
                    if (!ishash) {
                        if ([[TBXML attributeName:attribute] isEqualToString:@"value"])
                        {
                            //NSLog(@"value: %@=%@", [TBXML elementName:element], [TBXML attributeValue:attribute]);
                            //codeStr = [TBXML attributeValue:attribute];
                            
                            elementValue = [[TBXML attributeValue:attribute] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                            [aDataSet setObject:elementValue forKey:[TBXML elementName:element]];
                            
                            //[aDataSet setObject:[TBXML attributeValue:attribute] forKey:[TBXML elementName:element]];
                            
                            
                        }
                        else
                        {
                            //NSLog(@"not value: %@=%@", [TBXML elementName:element], [TBXML attributeValue:attribute]);
                            elementValue = [[TBXML attributeValue:attribute] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                            elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                            [aDataSet setObject:elementValue forKey:[NSString stringWithFormat:@"%@->%@", [TBXML elementName:element], [TBXML attributeName:attribute]]];
                            
                            //[aDataSet setObject:[TBXML attributeValue:attribute] forKey:[NSString stringWithFormat:@"%@->%@", [TBXML elementName:element], [TBXML attributeName:attribute]]];
                            
                        }
                        
                    } else
                    {
                        
                        if ([[TBXML attributeName:attribute] isEqualToString:@"value"])
                        {
                            hashValueCount++;
                            //NSLog(@"hashValueCount:%i",hashValueCount);
                            //NSLog(@"value: %@=%@", [TBXML elementName:element], [TBXML attributeValue:attribute]);
                            
                            //codeStr = [TBXML attributeValue:attribute];
                            if ((hashValueCount % 2) == 1)
                            {
                                elementValue = [[TBXML attributeValue:attribute] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                                [aDataSet setObject:elementValue forKey:@"code"];
                                
                                //[aDataSet setObject:[TBXML attributeValue:attribute] forKey:@"code"];
                                
                            } else if ((hashValueCount % 2) == 0)
                            {
                                elementValue = [[TBXML attributeValue:attribute] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                                [aDataSet setObject:elementValue forKey:@"value"];
                                
                                [aDataSet setObject:[TBXML attributeValue:attribute] forKey:@"value"];
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    // 다음 속성.
                    attribute = attribute->next;
                }
            }
            else
            {
                // 속성이 없는 경우.
                //NSLog(@"no attribute: %@=%@", [TBXML elementName:element], [TBXML textForElement:element]);
                elementValue = [[TBXML textForElement:element] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
                elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
                [aDataSet setObject:elementValue forKey:[TBXML elementName:element]];
                
                //[aDataSet setObject:[TBXML textForElement:element] forKey:[TBXML elementName:element]];
            }
        }
        
    }
    while ((element = element->nextSibling));
    
    //NSLog(@"cnt:%i, aDataSet:%@",cnt, aDataSet);
    
    return aDataSet;
}

// 서비스코드 전문 생성.
//genTR
- (NSString *)generate:(SHBDataSet *)aDataSet// withSign:(NSString*)electronicSign
{
    if (aDataSet == nil)
        return nil;
    
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableString *rootElement = [NSMutableString string];
    
    if ([aDataSet.serviceCode isEqualToString:@"TASK"]) { //task 전문
        
        Debug(@"\n------------------------------------------------------------------\
              \nTASK 전문 생성 시작\
              \n------------------------------------------------------------------");
        if ([aDataSet.TaskAndVector isEqualToString:@"N"]) {
            rootElement = (NSMutableString *)[self genTaskTR:aDataSet.serviceTaskCode dictionary:aDataSet];
        } else if ([aDataSet.TaskAndVector isEqualToString:@"Y"])
        {
            rootElement = (NSMutableString *)[self genTaskAndVectorTR:aDataSet.serviceTaskCode dictionary:aDataSet];
        }
        
        
    } else if ([aDataSet.serviceCode isEqualToString:@"REQUEST"]) { //request 전문
        
        Debug(@"\n------------------------------------------------------------------\
              \nREQUEST 전문 생성 시작:\
              \n------------------------------------------------------------------");
        rootElement = (NSMutableString *)[self genRequestTR:aDataSet];
        
    } else { //서비스 코드 전문
        
        Debug(@"\n------------------------------------------------------------------\
              \nCODE 전문 생성 시작:\
              \n------------------------------------------------------------------");
        if ([aDataSet.serviceCode isEqualToString:@"CODE"]) { //정렬된 데이타를 받기 위해 전문생성을 달리한다
            NSString *targetServer = [NSString stringWithFormat:@"%@", aDataSet.serviceCode];
            [rootElement appendFormat:@"<%@ ", targetServer];
            [rootElement appendFormat:@"language=\"%@\" ", @"ko"];
            [rootElement appendFormat:@"type=\"%@\">", @"vector"];
            [rootElement appendFormat:@"%@", [self stringForDataSet:aDataSet]];
            [rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/>",@"02"];
            [rootElement appendFormat:@"<VERSION value=\"%@\"/>",versionNumber];
            [rootElement appendFormat:@"</%@>", targetServer];
        } else
        {   //일반적 전문 형태
            
            if (self.vectorCode)
            {
                rootElement = (NSMutableString *)[self genRequestVector:aDataSet];
                
            } else
            {
                NSString *targetServer = [NSString stringWithFormat:@"S_RIB%@", aDataSet.serviceCode];
                NSString *responseMessage = [NSString stringWithFormat:@"R_RIB%@", aDataSet.serviceCode];
                
                [rootElement appendFormat:@"<%@ ", targetServer];
                [rootElement appendFormat:@"requestMessage=\"%@\" ", targetServer];
                [rootElement appendFormat:@"responseMessage=\"%@\" ", responseMessage];
                
                //전자 서명일경우
                if (self.eSign == YES) {
                    [rootElement appendFormat:@"useSign=\"%@\" ", @"true"];
                }
                
                //                BOOL onlyCode;
                if ([aDataSet objectForKey:@"attributeNamed"] == nil)
                {
                    //                    onlyCode = NO;
                    [rootElement appendFormat:@"serviceCode=\"%@\"> ", aDataSet.serviceCode];
                    [rootElement appendFormat:@"%@", [self stringForDataSet:aDataSet]];
                } else
                {
                    [rootElement appendFormat:@"%@=\"%@\" ",[aDataSet objectForKey:@"attributeNamed"],[aDataSet objectForKey:@"attributeValue"]];
                    [rootElement appendFormat:@"serviceCode=\"%@\"> ", aDataSet.serviceCode];
                    // 누락분 추가
                    [rootElement appendFormat:@"%@", [self stringForDataSet:aDataSet]];
                }
                [rootElement appendFormat:@"<VERSION value=\"%@\"/>",versionNumber];
                [rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/>",SHB_DEVICE_TYPE];
                [rootElement appendFormat:@"</%@>", targetServer];
            }
            
        }
        
        
    }
    
    Debug(@"\n------------------------------------------------------------------\
          \n송신 전문 생성 결과:%@\
          \n------------------------------------------------------------------", rootElement);
    return rootElement;
}

// 전문의 개별 엘리먼트 생성.
- (NSString *)stringForKeyValue:(NSString *)key andValue:(NSString *)value
{
    NSString *element;
    if (isNotificationService)
    {
        element = [NSString stringWithFormat:@"<%@ getSession=\"%@\"/>", key, [self stringSafeForXML:value]];
        //element = [NSString stringWithFormat:@"<%@ getSession=\"%@\"/>", key, value];
    }
    else
    {
        element = [NSString stringWithFormat:@"<%@ value=\"%@\"/>", key, [self stringSafeForXML:value]];
        //element = [NSString stringWithFormat:@"<%@ value=\"%@\"/>", key, value];
    }
    
    
    return element;
}

// 전문 생성.
- (NSString *)stringForDataSet:(SHBDataSet *)aDataSet
{
    NSMutableString *elements = [NSMutableString string];
    
    NSEnumerator *enumerator = [aDataSet keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject]))
    {
        [elements appendString:[self stringForKeyValue:key andValue:[aDataSet objectForKey:key]]];
    }
    
    return elements;
}

// 태스크 전문 생성.
- (NSString *)genTaskTR:(NSString *)task dictionary:(NSMutableDictionary *)dict
{
    if (task == nil)
        return nil;
    
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //NSLog(@"aa:%@, bb:%@, cc:%@",task,[dict objectForKey:TASK_NAME_KEY],[dict objectForKey:TASK_ACTION_KEY]);
    NSMutableString *rootElement = [NSMutableString string];
    
    
    if ([[dict objectForKey:TASK_ACTION_KEY] isEqualToString:@"selectSmartLetter"] ||
        [[dict objectForKey:TASK_ACTION_KEY] isEqualToString:@"selectCoupon3"] ||
        [[dict objectForKey:TASK_ACTION_KEY] isEqualToString:@"selectNewYN2"] ||
        [[dict objectForKey:TASK_ACTION_KEY] isEqualToString:@"selectSbankWhiteList"])
    {
        isNotificationService = YES;
    }
    
    //[rootElement appendFormat:@"<%@ task=\"%@\" action=\"%@\">", task, [dict objectForKey:TASK_NAME_KEY], [dict objectForKey:TASK_ACTION_KEY]];
    if ([[dict objectForKey:TASK_ACTION_KEY] isEqualToString:@"insertGroupSsoAgree"])
    {
        [rootElement appendFormat:@"<%@ task=\"%@\" action=\"%@\" serviceCode=\"SSO012\">", task, [dict objectForKey:TASK_NAME_KEY], [dict objectForKey:TASK_ACTION_KEY]];
    }else
    {
        [rootElement appendFormat:@"<%@ task=\"%@\" action=\"%@\">", task, [dict objectForKey:TASK_NAME_KEY], [dict objectForKey:TASK_ACTION_KEY]];
    }
    // 하위 엘리먼트 추가.
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject]))
    {
        if (![key isEqualToString:TASK_NAME_KEY] && ![key isEqualToString:TASK_ACTION_KEY])
        {
            [rootElement appendFormat:@"%@", [self stringForKeyValue:key andValue:[dict objectForKey:key]]];
        }
    }
    [rootElement appendFormat:@"<VERSION value=\"%@\"/>",versionNumber];
    [rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/></%@>", SHB_DEVICE_TYPE, task];
    //[rootElement appendFormat:@"<구분 value= \"%@\"/></%@>", SHB_DEVICE_TYPE, task];
    //NSLog(@"task gr:%@",rootElement);
    
    isNotificationService = NO; // 초기화
    
    return rootElement;
}
- (NSString *)genTaskAndVectorTR:(NSString *)task dictionary:(SHBDataSet *)aDataSet
{
    //NSLog(@"count:%i",[aDataSet count]);
    //NSLog(@"aDataSet:%@",aDataSet);
    
    NSEnumerator *enumerator = [aDataSet keyEnumerator];
    
    id key;
    int j = 0;
    //NSMutableDictionary *item = [NSMutableDictionary dictionary];
    SHBDataSet *item = [SHBDataSet dictionary];
    SHBDataSet *vectorSet = [SHBDataSet dictionary];
    while ((key = [enumerator nextObject]))
    {
        //NSLog(@"aaaa:%@",key);
        NSRange range;
        range = [key rangeOfString:@"vector"];
        
        if (range.location == NSNotFound)
        {
            //NSLog(@"key:%@",key);
            //NSLog(@"value:%@",[aDataSet objectForKey:key]);
            [item setValue:[aDataSet objectForKey:key] forKey:key];
        } else
        {
            [vectorSet insertObject:[aDataSet objectForKey:key] forKey:key atIndex:j];
            j++;
        }
    }
    
    //NSLog(@"item:%@",item);
    //NSLog(@"vectorSet:%@",vectorSet);
    //NSLog(@"aDataSet.serviceCode:%@",aDataSet.serviceCode);
    
    NSMutableString *rootElement = [NSMutableString string];
    
    
    [rootElement appendFormat:@"<vector result=\"%i\" task=\"%@\" action=\"%@\">",[vectorSet count], [aDataSet objectForKey:TASK_NAME_KEY], [aDataSet objectForKey:TASK_ACTION_KEY]];
    
    //    //전자 서명일경우
    //    if (self.eSign == YES) {
    //        [rootElement appendFormat:@"useSign=\"%@\" ", @"true"];
    //    }
    
    
    if ([aDataSet objectForKey:@"attributeNamed"] == nil)
    {
        
        //NSString *title = aDataSet.vectorTitle;
        //title = [title str
        
        for (int i = 0; i < [vectorSet count]; i++) {
            NSString *tmp = [[[NSString alloc] initWithFormat:@"vector%i",i ] autorelease];
            
            [rootElement appendFormat:@"<data vectorkey=\"%i\">",i];
            [rootElement appendFormat:@"<%@>",aDataSet.serviceTaskCode];
            
            SHBDataSet *tmpSet = [[[SHBDataSet alloc] initWithDictionary:[vectorSet objectForKey:tmp]] autorelease];
            
            [rootElement appendFormat:@"%@", [self stringForDataSet:tmpSet]];
            
            [rootElement appendFormat:@"</%@>",aDataSet.serviceTaskCode];
            [rootElement appendFormat:@"</data>"];
        }
        [rootElement appendFormat:@"</vector>"];
        //[rootElement appendFormat:@"</%@>",aDataSet.vectorTitle];
        
    }
    
    
    //[rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/>",SHB_DEVICE_TYPE];
    //[rootElement appendFormat:@"</%@>", targetServer];
    
    return rootElement;
}
// 리퀘스트 전문 생성.
- (NSString *)genRequestTR:(NSMutableDictionary *)dict
{
    if (dict == nil)
        return nil;
    
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // !!!: iOS6에서 [[UIDevice currentDevice] uniqueIdentifier] deprecated.
    NSMutableString *rootElement = [NSMutableString string];
    //[rootElement appendFormat:@"<Request><X value=\"0.0\" /><Y value=\"0.0\" /><UDID value=\"%@\" />", [[UIDevice currentDevice] uniqueIdentifier]];
    [rootElement appendFormat:@"<Request><X value=\"0.0\" /><Y value=\"0.0\" /><UDID value=\"%@\" />",AppInfo.openUDID];
    
    [rootElement appendFormat:@"%@", [self genElentntsWithDictionary:dict]];
    [rootElement appendFormat:@"<VERSION value=\"%@\"/>",versionNumber];
    [rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/></Request>", SHB_DEVICE_TYPE];
    
    return rootElement;
}

// request 전문의 개별 엘리먼트 생성.
- (NSString *)genElement:(NSString *)key andValue:(NSString *)value
{
    NSString *element = [NSString stringWithFormat:@"<%@ value=\"%@\"/>", key, [self stringSafeForXML:value]];
    //NSString *element = [NSString stringWithFormat:@"<%@ value=\"%@\"/>", key, value];
    return element;
}

// request 전문의 MOBILE_CERT시 getSession 개별 엘리먼트 생성.
- (NSString *)genElement:(NSString *)key andGetSessionValue:(NSString *)value
{
    NSString *element = [NSString stringWithFormat:@"<%@ value=\"%@\"/>", key, [self stringSafeForXML:value]];
    //NSString *element = [NSString stringWithFormat:@"<%@ %@/>", key, value];
    return element;
}

// request 전문 생성.
- (NSString *)genElentntsWithDictionary:(NSMutableDictionary *)dict
{
    NSMutableString *elements = [NSMutableString string];
    
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject]))
    {
        if ([AppInfo.serviceCode isEqualToString:@"MOBILE_CERT"] && [[dict objectForKey:key] hasPrefix:@"getSession"]) {
            [elements appendString:[self genElement:key andGetSessionValue:[dict objectForKey:key]]];
        }
        else {
            [elements appendString:[self genElement:key andValue:[self stringSafeForXML:[dict objectForKey:key]]]];
            //[elements appendString:[self genElement:key andValue:[dict objectForKey:key]]];
        }
    }
    
    return elements;
}

//vector 방식 전문 처리
- (NSString *)genRequestVector:(SHBDataSet *)aDataSet
{
    //NSLog(@"count:%i",[aDataSet count]);
    //NSLog(@"aDataSet:%@",aDataSet);
    
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSEnumerator *enumerator = [aDataSet keyEnumerator];
    
    id key;
    int j = 0;
    //NSMutableDictionary *item = [NSMutableDictionary dictionary];
    SHBDataSet *item = [SHBDataSet dictionary];
    SHBDataSet *vectorSet = [SHBDataSet dictionary];
    while ((key = [enumerator nextObject]))
    {
        //NSLog(@"aaaa:%@",key);
        NSRange range;
        range = [key rangeOfString:@"vector"];
        
        if (range.location == NSNotFound)
        {
            //NSLog(@"key:%@",key);
            //NSLog(@"value:%@",[aDataSet objectForKey:key]);
            [item setValue:[aDataSet objectForKey:key] forKey:key];
        } else
        {
            [vectorSet insertObject:[aDataSet objectForKey:key] forKey:key atIndex:j];
            j++;
        }
    }
    
    //NSLog(@"item:%@",item);
    //NSLog(@"vectorSet:%@",vectorSet);
    //NSLog(@"aDataSet.serviceCode:%@",aDataSet.serviceCode);
    
    NSMutableString *rootElement = [NSMutableString string];
    NSString *targetServer = [NSString stringWithFormat:@"S_RIB%@", aDataSet.serviceCode];
    NSString *responseMessage = [NSString stringWithFormat:@"R_RIB%@", aDataSet.serviceCode];
    
    [rootElement appendFormat:@"<%@ ", targetServer];
    [rootElement appendFormat:@"requestMessage=\"%@\" ", targetServer];
    [rootElement appendFormat:@"responseMessage=\"%@\" ", responseMessage];
    
    //전자 서명일경우
    if (self.eSign == YES) {
        [rootElement appendFormat:@"useSign=\"%@\" ", @"true"];
    }
    
    
    if ([aDataSet objectForKey:@"attributeNamed"] == nil)
    {
        
        [rootElement appendFormat:@"serviceCode=\"%@\"> ", aDataSet.serviceCode];
        
        //NSString *title = aDataSet.vectorTitle;
        //title = [title str]
        [rootElement appendFormat:@"<데이타건수 target=\"%@\" value=\"%i\"/>",aDataSet.vectorTitle, [vectorSet count]];
        [rootElement appendFormat:@"<%@ value=\"S_RIB%@_1\">",aDataSet.vectorTitle, aDataSet.serviceCode];
        
        if ([item count] > 0)
        {
            [rootElement appendFormat:@"%@", [self stringForDataSet:item]];
        }
        [rootElement appendFormat:@"<vector result=\"%i\">",[vectorSet count]];
        
        for (int i = 0; i < [vectorSet count]; i++) {
            NSString *tmp = [[[NSString alloc] initWithFormat:@"vector%i",i ] autorelease];
            
            [rootElement appendFormat:@"<data vectorkey=\"%i\">",i];
            [rootElement appendFormat:@"<%@_1>",targetServer];
            
            SHBDataSet *tmpSet = [[[SHBDataSet alloc] initWithDictionary:[vectorSet objectForKey:tmp]] autorelease];
            
            [rootElement appendFormat:@"%@", [self stringForDataSet:tmpSet]];
            
            [rootElement appendFormat:@"</%@_1>",targetServer];
            [rootElement appendFormat:@"</data>"];
        }
        [rootElement appendFormat:@"</vector>"];
        [rootElement appendFormat:@"</%@>",aDataSet.vectorTitle];
        
    }
    
    [rootElement appendFormat:@"<VERSION value=\"%@\"/>",versionNumber];
    [rootElement appendFormat:@"<COM_SUBCHN_KBN value=\"%@\"/>",SHB_DEVICE_TYPE];
    [rootElement appendFormat:@"</%@>", targetServer];
    
    return rootElement;
    
}
//서버에서 받아 들이지 못하는 문자열 치환
- (NSString *)stringSafeForXML:(NSString *)elementValue
{
    if ([SHBUtility isFindString:elementValue find:@"<E2K_CHAR="] || [SHBUtility isFindString:elementValue find:@"<E2K_NUM="])
    {
        return elementValue;
    }
    
    if (elementValue == nil || [elementValue length] == 0)
    {
        
        elementValue = @"";
    }
    NSString *tmpStr;
    tmpStr = [elementValue stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        elementValue = @"";
    }
    /*
    NSMutableString *str = [NSMutableString stringWithString:elementValue];
    NSRange all = NSMakeRange (0, [str length]);
    [str replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:all];
    
    return str;
     */
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
    return elementValue;
}
@end
