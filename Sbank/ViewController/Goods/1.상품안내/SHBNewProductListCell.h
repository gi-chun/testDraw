//
//  SHBNewProductListCell.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 11..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNewProductListCell : UITableViewCell

/**
 상품명
 */
@property (retain, nonatomic) UILabel *lblProductName;

/**
 악세서리뷰
 */
@property (nonatomic, retain) UIImageView *ivAccessory;

@end
