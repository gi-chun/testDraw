//
//  SHBTickerView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBTickerView : UIView {
	IBOutlet UIView		*title1View;
	IBOutlet UIView		*title2View;
	IBOutlet UIView		*title3View;
	IBOutlet UIView		*title4View;
	IBOutlet UIView		*title5View;
	IBOutlet UIButton	*title1Label;
	IBOutlet UIButton	*title2Label;
	IBOutlet UIButton	*title3Label;
	IBOutlet UIButton	*title4Label;
	IBOutlet UIButton	*title5Label;
	
	NSMutableArray	*tickerArray;
	int	showTitleNum;
	int arrayCount;
	
	float title1Width;
	float title2Width;
	float title3Width;
	float title4Width;
	float title5Width;
	
	BOOL	isSlideText;
}

@property (nonatomic,assign) BOOL isSlideText;
@property (nonatomic, retain) IBOutlet UIButton   *voiceOverBtn;

- (void)executeWithData:(NSArray*)arrData;
- (void)executeWithData2:(NSArray*)arrData;


- (IBAction)buttonPressed:(UIButton*)sender;


@end
