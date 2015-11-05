//
//  SHBNewProductListViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품리스트 화면
 */

#import "SHBBaseViewController.h"

@interface SHBNewProductListViewController : SHBBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tblProduct;

@property BOOL needsAllList;	// (푸쉬로 타고들어왔을때) 상품상세에서 백으로 돌아왔을때 상품전체 리스트 가져오는 전문처리를 위한 플래그

@end
