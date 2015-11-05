//
//  SHBCardCashServiceViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardCashServiceViewController.h"

@interface SHBCardCashServiceViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBCardCashServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"현금서비스 이체"];
    
    CGFloat x = 8;
    CGFloat y = _info1.frame.origin.y;
    
    NSString *info3HTML = @"<html><head> \
                          <style type=\"text/css\"> \
                          body { background-color:transparent; margin:0px 0px 0px 0px; padding:0px 0px 0px 0px; } \
                          font.z{ font-family:\"helvetica\"; font-size:13; color:#393939; line-height:1.25em; }\
                          font.w{ font-family:\"helvetica\"; font-size:13; color:#AD5555; line-height:1.25em; }\
                          </style></head> \
                          <body><font class=\"z\"> \
                          'Smart 신한' 앱 로그인은 신한카드 온라인 회원에 한하여 가능하며, 신한카드 온라인 회원이 아니신 고객님들께서는 \
                          PC를 통하여 신한카드 홈페이지</font><font class=\"w\">(www.shinhancard.com)</font><font class=\"z\">에 \
                          접속하셔서 회원가입 후 이용해주시길 부탁드립니다.</font> \
                          </body></html>";
    
    NSString *info3String = @"'Smart 신한' 앱 로그인은 신한카드 온라인 회원에 한하여 가능하며, 신한카드 온라인 회원이 아니신 고객님들께서는 \
                            PC를 통하여 신한카드 홈페이지(www.shinhancard.com)에 접속하셔서 회원가입 후 이용해주시길 부탁드립니다.";
    
    [_info3 loadHTMLString:info3HTML baseURL:nil];
    
    // 가변 길이 설정
    [self adjustToView:_info1 originX:x originY:y text:_info1.text];
    y += _info1.frame.size.height + 10;
    [self adjustToView:_info2 originX:x originY:y text:_info2.text];
    y += _info2.frame.size.height + 10;
    [self adjustToView:_info3 originX:x originY:y text:info3String];
    y += _info3.frame.size.height + 10;
    [self adjustToView:_info4 originX:x originY:y text:_info4.text];
    y += _info4.frame.size.height + 10;
    [self adjustToView:_info5 originX:x originY:y text:_info5.text];
    y += _info5.frame.size.height + 5;
    
    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   y)];
    
    [_mainSV addSubview:_mainView];
    [_mainSV setContentSize:_mainView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainView release];
    [_info1 release];
    [_info2 release];
    [_info3 release];
    [_info4 release];
    [_info5 release];
    [_mainSV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setInfo1:nil];
    [self setInfo2:nil];
    [self setInfo3:nil];
    [self setInfo4:nil];
    [self setInfo5:nil];
    [self setMainSV:nil];
    [super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:13]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - Button
/// 현금서비스 이체 신청
- (IBAction)transferRequestBtn:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartshinhan:////appcall?StartPageMenuName=SHCM_003_003"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"smartshinhan:////appcall?StartPageMenuName=SHCM_003_003"]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/sinhankadeu-smart-sinhan/id360681882?mt=8"]];
    }
}

#pragma mark - UIWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // webView가 늦게 불러와져서 깜박이는 것 방지
    [_info1 setHidden:NO];
    [_info2 setHidden:NO];
    [_info4 setHidden:NO];
    [_info5 setHidden:NO];
}

@end
