//
//  SHBSelectBox.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

typedef enum
{
	SHBSelectBoxStateNormal,
	SHBSelectBoxStateSelected,
	SHBSelectBoxStateDisabled,
}SHBSelectBoxState;

#import <UIKit/UIKit.h>

@protocol SHBSelectBoxDelegate;


@interface SHBSelectBox : UIView

@property (nonatomic, assign) id<SHBSelectBoxDelegate> delegate;

@property (nonatomic, setter = setState:) SHBSelectBoxState state;

@property (nonatomic, retain, setter = setText:) NSString *text;

@end


@protocol SHBSelectBoxDelegate <NSObject>

@optional
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox;

@end