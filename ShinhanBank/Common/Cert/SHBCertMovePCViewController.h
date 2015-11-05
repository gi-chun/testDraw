//
//  SHBCertMovePCViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCertMovePCViewController : SHBBaseViewController

@property (nonatomic, retain) NSURLConnection* connectionForExportCertificate;
@property (nonatomic, retain) NSURLResponse* response;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSString *authCode;
@property (retain, nonatomic) IBOutlet UITextField *firstAuthCode;
@property (retain, nonatomic) IBOutlet UITextField *secondAuthCode;
@property (nonatomic, retain) IBOutlet NSString *certPwd;
@property (nonatomic, retain) IBOutlet NSTimer *timer;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressActive;
@end
