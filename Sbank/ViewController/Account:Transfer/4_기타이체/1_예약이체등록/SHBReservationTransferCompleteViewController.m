//
//  SHBReservationTransferCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservationTransferCompleteViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBReservationTransferCompleteViewController ()
{
    BOOL isRegAccNo;
}
@end

@implementation SHBReservationTransferCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 100:   // 자주쓰는 계좌등록
        {
            if(isRegAccNo)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"이미등록된 계좌입니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            if([_lblData03.text isEqualToString:@"43501001190"] ||
               [_lblData03.text isEqualToString:@"34401162030"] ||
               [_lblData03.text isEqualToString:@"34401199090"] ||
               [_lblData03.text isEqualToString:@"34401093320"] ||
               [_lblData03.text isEqualToString:@"34401197940"] ||
               [_lblData03.text isEqualToString:@"38301000178"] ||
               [_lblData03.text isEqualToString:@"34401198298"] ||
               [_lblData03.text isEqualToString:@"36101100263"] ||
               [_lblData03.text isEqualToString:@"36101102088"] ||
               [_lblData03.text isEqualToString:@"36101103459"] ||
               [_lblData03.text isEqualToString:@"31801093322"] ||
               [_lblData03.text isEqualToString:@"30601236928"] ||
               [_lblData03.text isEqualToString:@"34401197933"] ||
               [_lblData03.text isEqualToString:@"36107101326"] ||
               [_lblData03.text isEqualToString:@"100018666254"] ||
               [_lblData03.text isEqualToString:@"100007460611"] ||
               [_lblData03.text isEqualToString:@"100014301031"] ||
               [_lblData03.text isEqualToString:@"100001298169"] ||
               [_lblData03.text isEqualToString:@"100014159385"] ||
               [_lblData03.text isEqualToString:@"100002114914"] ||
               [_lblData03.text isEqualToString:@"100014199383"] ||
               [_lblData03.text isEqualToString:@"100014283415"] ||
               [_lblData03.text isEqualToString:@"100014868899"] ||
               [_lblData03.text isEqualToString:@"100016904551"] ||
               [_lblData03.text isEqualToString:@"100011897988"] ||
               [_lblData03.text isEqualToString:@"100013946245"] ||
               [_lblData03.text isEqualToString:@"100014159378"] ||
               [_lblData03.text isEqualToString:@"150000497880"] )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"증권사계좌번호는 계좌등록할 수 없습니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            int processFlag;
            NSString *strBankName = _lblData02.text;
            NSString *strInAccNo = _lblData03.text;
            
            if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구조흥은행"])
            {
                if([strInAccNo length] == 11)
                {
                    if([strBankName isEqualToString:@"신한은행"])
                    {
                        if([[strInAccNo substringFromIndex:3] hasPrefix:@"99"])
                        {
                            processFlag = 3;
                        }
                        else
                        {
                            processFlag = 1;
                        }
                    }
                    else
                    {
                        processFlag = 3;
                    }
                }
                else if([strInAccNo length] == 14)
                {
                    if([[strInAccNo substringFromIndex:3] hasPrefix:@"901"] || [strInAccNo hasPrefix:@"562"])
                    {
                        processFlag = 3;
                    }
                    else
                    {
                        processFlag = 1;
                    }
                }
                else
                {
                    processFlag = 1;
                }
                if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
                {
                    processFlag = 4;
                }
            }
            else
            {
                processFlag = 2;
            }
            
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                    @"입금계좌번호" : strInAccNo,
                                    @"입금계좌메모" : _lblData04.text,
                                    }];
            
            switch (processFlag)
            {
                case 2:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2233" viewController:self] autorelease];
                    aDataSet[@"출금계좌번호"] = _lblData01.text;
                    break;
                case 3:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2235" viewController:self] autorelease];
                    aDataSet[@"출금계좌번호"] = _lblData01.text;
                    break;
                default:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2231" viewController:self] autorelease];
                    break;
            }
            
            self.service.requestData = aDataSet;
            
            [self.service start];
            [aDataSet release];
        }
            break;
        case 200:   // 확인
        {
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    isRegAccNo = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[NSString stringWithFormat:@"자주쓰는 입금계좌에 등록되었습니다."]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
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
    
    self.title = @"기타이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예약이체 등록완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData02.text = AppInfo.commonDic[@"입금은행"];
    _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData04.text = AppInfo.commonDic[@"수취인성명"];
    _lblData05.text = AppInfo.commonDic[@"이체금액"];
    _lblData06.text = [NSString stringWithFormat:@"%@ %@", AppInfo.commonDic[@"이체예정일자"],  AppInfo.commonDic[@"이체예정시간"]];
    _lblData07.text = AppInfo.commonDic[@"받는통장메모"];
    _lblData08.text = AppInfo.commonDic[@"내통장메모"];
    _lblData09.text = AppInfo.commonDic[@"CMS코드"];
    
    isRegAccNo = NO;
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
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [super viewDidUnload];
}
@end
