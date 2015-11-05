//
//  SHBCloseProductEndViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBCloseProductConfirmViewController.h"

@interface SHBCloseProductEndViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) SHBCloseProductConfirmViewController *confirmVC;
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;
/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSString *Close_type;

@end
