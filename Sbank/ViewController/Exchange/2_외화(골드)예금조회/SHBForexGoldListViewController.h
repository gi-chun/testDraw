//
//  SHBForexGoldListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 외화골드예금조회
 외화골드 계좌목록 화면
 */

#define FOREX_180 @"180" // 외화체인지업예금
#define FOREX_182 @"182" // 외화정기예금, 민트리볼빙외화예금, 민트Libor연동외화예금
#define FOREX_185 @"185" // Multiple외화정기예금
#define FOREX_184 @"184" // Tops외화적립예금
#define FOREX_181 @"181" // 외화당좌예금
#define FOREX_327 @"327" // 외화당좌예금
#define GOLD_186 @"186" // 신한골드리슈금적립
#define GOLD_187 @"187" // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 @"188" // 달러&골드테크통장

@interface SHBForexGoldListViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable; // 계좌목록

- (void)refresh;
@end                                          
