//
//  SHBUDreamInfoViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBUDreamInfoViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUDreamStipulationViewController.h"
#import "SHBUDreamMoneyRateViewController.h"

@interface SHBUDreamInfoViewController ()

@end

@implementation SHBUDreamInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_webView release];
	[_bottomView release];
    [super dealloc];
}
- (void)viewDidUnload {
	[self setWebView:nil];
	[self setBottomView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"U드림 저축예금 전환"];
    self.strBackButtonTitle = @"U드림 저축예금 전환 상품안내";
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"상품안내" maxStep:0 focusStepNumber:0]autorelease]];
	
	//NSString *strUrl = [NSString stringWithFormat:@"%@/sbank/prodSumm/sbank_intro_110000501.html", URL_IMAGE];
    NSString *strUrl;
    if (!AppInfo.realServer) {
        strUrl = [NSString stringWithFormat:@"%@/sbank/prod/sbank_desc_200013401.html", URL_IMAGE_TEST];
     }
    else {
        strUrl = [NSString stringWithFormat:@"%@/sbank/prod/sbank_desc_200013401.html", URL_IMAGE];
    }
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strUrl]]]];
	
	Debug(@"strUrl : %@", strUrl);
	FrameReposition(self.bottomView, left(self.bottomView), height(self.webView)+1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if 1	// Temp
- (NSArray *)currentDateAgoYear:(NSInteger)yy AgoMonth:(NSInteger)mm AgoDay:(NSInteger)dd
{
	//NSString *strURL = [NSString stringWithFormat:@"http://%@%@y=%d&m=%d&d=%d", SERVER_IP, DATE_URL, yy, mm, dd];
    NSString *strURL = [NSString stringWithFormat:@"https://%@%@y=%d&m=%d&d=%d", AppInfo.serverIP, DATE_URL, yy, mm, dd];
	NSURL *url = [NSURL URLWithString:strURL];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLResponse *response;
	NSError *error;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (data == nil) {
		return nil;
	}
	
	NSString *strDate = [NSString stringWithFormat:@"%s", [data bytes]];
	NSRange range = [strDate rangeOfString:@"addDate value='"];
	if (range.location == NSNotFound) {
		Debug(@"Not Found");
		return nil;
	}
	
	range = NSMakeRange(range.location + range.length, 8);
	NSString *strStartDate = [strDate substringWithRange:range];
	
	strDate = [NSString stringWithFormat:@"%s", [data bytes]];
	range = [strDate rangeOfString:@"inputDate value='"];
	if (range.location == NSNotFound) {
		Debug(@"Not Found");
		
		return nil;
	}
	
	range = NSMakeRange(range.location + range.length, 8);
	NSString *strEndDate = [strDate substringWithRange:range];
	
	NSArray *array = [NSArray arrayWithObjects:strStartDate, strEndDate, nil];
	
	return array;
}
#endif

#pragma mark - Action
- (IBAction)interestBtnAction:(UIButton *)sender {
	
	
//	NSString *strCurrentDate = [[self currentDateAgoYear:0 AgoMonth:0 AgoDay:0] objectAtIndex:0];
//		
//	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
//						  @{
//						  @"조회구분" : @"1",
//						  @"기준일자" : strCurrentDate,
//						  @"수신금리유형" : @"1",
//						  @"이자지급방법" : @"99",
//						  @"반복횟수" : @"1",
//						  @"상품코드" : @"110000501",
//						  }];
//	dataSet.serviceCode = @"D5010";
//	
//	[self serviceRequest:dataSet];
	NSString *strUrl;
     if (!AppInfo.realServer)
     {
         strUrl = [NSString stringWithFormat:@"%@PROD_ID=%@&EQUP_CD=SI", URL_INTEREST_TEST, @"110000501"];
     }
     else{
          strUrl = [NSString stringWithFormat:@"%@PROD_ID=%@&EQUP_CD=SI", URL_INTEREST, @"110000501"];
     }
    
    
    
	SHBUDreamMoneyRateViewController *viewController = [[SHBUDreamMoneyRateViewController alloc]initWithNibName:@"SHBUDreamMoneyRateViewController" bundle:nil];
	viewController.strURL = strUrl;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)depositBtnAction:(UIButton *)sender {
	SHBUDreamStipulationViewController *viewController = [[SHBUDreamStipulationViewController alloc]initWithNibName:@"SHBUDreamStipulationViewController" bundle:nil];
	//viewController.needsLogin = YES;
    viewController.needsCert = YES;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark - Http Delegate
- (void)client:(OFHTTPClient *)client didReceiveData:(NSData *)data
{
	Debug(@"data : %@", data);
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
	Debug(@"dataSet : %@", dataSet);
	self.dataList = [dataSet arrayWithForKey:@"조회내역"];
	Debug(@"self.dataList : %@", self.dataList);
}

- (void)client:(OFHTTPClient *)client didFail:(NSError *)error
{
	Debug(@"error : %@", [error description]);
}

@end
