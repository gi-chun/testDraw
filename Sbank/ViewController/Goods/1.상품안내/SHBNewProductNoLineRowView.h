//
//  SHBNewProductNoLineRowView.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNewProductNoLineRowView : UIView

@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblValue;
@property (nonatomic, retain) UIView *lblView;

- (id)initWithYOffset:(CGFloat)yOffset title:(NSString *)title value:(NSString *)value;
- (id)initWithYOffset:(CGFloat)yOffset title:(NSString *)title value:(NSString *)value isTicker:(BOOL)isTicker;
- (id)initWithYOffset:(CGFloat)yOffset;

@end
