//
//  SHBPrimiumInfoViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPrimiumInfoViewController.h"
#import "SHBDepositInfoInputViewController.h"
#import "SHBPrimiumTransferViewController.h"

@interface SHBPrimiumInfoViewController ()

@end

@implementation SHBPrimiumInfoViewController
@synthesize accInfoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:   // 출금
        {
            SHBPrimiumTransferViewController *nextViewController = [[[SHBPrimiumTransferViewController alloc] initWithNibName:@"SHBPrimiumTransferViewController" bundle:nil] autorelease];
            nextViewController.outAccInfoDic = self.accInfoDic;
            [self.navigationController pushFadeViewController:nextViewController];
            
        }
            break;
        case 200:   // 입금
        {
            SHBDepositInfoInputViewController *nextViewController = [[[SHBDepositInfoInputViewController alloc] initWithNibName:@"SHBDepositInfoInputViewController" bundle:nil] autorelease];
            nextViewController.inAccInfoDic = self.accInfoDic;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    _lblData05.text = [NSString stringWithFormat:@"%@%%",aDataSet[@"연세전수익률"]];
    _lblData06.text = [NSString stringWithFormat:@"%@%%", aDataSet[@"연보수율"]];
    
    return NO;
}

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
    
    self.title = @"즉시이체/예금입금";
    self.strBackButtonTitle = @"마케프리미엄 신탁 계좌정보";

    _lblData01.text = self.accInfoDic[@"계좌번호"];
    _lblData02.text = self.accInfoDic[@"계좌정보상세"][@"신규일자"];
    _lblData03.text = self.accInfoDic[@"계좌정보상세"][@"만기일자"];
    _lblData04.text = self.accInfoDic[@"잔액"];
    _lblData05.text = @"0.0%";
    _lblData06.text = @"0.0%";
    
	if([self.accInfoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁"] ||
	   [self.accInfoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁(개인용)"] ||
	   [self.accInfoDic[@"계좌명"] isEqualToString:@"나이스프리미엄신탁(4등급)"] ||
	   [self.accInfoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁-법인용(5등급)"] ||
	   [self.accInfoDic[@"계좌명"] isEqualToString:@"마켓프리미엄신탁-개인용(5등급)"])
	{
		_btnOut.hidden = NO;
	}
    else
    {
		_btnOut.hidden = YES;
        _btnIn.frame = CGRectMake(83.0f, 0.0f, 150.0f, 29.0f);
        [_btnIn setNeedsDisplay];
    }
    
	if([self.accInfoDic[@"계좌정보상세"][@"예금종류"] isEqualToString:@"3"] &&
	   [self.accInfoDic[@"계좌정보상세"][@"입금가능여부"] isEqualToString:@"1"] )
	{
		_btnIn.hidden = NO;
	}
    else
    {
		_btnIn.hidden = YES;
        _btnOut.frame = CGRectMake(83.0f, 0.0f, 150.0f, 29.0f);
        [_btnOut setNeedsDisplay];
    }
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2035" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                 @"계좌번호" : self.accInfoDic[@"계좌번호"],
                                 @"은행구분" : self.accInfoDic[@"은행구분"],
                                 @"거래일자" : AppInfo.tran_Date,
                                 }] autorelease];
    [self.service start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_btnOut release];
    [_btnIn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setBtnOut:nil];
    [self setBtnIn:nil];
    [super viewDidUnload];
}
@end
