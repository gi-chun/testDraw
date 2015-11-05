//
//  SHBAutoTransferCancelCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAutoTransferCancelCompleteViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
