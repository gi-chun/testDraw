//
//  SHBUtilFile.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
@interface SHBUtilFile : NSObject
{
	
}

+(id)instance;

-(void)initData;
-(void)setShareDataFile:(NSString*)fileName fileData:(NSDictionary*)data;
-(NSMutableDictionary*)getShareDataFile:(NSString*)fileName;
-(void)setShareListFile:(NSString*)fileName fileData:(NSArray*)data;
-(NSMutableArray*)getShareListFile:(NSString*)fileName;
-(NSString *)dataFilePath:(NSString*)name;
-(void)setShareArrayFile:(NSString*)fileName fileData:(NSArray*)data;
-(NSMutableArray*)getShareArrayFile:(NSString*)fileName;
-(NSString *) getHybridPath:(NSInteger)path fileName:(NSString *)fileName;


#if !TARGET_IPHONE_SIMULATOR

NSString* getModel(void);
NSString* getOSVersion(void);
NSString* getTelecomCarrierName(void);
NSString* getISOCountryCode(void);
NSString* getMobileNetworkCode(void);
NSString* getNetworkStatus(void);
NSString* getWiFiMACAddress(void);
NSString* getEthernetMACAddress(void);
NSString* getExternalIPAddress(NSString* serverIPstr, unsigned short serverPortNbr);
NSString* getInternalIPAddress1(void);
NSString* getInternalIPAddress2(void);
NSString* getSSID(void);
NSString* getBSSID(void);
NSString* getCellNumber(void);
NSString* getUserAccount(void);
NSString* checkRoot(void);
NSString* getUUID1(NSString* accessGroupStr);
NSString* getUUID2(NSString* accessGroupStr);
NSString* getResultSum(NSString* serverIPstr, unsigned short serverPortNbr, bool isDisConnected, NSString* accessGroupStr);
NSString* checkProxy(void);
#endif

+ (NSString *)getModel;
+ (NSString *)getOSVersion;
+ (NSString *)getTelecomCarrierName;
+ (NSString *)getISOCountryCode;
+ (NSString *)getMobileNetworkCode;
+ (NSString *)getNetworkStatus;
+ (NSString *)getWiFiMACAddress:(BOOL)isColon;
+ (NSString *)getEthernetMACAddress:(BOOL)isColon;
+ (NSString *)getExternalIPAddress:(NSString *)serverIPstr portNumber:(unsigned short)serverPortNbr;
+ (NSString *)getInternalIPAddress1;
+ (NSString *)getInternalIPAddress2;
+ (NSString *)getSSID;
+ (NSString *)getBSSID;
+ (NSString *)getCellNumber;
+ (NSString *)getUserAccount;
+ (NSString *)checkRoot;
+ (NSString *)getPhoneUUID1:(NSString *)aAccessGroup;
+ (NSString *)getPhoneUUID2:(NSString *)aAccessGroup;
+ (NSString *)getResultSum:(NSString *)serverIPstr portNumber:(unsigned short)serverPortNbr connected:(BOOL)isConnect accessGroup:(NSString *)aAccessGroup;

+ (NSString *)getGlobalIPAddress;
+ (NSString *)getProxy;
@end
