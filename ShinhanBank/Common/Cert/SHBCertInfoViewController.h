//
//  SHBCertInfoViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCertInfoViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;

//@property (nonatomic, retain) IBOutlet UIButton *confirmBtn;
@property (nonatomic, retain) IBOutlet UIImageView *certImageView;
- (IBAction)confirmBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *cnLabel0;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel1;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel2;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel3;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel4;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel5;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel6;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel7;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel8;
@property (nonatomic, retain) IBOutlet UILabel *cnLabel9;

/** 인증서 정보 속성
 */
//@property (nonatomic, retain) NSString *version;
//@property (nonatomic, retain) NSString *serialNumber;
//@property (nonatomic, retain) NSString *signAlgorithm;
//@property (nonatomic, retain) NSString *issuerDN;
//@property (nonatomic, retain) NSString *notBefore;
//@property (nonatomic, retain) NSString *notAfter;
//@property (nonatomic, retain) NSString *subjectDN;
//@property (nonatomic, retain) NSString *publicKeyAlgorithm;
//@property (nonatomic, retain) NSString *publicKeyBit;
//@property (nonatomic, retain) NSString *fingerPrint;
//@property (nonatomic, retain) NSString *fingerPrintAlgorithm;
//@property (nonatomic, retain) NSString *authorityKeyIdentifier;
//@property (nonatomic, retain) NSString *subjectKeyIdentifier;
//@property (nonatomic, retain) NSString *keyUsage;
//@property (nonatomic, retain) NSString *certificatePolicy;
//@property (nonatomic, retain) NSString *subjectAltName;
//@property (nonatomic, retain) NSString *CRLDistributionPoints;
//@property (nonatomic, retain) NSString *authorityInfoAcc;







@end
