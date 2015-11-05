//
//  SHBFreqTransferRegCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBFreqTransferRegCompleteViewController : SHBBaseViewController
{
    int nType;
}
@property (nonatomic        ) int nType;    // 0 : 등록, 1 : 변경
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblData;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
