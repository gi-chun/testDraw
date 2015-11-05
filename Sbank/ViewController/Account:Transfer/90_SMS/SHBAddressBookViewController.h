//
//  SHBAddressBookViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAddressBookViewController : SHBBaseViewController
{
    id pViewController;
    SEL pSelector;
}
@property (assign, nonatomic) id pViewController;
@property (assign, nonatomic) SEL pSelector;
@end
