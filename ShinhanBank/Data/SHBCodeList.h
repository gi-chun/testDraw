//
//  SHBCodeList.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 01.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBCodeList : NSObject

@property (nonatomic, retain) NSMutableArray *bankList;
@property (nonatomic, retain) NSMutableDictionary *bankCode;
@property (nonatomic, retain) NSMutableDictionary *bankCodeReverse;
@property (nonatomic, retain) NSMutableArray *celebrationCode;
@property (nonatomic, retain) NSMutableArray *currencyList;
@property (nonatomic, retain) NSMutableArray *jibangCode;
@property (nonatomic, retain) NSMutableDictionary *jibangCodeReverse;
@property (nonatomic, retain) NSMutableDictionary *jibangGwamok;
@property (nonatomic, retain) NSMutableDictionary *jibangGwamokReverse;
@property (nonatomic, retain) NSMutableArray *nationList;
@property (nonatomic, retain) NSMutableArray *cardList;
@property (nonatomic, retain) NSMutableArray *creditCardList;

- (NSString *)bankNameFromCode:(NSString *)code;
@end
