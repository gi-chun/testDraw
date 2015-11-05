//
//  SHBTickerView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTickerView.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBTickerViewController.h"

@interface SHBTickerView ()

@property (retain, nonatomic) UIView *curView;
@property (retain, nonatomic) UIView *nextView;

@end


@implementation SHBTickerView

@synthesize isSlideText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    
    self.curView = nil;
    self.nextView = nil;
    
    [title1View release];
    [title2View release];
    [title3View release];
    [title4View release];
    [title5View release];
    [title1Label release];
    [title2Label release];
    [title3Label release];
    [title4Label release];
    [title5Label release];
    [_voiceOverBtn release];
    
    [super dealloc];
}


- (void)titleRolling
{
    showTitleNum++;
    
    if(showTitleNum > arrayCount) {
        showTitleNum = 1;
    }
    
    CGFloat defaultY = self.frame.size.height + 5;
    
    if (showTitleNum == arrayCount) {
        self.nextView = title1View;
    }
    else {
        switch (showTitleNum) {
            case 1:
                self.nextView = title2View;
                break;
            case 2:
                self.nextView = title3View;
                break;
            case 3:
                self.nextView = title4View;
                break;
            case 4:
                self.nextView = title5View;
                break;
            case 5:
                self.nextView = title1View;
                break;
            default:
                break;
        }
    }
    
    self.nextView.frame = CGRectMake(0, defaultY, self.frame.size.width, self.frame.size.height);
    [self.nextView setHidden:NO];
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self.voiceOverBtn setHidden:NO];
        
        NSDictionary *nDic = [tickerArray objectAtIndex:(showTitleNum == arrayCount) ? 0 : showTitleNum];
        NSString *title = [nDic objectForKey:@"티커제목"];
        
        [self.voiceOverBtn setAccessibilityLabel:title];
        [self.voiceOverBtn setTag:self.curView.tag];
    }
    else {
        [self.voiceOverBtn setHidden:YES];
    }
    
    [UIView animateWithDuration:1
                     animations:^{
                         self.curView.frame = CGRectMake(0, defaultY * -1, self.frame.size.width, self.frame.size.height);
                         self.nextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
//                         [self.curView setHidden:YES];
                     }];
    
    self.curView = self.nextView;
}

- (void)executeWithData:(NSArray*)arrData{
    SafeRelease(tickerArray);
    tickerArray = [[NSMutableArray alloc] initWithArray:arrData];
    arrayCount = [tickerArray count];
    
    if (arrayCount > 5) arrayCount = 5;
    
    if (arrayCount > 0) {
        showTitleNum = 0;
    } else {
        return;
    }
    
    title1View.hidden = NO;
    title2View.hidden = NO;
    title3View.hidden = NO;
    title4View.hidden = NO;
    title5View.hidden = NO;
    
    self.curView = title1View;
    self.curView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self.voiceOverBtn setHidden:NO];
        
        NSDictionary *nDic = [tickerArray objectAtIndex:showTitleNum];
        NSString *title = [nDic objectForKey:@"티커제목"];
        
        [self.voiceOverBtn setAccessibilityLabel:title];
    }
    else {
        [self.voiceOverBtn setHidden:YES];
    }
    
    if (arrayCount != 1) {
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(titleRolling) userInfo:nil repeats:YES];
    }
}

- (void)executeWithData2:(NSArray*)arrData{
    SafeRelease(tickerArray);
    tickerArray = [[NSMutableArray alloc] initWithArray:arrData];
    arrayCount = [tickerArray count];
    if (arrayCount > 5) arrayCount = 5;
    if (arrayCount > 0){
        showTitleNum = 0;
    }else{
        return;
    }
    title1View.hidden = YES;
    title2View.hidden = YES;
    title3View.hidden = YES;
    title4View.hidden = YES;
    title5View.hidden = YES;
    for (int i = 0; i < arrayCount; i++) {
        // NSDictionary *nDic = [[tickerArray objectAtIndex:i] objectForKey:@"Ticker"];
        // NSString *title = [nDic objectForKey:@"티커제목"];
        NSString *title = [tickerArray objectAtIndex:i];
        CGSize labelSize = [title sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        switch (i) {
            case 0:
                if (isSlideText && title1View.frame.size.width < labelSize.width){
                    title1Width  = labelSize.width;
                    title1Label.frame = CGRectMake(0, 0, labelSize.width, title1Label.frame.size.height);
                    title1View.frame  = CGRectMake(0, 0, labelSize.width, title1View.frame.size.height);
                }else{
                    title1Width  = title1View.frame.size.width;
                }
                //title1Label.text = title;
                break;
            case 1:
                if (isSlideText && title2View.frame.size.width < labelSize.width){
                    title2Width = labelSize.width;
                    title2Label.frame = CGRectMake(0, 0, labelSize.width, title2Label.frame.size.height);
                    title2View.frame  = CGRectMake(0, 0, labelSize.width, title2View.frame.size.height);
                }else{
                    title2Width = title2View.frame.size.width;
                }
                //title2Label.text = title;
                break;
            case 2:
                if (isSlideText && title3Label.frame.size.width < labelSize.width){
                    title3Width = labelSize.width;
                    title3Label.frame = CGRectMake(0, 0, labelSize.width, title3Label.frame.size.height);
                    title3View.frame  = CGRectMake(0, 0, labelSize.width, title3View.frame.size.height);
                }else{
                    title3Width = title3View.frame.size.width;
                }
                //title3Label.text = title;
                break;
            case 3:
                if (isSlideText && title4Label.frame.size.width < labelSize.width){
                    title4Width = labelSize.width;
                    title4Label.frame = CGRectMake(0, 0, labelSize.width, title4Label.frame.size.height);
                    title4View.frame  = CGRectMake(0, 0, labelSize.width, title4View.frame.size.height);
                }else{
                    title4Width = title4View.frame.size.width;
                }
                //title4Label.text = title;
                break;
            case 4:
                if (isSlideText && title5Label.frame.size.width < labelSize.width){
                    title5Width = labelSize.width;
                    title5Label.frame = CGRectMake(0, 0, labelSize.width, title5Label.frame.size.height);
                    title5View.frame  = CGRectMake(0, 0, labelSize.width, title5View.frame.size.height);
                }else{
                    title5Width = title5View.frame.size.width;
                }
                //title5Label.text = title;
                break;
            default:
                break;
        }
    }
    [self titleRolling];
    if (isSlideText){
        [NSTimer scheduledTimerWithTimeInterval:15.5f target:self selector:@selector(titleRolling) userInfo:nil repeats:YES];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(titleRolling) userInfo:nil repeats:YES];
    }
    
}

- (IBAction)buttonPressed:(UIButton*)sender{
    // 티커 선택시
    NSDictionary *nDic = [tickerArray objectAtIndex:showTitleNum - 1];
    if ([nDic objectForKey:@"티커Url"]){
        // SHBWebViewConfirmViewController *webViewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
        // [webViewController executeWithTitle:@"" SubTitle:@"티커 내용" RequestURL:[nDic objectForKey:@"티커Url"]];
        // [AppDelegate.navigationController pushFadeViewController:webViewController];
        // [webViewController release];
        SHBTickerViewController *webViewController = [[SHBTickerViewController alloc] initWithNibName:@"SHBTickerViewController" bundle:nil];
        
        [webViewController executeWithTitle:@"" SubTitle:@"티커 내용" RequestURL:[nDic objectForKey:@"티커Url"]];
        [AppDelegate.navigationController pushFadeViewController:webViewController];
        [webViewController release];
    }
}


@end