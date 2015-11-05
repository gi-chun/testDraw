//
//  SHBSMSEditViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBSMSEditViewController : SHBBaseViewController<SHBTextFieldDelegate>
{
    id pViewController;
    SEL pSelector;
}
@property (assign, nonatomic) id pViewController;
@property (assign, nonatomic) SEL pSelector;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSenderName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
