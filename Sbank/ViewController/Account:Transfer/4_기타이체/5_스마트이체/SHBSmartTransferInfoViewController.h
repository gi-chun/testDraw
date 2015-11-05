//
//  SHBSmartTransferInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 2..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBAttentionLabel.h"

/**
 조회/이체 - 기타이체 - 스마트 이체 조회/등록/변경
 스마트이체 안내
 */

@interface SHBSmartTransferInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBAttentionLabel *info1;
@property (retain, nonatomic) IBOutlet SHBButton *productInfoBtn;
@end
