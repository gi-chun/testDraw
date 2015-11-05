//
//  SHBSmithingFinishViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSmithingFinishViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UILabel* askDateLabel;
@property(nonatomic, retain) IBOutlet UILabel* askDate;
@property(nonatomic, retain) IBOutlet UILabel* phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* askType;
@property(nonatomic, retain) IBOutlet UILabel* mainMsg;
@property(nonatomic, retain) IBOutlet UILabel* subMsg;

@property(nonatomic, retain) IBOutlet UIButton *btn;
- (IBAction)buttonTouched:(id)sender;
@end
