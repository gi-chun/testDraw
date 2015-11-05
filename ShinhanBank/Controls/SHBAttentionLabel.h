//
//  SHBAttentionLabel.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBAttentionLabel : UIView{
	
    NSMutableDictionary* dic;       // font + color array
    
    UIView* containerView;          // subviews <- labels
    
	int offsety;                    // 줄간격
}

@property (nonatomic, copy) UIImage* imageMarker;
@property (nonatomic, retain) NSMutableDictionary* dic;
@property (nonatomic, retain) NSString* text;

@property (nonatomic, retain) UIView* containerView;

@property (nonatomic) int offsety;

- (void)initFrame:(CGRect)frame;
-(void)defaultTag;
-(void)addTag:(NSString*)tag withFont:(UIFont*)font withColor:(UIColor*)color;
-(void)update;
-(void)layout;


@end
