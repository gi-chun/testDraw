//
//  SHBHTTPDummyClient.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**전문을 날리지만 결과값을 신경 쓸 필요없을때 사용
 */
@interface SHBHTTPDummyClient : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *recvData;
}
- (void) requestaSyncData:(NSString *)postUrl postStr:(NSString *)postString;

@end
