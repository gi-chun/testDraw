//
//  SHBForexRequestDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 환전신청내역조회
 환전신청내역상세 화면
 */

@interface SHBForexRequestDetailViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *detailData;

@end
