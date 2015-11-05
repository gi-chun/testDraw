//
//  SHBMyMenuListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBMyMenuListCellDelegate <NSObject>
- (void) addItemToCart:(int)itemId itemSection:(int)section;
@end

@interface SHBMyMenuListCell : UITableViewCell
{
    id target;
	SEL openBtnSelector;
    int section;
    int row;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;
@property (nonatomic        ) int section;
@property (nonatomic        ) int row;
@property int itemId;

@property (nonatomic, retain) IBOutlet UILabel  *label2;        // 메뉴명
@property (retain, nonatomic) IBOutlet UIButton *btnOpen;

@property (assign) id<SHBMyMenuListCellDelegate> delegate;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
