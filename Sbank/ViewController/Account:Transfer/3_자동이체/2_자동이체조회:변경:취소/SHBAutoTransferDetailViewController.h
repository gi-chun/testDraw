//
//  SHBAutoTransferDetailViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBAutoTransferDetailViewController : SHBBaseViewController
{
    int nType; // 0: 정상 9:해지
    NSString *strAccNo;
}
@property (nonatomic        ) int nType;
@property (nonatomic, retain) NSString *strAccNo;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccInfo;
@property (retain, nonatomic) IBOutlet UIView *changeView;
@property (retain, nonatomic) IBOutlet UIView *comfirmView;
@property (retain, nonatomic) IBOutlet UIView *infoView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
