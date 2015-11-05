//
//  SHBViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 8. 25..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNewProductCouponViewController.h"
#import "SHBAccountService.h"
#import "SHBProductService.h"
#import "SHBNewProductInfoViewController.h"
#import "SHBNewProductCouponEndViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util

@interface SHBNewProductCouponViewController () <SHBproductCouponCancelDelegate>

@end




@implementation SHBNewProductCouponViewController
@synthesize acc;


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
     [self setTitle:@"쿠폰등록"];
    
    
     NSMutableArray *tmpData = [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"];
    
    for(int i=0; i<[tmpData count]; i++)
    {
        //NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        if ([[[tmpData objectAtIndex:i] objectForKey:@"상품코드"] isEqualToString:@"230011821"])
        {
            ollehAcc =  [[NSString alloc] initWithFormat:@"%@",[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"]];
            
        }
        
    }
    
    //NSLog(@"ollehAcc %@",ollehAcc);
    
     if ([ollehAcc isEqualToString:@""] || ollehAcc == nil) {  // 올레 계좌가 없을떄

         [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1000 title:@"" message:@"신한 올레tv모바일적금이 가입되어 있지 않습니다! 적금을 먼저 가입해 주세요!"];
         
     
     }
     else{
         
         if ([self.data[@"cp"] isEqualToString:@""] || self.data[@"cp"] ==nil )  // 올레 계좌가 있을때
         {
             acc.text = ollehAcc;  // 가입된 올레 계좌번호   // 올레 쿠폰값이 없을때
             _txtInCoupon.enabled = YES;
         }
         
         else
         {
             
             acc.text = ollehAcc;  // 가입된 올레 계좌번호
             _txtInCoupon.text = self.data[@"cp"];    // 올레 쿠폰값이 있을때
             _txtInCoupon.enabled = NO;
             
         }
    
         
     }

}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"productCode" : @"230011821",
                                                                                   }];
        SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
        viewController.mdicPushInfo = dic;
        [viewController setDelegate:self];
        [self checkLoginBeforePushViewController:viewController animated:YES];
        AppInfo.ollehCoupon = self.data[@"cp"];

    }
}



#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	[super executeWithDic:mDic];
    
    if (mDic) {
        
        self.isPushAndScheme = YES;
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
    
        
        self.data = mDic;
    }
}


- (IBAction)okButton:(id)sender
{
    //쿠폰등록 전문
    NSString *tmp = [ollehAcc stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (![tmp isEqualToString:@""]) {  // 올레 적금 계좌가 있을시 올레쿠폰 조회
        
        NSLog(@"===%@",tmp);
        
        //쿠폰조회
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                     @"업무구분text" : @"올레tv모바일적금 쿠폰등록",
                                                                     @"계좌번호" : tmp,
                                                                     @"등록해제구분" : @"1",
                                                                     @"등록해제코드" : @"23090",
                                                                     @"쿠폰번호" : self.data[@"cp"],
                                                                     }];
        
        
        self.service = [[[SHBProductService alloc]initWithServiceId:kE4904Id viewController:self]autorelease];
        self.service.requestData = dataSet;
        [self.service start];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SHBproductCouponCancelDelegate
- (void)productCouponCancel
{
   [self.navigationController fadePopToRootViewController];
}



#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if([string length] > 1)
    {
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtInCoupon )
    {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		//한글 7자 제한(영문 14자)
		if (dataLength + dataLength2 > 6)
        {
			return NO;
		}
	}
			
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    _txtInCoupon.text = [SHBUtility substring:_txtInCoupon.text ToMultiByteLength:6];
    
    
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

    if([AppInfo.serviceCode isEqualToString:@"E4904"])
    {
        
        NSLog(@"쿠폰 등록 ");
        SHBNewProductCouponEndViewController *viewController = [[[SHBNewProductCouponEndViewController alloc] initWithNibName:@"SHBNewProductCouponEndViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }

    return NO;
    
}
@end
