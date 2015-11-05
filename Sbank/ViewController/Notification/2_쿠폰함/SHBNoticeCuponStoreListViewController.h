//
//  SHBNoticeCuponStoreViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 15..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"


@interface SHBNoticeCuponStoreListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *dicSelectedData;
    NSMutableDictionary *dictionary_select;
    NSString *code;
    NSString *cmma_string;
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView1;
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent;
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;
@end
