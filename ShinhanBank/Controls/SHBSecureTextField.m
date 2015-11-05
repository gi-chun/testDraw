//
//  SHBSecureTextField.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSecureTextField.h"
#import "SHBSecureTextFieldDelegate.h"

@implementation SHBSecureTextField

@synthesize defaultDelegate;
@synthesize targetViewController;
@synthesize maximum;
@synthesize keybordType;
@synthesize selfOriginY;

- (void)dealloc
{
    [defaultDelegate release], defaultDelegate = nil;
    [targetViewController release], targetViewController = nil;
    [super dealloc];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        self.secureTextEntry = YES;
        self.defaultDelegate = [SHBSecureTextFieldDelegate secureDelegate];
        self.delegate = defaultDelegate;
        defaultDelegate.parentTextField = self;
        defaultDelegate.targetViewController = self.targetViewController;
        defaultDelegate.preBtnEnable = YES;
        defaultDelegate.nextBtnEnable = YES;
        
        int leftCapWidth;
        UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
        float imageWidth = tmpImage.size.width;
        
        if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
            leftCapWidth = 0;
            
        } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
            leftCapWidth = ((imageWidth / 2) - 1);
            
        }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
            
            //leftCapWidth = ((self.bounds.size.width / 2) - 1);
            leftCapWidth = 3;
        }
        
        [self setBackground:[[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
        [self setDisabledBackground:[[UIImage imageNamed:@"textfeld_dim.png"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
        
        //self.layer.cornerRadius = 10;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.secureTextEntry = YES;
        self.defaultDelegate = [SHBSecureTextFieldDelegate secureDelegate];
        self.delegate = defaultDelegate;
        defaultDelegate.parentTextField = self;
        defaultDelegate.targetViewController = self.targetViewController;
        defaultDelegate.preBtnEnable = YES;
        defaultDelegate.nextBtnEnable = YES;
        
        int leftCapWidth;
        UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
        float imageWidth = tmpImage.size.width;
        
        if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
            leftCapWidth = 0;
            
        } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
            leftCapWidth = ((imageWidth / 2) - 1);
            
        }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
            
            //leftCapWidth = ((self.bounds.size.width / 2) - 1);
            leftCapWidth = 3;
        }
        
        [self setBackground:[[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
        [self setDisabledBackground:[[UIImage imageNamed:@"textfeld_dim.png"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
    }
    return self;
}

- (void)showKeyPadWitType:(SHBSecureTextFieldType)keyPadType
{
    
    switch (keyPadType)
    {
        case SHBSecureTextFieldTypeCharacter:
            //[AppInfo getNFilterPK]; //nfinterPK를 가져온다.
            self.keyboardType = 1;
            //ios7 + xcode5 대응
            //[self addTarget:defaultDelegate action:@selector(showKeypad) forControlEvents:UIControlEventEditingDidBegin];
            break;
            
        case SHBSecureTextFieldTypeNumber:
            //[AppInfo getNFilterPK]; //nfinterPK를 가져온다.
            self.keyboardType = 0;
            //ios7 + xcode5 대응
            //[self addTarget:defaultDelegate action:@selector(showKeypadForNum) forControlEvents:UIControlEventEditingDidBegin];
            break;
        default:
            break;
    }
}

- (void)showKeyPadWitType:(SHBSecureTextFieldType)keyPadType
                 delegate:(id<SHBSecureDelegate>)aDelegate
                   target:(SHBBaseViewController *)aTargetViewController
                  maximum:(int)aMaxium
{
    //    if (!AppInfo.isGetKeyNFilter)
    //    {
    //        [AppInfo loadPublicKeyForNFilter]; //nfinterPK를 가져온다.
    //    }
    
    
    [self showKeyPadWitType:keyPadType];
    self.defaultDelegate.delegate = aDelegate;
    self.defaultDelegate.targetViewController = aTargetViewController;
    self.maximum = aMaxium;
}

- (void)closeSecureKeyPad{
    AppInfo.isLandScapeKeyPadBolck = NO;
	[self.defaultDelegate closeKeyPad];
}

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next
{
    
    self.defaultDelegate.preBtnEnable = prev;
    self.defaultDelegate.nextBtnEnable = next;
    [self.defaultDelegate enableAccButtons:prev Next:next];
}
- (void)focusSetWithLoss:(BOOL)focus
{
    
}
//- (void)supportLandScape:(BOOL)isSupport
//{
//    AppInfo.isLandScapeKeyPadBolck = isSupport;
//}
@end
