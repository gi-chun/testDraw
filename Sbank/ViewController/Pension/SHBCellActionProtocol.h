//
//  SHBCellActionProtocol.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 13..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHBCellActionProtocol <NSObject>

@optional
@property (nonatomic, assign) id <SHBCellActionProtocol> subViewButtonActionDelegate; // subViewAction

@required
- (void)cellButtonActionisOpen:(int)aRow;
- (void)cellButtonAction:(int)aTag;

@end
