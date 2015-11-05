//
//  SHBForexRequestInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 외화환전신청
 외화환전신청 안내 화면
 */

@interface SHBForexRequestInfoViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectCouponDic; // 선택한 쿠폰

@property (retain, nonatomic) IBOutlet UIView *sectionView; // 우대율 표 section
//@property (retain, nonatomic) IBOutlet UIWebView *infoWV;
@property (retain, nonatomic) IBOutlet SHBWebView *infoWV;

@end
