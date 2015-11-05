//
//  SHBCertManageCell.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertManageCell.h"

@implementation SHBCertManageCell

@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize btnOpen;
@synthesize certDelBtn;
@synthesize certPwdBtn;
@synthesize certConfirmBtn;
@synthesize certInfoBtn;
@synthesize cellButtonActionDelegate;
@synthesize certImage;
@synthesize notAfterTitle;
@synthesize bgView;
@synthesize lineImage;
@synthesize issuerTitleLabel;

//@synthesize target;
@synthesize row;
//@synthesize pSelector;

- (void)dealloc
{
    //[target release];
    [lineImage release];
    [certDelBtn release];
    [certPwdBtn release];
    [certConfirmBtn release];
    [certInfoBtn release];
    [btnOpen release];
    [typeLabel release]; typeLabel = nil;
    [subjectLabel release], subjectLabel = nil;
    [issuerAliasLabel release], issuerAliasLabel = nil;
    [notAfterLabel release], notAfterLabel = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    //    NSDictionary *dic = @{@"Index" : [NSString stringWithFormat:@"%d", row], @"Button" : sender};
    //
    //    //NSLog(@"button dic:%@",dic);
    //    [self.target performSelector:self.pSelector withObject:dic];
    
    switch ([sender tag]) {
            
        case 2000:        // 펼치기
        {
            [cellButtonActionDelegate cellButtonActionisOpen:self.row];
        }
            break;
        case 2001:        // 삭제
        {
            [cellButtonActionDelegate cellButtonAction:[sender tag]];
        }
            break;
        case 2002:        // 암호변경
        {
            [cellButtonActionDelegate cellButtonAction:[sender tag]];
        }
            break;
        case 2003:        // 본인확인
        {
            [cellButtonActionDelegate cellButtonAction:[sender tag]];
        }
            break;
        case 2004:        // 인증서 정보
        {
            [cellButtonActionDelegate cellButtonAction:[sender tag]];
        }
            break;
        default:
            break;
    }
}

@end
