//
//  Encryption.h
//  ___ORCHESTRAPROJECT___
//
//  Created by Jang, Seyoung on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PhoneGapCommand.h"
#import <CommonCrypto/CommonCryptor.h>

@interface Encryption : NSObject {

}
-(void) base64Encoding:(NSArray*)args withDict:(NSMutableDictionary*)options;
-(void) base64Decoding:(NSArray*)args withDict:(NSMutableDictionary*)options;
-(NSString *) aes128Encrypt:(NSString*)args;
-(NSString *) aes128Decrypt:(NSString*)args;

- (NSData *)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data ;
- (NSData *)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data;
- (NSString *)hexEncode:(NSData *)data ;
- (NSData*) decodeHexString : (NSString *)hexString ;
@end
