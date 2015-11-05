//
//  SHBNewProductEventInfoViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 8. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNewProductEventInfoViewController.h"
#import "SHBProductService.h"
#import "SHBAccountService.h"
#import "SHBNewProductInfoViewController.h"

@interface SHBNewProductEventInfoViewController ()

@end

@implementation SHBNewProductEventInfoViewController

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
    [self setTitle:@"이벤트"];
    
   
    
     [_scrollView setContentSize:_infoView.frame.size];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];

}


#pragma mark - Button

- (IBAction)checkButton:(id)sender
{
    [sender setSelected:![sender isSelected]];
}

- (IBAction)okButton:(id)sender
{
    if (![_checkBtn isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"이벤트 안내를 읽고 동의하셔야 이벤트참여가 가능합니다."];
        
        return;
    }
    
    // 올레 연동 부분
    
    NSString *tmp = [ollehAcc stringByReplacingOccurrencesOfString:@"-" withString:@""];
   
    if (tmp != nil) {  // 올레 적금 계좌가 있을시 올레쿠폰 조회
        
        //NSLog(@"===%@",tmp);
        
        //쿠폰조회
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                     @"검색구분" : @"3",
                                                                     @"검색번호" : tmp,
                                                                     @"은행구분" : @"1",
                                                                     @"조회구분" : @"1",
                                                                     }];
        
        
        self.service = [[[SHBProductService alloc]initWithServiceId:kE4903Id_olleh viewController:self]autorelease];
        self.service.requestData = dataSet;
        [self.service start];

    }
    else{   //올레 적금이 없으면 상품신규로 진행
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"productCode" : @"230011821",
                                                                                   }];
        
       SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
        viewController.mdicPushInfo = dic;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    Debug(@"aDataSet : %@", aDataSet);

    if([AppInfo.serviceCode isEqualToString:@"D0011"])
    {
        
        NSMutableArray *tmpData = [aDataSet arrayWithForKey:@"예금계좌"];
        

        
        for(int i=0; i<[tmpData count]; i++)
        {
            //NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            if ([[[tmpData objectAtIndex:i] objectForKey:@"상품코드"] isEqualToString:@"230011821"])
            {
                ollehAcc =  [[NSString alloc] initWithFormat:@"%@",[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"]];
                
            }
            
        }
        
    }
    
    if (self.service.serviceId == kE4903Id_olleh)
	{
        NSMutableArray *couponData = [aDataSet arrayWithForKeyPath:@"LIST.vector.data"];
        NSString *couponNum = @"";
        for(int i=0; i<[couponData count]; i++)
        {
            //NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            if ([[[couponData objectAtIndex:i] objectForKey:@"쿠폰종류"] isEqualToString:@"G00005"])
            {
                
                //올레페이지로 쿠폰 전송~~~
                couponNum =  [[NSString alloc] initWithFormat:@"%@",[[couponData objectAtIndex:i] objectForKey:@"쿠폰번호"]];
                
                break;
                
            }
            
        }
        
        
        NSLog(@"couponNum %@",couponNum);
        SHBPushInfo *openURLManager = [SHBPushInfo instance];
        [openURLManager requestOpenURL:[NSString stringWithFormat:@"%@%@",@"http://m.tvmobile.olleh.com/jsp/shotm/mobile/sh_event_info.jsp?sbank=", couponNum]SSO:NO];


    }
    
    
 
    return NO;
    
}

@end
