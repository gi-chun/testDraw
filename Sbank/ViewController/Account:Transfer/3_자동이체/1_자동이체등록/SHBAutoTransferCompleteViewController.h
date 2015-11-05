//
//  SHBAutoTransferCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAutoTransferCompleteViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
