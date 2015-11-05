//
//  SHBGiroTaxInputViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBPopupView.h"

@interface SHBGiroTaxInputViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBTextFieldDelegate>
{
    
    IBOutlet UITableView        *tableView1;
    IBOutlet UIView             *viewLine;          // 밑줄 가리는 view
    
    IBOutlet UIView             *helpView;          // 도움말 view
    
    IBOutlet SHBTextField       *textField1;        // 지로 번호 textField
    IBOutlet SHBTextField       *textField2;        // 전자 납부번호 textField
}

- (IBAction)buttonDidPush:(id)sender;

@end
