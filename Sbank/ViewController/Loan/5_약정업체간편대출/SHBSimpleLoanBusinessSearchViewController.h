//
//  SHBSimpleLoanBusinessSearchViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

/**
 대출 - 약정업체 간편대출
 약정업체 간편대출 가능업체 검색 화면
 */

@interface SHBSimpleLoanBusinessSearchViewController : SHBBaseViewController
<UITableViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBTextField *business;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@end
