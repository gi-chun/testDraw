//
//  SHBCertIssueStep6ReViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertIssueStep6ReViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet SHBDataSet *transDataSet;
@property (nonatomic, assign) BOOL isFirstLoginSetting;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소

@end
