//
//  SHBOverseasIPViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 3. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAttentionLabel.h"

/**
 보안센터 - 해외IP 차단신청
 해외IP 차단신청 안내 화면
 */

@interface SHBOverseasIPViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBAttentionLabel *IPLabel;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *registLabel;

@property (retain, nonatomic) IBOutlet UIScrollView *contentSV;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@end
