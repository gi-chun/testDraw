//
//  SHBEasyCloseCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseCompleteViewController.h"
#import "SHBNewProductNoLineRowView.h"

#import "SHBNewProductInfoViewController.h" // 상품신규 안내
#import "SHBELD_BA17_3ViewController.h" // ELD상품 안내

@interface SHBEasyCloseCompleteViewController ()

@property (nonatomic, retain) NSMutableArray *payment; // 지급항목
@property (nonatomic, retain) NSMutableArray *deduction; // 공제항목

@end

@implementation SHBEasyCloseCompleteViewController

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
    [self navigationBackButtonHidden];
    
    [self setDefaultData];
    [self setUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.smartNewDic = nil;
    
	self.payment = nil;
    self.deduction = nil;
    
    [_okBtn release];
    [_smartNewView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setOkBtn:nil];
    [self setSmartNewView:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)setDefaultData
{
	// 지급항목
	self.payment = [NSMutableArray array];
    
	for (NSInteger i = 0; i < 9; i++) {
        
		NSString *strTitle = self.data[[NSString stringWithFormat:@"지급항목%d", i + 1]];
		NSString *strValue = self.data[[NSString stringWithFormat:@"지급내용%d", i + 1]];
		
		if ([strTitle length] > 0 && [strValue length] > 0) {
            
			NSDictionary *dic = @{ @"title" : strTitle, @"value" : strValue };
			[_payment addObject:dic];
		}
	}
	
	// 공제항목
	self.deduction = [NSMutableArray array];
    
	for (NSInteger i = 0; i < 9; i++) {
        
		NSString *strTitle = self.data[[NSString stringWithFormat:@"공제항목%d", i + 1]];
		NSString *strValue = self.data[[NSString stringWithFormat:@"공제내용%d", i + 1]];
		
		if ([strTitle length] > 0 && [strValue length] > 0) {
            
			NSDictionary *dic = @{ @"title" : strTitle, @"value" : strValue };
			[_deduction addObject:dic];
		}
	}
}

- (void)setUI
{
    CGFloat fCurrHeight = 55;
    
	UIView *focusView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	[focusView setBackgroundColor:RGB(235, 217, 195)];
	[self.contentScrollView addSubview:focusView];
    
	// 원금 및 이자내역 ~ 공제내역
	for (NSInteger i = 0; i < 4; i++) {
		
		if (i == 0) {
            
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 10
                                                                                             title:@"원금 및 이자내역"
                                                                                             value:nil] autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
		}
		else if (i == 1) {
            
			SInt64 total = 0;
            
			for (NSDictionary *dic in _payment) {
                
				NSString *strTitle = dic[@"title"];
				NSString *strValue = [NSString stringWithFormat:@"%@원", dic[@"value"]];
                
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25
                                                                                                 title:strTitle
                                                                                                 value:strValue] autorelease];
				[self.contentScrollView addSubview:row];
				
				total += [[SHBUtility commaStringToNormalString:strValue] longLongValue];
			}
			
            NSString *money = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", total]]];
            
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25
                                                                                             title:@"원금 및 이자합계"
                                                                                             value:money] autorelease];
			[self.contentScrollView addSubview:row];
		}
		else if (i == 2) {
            
			FrameReposition(focusView, 0, fCurrHeight);
            
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25
                                                                                             title:@"공제 내역"
                                                                                             value:nil] autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
		}
		else if (i == 3) {
            
			for (NSDictionary *dic in _deduction) {
                
				NSString *strTitle = dic[@"title"];
				NSString *strValue = [NSString stringWithFormat:@"%@원", dic[@"value"]];
                
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25
                                                                                                 title:strTitle
                                                                                                 value:strValue] autorelease];
				[self.contentScrollView addSubview:row];
			}
			
            NSString *money = [NSString stringWithFormat:@"%@원", self.data[@"총공제액"]];
            
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25
                                                                                             title:@"공제합계"
                                                                                             value:money] autorelease];
            [row.lblTitle setTextColor:RGB(0, 137, 220)];
            [row.lblValue setTextColor:RGB(0, 137, 220)];
			[self.contentScrollView addSubview:row];
		}
	}
    
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, fCurrHeight += 25, 317, 1)] autorelease];
    [lineView setBackgroundColor:RGB(209, 209, 209)];
    [self.contentScrollView addSubview:lineView];
    
    fCurrHeight -= 19;
    
    for (int i = 0; i < 3; i++) {
        
        SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight += 25] autorelease];
        [self.contentScrollView addSubview:row];
        
        if (i == 0) {
            
            fCurrHeight -= 10;
            
            [row.lblTitle setText:@"받으시는 금액"];
            
            FrameResize(row.lblTitle, 301, height(row.lblTitle));
        }
        else if (i == 1) {
            
            [row.lblTitle setFont:[UIFont systemFontOfSize:13]];
            [row.lblTitle setText:@"(원금 및 이자 합계금액-공제합계금액)"];
            
            FrameResize(row.lblTitle, 301, height(row.lblTitle));
        }
        else if (i == 2) {
            
            [row.lblValue setText:[NSString stringWithFormat:@"%@원", self.data[@"실수령액"]]];
        }
    }
    
    fCurrHeight += 15 + 5;
    
    UIView *lineView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, fCurrHeight += 10, 317, 1)] autorelease];
    [lineView2 setBackgroundColor:RGB(209, 209, 209)];
    [self.contentScrollView addSubview:lineView2];
    
    if (_smartNewDic) {
        
        [_okBtn setHidden:YES];
        
        FrameReposition(_smartNewView, 0, fCurrHeight);
        [self.contentScrollView addSubview:_smartNewView];
        
        [self.contentScrollView setContentSize:CGSizeMake(317, fCurrHeight + _smartNewView.frame.size.height)];
    }
    else {
        
        FrameReposition(_okBtn, 83, fCurrHeight += 20);
        
        [self.contentScrollView setContentSize:CGSizeMake(317, fCurrHeight + 29 + 20)];
    }
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        case 200: {
            
            // 스마트신규 추천 내역
            
            // SHBSmartNewListViewController, SHBNoticeSmartNewViewController 동일하게 수정 필요
            
            if ([_smartNewDic[@"인터넷신규여부"] isEqualToString:@"1"] && [_smartNewDic[@"모바일신규여부"] isEqualToString:@"0"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"선택하신 상품은 인터넷뱅킹에서만 가능한 상품입니다."];
                return;
            }
            
            if ([_smartNewDic[@"일인일계좌가입여부"] isEqualToString:@"1"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"해당 상품은 1인 1계좌만 가입 가능합니다. 기 가입여부를 확인하세요.\n※ 만기일자 이후 또는 기 가입계좌 해지 후 실행하시기 바랍니다."];
                return;
            }
            
            if ([_smartNewDic[@"상품코드"] length] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"신한S뱅크에서 미판매중인 상품입니다."];
                return;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                       @"productCode" : [SHBUtility nilToString:_smartNewDic[@"상품코드"]],
                                                                              		   @"recStaffNo" : [SHBUtility nilToString:_smartNewDic[@"등록직원"]],
                                                                                       @"_등록직원" : [SHBUtility nilToString:_smartNewDic[@"등록직원"]],
                                                                                       @"_등록직원명" : [SHBUtility nilToString:_smartNewDic[@"등록직원명"]],
                                                                                       @"_등록지점" : [SHBUtility nilToString:_smartNewDic[@"등록지점"]],
                                                                                       @"_등록지점명" : [SHBUtility nilToString:_smartNewDic[@"등록지점명"]],
                                                                                       @"_스마트신규금액" : [SHBUtility nilToString:_smartNewDic[@"신규금액"]],
                                                                            		   @"_스마트신규이자지급방법" : [SHBUtility nilToString:_smartNewDic[@"이자지급방법"]],
                                                                            		   @"_스마트신규지급주기" : [SHBUtility nilToString:_smartNewDic[@"지급주기"]]
                                                                                       }];
            
            if ([_smartNewDic[@"상품코드"] hasPrefix:@"209"]) {
                
                // ELD 상품
                
                SHBELD_BA17_3ViewController *viewController = [[[SHBELD_BA17_3ViewController alloc] initWithNibName:@"SHBELD_BA17_3ViewController" bundle:nil] autorelease];
                
                [viewController executeWithDic:dic];
                [self checkLoginBeforePushViewController:viewController animated:YES];
                
                return;
            }
            
            SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
            
            viewController.mdicPushInfo = dic;
            viewController.dicSmartNewData = _smartNewDic;
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
