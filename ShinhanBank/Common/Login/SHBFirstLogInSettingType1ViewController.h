//
//  SHBFirstLogInSettingType1ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"

@interface SHBFirstLogInSettingType1ViewController : SHBBaseViewController <SHBListPopupViewDelegate>

@property (nonatomic, retain) NSMutableArray *certList;

- (IBAction) confirmClick:(id)sender;
- (IBAction) cancelClick:(id)sender;

@end
