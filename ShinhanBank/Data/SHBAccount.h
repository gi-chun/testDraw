//
//  SHBAccount.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBAccount : NSObject

@property (nonatomic, retain) NSString *accountNo;          // 계좌번호(신).
@property (nonatomic, retain) NSString *oldAccountNo;       // 구계좌번호.
@property (nonatomic, retain) NSString *bankCode;           // 은행코드.
@property (nonatomic, retain) NSString *depositType;        // 1:신한은행, 2:구 조흥, 3:구 신한
@property (nonatomic, retain) NSString *accountName;        // 계좌명.
@property (nonatomic, retain) NSString *issueDate;          // 신규일자.
@property (nonatomic, retain) NSString *balance;            // 계좌잔액.
@property (nonatomic, retain) NSString *availableBalance;   // 출금가능잔액.

@end
