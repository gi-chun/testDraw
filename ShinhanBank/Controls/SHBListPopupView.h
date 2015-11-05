//
//  SHBListPopupView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 24..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBListPopupViewDelegate;

@interface SHBListPopupView : UIView <UITableViewDataSource, UITableViewDelegate>
{
	UITableView		*_tableView;
	NSMutableArray	*_options;
	NSMutableArray	*_dispOptions;
	NSString	*_cellNibName;
	float _cellLblCount;
	float _cellHeight;
	
}

@property (nonatomic, assign) id<SHBListPopupViewDelegate> delegate;

- (id)initWithTitle:(NSString *)aTitle options:(NSMutableArray *)aOptions CellNib:(NSString*)cellNib CellH:(float)cellH CellDispCnt:(float)cellDispCnt CellOptCnt:(float)cellOptCnt;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)closePopupViewWithButton:(UIButton*)sender;
- (void)reloadTableViewWithIndex:(NSInteger)index;

@end

@protocol SHBListPopupViewDelegate <NSObject>
@optional
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex;
- (void)listPopupViewDidCancel;
@end