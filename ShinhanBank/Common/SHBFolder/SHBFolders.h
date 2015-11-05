//
//  SHBFolders.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBFoldersDelegate.h"

@class CAMediaTimingFunction;

typedef void (^SHBFoldersCompletionBlock)(void);
typedef void (^SHBFoldersCloseBlock)(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);
typedef void (^SHBFoldersOpenBlock)(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);

enum SHBFoldersOpenDirection {
    SHBFoldersOpenDirectionUp = 1,
    SHBFoldersOpenDirectionDown = 2
};
typedef NSInteger SHBFoldersOpenDirection;

@interface SHBFolders : NSObject{
	id <SHBFoldersDelegate> delegate;
}

/* Designated convenience initializer */
+ (id)folder;

/**
 The view to be know close folder
*/
@property (nonatomic, assign) id/*<SHBFoldersDelegate>*/ delegate;


/* The view to be embedded between
 * two folder-style panels.
 *
 * REQUIRED */
@property (nonatomic, strong) UIView *contentView;


/* This is the view in which you wish the folders to be
 * added as a subview of. Behaviour when the container
 * view is smaller than the content view is undefined.
 *
 * REQUIRED */
@property (nonatomic, strong) UIView *containerView;


/* The position is used to determine where the folders should
 * be opened.  In later updates the x-coordinate will be used
 * to create a "notch", similar to the iOS Springboard. The
 * position should be relative to the container view.
 *
 * REQUIRED */
@property (nonatomic, readwrite) CGPoint position;


/* Set the direction for the slide.
 * Default is SHBFoldersOpenDirectionUp. */
@property (nonatomic, readwrite) SHBFoldersOpenDirection direction;


/* Sets whether a triangle is drawn pointing toward the
 * opening position. NB: The background of the content view
 * must be repeatable. Defaults to NO. */
@property (nonatomic, assign) BOOL showsNotch;


/* Sets whether the upper and lower panes have a darkened
 * effect applied to them when animating to the open position.
 * This could help to offset your content from the surrounding views.
 * Defaults to NO. */
@property (nonatomic, assign) BOOL darkensBackground;


/* Sets the background color of the content view
 * and the notch. Only used if showsTriangle is
 * set to YES. Defaults to nil. */
@property (nonatomic, strong) UIColor *contentBackgroundColor;


/* Sets whether the stationary folder pane should
 * be transparent to show actual content underneath.
 * The pane will still absorb touches, so your content
 * will not recieve touch events. Defaults to NO. */
@property (nonatomic, assign) BOOL transparentPane;


/* Sets whether the panes cast shadows over the content view.
 * The moving pane will have a shadow with a constant position
 * for performance reasons. Defaults to NO; */
@property (nonatomic, assign) BOOL shadowsEnabled;


/* Experimental setting that sets the shouldRasterize property
 * on the content view's layer. Defaults to NO. */
@property (nonatomic, assign) BOOL shouldRasterizeContent;


/* The following blocks are called at specific
 * times during the lifetime of the folder.
 *
 * The open & close blocks are called immediately before
 * the folder is about to open or close, respectively.
 *
 * The completion block is called when all views
 * have been removed, and the folder is completely closed. */
@property (nonatomic, copy) SHBFoldersOpenBlock openBlock;
@property (nonatomic, copy) SHBFoldersCloseBlock closeBlock;
@property (nonatomic, copy) SHBFoldersCompletionBlock completionBlock;


/* Opens the folder. Be sure the required properties are set! */
- (void)open;

/* Closes the currently open folder. */
- (void)closeCurrentFolder;

/* Resize contents view*/
- (void)resizeContentsView:(float)height;


#pragma mark -
#pragma mark Deprecated methods

/* Deprecated in favor of using properties. */
+ (void)openFolderWithContentView:(UIView *)contentView
position:(CGPoint)position
containerView:(UIView *)containerView
openBlock:(SHBFoldersOpenBlock)openBlock
closeBlock:(SHBFoldersCloseBlock)closeBlock
completionBlock:(SHBFoldersCompletionBlock)completionBlock
direction:(SHBFoldersOpenDirection)direction __attribute__((deprecated));

@end