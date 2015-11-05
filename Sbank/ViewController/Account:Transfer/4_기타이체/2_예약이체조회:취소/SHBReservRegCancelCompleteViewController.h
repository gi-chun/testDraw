//
//  SHBReservRegCancelCompleteViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBReservRegCancelCompleteViewController : SHBBaseViewController
{
    NSDictionary *infoDic;
}
@property (retain, nonatomic) NSDictionary *infoDic;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
