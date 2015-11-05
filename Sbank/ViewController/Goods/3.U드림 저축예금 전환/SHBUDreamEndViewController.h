//
//  SHBUDreamEndViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBUDreamEndViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet SHBButton *btnFinish;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
