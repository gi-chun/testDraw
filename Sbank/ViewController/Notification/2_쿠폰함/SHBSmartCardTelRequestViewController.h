//
//  SHBSmartCardTelRequestViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

@protocol SHBSmartCardTelRequestDelegate <NSObject>

- (void)smartCardTelRequestSuccess;
- (void)smartCardTelRequestBack;

@end
@interface SHBSmartCardTelRequestViewController : SHBBaseViewController <SHBTextFieldDelegate>


@property (assign, nonatomic) id<SHBSmartCardTelRequestDelegate> delegate;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *massegeView;
@property (retain, nonatomic) IBOutlet SHBTextField *textField1;
@property (retain, nonatomic) IBOutlet SHBTextField *textField2;
@property (retain, nonatomic) IBOutlet SHBTextField *textField3;
@property (retain, nonatomic) IBOutlet SHBTextField *textField4;
@property (retain, nonatomic) IBOutlet SHBTextField *textField5;
@property (retain, nonatomic) IBOutlet UITextView *contentTV;
@property (retain, nonatomic) IBOutlet UITextView *massegecontentTV;
@property (retain, nonatomic) IBOutlet UIView *toolBarView;
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel_1;
@property (retain, nonatomic) IBOutlet UILabel *partLabel;
@property (retain, nonatomic) IBOutlet UILabel *partLabel_1;
@property (retain, nonatomic) IBOutlet UIButton *prevBtn;
@end

