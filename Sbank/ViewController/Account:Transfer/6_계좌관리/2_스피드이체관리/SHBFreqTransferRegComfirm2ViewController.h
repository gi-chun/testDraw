//
//  SHBFreqTransferRegComfirm2ViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBFreqTransferRegComfirm2ViewController : SHBBaseViewController
{
    id pViewController;
    SEL pSelector;
}
@property (assign, nonatomic) id pViewController;
@property (assign, nonatomic) SEL pSelector;
@property (retain, nonatomic) IBOutlet SHBTextField *txtNickName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
