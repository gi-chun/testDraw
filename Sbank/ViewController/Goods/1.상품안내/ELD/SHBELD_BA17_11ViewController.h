//
//  SHBELD_BA17_11ViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 6. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 상품신규 - ELD
 약관동의 및 상품설명서
 */

@interface SHBELD_BA17_11ViewController : SHBBaseViewController <UIWebViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *viewDataSource;

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIButton *termsCheck;
@property (retain, nonatomic) IBOutlet UIButton *ELDCheck;
//@property (retain, nonatomic) IBOutlet UIWebView *marketingWV;
@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;


@end
