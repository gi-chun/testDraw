//
//  SHBDistricTaxPaymentDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 7..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBDistricTaxPaymentDetailViewController.h"
#import "SHBGiroTaxListService.h"               // 지로서비스
#import "SHBUtility.h"          // 유틸리티


@interface SHBDistricTaxPaymentDetailViewController ()

@end

@implementation SHBDistricTaxPaymentDetailViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:                // 확인 버튼
        {
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    // 각각 auto bind 되도록 형식에 맞게 수정
    // 신 지방세의 경우
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G1422"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            int intBeforeDate = [aDataSet[@"납기내납기일->originalValue"] intValue];
            int intPayDate = [aDataSet[@"납부일시1->originalValue"] intValue];
            
            // 납기 내후에 따라 강조 처리
            if ( intBeforeDate > intPayDate )
            {
                [view1 setHidden:NO];
            }
            else
            {
                [view2 setHidden:NO];
            }
            
            NSString *strAmount = [NSString stringWithFormat:@"%d", [[aDataSet objectForKey:@"과세표준금액"] intValue]];
            strAmount = [SHBUtility normalStringTocommaString:strAmount];
            
            NSString *strDayTime = [NSString stringWithFormat:@"%@(%@)", [aDataSet objectForKey:@"납부일시1"], [aDataSet objectForKey:@"납부일시2"]];
            
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", strAmount] forKey:@"과세표준금액원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", [aDataSet objectForKey:@"납부금액"]] forKey:@"납부금액원"];
            [aDataSet setObject:strDayTime forKey:@"납부일시"];
        }
    }
    // 구 지방세의 경우
    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0322"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            NSString *strAmount = [NSString stringWithFormat:@"%d", [[aDataSet objectForKey:@"과세표준"] intValue]];
            strAmount = [SHBUtility normalStringTocommaString:strAmount];
            
            NSString *strDayTime = [NSString stringWithFormat:@"%@(%@)", [aDataSet objectForKey:@"납부일시1"], [aDataSet objectForKey:@"납부일시2"]];
            
            [aDataSet setObject:[aDataSet objectForKey:@"과세사항"] forKey:@"과세대상"];
            [aDataSet setObject:[aDataSet objectForKey:@"과목->display"] forKey:@"세목명"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", strAmount] forKey:@"과세표준금액원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", [aDataSet objectForKey:@"납부금액"]] forKey:@"납부금액원"];
            [aDataSet setObject:strDayTime forKey:@"납부일시"];
        }
    }    
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"지방세납부내역조회";
    
    
    AppInfo.isNeedBackWhenError = YES;
    
    OFDataSet *aDataSet = nil;
    
    int intServiceID = LOCAL_TAX_NEW_DETAIL;
    
    if ( [[dicDataDictionary objectForKey:@"신구구분"] isEqualToString:@"NEW"] )
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : @"2000",
                     @"거래구분코드" : @"533002",
                     @"이용기관지로번호" : [self.dicDataDictionary objectForKey:@"이용기관지로번호1"],
                     @"조회구분" : @"E",
                     @"전자납부번호" : [self.dicDataDictionary objectForKey:@"전자납부번호"]
                     }] autorelease];
    }
    else
    {
        intServiceID = LOCAL_TAX_OLD_DETAIL;
        
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"이용기관지로번호" : @"111000135",
                     @"전자납부번호" : [self.dicDataDictionary objectForKey:@"전자납부번호"],
                     //@"납부자주민번호" : AppInfo.ssn
                     //@"납부자주민번호" : [AppInfo getPersonalPK],
                     @"납부자주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                     }] autorelease];
        
    }
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: intServiceID viewController: self ] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
