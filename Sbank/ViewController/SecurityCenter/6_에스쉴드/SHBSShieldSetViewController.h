//
//  SHBSShieldSetViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
@interface SHBSShieldSetViewController : SHBBaseViewController

@property(retain, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, retain) IBOutlet SHBTextField *dayCntTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *nightCntTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *satCntTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *satNightCntTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *sunCntTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *sunNightCntTextField;

- (IBAction)cinfirmClick:(id)sender;
- (IBAction)cancelClick:(id)sender;
@end
