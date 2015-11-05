//
//  SHBCertManageViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INISAFEXSafe.h" //신
#import "SHBCellActionProtocol.h"           // cell에서 발생하는 event를 받기 위한 protocol
#import "CertificateInfomation.h"

@class CertificateInfo;
@class CertificateInfomation;

@interface SHBCertManageViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBCellActionProtocol>


@property (retain, nonatomic) IBOutlet UITableView *certListTable;
@property (nonatomic, retain) NSMutableArray *certList;
@property (nonatomic, retain) NSMutableArray *certListTemp;
@property (nonatomic, assign) BOOL isSignupProcess; //루트로 가는거 결정
@property (nonatomic, retain) IBOutlet SHBButton *idBtn;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, retain) IBOutlet SHBButton *settingBtn;

//이니텍 신모듈
@property (nonatomic) int selected_row;

- (void)cellButtonActionisOpen:(int)aRow;
- (void)cellButtonAction:(int)aTag;
- (IBAction) pushIDPWDLoginView:(id)sender;
- (IBAction) pushLoginSettingView:(id)sender;
@end
