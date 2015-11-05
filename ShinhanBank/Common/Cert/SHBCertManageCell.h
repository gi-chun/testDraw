//
//  SHBCertManageCell.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBCellActionProtocol.h"

@interface SHBCertManageCell : UITableViewCell
@property (nonatomic, assign) id <SHBCellActionProtocol> cellButtonActionDelegate;         // buttonPushDelegate

//@property (nonatomic, assign) id target;
@property (nonatomic        ) int row;
//@property (nonatomic, assign) SEL pSelector;

@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;

@property (nonatomic, retain) IBOutlet UILabel *issuerTitleLabel;


@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *certDelBtn;
@property (retain, nonatomic) IBOutlet UIButton *certPwdBtn;
@property (retain, nonatomic) IBOutlet UIButton *certConfirmBtn;
@property (retain, nonatomic) IBOutlet UIButton *certInfoBtn;

@property (retain, nonatomic) IBOutlet UIView *bgView;

@property (retain, nonatomic) IBOutlet UIImageView *certImage;
@property (retain, nonatomic) IBOutlet UIImageView *lineImage;
@end
