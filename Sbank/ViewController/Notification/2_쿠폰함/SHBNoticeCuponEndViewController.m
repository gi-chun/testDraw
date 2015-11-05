//
//  SHBNoticeCuponEndViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 14..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNoticeCuponEndViewController.h"
#import "SHBNotificationService.h" // 서비스
#import "SHBNewProductInfoViewController.h"


@interface SHBNoticeCuponEndViewController ()

@end

@implementation SHBNoticeCuponEndViewController
@synthesize selectCouponDic;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"쿠폰조회";
    
    L_name.text =  self.selectCouponDic[@"상품명"];
    L_money.text =  [NSString stringWithFormat:@"%@원",self.selectCouponDic[@"신규금액"]];
    L_month.text =  [NSString stringWithFormat:@"%@개월",self.selectCouponDic[@"계약기간"]];

    
        // Type에 따른 서브 뷰 초기화
    if (!self.isTypeB) { // Type A (신한그린애너지, Mint(온라인전용) 정기예금 금리우대 쿠폰)
        
        CGRect tempRect = self.view1.frame;
        tempRect.origin.y = 140.0;
        self.view1.frame = tempRect;
        [self.contentsView addSubview:self.view1];
        
        L_online.text = [NSString stringWithFormat:@"연 %@%%",self.selectCouponDic[@"적용금리"]];
        L_date.text =   [NSString stringWithFormat:@"(%@ 현재,세전)",AppInfo.tran_Date];
   
    }
    else { // Type B (Tops회전, U드림회전 정기예끔 금리우대 쿠폰)
        
        CGRect tempRect = self.view2.frame;
        tempRect.origin.y = 140.0;
        self.view2.frame = tempRect;
        [self.contentsView addSubview:self.view2];
        
        B_turn.text = [NSString stringWithFormat:@"%@개월",self.selectCouponDic[@"회전주기"]];
        B_online.text = [NSString stringWithFormat:@"연 %@%%",self.selectCouponDic[@"적용금리"]];
        B_date.text =   [NSString stringWithFormat:@"(%@ 현재,세전)",AppInfo.tran_Date];

    }

        
//    if ([selectCouponDic[@"이자지급주기"] isEqualToString:@"0"]) {  //회전주기 상품
//         L_note.text = [NSString stringWithFormat:@"* 특별금리우대 상품은 자동재예치가 불가합니다."];
//    }
//    else{
//        L_note.text = @"";  // 회전상품
//    }
   
}

- (IBAction)buttonDidPush:(id)sender
{
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"상품코드" : selectCouponDic[@"상품코드"],
                           }];
	self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_INFO_SERVICE
                                                       viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];

    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    [self.selectCouponDic setObject:self.selectCouponDic[@"신규금액"] forKey:@"신청금액"];
    [self.selectCouponDic setObject:[NSString stringWithFormat:@"%@개월",self.selectCouponDic[@"계약기간"]] forKey:@"가입기간문구"];
    [self.selectCouponDic setObject:self.selectCouponDic[@"적용금리"] forKey:@"적용금리"];
    [self.selectCouponDic setObject:@"1" forKey:@"고객별산출금리상품여부"];
    [self.selectCouponDic setObject:self.selectCouponDic[@"계약기간"] forKey:@"기간수"];
    [self.selectCouponDic setObject:@"0" forKey:@"영업점상품여부"];
    
    
    if (self.service.serviceId == COUPON_INFO_SERVICE)
    {
        SHBNewProductInfoViewController *viewController = [[SHBNewProductInfoViewController alloc]initWithNibName:@"SHBNewProductInfoViewController" bundle:nil];
    
        viewController.dicReceiveData = aDataSet;
        viewController.dicSelectedData = selectCouponDic;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
    
    
    }
     return NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
