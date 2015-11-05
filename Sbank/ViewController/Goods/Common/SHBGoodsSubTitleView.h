//
//  SHBGoodsSubTitleView.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBGoodsSubTitleView : UIView

@property (nonatomic, retain) NSMutableArray *marrSteps;

- (id)initWithTitle:(NSString *)title maxStep:(NSUInteger)maxStep;
- (id)initWithTitle:(NSString *)title maxStep:(NSUInteger)maxStep focusStepNumber:(NSUInteger)focusStep;
- (void)setFocusStepNumber:(NSUInteger)num;

@end
