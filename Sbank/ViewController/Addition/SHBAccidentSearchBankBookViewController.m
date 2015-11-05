//
//  SHBAccidentSearchBankBookViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchBankBookViewController.h"
#import "SHBAccidentSearchBankBookListViewController.h"	// 통장/인감 사고신고 조회 2depth
#import "SHBCustomerService.h"

@interface SHBAccidentSearchBankBookViewController ()

@end

@implementation SHBAccidentSearchBankBookViewController

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
	[self setTitle:@"사고신고 조회"];
    
    self.strBackButtonTitle = @"통장/인감사고신고조회 메인";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSLog(@"aDataSet : %@", aDataSet);
    int tempCount = 0;
    
    NSMutableArray *tempDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"계좌목록"]) {
        if ([dic[@"인감분실여부"] isEqualToString:@"0"] &&
			[dic[@"통장분실여부"] isEqualToString:@"0"] )
		{
            tempCount++;
            continue;
        }
        
        else {
            
            if (![dic[@"예금종류"] isEqualToString:@"7"])
            {
                // 예금명
                if ([dic[@"상품부기명"] length] > 0)
                {
                    [dic setObject:dic[@"상품부기명"] forKey:@"예금명"];
                }
                else
                {
                    [dic setObject:dic[@"과목명"] forKey:@"예금명"];
                }

                if ([dic[@"신계좌변환여부"] isEqualToString:@"1"])
                {
                    [dic setObject:dic[@"계좌번호"] forKey:@"관련계좌번호"];
                }
                else
                {
                    if (dic[@"구계좌번호"] != nil)
                        [dic setObject:dic[@"구계좌번호"] forKey:@"관련계좌번호"];
                    else
                        [dic setObject:@"" forKey:@"관련계좌번호"];
                }
                
                if ([dic [@"잔액"] length] > 0 || [dic[@"펑가금액"] length] > 0 || [dic[@"외환잔액"] length] > 0)
                {
                    if ([dic[@"통화코드"] isEqualToString:@""] &&
                        ![dic[@"예금종류"] isEqualToString:@"4"] &&
                        ![dic[@"예금종류"] isEqualToString:@"5"] &&
                        ![dic[@"예금종류"] isEqualToString:@"6"] )
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원",dic[@"잔액"]] forKey:@"잔액(평가금액)"];
                    }
                    else if ([dic[@"통화코드"] isEqualToString:@"KRW"] &&
                             ![dic[@"예금종류"] isEqualToString:@"4"] &&
                             ![dic[@"예금종류"] isEqualToString:@"5"] &&
                             ![dic[@"예금종류"] isEqualToString:@"6"] )
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)",dic[@"잔액"]] forKey:@"잔액(평가금액)"];
                    }
                    
                    else if ([dic[@"통화코드"] isEqualToString:@""] &&
                             [dic[@"예금종류"] isEqualToString:@"4"])
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"평가금액"]] forKey:@"잔액(평가금액)"];
                        
                    }
                    
                    else if ([dic[@"통화코드"] isEqualToString:@""] &&
                             ([dic[@"예금종류"] isEqualToString:@"5"] ||
                              [dic[@"예금종류"] isEqualToString:@"6"]) )
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)", dic[@"외화잔액"]] forKey:@"잔액(평가금액)"];
                        
                    }
                    else if ([dic[@"통화코드"] isEqualToString:@"KRW"] &&
                             [dic[@"예금종류"] isEqualToString:@"4"] )
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"평가금액"]] forKey:@"잔액(평가금액)"];
                        
                    }
                    else if ([dic[@"통화코드"] isEqualToString:@"KRW"] &&
                             ([dic[@"예금종류"] isEqualToString:@"5"] ||
                              [dic[@"예금종류"] isEqualToString:@"6"]) )
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@원(KRW)", dic[@"외화잔액"]] forKey:@"잔액(평가금액)"];
                    }
                    
                    else if(![dic[@"통화코드"] isEqualToString:@""] &&   //펀드
                            ![dic[@"통화코드"] isEqualToString:@"KRW"] &&
                            [dic[@"예금종류"] isEqualToString:@"4"])
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)",dic[@"평가금액"], dic[@"통화코드"]] forKey:@"잔액(평가금액)"];
                    }
                    else if(![dic[@"통화코드"] isEqualToString:@""] &&
                            ![dic[@"통화코드"] isEqualToString:@"KRW"] &&
                            ([dic[@"예금종류"] isEqualToString:@"5"] || [dic[@"예금종류"] isEqualToString:@"6"]))
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)",dic[@"외화잔액"],dic[@"통화코드"]] forKey:@"잔액(평가금액)"];
                        
                    }
                    else if(![dic[@"통화코드"] isEqualToString:@""] &&
                            ![dic[@"통화코드"] isEqualToString:@"KRW"])
                    {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)",dic[@"잔액"],dic[@"통화코드"]] forKey:@"잔액(평가금액)"];
                    }
                    
                }
                
                if ([dic[@"통장분실여부"] isEqualToString:@"1"])
                {
                    [dic setObject:@"유" forKey:@"통장사고"];
                }
                else
                {
                    [dic setObject:@"-" forKey:@"통장사고"];
                }
                if ([dic[@"인감분실여부"] isEqualToString:@"1"])
                {
                    [dic setObject:@"유" forKey:@"인감사고"];
                }
                else
                {
                    [dic setObject:@"-" forKey:@"인감사고"];
                }
                [tempDataArray addObject:dic];
            }
        }
    }
    NSLog(@"tempDataArray : %@", tempDataArray);

    if (tempCount == [[aDataSet arrayWithForKey:@"계좌목록"] count]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"사고신고된 통장/인감이 없습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
        
        return NO;
    }

	SHBAccidentSearchBankBookListViewController *viewController = [[[SHBAccidentSearchBankBookListViewController alloc] initWithNibName:@"SHBAccidentSearchBankBookListViewController" bundle:nil] autorelease];
    [viewController setListData:(NSArray *)tempDataArray];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];

    return YES;
}

#pragma mark - Action

- (IBAction)refBtnAction:(UIButton *)sender
{
    // E4130 전문호출
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"거래구분" : @"9",
                            @"보안계좌조회구분" : @"2",
                            @"계좌감추기여부" : @"1",
                            }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_E4130_SERVICE viewController: self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];

}

@end
