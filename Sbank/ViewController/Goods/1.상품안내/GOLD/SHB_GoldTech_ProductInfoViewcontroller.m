//
//  SHB_GoldTech_ProductInfoViewcontroller.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 11. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHB_GoldTech_ProductInfoViewcontroller.h"
#import "SHBGoodsSubTitleView.h"
#import "SHB_GoldTech_InputViewcontroller.h"
#import "SHBELD_BA17_5ViewController.h"

@interface SHB_GoldTech_ProductInfoViewcontroller ()

@end

@implementation SHB_GoldTech_ProductInfoViewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"예금적금 상품설명";
    
    [self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.wvProductInfo setBackgroundColor:RGB(244, 239, 233)];
    
       

    NSString *strProductUrl = nil;
    
    if (AppInfo.realServer) {
        
        strProductUrl = [NSString stringWithFormat:@"https://m.shinhan.com/pages/financialPrdt/gold/sb_gold_detail.jsp?C_PROD_ID=%@&EQUP_CD=SI", self.dicSelectedData[@"상품코드"]];
    }
    else {
        
        strProductUrl = [NSString stringWithFormat:@"https://dev-m.shinhan.com/pages/financialPrdt/gold/sb_gold_detail.jsp?C_PROD_ID=%@&EQUP_CD=SI", self.dicSelectedData[@"상품코드"]];
    }
    
   
    
    
    //상품신규 웹뷰 페이지 캐시 초기화 파라미터
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strProductUrl]]];
    [self.wvProductInfo loadRequest:request];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:0 focusStepNumber:0]autorelease]];
    
    [_btn_lastAgreeCheck setSelected:NO];

}



#pragma mark - Action

- (IBAction)agreeCheckBtnAction:(UIButton *)sender {
	[sender setSelected:!sender.selected];
	
	self.lastAgreeCheck = [sender isSelected];
}


- (IBAction)joinBtnAction:(UIButton *)sender
{
    NSString *strMsg = nil;
    
    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger *time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    

    
    if (![SHBUtility isOPDate:date] || time < 90000 || time > 190000) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신규 및 거래가능 시간은 09:00~19:00(휴일/토요일 이용불가)까지 입니다."];
        
        return;
    }
    
    
    if (![self isLastAgreeCheck])
    {
		strMsg = @"상품에 대하여 충분히 이해하신 경우에만 다음단계로 진행 가능합니다.";
	}
    
    if (strMsg) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}

//    
//    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    date = [date stringByReplacingOccurrencesOfString:@"." withString:@""];
//    
//    NSInteger time = [[SHBUtility getCurrentTime] integerValue];
//    
//    if (![SHBUtility isOPDate:date] || time < 90000 || 190000 < time) {
//        
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"신규 및 거래가능 시간은 가능시간은 09:00 ~ 19:00(휴일/토요일 이용불가)까지 입니다."];
//        return;
//    }
    
    //투자분석진행시작!!!!!!!!!!!!!
    SHBELD_BA17_5ViewController *viewController = [[[SHBELD_BA17_5ViewController alloc] initWithNibName:@"SHBELD_BA17_5ViewController" bundle:nil] autorelease];
    
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.dicSelectedData];
    viewController.needsCert = YES;
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

//- (IBAction)cancelBtnAction:(UIButton *)sender {
//    [_btn_lastAgreeCheck setSelected:NO];
//}


- (void)viewDidUnload {
    [self setWvProductInfo:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
