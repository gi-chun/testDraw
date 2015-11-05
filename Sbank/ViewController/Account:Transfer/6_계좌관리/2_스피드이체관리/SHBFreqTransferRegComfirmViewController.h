//
//  SHBFreqTransferRegComfirmViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBFreqTransferRegComfirmViewController : SHBBaseViewController
{
    int nType;
    SHBAccountService *service;
}
@property (nonatomic        ) int nType;    // 0 : 등록, 1 : 변경
@property (nonatomic, retain) SHBAccountService *service;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
