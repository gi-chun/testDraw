//
//  SHBSearchResultNormalTypeTableViewCell.h
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 25..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSearchResultNormalTypeTableViewCell : UITableViewCell
{
    UILabel *lblTitle;
    UILabel *lblDescript;
}
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDescript;
@end