//
//  SHBSmithingSecureMediaViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBSecretCardViewController.h"
@interface SHBSmithingSecureMediaViewController : SHBBaseViewController<SHBSecretCardDelegate>

@property(nonatomic, assign) int deviceIndex;
@end
