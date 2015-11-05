//
//  SHBAttentionLabel.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAttentionLabel.h"

#define _TAG_IMAGE_VIEW_MARK        860001

@implementation SHBAttentionLabel

@synthesize imageMarker=_imageMarker;
@synthesize dic;
@synthesize text=_text;
@synthesize containerView;
@synthesize offsety;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        dic = [[NSMutableDictionary alloc] initWithCapacity:3];
		[self defaultTag];
		
		containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		containerView.backgroundColor = [UIColor clearColor];
		[self addSubview:containerView];
		
		offsety = 0;
    }
    
    return self;
}

- (void)initFrame:(CGRect)frame
{
    dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self defaultTag];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    
    offsety = 0;
}

-(void)dealloc{
    [containerView release];
    containerView = nil;
    [dic release];
    [super dealloc];
}



-(void)defaultTag{
	[self addTag:@"default" withFont:[UIFont systemFontOfSize:13.0f] withColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1]];
	
	[self addTag:@"darkGray_12" withFont:[UIFont systemFontOfSize:12.0f] withColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1]];
	
	[self addTag:@"midGray_13" withFont:[UIFont systemFontOfSize:13.0f] withColor:[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1]];
    [self addTag:@"midGray_12" withFont:[UIFont systemFontOfSize:12.0f] withColor:[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1]];
	
	[self addTag:@"lightGray_13" withFont:[UIFont systemFontOfSize:13.0f] withColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1]];
    [self addTag:@"lightGray_12" withFont:[UIFont systemFontOfSize:12.0f] withColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1]];
    
	[self addTag:@"midBlue_12" withFont:[UIFont systemFontOfSize:12.0f] withColor:[UIColor colorWithRed:40.0f/255.0f green:91.0f/255.0f blue:142.0f/255.0f alpha:1]];
	[self addTag:@"midBlue_13" withFont:[UIFont systemFontOfSize:13.0f] withColor:[UIColor colorWithRed:40.0f/255.0f green:91.0f/255.0f blue:142.0f/255.0f alpha:1]];
    
    [self addTag:@"midGray_15" withFont:[UIFont systemFontOfSize:15.0f] withColor:RGB(74, 74, 74)];
    [self addTag:@"midRed_15" withFont:[UIFont systemFontOfSize:15.0f] withColor:RGB(209, 75, 75)];
	
	[self addTag:@"midBoldGray_13" withFont:[UIFont boldSystemFontOfSize:13.0f] withColor:RGB(74, 74, 74)];
    [self addTag:@"midLightBlue_13" withFont:[UIFont systemFontOfSize:13.0f] withColor:RGB(0, 137, 220)];
	
	[self addTag:@"midBoldGray_15" withFont:[UIFont boldSystemFontOfSize:15.0f] withColor:RGB(74, 74, 74)];
    [self addTag:@"midLightBlue_15" withFont:[UIFont systemFontOfSize:15.0f] withColor:RGB(0, 137, 220)];
    
    [self addTag:@"default_15" withFont:[UIFont systemFontOfSize:15.0f] withColor:RGB(44, 44, 44)];
    
    [self addTag:@"midRed_13" withFont:[UIFont systemFontOfSize:13.0f] withColor:RGB(209, 75, 75)];
}


-(void)addTag:(NSString*)tag withFont:(UIFont*)font withColor:(UIColor*)color{
    
    NSArray* array = [[NSArray alloc] initWithObjects:font, color, nil];
    [dic setValue:array forKey:tag];
    [array release];
    
    [self update];
}

-(void)setImageMarker:(UIImage *)theImageMarker{
    _imageMarker = theImageMarker;
    
}

-(void)setText:(NSString *)theText{
    _text = theText;
    [self update];
}

-(void)addLabelWithText:(NSString*)str tag:(NSString*)tag{
    
    //tim(nodebug) NSLog(@"addLabelWithText %@\t%@", str, tag);
    
    
    if([tag isEqualToString:@"m"]){
        UIImage* image = [UIImage imageNamed:str];
        UIImageView* imageViewMark = [[UIImageView alloc] initWithImage:image];
		imageViewMark.tag = _TAG_IMAGE_VIEW_MARK;
		imageViewMark.contentMode = UIViewContentModeScaleToFill;
		imageViewMark.frame = CGRectMake(0, 0, image.size.width, image.size.height);
		[containerView addSubview:imageViewMark];
		[imageViewMark release];
    }else{
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        
        NSArray* array = [dic objectForKey:tag];
        if(!array){
            array = [dic objectForKey:@"default"];
        }
        label.text = str;
        label.font = [array objectAtIndex:0];
        label.textColor = [array objectAtIndex:1];
        
        [containerView addSubview:label];
        [label release];
    }
}


-(void)update{
    
    if(self.text == nil)
        return;
    
    for(UIView* v in containerView.subviews){
        [v removeFromSuperview];
    }
    
    BOOL isOutter = YES;
    
    const char* src = [self.text cStringUsingEncoding:NSUTF8StringEncoding];
    int length = strlen(src);
    
    char* tag = (char*)calloc(100, sizeof(char));
    char* buf = (char*)calloc(length, sizeof(char));
    
    for(;*src != '\0';src++){
        if(isOutter){
            switch(*src){
                case '\\':  //<,>값을 표시 할 경우가 생겨 추가.
                    src++;
                    strncat(buf, src, 1);
                    break;
                case '<':
                    src++;
                    isOutter = NO;
                    
                    if(strlen(buf) > 0)
                        [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:@"default"];
                    memset(buf, 0, length);
                    memset(tag, 0, 100);
                    while(*src != '>'){
                        strncat(tag, src, 1);
                        src++;
                    }
                    break;
                case '\n':
                    if(strlen(buf) > 0)
                        [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:@"default"];
                    
                    memset(buf, 0, length);
                    strncat(buf, src, 1);
                    [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:@"default"];
                    memset(buf, 0, length);
                    break;
                default:
                    strncat(buf, src, 1);
                    break;
            }
        }else{
            switch(*src){
                case '<':
                    if(strlen(buf) > 0)
                        [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:[NSString stringWithCString:tag encoding:NSUTF8StringEncoding]];
                    
                    memset(buf, 0, length);
                    memset(tag, 0, 100);
                    while(*src != '>'){
                        src++;
                    }
                    isOutter = YES;
                    break;
                case '\n':
                    if(strlen(tag) > 0)
                        [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:[NSString stringWithCString:tag encoding:NSUTF8StringEncoding]];
                    
                    memset(buf, 0, length);
                    strncat(buf, src, 1);
                    [self addLabelWithText:@"\n" tag:[NSString stringWithCString:tag encoding:NSUTF8StringEncoding]];
                    memset(buf, 0, length);
                    break;
                default:
                    strncat(buf, src, 1);
                    break;
            }
        }
    }
    
    if(strlen(buf) > 0){
        if(isOutter)
            [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:@"default"];
        else
            [self addLabelWithText:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] tag:[NSString stringWithCString:tag encoding:NSUTF8StringEncoding]];
    }
    free(tag);
    free(buf);
    
    [self layout];
    
}

-(void)layout{
    int thisX = 0;
    int thisY = 0; // + offsety;
    int height = 0;
    
    int indent = 0;
    
    for (int c = 0;c < containerView.subviews.count; c++) {
        
        id obj = [containerView.subviews objectAtIndex:c];
        
        if([obj isKindOfClass:[UIImageView class]]){
            UIImageView * imageView = (UIImageView *)obj;
            CGRect frame = imageView.frame;
            frame.origin.x = thisX;
            frame.origin.y = thisY + 2;
            imageView.frame = frame;
            thisX += imageView.frame.size.width + 3;
            indent = imageView.frame.size.width + 3;
        }else if([obj isKindOfClass:[UILabel class]]){
            UILabel * thisLabel = (UILabel *)obj;
            
            if(thisLabel.text == nil) continue;
            
            CGSize size = [thisLabel.text sizeWithFont:thisLabel.font
                                     constrainedToSize:CGSizeMake(9999, 9999)
                                         lineBreakMode:thisLabel.lineBreakMode];
            
            if([thisLabel.text isEqualToString:@"\n"]){
                thisX = 0;
                thisY += thisLabel.font.lineHeight + 7 + offsety;
                indent = 0;
            }else if(thisX + size.width < containerView.bounds.size.width){
                CGRect thisFrame = CGRectMake( thisX, thisY, size.width, size.height );
                thisLabel.frame = thisFrame;
                thisX += size.width;
            }else{
                
                NSString* text = thisLabel.text;
                
                int i = 0;
                for(i = text.length; i > 0; i--){
                    NSString* subtext = [text substringToIndex:i];
                    CGSize sizeSub = [subtext sizeWithFont:thisLabel.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:thisLabel.lineBreakMode];
                    if(thisX + sizeSub.width < containerView.bounds.size.width){
                        thisLabel.text = subtext;
                        thisLabel.frame = CGRectMake( thisX, thisY, sizeSub.width, sizeSub.height);
                        
                        thisX = indent;
                        
                        //tim(nodebug) NSLog(@"%f %f %f %f", thisLabel.font.ascender, thisLabel.font.capHeight, thisLabel.font.xHeight, thisLabel.font.lineHeight);
                        
                        thisY += thisLabel.font.lineHeight + offsety;
                        //height = thisY + sizeSub.height + 20;
                        
                        UILabel* labelCopy = [[UILabel alloc] initWithFrame:CGRectZero];
                        labelCopy.backgroundColor = [UIColor clearColor];
                        [containerView insertSubview:labelCopy atIndex:[containerView.subviews indexOfObject:thisLabel] + 1];
                        [labelCopy release];
                        labelCopy.font = thisLabel.font;
                        labelCopy.textColor = thisLabel.textColor;
                        labelCopy.text = [text substringFromIndex:i];
                        break;
                    }
                }
                
                if(i == 0){
                    thisX = indent;
                    thisY += thisLabel.font.lineHeight + offsety;
                    thisLabel.frame = CGRectMake( thisX, thisY, size.width, size.height);
                    
                    thisX += size.width;
                }
                
            }
            height = thisY + size.height + 20 + offsety;
			//            height = thisY + size.height + 10;
        }
    }
    
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

@end
