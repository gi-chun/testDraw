//
//  SHBSmartTransferAddCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBAttentionLabel.h"

/**
 조회/이체 - 기타이체 - 스마트 이체 조회/등록/변경
 조회/등록/변경 완료
 */

@interface SHBSmartTransferAddCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *view1;
@property (retain, nonatomic) IBOutlet UIView *view2;
@property (retain, nonatomic) IBOutlet UIView *view3;
@property (retain, nonatomic) IBOutlet UIView *view4;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *info;
@end
