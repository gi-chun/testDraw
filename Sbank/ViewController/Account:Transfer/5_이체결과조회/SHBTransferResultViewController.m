//
//  SHBTransferResultViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTransferResultViewController.h"
#import "SHBFreqTransferRegComfirm2ViewController.h"
#import "SHBAccountService.h"

@interface SHBTransferResultViewController ()
{
    int serviceType;
    SHBPopupView *popupView;
    BOOL isRegTransfer;
    
    CGFloat popupViewY;
}
@property (nonatomic, retain) SHBPopupView *popupView;
@end

@implementation SHBTransferResultViewController
@synthesize infoDic;
@synthesize popupView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            _txtFaxNo.text = @"";
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 101:   // 스피드이체등록
        {
            if(isRegTransfer)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"이미 등록하였습니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            serviceType = 1;
            
            NSDictionary *dic = @{
            @"입금계좌별명" : self.infoDic[@"입금계좌성명"],
            @"출금계좌번호" : self.infoDic[@"출금계좌번호"],
            @"입금은행" : [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]],
            @"입금은행코드" : self.infoDic[@"입금은행코드"],
            @"입금계좌번호" : self.infoDic[@"입금계좌번호"],
            @"입금자명" : self.infoDic[@"입금계좌성명"],
            @"이체금액" : self.infoDic[@"이체금액"],
            @"받는분통장메모" : [self.infoDic[@"입금계좌통장메모"] isEqualToString:@""] ? self.infoDic[@"출금계좌성명"] : self.infoDic[@"입금계좌통장메모"],
            @"보내는분통장메모" : [self.infoDic[@"출금계좌통장메모"] isEqualToString:@""] ? self.infoDic[@"입금계좌성명"] : self.infoDic[@"출금계좌통장메모"],
            };
            
            SHBFreqTransferRegComfirm2ViewController *nextViewController = [[[SHBFreqTransferRegComfirm2ViewController alloc] initWithNibName:@"SHBFreqTransferRegComfirm2ViewController" bundle:nil] autorelease];
            nextViewController.data = dic;
            nextViewController.pViewController = self;
            nextViewController.pSelector = @selector(regFreqTransfer);
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 200:
        {
            [self.navigationController fadePopViewController];
        }
            break;
        case 300:
        {
            if(_txtFaxNo.text == nil || [_txtFaxNo.text length] == 0 || [_txtFaxNo.text length] > 20 || [_txtFaxNo.text length] <= 8)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"'수신자 팩스번호' 입력값이 유효하지 않습니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }

            // 계좌 종류 구분
            NSString *strAccNo1 = [self.infoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strAccNo2 = [self.infoDic[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSString *strBankName = _lblData04.text;
            
            NSString *strAccountNumber1 = @"";      // 출금계좌번호
            NSString *strAccountNumber2 = @"";      // 입금계좌번호
            
            // 출금계좌의 경우는 * 처리
            if([strAccNo1 length] == 11)       // 당행 11자리
            {
                strAccountNumber1 = [NSString stringWithFormat:@"%@-***%@", [self.infoDic[@"출금계좌번호"] substringToIndex:6], [self.infoDic[@"출금계좌번호"] substringFromIndex:10]];
                
            }
            else                // 당행 11자리가 아닌 경우
            {
                strAccountNumber1 = [NSString stringWithFormat:@"%@***%@", [self.infoDic[@"출금계좌번호"] substringToIndex:4], [self.infoDic[@"출금계좌번호"] substringFromIndex:7]];
            }
            
            // 입금계좌의 경우는 당행의 경우 * 처리, 타행의 경우 미처리
            // 1:당행, 2:타행
            if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구조흥은행"])
            {   
                // 입금계좌
                if([strAccNo2 length] == 11)       // 당행 11자리
                {
                    strAccountNumber2 = [NSString stringWithFormat:@"%@***%@", [self.infoDic[@"입금계좌번호"] substringToIndex:5], [self.infoDic[@"입금계좌번호"] substringFromIndex:8]];
                    
                }
                else                // 당행 11자리가 아닌 경우
                {
                    strAccountNumber2 = [NSString stringWithFormat:@"%@***%@", [self.infoDic[@"입금계좌번호"] substringToIndex:3], [self.infoDic[@"입금계좌번호"] substringFromIndex:6]];
                }
            }
            else            // 타행의 경우
            {
                //strAccountNumber2 = self.infoDic[@"입금계좌번호"];  // 타행도 같게 처리 2013.12.20 요청(정과장님)
                 strAccountNumber2 = [NSString stringWithFormat:@"%@***%@", [self.infoDic[@"입금계좌번호"] substringToIndex:3], [self.infoDic[@"입금계좌번호"] substringFromIndex:6]];
            }
            
            NSString *FaxData = @"";
            
            if([[AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]] isEqualToString:@"한미은행"])
            {
                FaxData = [NSString stringWithFormat:@"%@|%@ %@|%@|%@|%@|%@|%@|%@|씨티은행 %@|%@|%@|%@|%@|%@|%@",
                           [_txtFaxNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                           AppInfo.tran_Date,
                           AppInfo.tran_Time,
                           self.infoDic[@"거래일자"],
                           self.infoDic[@"거래시간"],
                           self.infoDic[@"이용매체"],
                           self.infoDic[@"출금계좌성명"],
                           self.infoDic[@"입금계좌성명"],
//                           self.infoDic[@"출금계좌번호"],
                           strAccountNumber1,       // 출금계좌번호
//                           self.infoDic[@"입금계좌번호"],
                           strAccountNumber2,       // 입금계좌번호
                           self.infoDic[@"타행처리번호"],
                           self.infoDic[@"CMS코드"],
                           self.infoDic[@"수수료"],	
                           self.infoDic[@"이체금액"],
                           self.infoDic[@"출금계좌통장메모"], 
                           self.infoDic[@"입금계좌통장메모"]];
            }
            else
            {
                FaxData = [NSString stringWithFormat:@"%@|%@ %@|%@|%@|%@|%@|%@|%@|%@ %@|%@|%@|%@|%@|%@|%@",
                           _txtFaxNo.text,
                           AppInfo.tran_Date,
                           AppInfo.tran_Time,
                           self.infoDic[@"거래일자"],
                           self.infoDic[@"거래시간"],
                           self.infoDic[@"이용매체"],
                           self.infoDic[@"출금계좌성명"],
                           self.infoDic[@"입금계좌성명"],
//                           self.infoDic[@"출금계좌번호"],
                           strAccountNumber1,       // 출금계좌번호
                           [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]],
//                           self.infoDic[@"입금계좌번호"],
                           strAccountNumber2,       // 입금계좌번호
                           self.infoDic[@"타행처리번호"],
                           self.infoDic[@"CMS코드"],
                           self.infoDic[@"수수료"],
                           self.infoDic[@"이체금액"],
                           self.infoDic[@"출금계좌통장메모"],
                           self.infoDic[@"입금계좌통장메모"]];
                
            }
            
            serviceType = 0;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E4900" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"템플릿아이디" : @"SRIB0801",
                                    @"전송요청시간" : [NSString stringWithFormat:@"%@%@",
                                                 [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                                                 [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""]],
                                    @"수신주소" : _txtFaxNo.text,
                                    @"거래채널구분" : @"3",
                                    @"데이터길이" : @"1023",
                                    @"팩스데이터" : FaxData,
                                    }] autorelease];
            
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        case 400:
        {
            [popupView closePopupViewWithButton:nil];
        }
            break;
        case 500:
        {
            serviceType = 2;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D4200" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"에러코드" : self.infoDic[@"결과코드"],
                                    }] autorelease];
            
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.service = nil;

    switch (serviceType) {
        case 0:
        {
            [popupView closePopupViewWithButton:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"이체확인증이 팩스로 전송되었습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
            [alert release];
        }
            break;
        case 1:
        {
            _btnRegTransfer.enabled = NO;
            
            NSString *strMessage = [NSString stringWithFormat:@"스피드이체가 등록되었습니다."];
            
            if(![_lblData11.text isEqualToString:@""])
            {
                strMessage = [NSString stringWithFormat:@"스피드이체가 등록되었습니다.\n\n(CMS코드는 스피드이체정보에 저장되지 않습니다.)"];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:strMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
            break;
        case 2:
        {
            NSString *strMessage = [NSString stringWithFormat:@"%@\n%@ %@ %@", self.infoDic[@"결과코드"], aDataSet[@"에러메세지1"], aDataSet[@"에러메세지2"], aDataSet[@"에러메세지3"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류코드조회"
                                                            message:strMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}

- (void)regFreqTransfer
{
    isRegTransfer = YES;
    _btnRegTransfer.enabled = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 100 && buttonIndex == 0) {
        [self.navigationController fadePopToRootViewController];
	}
}

#pragma mark - SHBListPopupViewDelegate
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary*)mDic
{
    
}

- (void)popupViewDidCancel
{
    
}


#pragma mark -
#pragma mark SHBTextFieldDelegate

- (void)didPrevButtonTouch          // 이전버튼
{
    
}

- (void)didNextButtonTouch          // 다음버튼
{
    
}

- (void)didCompleteButtonTouch      // 완료버튼
{
    [_txtFaxNo resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    curTextField = textField;
    
    [(SHBTextField *)curTextField enableAccButtons:NO Next:NO];
    
    if([curTextField respondsToSelector:@selector(focusSetWithLoss:)])
    {
        [(SHBTextField *)curTextField focusSetWithLoss:YES];
    }
    
    displayKeyboard = YES;
    
    CGRect frame = popupView.frame;
    popupViewY = frame.origin.y;
    frame.origin.y -= 44;
    [popupView setFrame:frame];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [(SHBTextField *)curTextField focusSetWithLoss:NO];
    
    displayKeyboard = NO;
    
    CGRect frame = popupView.frame;
    frame.origin.y = popupViewY;
    [popupView setFrame:frame];
}

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"이체결과조회";

    NSLog(@"%@", self.infoDic);
    
    popupView = [[SHBPopupView alloc] initWithTitle:@"FAX 전송" subView:_faxInfoView];
    popupView.delegate = self;
    
    isRegTransfer = NO;
    
    _lblData01.text = [NSString stringWithFormat:@"%@ %@", self.infoDic[@"거래일자"], self.infoDic[@"거래시간"]];
    _lblData02.text = self.infoDic[@"결과코드"];
    _lblData03.text = self.infoDic[@"출금계좌번호"];
    _lblData04.text = [AppInfo.codeList bankNameFromCode:self.infoDic[@"입금은행코드"]];
    _lblData05.text = self.infoDic[@"입금계좌번호"];
    _lblData06.text = self.infoDic[@"입금계좌성명"];
    _lblData07.text = [NSString stringWithFormat:@"%@ 원", self.infoDic[@"이체금액"]];
    _lblData08.text = [NSString stringWithFormat:@"%@ 원", self.infoDic[@"수수료"]];
    _lblData09.text = self.infoDic[@"입금계좌통장메모"]; //[self.infoDic[@"입금계좌통장메모"] isEqualToString:@""] ? self.infoDic[@"출금계좌성명"] : self.infoDic[@"입금계좌통장메모"];
    _lblData10.text = self.infoDic[@"출금계좌통장메모"]; //[self.infoDic[@"출금계좌통장메모"] isEqualToString:@""] ? self.infoDic[@"입금계좌성명"] : self.infoDic[@"출금계좌통장메모"];
    _lblData11.text = self.infoDic[@"CMS코드"];
    
	if ([self.infoDic[@"결과코드"] isEqualToString:@"정상"])
    {
        _btnRegTransfer.hidden = NO;
        _lblCaption.hidden = NO;
    }
    else
    {
        [_btnFaxSend setTitle:@"오류코드조회" forState:UIControlStateNormal];
        _btnFaxSend.tag = 500;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_faxInfoView release];
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [_lblData10 release];
    [_lblData11 release];
    [_lblCaption release];
    [_btnFaxSend release];
    [_txtFaxNo release];
    [_btnRegTransfer release];
    [_btnOK release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setFaxInfoView:nil];
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [self setLblData10:nil];
    [self setLblData11:nil];
    [self setLblCaption:nil];
    
    [self setBtnFaxSend:nil];
    [self setTxtFaxNo:nil];
    [self setBtnRegTransfer:nil];
    [self setBtnOK:nil];
    [super viewDidUnload];
}
@end
