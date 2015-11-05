//
//  SHBSmartCareTelRequestViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

@protocol SHBSmartCareTelRequestDelegate <NSObject>

- (void)smartCareTelRequestSuccess;
- (void)smartCareTelRequestBack;

@end

@interface SHBSmartCareTelRequestViewController : SHBBaseViewController <SHBTextFieldDelegate>

@property (assign, nonatomic) id<SHBSmartCareTelRequestDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *textField1;
@property (retain, nonatomic) IBOutlet SHBTextField *textField2;
@property (retain, nonatomic) IBOutlet SHBTextField *textField3;
@property (retain, nonatomic) IBOutlet SHBTextField *textField4;
@property (retain, nonatomic) IBOutlet UITextView *contentTV;
@property (retain, nonatomic) IBOutlet UIView *toolBarView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@end
