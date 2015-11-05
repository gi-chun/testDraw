//
//  SHBNewProductEventInfoViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 8. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBNewProductEventInfoViewController : SHBBaseViewController
{
    NSString *ollehAcc;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.
@end
