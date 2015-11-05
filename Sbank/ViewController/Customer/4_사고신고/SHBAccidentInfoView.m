//
//  SHBAccidentInfoView.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentInfoView.h"

@interface SHBAccidentInfoView ()

@end

@implementation SHBAccidentInfoView

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Button

- (IBAction)bankCallBtn:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1577-8000"]];
}

- (IBAction)cardCallBtn:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1544-7000"]];
}

@end
