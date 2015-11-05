//
//  SHBDistricTaxMenuViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"


@interface SHBDistricTaxMenuViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate>
{
    IBOutlet UIView             *viewPopupView;             // 지역선택 popupView
    SHBPopupView                *viewRegionPopupView;       // popupView
    IBOutlet UITableView        *tableViewRegion;           // 지역 tableView
    
    IBOutlet SHBTextField       *textFieldSearch;           // 검색 textField
    
    IBOutlet UILabel            *labelRegion;               // 지역 label
    
    NSMutableArray              *arraySearchRegion;         // 검색된 지역
    NSMutableDictionary         *dicDataDictionary;         // dataDic
    
    NSInteger   intButtonIndex;         // radio button index
    
}


- (IBAction)buttonDidPush:(id)sender;       // 일반 버튼 action
- (IBAction)radioButtonDidPush:(id)sender;  // radio 버튼 action

@end
