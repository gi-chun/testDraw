//
//  SHBLoanEndViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBLoanEndViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet SHBButton *btnConfirm;

/**
 사용자입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

@property (nonatomic, retain) NSDictionary *L1312;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
