//
//  SHBForexRequestStipulationViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 10. 28..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestStipulationViewController.h"
#import "SHBExchangeService.h" // 서비스

#import "SHBForexRequestCouponInputViewController.h" // 외화환전신청 정보입력(1)
#import "SHBNewProductSeeStipulationViewController.h" // 약관

@interface SHBForexRequestStipulationViewController ()
{
    BOOL isSee1; // 외환거래 기본약관 보기
    BOOL isSee2; // 개인(신용)정보 수집,이용 동의서 보기
}

@property (retain, nonatomic) NSArray *collectionList;

@end

@implementation SHBForexRequestStipulationViewController

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
    
    [self setTitle:@"외화환전신청"];
    self.strBackButtonTitle = @"외화환전신청 2단계";
    
    [self.contentScrollView addSubview:_contentView];
    [self.contentScrollView setContentSize:_contentView.frame.size];
    
    self.collectionList = @[ _useEssentialCollection, _useSelectCollection, _useInherentCollection,
                             _provideEssentialCollection, _provideSelectCollection, _provideInherentCollection ];
    
    isSee1 = NO;
    isSee2 = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCouponDic = nil;
    self.collectionList = nil;
    
    [_contentView release];
    [_agree1 release];
    [_agree2 release];
    [_useEssentialCollection release];
    [_useSelectCollection release];
    [_useInherentCollection release];
    [_provideEssentialCollection release];
    [_provideSelectCollection release];
    [_provideInherentCollection release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setAgree1:nil];
    [self setAgree2:nil];
    [self setUseEssentialCollection:nil];
    [self setUseSelectCollection:nil];
    [self setUseInherentCollection:nil];
    [self setProvideEssentialCollection:nil];
    [self setProvideSelectCollection:nil];
    [self setProvideInherentCollection:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(UIButton *)sender
{
    switch ([sender tag]) {
        case 11: // 외환거래 기본약관 (보기)
        {
            isSee1 = YES;
            
            NSString *strUrl;
            
            if (!AppInfo.realServer)
            {
                strUrl = [NSString stringWithFormat:@"%@sbank_exchange_yak.html", URL_YAK_TEST];
            }
            else{
                strUrl = [NSString stringWithFormat:@"%@sbank_exchange_yak.html", URL_YAK];
            }
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strUrl;
            viewController.strName = @"외화환전신청";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 12: // 외횐거래 기본약관 (예, 동의합니다.)
        {
            [_agree1 setSelected:![_agree1 isSelected]];
        }
            break;
        case 21: // 유의사항 안내 및 동의 (예, 동의합니다.)
        {
            [_agree2 setSelected:![_agree2 isSelected]];
        }
            break;
        case 31: // 개인(신용)정보 수집,이용 동의서 (보기)
        {
            isSee2 = YES;
            
            NSString *strUrl;
            
            if (!AppInfo.realServer)
            {
                strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK_TEST];
            }
            else
            {
                strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK];
            }
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strUrl;
            viewController.strName = @"외화환전신청";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 111: // 1. 필수적 정보 (동의함)
        case 112: // 1. 필수적 정보 (동의하지 못함)
        case 121: // 1. 선택적 정보 (동의함)
        case 122: // 1. 선택적 정보 (동의하지 못함)
        case 131: // 2. 고유식별정보 (동의함)
        case 132: // 2. 고유식별정보 (동의하지 못함)
        case 141: // 3. 필수적 정보 (동의함)
        case 142: // 3. 필수적 정보 (동의하지 못함)
        case 151: // 3. 선택적 정보 (동의함)
        case 152: // 3. 선택적 정보 (동의하지 못함)
        case 161: // 4. 고유식별정보 (동의함)
        case 162: // 4. 고유식별정보 (동의하지 못함)
        {
            NSUInteger index = ([sender tag] / 10) - 11;
            
            for (UIButton *button in _collectionList[index]) {
                
                [button setSelected:NO];
            }
            
            [sender setSelected:YES];
        }
            break;
        case 201: // 확인
        {
            if (!isSee1) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"외환거래 기본약관 보기를 선택하여 확인하시기 바랍니다."];
                return;
            }
            
            if (![_agree1 isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"외환거래 기본약관에 동의하셔야 합니다."];
                return;
            }
            
            if (![_agree2 isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"유의사항에 동의하셔야 합니다."];
                return;
            }
            
            if (!isSee2) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"개인(신용)정보 수집,이용,제공 동의서(금융거래설정 등) 및 고객권리 안내문 보기를 선택하여 확인하시기 바랍니다."];
                return;
            }
            
            if (![_useEssentialCollection[0] isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"1번 필수적 정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            if (![_useInherentCollection[0] isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            if (![_provideEssentialCollection[0] isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"3번 필수적 정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            if (![_provideInherentCollection[0] isSelected]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"4번 고유식별정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            SHBForexRequestCouponInputViewController *viewController = [[[SHBForexRequestCouponInputViewController alloc] initWithNibName:@"SHBForexRequestCouponInputViewController" bundle:nil] autorelease];
            
            viewController.selectCouponDic = _selectCouponDic;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 202: // 취소
        {
            [self.navigationController fadePopViewController];
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
    return YES;
}

@end
