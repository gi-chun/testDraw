//
//  SHBSimpleDistricTaxInputNoViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 11..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBSimpleDistricTaxInputNoViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>
{
    IBOutlet SHBTextField       *textField1;         // 간편납부번호 textField
}

// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

- (IBAction)buttonDidPush:(id)sender;

@end
