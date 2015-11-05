//
//  SHBDataSet.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 OFDataSet을 상속하는 데이터셋 클래스이다.
 */

#import "OFDataSet.h"

@interface SHBDataSet : OFDataSet
{
    NSString *serviceCode;
}

@property (nonatomic, retain) NSString* serviceCode;
@property (nonatomic, retain) NSString* serviceTaskCode;
@property (nonatomic, retain) NSString* vectorTitle;
@property (nonatomic, retain) NSString* TaskAndVector;

@end
