//
//  SHBAutoTransferComfirmViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAutoTransferComfirmViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;

@end
