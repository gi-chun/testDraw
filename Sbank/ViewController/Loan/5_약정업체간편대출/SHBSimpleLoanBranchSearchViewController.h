//
//  SHBSimpleLoanBranchSearchViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 19..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

/**
 대출 - 약정업체 간편대출
 영업점조회 화면
 */

@protocol SHBSimpleLoanBranchSearchDelegate <NSObject>

- (void)simpleLoanBranchSearchSelectIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)data;

@end

@interface SHBSimpleLoanBranchSearchViewController : SHBBaseViewController
<UITextFieldDelegate, SHBTextFieldDelegate, UITableViewDelegate>

@property (assign, nonatomic) id<SHBSimpleLoanBranchSearchDelegate> delegate;

@property (retain, nonatomic) IBOutlet SHBTextField *branch;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
