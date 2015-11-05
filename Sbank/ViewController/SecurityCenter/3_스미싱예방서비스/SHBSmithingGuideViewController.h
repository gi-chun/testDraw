//
//  SHBSmithingGuideViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBIdentity4ViewController.h"

@interface SHBSmithingGuideViewController : SHBBaseViewController<SHBIdentity4Delegate>

@property (retain, nonatomic) IBOutlet UIView *mainView;

- (IBAction)buttonTouched:(id)sender;
@end
