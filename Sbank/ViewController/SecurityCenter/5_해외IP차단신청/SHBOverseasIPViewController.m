//
//  SHBOverseasIPViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 3. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBOverseasIPViewController.h"

#import "SHBOverseasIPConfirmViewController.h" // 해외IP 차단신청 확인

@interface SHBOverseasIPViewController ()
{
    BOOL isRegist; // 한국인터넷진흥원 등록여부
}

@end

@implementation SHBOverseasIPViewController

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
    
    [self setTitle:@"해외IP 차단신청"];
    self.strBackButtonTitle = @"해외IP 차단신청";
    
    [_contentSV addSubview:_mainView];
    [_contentSV setContentSize:_mainView.frame.size];
    
    [_IPLabel initFrame:_IPLabel.frame];
    [_IPLabel setText:@"<midGray_15>내 IP 주소 : </midGray_15><default_15></default_15>"];
    
    [_registLabel initFrame:_registLabel.frame];
    [_registLabel setText:@"<midGray_15>한국인터넷진흥원 등록여부 : </midGray_15><default_15></default_15>"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_IPLabel release];
    [_registLabel release];
    [_contentSV release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setIPLabel:nil];
    [self setRegistLabel:nil];
    [self setContentSV:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}


#pragma mark - Button

- (void)buttonPressed:(UIButton *)sender
{
    switch ([sender tag]) {
        case 10:
        {
            // 서비스 신청
            
            if (isRegist) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeTwoButton
                                   tag:1110
                                 title:@""
                               message:@"서비스 신청 전 내 IP정보를 확인하십시오. 해외 출국 계획이 있으신 고객님은 출국 전 반드시 영업점에 방문하시어 본 서비스를 해지하셔야만 해외에서 인터넷뱅킹, 스마트뱅킹을 통한 이체/신규/해지 등을 하실 수 있습니다."];
                
                return;
            }
            else {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeTwoButton
                                   tag:2220
                                 title:@""
                               message:@"현재 고객님께서는 해외 IP로 접속 중이십니다. 이 서비스를 신청하시면, 현재 사용중인 PC로 이체/신규/해지 등을 하실 수 없습니다.\n서비스 신청을 하시겠습니까?"];
                
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    /*
    [UIAlertView showAlert:self
                      type:ONFAlertTypeTwoButton
                       tag:3330
                     title:@""
                   message:[NSString stringWithFormat:@"고객님께서는 해외IP 차단 서비스를 %@에 정상적으로 등록하였습니다.", @"2014년 02년 18일"]];
     */
    
    NSString *ip = @"10.25.65.167";
    NSString *regist = @"등록";
    
    [_IPLabel setText:[NSString stringWithFormat:@"<midGray_15>내 IP 주소 : </midGray_15><default_15>%@</default_15>", ip]];
    [_registLabel setText:[NSString stringWithFormat:@"<midGray_15>한국인터넷진흥원 등록여부 : </midGray_15><default_15>%@</default_15>", regist]];
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case 1110:
        {
            if (buttonIndex == 0) {
                SHBOverseasIPConfirmViewController *viewController = [[[SHBOverseasIPConfirmViewController alloc] initWithNibName:@"SHBOverseasIPConfirmViewController" bundle:nil] autorelease];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
            break;
        case 2220:
        {
            if (buttonIndex == 0) {
                SHBOverseasIPConfirmViewController *viewController = [[[SHBOverseasIPConfirmViewController alloc] initWithNibName:@"SHBOverseasIPConfirmViewController" bundle:nil] autorelease];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
            break;
        case 3330:
        {
            [self.navigationController fadePopToRootViewController];
        }
            break;
        default:
            break;
    }
}

@end
