//
//  CertificateInfo.h
//  certList
//
//  Created by  김대현 on 10. 4. 20..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CertificateInfo : NSObject {
	NSInteger index;
	NSString *user;
	NSString *issuer;
	NSString *type;
	NSString *expire;
   
	NSInteger expired;
	
}
@property (nonatomic) NSInteger index;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *issuer;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *expire;

@property (nonatomic) NSInteger expired;


- (CertificateInfo *) initWithParsing: (char *)line;
- (int) changePassword: (char *)passwd newPasswd: (char *)newPasswd;
- (int) deleteCert;

@end
