//
//  Encryption.m
//  ___ORCHESTRAPROJECT___
//
//  Created by Jang, Seyoung on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Encryption.h"
//#import "___ORCHESTRAPROJECT___AppDelegate.h"
#import "NSData+Base64.h"

@implementation Encryption
#pragma mark -
#pragma mark Base64Encoding/base64Decoding  Methods
-(void) base64Encoding:(NSArray*)args withDict:(NSMutableDictionary*)options
{
//    NSString* callbackId = [args objectAtIndex:0];
    
//	NSString* originalString = [args objectAtIndex:1];
	
	//Base64Encoding
//	NSData *sourceData = [originalString dataUsingEncoding:NSUTF8StringEncoding]; 
//	NSString *encodingString = [sourceData  base64EncodedString];
//	NSLog(@"encodeData=%@",string1);
	
	//PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:encodingString];
    //NSString* str = [result toSuccessCallbackString:callbackId];
	
    //[self writeJavascript: str];
    
}
-(void) base64Decoding:(NSArray*)args withDict:(NSMutableDictionary*)options
{
//    NSString* callbackId = [args objectAtIndex:0];
//    NSString* decodedString = [args objectAtIndex:1];
	
	//Base64Decoding
//	NSData *decodedData = [NSData dataFromBase64String:decodedString];
//	NSString *originalString = [[[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding] autorelease];
	
//	NSLog(@"DecodeData=%@",originalString);
	
    //PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:originalString];
    //NSString* str = [result toSuccessCallbackString:callbackId];
	
    //[self writeJavascript: str];
    
}
#pragma mark -
#pragma mark Aes128Encrypt/Aes128Decrypt  Methods
- (NSString *) aes128Encrypt:(NSString *)args
{
	
    NSString* originalString = args;
	//AES128EncryptString
	NSString *dbsdnsdyd = [NSString stringWithFormat:@"#gkdxpaus&^qhkdl18shaemfdk10040802$!@(^!^*"];
    //NSString *dbsdnsdyd = [NSString stringWithFormat:@"0987654321098765"];
    if ([originalString length] ==0) {
        
        return nil;
    }
    NSData *data = [[[NSData alloc] initWithData:[originalString dataUsingEncoding:NSUTF8StringEncoding]]autorelease];
    
    NSData *ret = [self AES128EncryptWithKey:dbsdnsdyd theData:data];
	
    NSString* aslkdfwei = [self hexEncode:ret];
	
	//NSLog(@"originalString=%@",originalString);
	//NSLog(@"encryptString=%@",encryptString);
	
    return aslkdfwei;
}
- (NSString *) aes128Decrypt:(NSString *)args
{

	NSString* smdcmoihzw45 = args;
	
	//AES128DecryptString
	NSString *dbsdnsdyd = [NSString stringWithFormat:@"#gkdxpaus&^qhkdl18shaemfdk10040802$!@(^!^*"];
    //NSString *dbsdnsdyd = [NSString stringWithFormat:@"0987654321098765"];
    //NSLog(@"hex = %@",encryptString);
    NSData *ret = [self decodeHexString:smdcmoihzw45];
    
    NSData *ret2 = [self AES128DecryptWithKey:dbsdnsdyd theData:ret];
    
    NSString *csdnsandcl9273 = [[[NSString alloc] initWithData:ret2 encoding:NSUTF8StringEncoding] autorelease];
    
//	NSLog(@"originalString=%@",originalString);
	//NSLog(@"decryptString=%@",decryptString);
	if ([csdnsandcl9273 isEqualToString:@""] || csdnsandcl9273 ==nil) {
        
        return nil;

    }
    
    return csdnsandcl9273;

}
- (NSData *)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data {
	
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    
    //See the doc: For block ciphers, the output size will always be less than or 
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, 
                                          kCCAlgorithmAES128, 
                                          kCCOptionECBMode +kCCOptionPKCS7Padding,
                                          keyPtr, 
                                          kCCKeySizeAES128, // oorspronkelijk 256
                                          nil, /* initialization vector (optional) */
                                          [Data bytes], 
                                          dataLength, /* input */
                                          buffer, 
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
	
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data
{
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    
    //See the doc: For block ciphers, the output size will always be less than or 
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, 
                                          kCCAlgorithmAES128, 
                                          kCCOptionECBMode +kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [Data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

-(NSString *)hexEncode:(NSData *)data{
    NSMutableString *hex = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    char temp[3];
    NSUInteger i=0;
    
    for(i=0; i<[data length]; i++){
        temp[0] = temp[1] = temp[2] =0;
        (void)sprintf(temp, "%02x",bytes[i]);
        [hex appendString:[NSString stringWithUTF8String:temp]];
        
    }
    return hex;
}

- (NSData*) decodeHexString : (NSString *)hexString 
{
    int tlen = [hexString length]/2;
    
    char tbuf[tlen];
    int i,k,h,l;
    bzero(tbuf, sizeof(tbuf));
    
    for(i=0,k=0;i<tlen;i++)
    {
        h=[hexString characterAtIndex:k++];
        l=[hexString characterAtIndex:k++];
        h=(h >= 'A') ? h-'A'+10 : h-'0';
        l=(l >= 'A') ? l-'A'+10 : l-'0';
        tbuf[i]= ((h<<4)&0xf0)| (l&0x0f);
    }
    
    return [NSData dataWithBytes:tbuf length:tlen];
}

@end
