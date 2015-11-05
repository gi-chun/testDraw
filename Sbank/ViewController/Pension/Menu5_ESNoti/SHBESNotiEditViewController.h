//
//  SHBESNotiEditViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 26..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"


@interface SHBESNotiEditViewController : SHBBaseViewController <SHBTextFieldDelegate, UITextFieldDelegate>
{
    
    IBOutlet SHBTextField       *textFieldNumber1;          // 우편번호1
    IBOutlet SHBTextField       *textFieldNumber2;          // 우편번호2
    
    IBOutlet SHBTextField       *textFieldAddress1;         // 주소
    IBOutlet SHBTextField       *textFieldAddress2;         // 상세주소
    
    IBOutlet SHBTextField       *textFieldPhone1;           // 전화번호1
    IBOutlet SHBTextField       *textFieldPhone2;           // 전화번호2
    IBOutlet SHBTextField       *textFieldPhone3;           // 전화번호3
    
    IBOutlet SHBTextField       *textFieldCellNumber1;      // 휴대전화1
    IBOutlet SHBTextField       *textFieldCellNumber2;      // 휴대전화2
    IBOutlet SHBTextField       *textFieldCellNumber3;      // 휴대전화3
    
    IBOutlet SHBTextField       *textFieldEmail;            // 이메일
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;

@end
