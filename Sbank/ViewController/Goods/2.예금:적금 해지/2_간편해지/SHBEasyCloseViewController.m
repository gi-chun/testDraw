//
//  SHBEasyCloseViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseViewController.h"

#import "SHBEasyCloseStipulationViewController.h" // 약관보기
#import "SHBEasyCloseConfirmViewController.h" // 신한e-간편해지 확인

@interface SHBEasyCloseViewController ()
{
    BOOL _isSee;
}

@end

@implementation SHBEasyCloseViewController

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
    
    [self setTitle:@"신한e-간편해지"];
    self.strBackButtonTitle = @"신한e-간편해지 서비스 신청";
    
    _isSee = NO;
    
    [_infoL setText:[NSString stringWithFormat:@"본인은 창구에서 신규한 예적금 [%@]을 귀행의 e-간편 해지 서비스를 이용하여 해지 신청하고, 이때의 해지원리금은 본인 명의의 입출식 계좌로 이체 요청함을 약정합니다. 상기 약정에 동의합니다.", self.data[@"계좌번호"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.smartNewDic = nil;
    
    [_agree1 release];
    [_agree2 release];
    [_infoL release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAgree1:nil];
    [self setAgree2:nil];
    [self setInfoL:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)resetUI
{
    _isSee = NO;
    
    [_agree1 setSelected:NO];
    [_agree2 setSelected:NO];
}

#pragma mark - UIButton

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 보기
            
            _isSee = YES;
            
            SHBEasyCloseStipulationViewController *viewController = [[[SHBEasyCloseStipulationViewController alloc] initWithNibName:@"SHBEasyCloseStipulationViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 200:
        case 300: {
            
            // 예, 동의합니다.
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 400: {
            
            // 확인
            
            if (!_isSee) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"약관보기를 선택하시고 내용을 확인해 주세요."];
                return;
            }
            
            if (![_agree1 isSelected]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"약관을 확인해주시고 동의합니다에 체크해주세요."];
                return;
            }
            
            if (![_agree2 isSelected]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"동의합니다에 체크해주세요."];
                return;
            }
            
            SHBEasyCloseConfirmViewController *viewController = [[[SHBEasyCloseConfirmViewController alloc] initWithNibName:@"SHBEasyCloseConfirmViewController" bundle:nil] autorelease];
            
            viewController.data = self.data;
            
            if (_smartNewDic) {
                
                viewController.smartNewDic = _smartNewDic;
            }
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 500: {
            
            // 취소
            
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

@end
