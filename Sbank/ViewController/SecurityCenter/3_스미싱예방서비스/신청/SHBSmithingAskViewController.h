//
//  SHBSmithingAskViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBIdentity4ViewController.h"

@interface SHBSmithingAskViewController : SHBBaseViewController<SHBIdentity4Delegate>

@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.

- (IBAction)buttonTouched:(id)sender;
@end
