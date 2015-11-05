//
//  SHBAccidentSearchInfoView.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchInfoView.h"

@interface SHBAccidentSearchInfoView()

@end

@implementation SHBAccidentSearchInfoView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.tag == 1111 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1577-8000"]];
	} else if (alertView.tag == 2222 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1544-7000"]];
    }

}

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
    [_btnCall1 release];
    [_btnCall2 release];

    [super dealloc];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 10:
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"1577-8000"
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"통화", @"취소", nil];
//            alert.tag = 1111;
//            [alert show];
//            [alert release];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1577-8000"]];
        }
            break;

        case 20:
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"1544-7000"
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"통화", @"취소", nil];
//            alert.tag = 2222;
//            [alert show];
//            [alert release];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1544-7000"]];
        }
            break;
            
        default:
            break;
    }
}

@end
