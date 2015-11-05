//
//  SHBButton.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBButton.h"

@implementation SHBButton


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
		
    // Drawing code
    int leftCapWidth;
    UIImage *tmpImage = [self backgroundImageForState:UIControlStateNormal];
    float imageWidth = tmpImage.size.width;
    
    if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        leftCapWidth = ((self.bounds.size.width / 2) - 1);
    }
    [self setBackgroundImage:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]forState:UIControlStateNormal];
    
    tmpImage = [self backgroundImageForState:UIControlStateHighlighted];
    
    imageWidth = tmpImage.size.width;
    
    if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        leftCapWidth = ((self.bounds.size.width / 2) - 1);
    }
    [self setBackgroundImage:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]forState:UIControlStateHighlighted];
    
    tmpImage = [self backgroundImageForState:UIControlStateDisabled];
    
    imageWidth = tmpImage.size.width;
    
    if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        leftCapWidth = ((self.bounds.size.width / 2) - 1);
    }
    [self setBackgroundImage:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]forState:UIControlStateDisabled];
    
    tmpImage = [self backgroundImageForState:UIControlStateSelected];
    
    imageWidth = tmpImage.size.width;
    
    if (self.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (self.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        leftCapWidth = ((self.bounds.size.width / 2) - 1);
    }
    [self setBackgroundImage:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]forState:UIControlStateSelected];
}


- (void) dealloc
{

    [super dealloc];
}

@end
