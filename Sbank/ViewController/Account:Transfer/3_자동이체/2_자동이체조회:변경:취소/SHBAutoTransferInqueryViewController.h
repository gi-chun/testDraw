//
//  SHBAutoTransferInqueryViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"
@interface SHBAutoTransferInqueryViewController : SHBBaseViewController<SHBListPopupViewDelegate>
{
    NSDictionary *outAccInfoDic;
}
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
