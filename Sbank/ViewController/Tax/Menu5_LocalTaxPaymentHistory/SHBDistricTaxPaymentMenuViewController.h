//
//  SHBDistricTaxPaymentMenuViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBListPopupView.h"

@interface SHBDistricTaxPaymentMenuViewController : SHBBaseViewController<SHBListPopupViewDelegate>
{
     NSDictionary *outAccInfoDic;
    int serviceType;
    
}
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;

- (IBAction)checkButtonDidPush:(id)sender;

@end
