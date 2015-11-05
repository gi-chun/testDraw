//
//  SHBForexFavoritDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 자주쓰는 해외송금/조회
 자주쓰는 해외송금 상세 화면
 */

@interface SHBForexFavoritDetailViewController : SHBBaseViewController
<UIAlertViewDelegate>

@property (retain, nonatomic) OFDataSet *detailData;

@property (retain, nonatomic) IBOutlet UILabel *consignee; // 수취인
@property (retain, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *bankName; // 수취은행명
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@end
