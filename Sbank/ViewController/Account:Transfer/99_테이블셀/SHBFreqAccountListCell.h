//
//  SHBFreqAccountListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBFreqAccountListCell : UITableViewCell
{
    id target;
	SEL openBtnSelector;
    
    int row;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;

@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIButton *btnOpen;

@end
