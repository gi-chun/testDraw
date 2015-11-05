//
//  SHBUserInfoEditSIDViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserInfoEditSIDViewController.h"
#import "SHBUtility.h"

#import "SHBIdentity1ViewController.h" // 본인 휴대폰 인증

@interface SHBUserInfoEditSIDViewController () <SHBIdentity1Delegate>

@property (retain, nonatomic) NSString *encriptedData;

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBUserInfoEditSIDViewController

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
    
    [self setTitle:@"고객정보변경"];
    self.strBackButtonTitle = @"고객정보변경 1단계";
    
    startTextFieldTag = 30300;
    endTextFieldTag = 30301;
    
    // 주민등록번호 뒷자리
    [_jumin2 showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:7];
    
    CGFloat y = _info.frame.origin.y;
    
    [self adjustToView:_info originX:_info.frame.origin.x originY:y text:_info.text];
    
    y += _info.frame.size.height + 5;
    
    [_bgBox setFrame:CGRectMake(_bgBox.frame.origin.x,
                                _bgBox.frame.origin.y,
                                _bgBox.frame.size.width,
                                y - _bgBox.frame.origin.y)];
    
    [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x,
                                     _bgBox.frame.origin.y + _bgBox.frame.size.height,
                                     _bottomView.frame.size.width,
                                     _bottomView.frame.size.height)];
    
    //2014.07.24 주민번호 입력 방지법에 의해 화면 건뜀
    //[self.view setHidden:YES];
    
    AppInfo.transferDic = @{ @"서비스코드" : @"C2310" };
    
    SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
    [viewController setServiceSeq:SERVICE_USER_INFO];
    [viewController setNeedsLogin:YES];
    viewController.delegate = self;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
    [viewController executeWithTitle:@"고객정보변경" Step:1 StepCnt:6 NextControllerName:@"SHBUserInfoEditSecurityViewController"];
    [viewController subTitle:@"추가인증 방법 선택"];
    [viewController release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.encriptedData = nil;
    
    [_jumin1 release];
    [_jumin2 release];
    [_bgBox release];
    [_info release];
    [_bottomView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setJumin1:nil];
    [self setJumin2:nil];
    [self setBgBox:nil];
    [self setInfo:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:13]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - Button

/// 계좌비밀번호
- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_jumin2 becomeFirstResponder];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_jumin1.text length] < 6) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"주민등록번호 13자리를 입력해 주십시오."];
        return;
    }
    
    if ([_jumin2.text length] < 7) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"주민등록번호 13자리를 입력해 주십시오."];
        return;
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"주민번호1" : _jumin1.text,
                           @"주민번호2" : _encriptedData,
                           @"DMLFL" : @"SC",
                           }];
    
    SendData(SHBTRTypeRequst, nil, LOGIN_CID_CHECK_URL, self, dataSet);
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    Debug(@"%@", dataSet);
    
    if (![dataSet[@"result"] isEqualToString:@"true"]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"본인정보가 일치하지 않습니다."];
        
        return;
    }
    
    [_jumin1 setText:@""];
    [_jumin2 setText:@""];
    
    /*
    SHBMobileCertificateViewController *viewController = [[[SHBMobileCertificateViewController alloc] initWithNibName:@"SHBMobileCertificateViewController" bundle:nil] autorelease];
    
    [viewController setNeedsLogin:YES];
    [viewController setServiceSeq:SERVICE_USER_INFO];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    [viewController executeWithTitle:@"고객정보변경"
                            subTitle:@"본인 휴대폰 인증"
                                step:2
                           stepCount:6
                       infoViewCount:MOBILE_INFOVIEW_1
                  nextViewController:@"SHBUserInfoEditSecurityViewController"];
     */
    
    AppInfo.transferDic = @{ @"서비스코드" : @"C2310" };
    
    SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
    [viewController setServiceSeq:SERVICE_USER_INFO];
    [viewController setNeedsLogin:YES];
    viewController.delegate = self;
     [self checkLoginBeforePushViewController:viewController animated:YES];
    
    // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
    [viewController executeWithTitle:@"고객정보변경" Step:2 StepCnt:6 NextControllerName:@"SHBUserInfoEditSecurityViewController"];
    [viewController subTitle:@"추가인증 방법 선택"];
    [viewController release];
}

#pragma mark - TextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == _jumin1) {
        if ([textField.text length] >= 6 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _jumin2) {
            if ([textField.text length] >= 7 && range.length == 0) {
                return NO;
            }
        }
	
    
    return YES;
}

#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedData = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
}

@end
