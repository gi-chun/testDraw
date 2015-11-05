//
//  SHBSmartCareDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"
#import "SHBAttentionLabel.h"

@protocol SHBSmartCareDetailDelegate <NSObject>


- (void)smartCareDetailBack;


@end



@interface SHBSmartCareDetailViewController : SHBBaseViewController<UIWebViewDelegate>
{
    IBOutlet SHBWebView		*webView;
}



@property (assign, nonatomic) id<SHBSmartCareDetailDelegate> delegate;


@property (nonatomic, retain) NSMutableDictionary *dicSelectedData; //선택된 데이터
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *numberLabel;

@end
