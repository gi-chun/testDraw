//
//  SHBFolders.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFolders.h"
#import "SHBView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>


const CGFloat SHBFoldersTriangleWidth = 26.f;
const CGFloat SHBFoldersTriangleHeight = 12.f;
const CGFloat SHBFoldersHighlightOpacity = 0.35f;
const CGFloat SHBFoldersOpeningDuration = 0.2f;

@interface SHBFolderSplitView : UIControl
@property (nonatomic) CGPoint position;
@property (nonatomic, strong) CAShapeLayer *highlight;
@property (nonatomic, assign) BOOL showsNotch;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL openingUp;
@property (nonatomic, assign) BOOL darkensBackground;
- (void)setHighlightOpacity:(CGFloat)opacity withDuration:(CFTimeInterval)duration;
@end

@interface SHBFolders () {
    SHBFolders *_strongSelf;
}
- (SHBFolderSplitView *)buttonForRect:(CGRect)aRect
                               screen:(UIImage *)screen
                             position:(CGPoint)position
                                  top:(BOOL)isTop
                          transparent:(BOOL)isTransparent
                            openingUp:(BOOL)openingUp;

- (void)openFolderWithContentView:(UIView *)contentView
                         position:(CGPoint)position
                    containerView:(UIView *)containerView
                        openBlock:(SHBFoldersOpenBlock)openBlock
                       closeBlock:(SHBFoldersCloseBlock)closeBlock
                  completionBlock:(SHBFoldersCompletionBlock)completionBlock
                        direction:(SHBFoldersOpenDirection)direction;

@property (nonatomic, strong) SHBFolderSplitView *top;
@property (nonatomic, strong) SHBFolderSplitView *bottom;
@property (nonatomic, assign) CGPoint folderPoint;
@property (nonatomic, strong) UIView *contentViewContainer;
@end


@implementation SHBFolders

@synthesize top = _top;
@synthesize bottom = _bottom;
@synthesize position = _position;
@synthesize direction = _direction;
@synthesize folderPoint = _folderPoint;
@synthesize contentView = _contentView;
@synthesize completionBlock = _completionBlock;
@synthesize transparentPane = _transparentPane;
@synthesize containerView = _containerView;
@synthesize closeBlock = _closeBlock;
@synthesize openBlock = _openBlock;

+ (id)folder {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        // keep ourself around
        _strongSelf = self;
    }
    return self;
}

- (void)open {
    [self openFolderWithContentView:self.contentView
                           position:self.position
                      containerView:self.containerView
                          openBlock:self.openBlock
                         closeBlock:self.closeBlock
                    completionBlock:self.completionBlock
                          direction:self.direction];
}

+ (void)openFolderWithContentView:(UIView *)contentView
                         position:(CGPoint)position
                    containerView:(UIView *)containerView
                        openBlock:(SHBFoldersOpenBlock)openBlock
                       closeBlock:(SHBFoldersCloseBlock)closeBlock
                  completionBlock:(SHBFoldersCompletionBlock)completionBlock
                        direction:(SHBFoldersOpenDirection)direction {
    [[[self alloc] init] openFolderWithContentView:contentView
                                          position:position
                                     containerView:containerView
                                         openBlock:openBlock
                                        closeBlock:closeBlock
                                   completionBlock:completionBlock
                                         direction:direction];
}

- (void)openFolderWithContentView:(UIView *)contentView
                         position:(CGPoint)position
                    containerView:(UIView *)containerView
                        openBlock:(SHBFoldersOpenBlock)openBlock
                       closeBlock:(SHBFoldersCloseBlock)closeBlock
                  completionBlock:(SHBFoldersCompletionBlock)completionBlock
                        direction:(SHBFoldersOpenDirection)direction {
    NSAssert(contentView && containerView, @"Content or container views must not be nil.");
    
    UIImage *screenshot = [containerView screenshot];
    
    self.contentView = contentView;
    self.openBlock = openBlock;
    self.closeBlock = closeBlock;
    self.completionBlock = completionBlock;
    self.direction = (direction > 0)?direction:SHBFoldersOpenDirectionUp;
    
    for (int i = 101; i < 110; i++)
    {
        [[self.contentView viewWithTag:i] setIsAccessibilityElement:YES];
    }
    
    BOOL up = (direction == SHBFoldersOpenDirectionUp);
    
    // I doubt this will help performance, because the content view itself
    // isn't the one being animated.
    CGFloat scale = [[UIScreen mainScreen] scale];
    contentView.layer.shouldRasterize = self.shouldRasterizeContent;
    contentView.layer.rasterizationScale = scale;
    
    CGFloat containerWidth = containerView.frame.size.width;
    CGFloat containerHeight = containerView.frame.size.height;
    
    CGRect upperRect = CGRectMake(0, 0, containerWidth, position.y);
    CGRect lowerRect = CGRectMake(0, position.y, containerWidth, containerHeight - position.y);
    
    self.top = [self buttonForRect:upperRect screen:screenshot position:position top:YES transparent:up ? NO : self.transparentPane openingUp:up];
    self.bottom = [self buttonForRect:lowerRect screen:screenshot position:position top:NO transparent:up ? self.transparentPane : NO openingUp:up];
    [self.top addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    
	self.contentViewContainer = [[[UIView alloc] initWithFrame:self.contentView.frame] autorelease];
    
    [containerView addSubview:self.contentViewContainer];
    [containerView addSubview:self.top];
    [containerView addSubview:self.bottom];
    
    CGRect contentFrame = self.contentView.frame;
    // depending on whether we're opening up or down, set the orign of the container to sit flush with the stationary view
    contentFrame.origin.y = (up) ? (containerHeight - contentFrame.size.height - (containerHeight - position.y)) : (position.y);
    
    if (self.showsNotch) {
        // if there is no background color, there's really nothing to
        // put in the notch (triangle) view. So, we should make sure we
        // have a color.
        NSAssert(self.contentBackgroundColor, @"contentBackgroundColor must not be nil");
        
        // the current limitation of this is that if the background isn't repeatable
        // there really is no way to customize how this is drawn. But for now,
        // it seems to be the most flexible way without knowing implementation details.
        self.contentView.backgroundColor = nil;
        self.contentViewContainer.backgroundColor = self.contentBackgroundColor;
        
        // make the content view container fill to fit the new dimensions
        // and draw all the way through the triangle.
        contentFrame.size.height += SHBFoldersTriangleHeight;
        contentFrame.origin.y -= up ? 0 : SHBFoldersTriangleHeight;
    }
    self.contentViewContainer.frame = contentFrame;
    
    
    // put the real content view into the stretched (if triangle enabled) container for the content view
    [self.contentViewContainer addSubview:self.contentView];
    
    
    // position the view correctly in the container view, offset the origin when direction requires it
    CGRect newContentFrame = self.contentView.frame;
    newContentFrame.origin = CGPointMake(0, self.showsNotch ? (up ? 0 : SHBFoldersTriangleHeight) : 0);
    self.contentView.frame = newContentFrame;
    
    CGFloat contentHeight = self.contentView.frame.size.height;
    self.folderPoint = (up) ? self.top.layer.position : self.bottom.layer.position;
    CGPoint toPoint = (CGPoint){ self.folderPoint.x, (up) ? (self.folderPoint.y - contentHeight) : (self.folderPoint.y + contentHeight)};
    
    if (self.shadowsEnabled) {
        // add the inner shadows using UIImageViews, which might seem heavy but in fact they're
        // rendered by the GPU, whereas a CALayer for instance is rendered by the CPU. We want
        // all the rendering speed we can get. Besides, the images will get cached for faster reloads.
        
        UIImage *topShadow = nil;
        UIImage *bottomShadow = nil;
        if (self.showsNotch) {
            topShadow = [UIImage imageNamed:up ? @"SHBFolders.bundle/shadow_top" : @"SHBFolders.bundle/shadow_top_notch"];
            bottomShadow = [UIImage imageNamed:up ? @"SHBFolders.bundle/shadow_low_notch" : @"SHBFolders.bundle/shadow_low"];
        } else {
            topShadow = [UIImage imageNamed:@"SHBFolders.bundle/shadow_top"];
            bottomShadow = [UIImage imageNamed:@"SHBFolders.bundle/shadow_low"];
        }
		
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentFrame.size.width, topShadow.size.height)];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentFrame.size.height - (bottomShadow.size.height),
                                                                                     contentFrame.size.width, bottomShadow.size.height)];
        topImageView.image = topShadow;
        bottomImageView.image = bottomShadow;
		bottomImageView.tag = 99999;
        //[self.contentViewContainer addSubview:topImageView];
        [self.contentViewContainer addSubview:bottomImageView];
        
        [topImageView release];
        [bottomImageView release];
    }
    
    // animate the sliding of the moveable pane upwards / downwards
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setValue:@"open" forKey:@"animationKey"];
    move.delegate = self;
    move.duration = SHBFoldersOpeningDuration;
    move.timingFunction = timingFunction;
    move.fromValue = [NSValue valueWithCGPoint:self.folderPoint];
    move.toValue = [NSValue valueWithCGPoint:toPoint];
    [up ? self.top.layer : self.bottom.layer addAnimation:move forKey:nil];
    
    if (openBlock) {
        openBlock(self.contentView, SHBFoldersOpeningDuration, timingFunction);
    }
    
    [(up) ? self.top.layer : self.bottom.layer setPosition:toPoint];
    
    // sets the highlight on the bottom / top of the panes to fade in / out for a convincing effect
    [self.top setHighlightOpacity:1.f withDuration:SHBFoldersOpeningDuration];
    [self.bottom setHighlightOpacity:1.f withDuration:SHBFoldersOpeningDuration];
}

- (void)performClose:(id)sender {
    BOOL up = (self.direction == SHBFoldersOpenDirectionUp);
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setValue:@"close" forKey:@"animationKey"];
    [move setDelegate:self];
    [move setTimingFunction:timingFunction];
    move.fromValue = [NSValue valueWithCGPoint:[[(up) ? self.top.layer : self.bottom.layer presentationLayer] position]];
    move.toValue = [NSValue valueWithCGPoint:_folderPoint];
    move.duration = SHBFoldersOpeningDuration;
    [up ? self.top.layer : self.bottom.layer addAnimation:move forKey:nil];
    if (self.closeBlock) self.closeBlock(self.contentView, SHBFoldersOpeningDuration, timingFunction);
    [(up) ? self.top.layer : self.bottom.layer setPosition:self.folderPoint];
    
    [self.top setHighlightOpacity:0.f withDuration:SHBFoldersOpeningDuration];
    [self.bottom setHighlightOpacity:0.f withDuration:SHBFoldersOpeningDuration];
	
    for (int i = 101; i < 110; i++)
    {
        [[self.contentView viewWithTag:i] setIsAccessibilityElement:NO];
    }
    
	// 상위 컨트롤에게 Close처리 전달
	if (self.delegate && [self.delegate respondsToSelector:@selector(closeFolders)]) {
        [self.delegate closeFolders];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationKey"] isEqualToString:@"close"]) {
        if (self.shouldRasterizeContent) {
            self.contentView.layer.shouldRasterize = NO;
        }
    }
    
    if ([[anim valueForKey:@"animationKey"] isEqualToString:@"close"]) {
        [self.top removeFromSuperview];
        [self.bottom removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self.contentViewContainer removeFromSuperview];
        
        if (self.completionBlock) {
            self.completionBlock();
        }
        
        _strongSelf = nil;
    }
}

- (SHBFolderSplitView *)buttonForRect:(CGRect)aRect
                               screen:(UIImage *)screen
                             position:(CGPoint)position
                                  top:(BOOL)isTop
                          transparent:(BOOL)isTransparent
                            openingUp:(BOOL)openingUp {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = aRect.size.width;
    CGFloat height = aRect.size.height;
    CGPoint origin = aRect.origin;
    
    CGRect scaledRect = CGRectMake(origin.x*scale, origin.y*scale, width*scale, height*scale);
    CGImageRef ref1 = CGImageCreateWithImageInRect([screen CGImage], scaledRect);
    
    SHBFolderSplitView *button = [[[SHBFolderSplitView alloc] initWithFrame:aRect] autorelease];
    button.top = isTop;
    button.position = position;
    button.layer.contents = isTransparent ? nil : (__bridge id)(ref1);
    button.layer.contentsGravity = kCAGravityCenter;
    button.layer.contentsScale = scale;
    button.highlight.opacity = 0.f;
    button.openingUp = openingUp;
    button.darkensBackground = self.darkensBackground;
    button.layer.shouldRasterize = (openingUp && !isTop) || (!openingUp && isTop);
    button.layer.rasterizationScale = screen.scale;
    button.showsNotch = self.showsNotch;
    CGImageRelease(ref1);
    
    return button;
}

- (void)closeCurrentFolder {
    [self performClose:self];
}

- (void)resizeContentsView:(float)height{
	
	self.contentViewContainer.frame = CGRectMake(self.contentViewContainer.frame.origin.x, self.contentViewContainer.frame.origin.y, self.contentViewContainer.frame.size.width, self.contentViewContainer.frame.size.height - height);
	
	UIImageView *bottomBar = (UIImageView*)[self.contentViewContainer viewWithTag:99999];
	bottomBar.frame = CGRectMake(bottomBar.frame.origin.x, bottomBar.frame.origin.y - height, bottomBar.frame.size.width, bottomBar.frame.size.height);
	
	self.bottom.frame = CGRectMake(self.bottom.frame.origin.x, self.bottom.frame.origin.y - height, self.bottom.frame.size.width, self.bottom.frame.size.height);
}


@end

@implementation SHBFolderSplitView
@synthesize position = _position;
@synthesize highlight = _highlight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self createHighlightWithFrame:frame];
    
    return self;
}

- (void)createHighlightWithFrame:(CGRect)aFrame {
    CGRect frame = aFrame;
    frame.size.height = 1.f;
    
    _highlight = [CAShapeLayer layer];
    _highlight.frame = self.bounds;
    _highlight.strokeColor = [UIColor colorWithWhite:1.f alpha:SHBFoldersHighlightOpacity].CGColor;
    _highlight.fillColor = nil;
    [self.layer addSublayer:_highlight];
}

- (void)setShowsNotch:(BOOL)showsNotch {
    _showsNotch = showsNotch;
    
    if (showsNotch) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        maskLayer.path = [self maskPath].CGPath;
        maskLayer.frame = self.bounds;
        
        // This sets mask the layer to get the shape of the notch drawn correctly.
        // Setting the layer mask is *extremely* expensive, so we double check that
        // we're not setting this on a view that is being animated. Otherwise, we can
        // kiss our good FPS goodbye.
        if ((self.openingUp && !self.top) || (!self.openingUp && self.top)) {
            self.layer.mask = maskLayer;
        }
    }
    
    self.highlight.path = [self highlightPath].CGPath;
}

- (void)setDarkensBackground:(BOOL)darkensBackground {
    _darkensBackground = darkensBackground;
    if (darkensBackground) {
        self.highlight.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    }
}

- (void)setHighlightOpacity:(CGFloat)opacity withDuration:(CFTimeInterval)duration {
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    if (opacity == 0.f) { // going to 0
        opacityAnimation.values = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:1.f],
                                   [NSNumber numberWithFloat:1.f],
                                   [NSNumber numberWithFloat:0.f], nil];
        opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.7f],
                                     [NSNumber numberWithFloat:1.f], nil];
    } else { // going to 1
        opacityAnimation.values = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.f],
                                   [NSNumber numberWithFloat:1.f],
                                   [NSNumber numberWithFloat:1.f], nil];
        opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.3f],
                                     [NSNumber numberWithFloat:1.f], nil];
    }
    opacityAnimation.duration = duration;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    [self.highlight addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (UIBezierPath *)maskPath {
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    
    [maskPath moveToPoint:CGPointZero];
    if (self.showsNotch && self.openingUp && !self.top) {
        [maskPath addLineToPoint:CGPointMake(self.position.x - (SHBFoldersTriangleWidth / 2), 0)];
        [maskPath addLineToPoint:CGPointMake(self.position.x, SHBFoldersTriangleHeight)];
        [maskPath addLineToPoint:CGPointMake(self.position.x + (SHBFoldersTriangleWidth / 2), 0)];
    }
    [maskPath addLineToPoint:CGPointMake(width, 0)];
    [maskPath addLineToPoint:CGPointMake(width, height)];
    if (self.showsNotch && !self.openingUp && self.top) {
        [maskPath addLineToPoint:CGPointMake(self.position.x + (SHBFoldersTriangleWidth / 2), height)];
        [maskPath addLineToPoint:CGPointMake(self.position.x, height - SHBFoldersTriangleHeight)];
        [maskPath addLineToPoint:CGPointMake(self.position.x - (SHBFoldersTriangleWidth / 2), height)];
    }
    [maskPath addLineToPoint:CGPointMake(0, height)];
    [maskPath addLineToPoint:CGPointZero];
    [maskPath closePath];
    return maskPath;
}

- (UIBezierPath *)highlightPath {
    UIBezierPath *highlightPath = [UIBezierPath bezierPath];
    
    CGSize size = self.bounds.size;
    [highlightPath moveToPoint:self.top ? CGPointMake(0, size.height - 0.5) : CGPointMake(0, 0.5)];
    
    if (self.showsNotch && self.openingUp && !self.top) {
        [highlightPath addLineToPoint:CGPointMake(self.position.x - (SHBFoldersTriangleWidth / 2), 0.5)];
        [highlightPath addLineToPoint:CGPointMake(self.position.x, SHBFoldersTriangleHeight + 0.5)];
        [highlightPath addLineToPoint:CGPointMake(self.position.x + (SHBFoldersTriangleWidth / 2), 0.5)];
    } else if (self.showsNotch && !self.openingUp && self.top) {
        [highlightPath addLineToPoint:CGPointMake(self.position.x - (SHBFoldersTriangleWidth / 2), size.height - 0.5)];
        [highlightPath addLineToPoint:CGPointMake(self.position.x, size.height - SHBFoldersTriangleHeight - 0.5)];
        [highlightPath addLineToPoint:CGPointMake(self.position.x + (SHBFoldersTriangleWidth / 2), size.height - 0.5)];
    }
    
    [highlightPath addLineToPoint:self.top ? CGPointMake(size.width, size.height - 0.5) : CGPointMake(size.width, 0.5)];
    [highlightPath closePath];
    
    return highlightPath;
}

@end

