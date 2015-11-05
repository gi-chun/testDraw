//
//  SHBELD_BA17_5ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 24..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_5ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"

#import "SHBELD_BA17_9ViewController.h"
#import "SHBELD_BA17_7ViewController.h"
#import "SHBELD_BA17_10ViewController.h"
#import "SHBELD_BA17_11ViewController.h"

#import "SHB_GoldTech_ManualViewController.h"

@interface SHBELD_BA17_5ViewController ()

- (void)setYPositionWithAddSubview:(UIView *)aView;
- (void)setImageWithViewStretching:(UIImageView *)aImageView imageType:(NSString *)aImageType view:(UIView *)aView;
- (CGFloat)heightOfContentView1:(UIView *)aView;
- (NSInteger)getCustomerTendencyType:(NSString *)typeStr;
- (void)setLayout;

@end

@implementation SHBELD_BA17_5ViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            // 나의 투자성향 알아보기 or 투자성향분석 다시하기
            NSLog(@"나의 투자성향 알아보기 or 투자성향분석 다시하기");
            // BA7로 이동
            
            SHBELD_BA17_7ViewController *viewController = [[[SHBELD_BA17_7ViewController alloc] initWithNibName:@"SHBELD_BA17_7ViewController" bundle:nil] autorelease];
            viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 1:
        {
            // 투자성향분석 원하지 않음
            
            AppInfo.serviceOption = @"BA17_5";
            
            self.service = nil;
            self.service = [[[SHBProductService alloc] initWithServiceId:kD6012Id viewController:self] autorelease];
            self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{ @"성향분석구분" : @"3" }];
            
            [self.service start];
        }
            break;
        case 2:
        {
            // BA17-5-3, BA17-5-4, BA17-8-1, BA17-8-2 가입하기
            
            if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-3"] ||
                [_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-4"])
            {
                
                AppInfo.serviceOption = @"BA17_5";
                
                self.service = nil;
                self.service = [[[SHBProductService alloc] initWithServiceId:kD6012Id viewController:self] autorelease];
                self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{ @"성향분석구분" : @"2" }];
                
                [self.service start];
            }
            else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-1"])
            {
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    SHB_GoldTech_ManualViewController *viewController = [[[SHB_GoldTech_ManualViewController alloc] initWithNibName:@"SHB_GoldTech_ManualViewController" bundle:nil] autorelease];
                    
                    viewController.dicSelectedData = self.viewDataSource;
                    [viewController.dicSelectedData setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                    [viewController.dicSelectedData setObject:[self getInvestment] forKey:@"_고객투자성향"];
                    [viewController.dicSelectedData setObject:[self getOverClass] forKey:@"_초과등급여부"];
                    [viewController.dicSelectedData setObject:[self getDerivativesInvestmentExperience] forKey:@"_파생상품투자경험"];
                    
                    [self checkLoginBeforePushViewController:viewController animated:YES];
                    
                    return;
                }
                
                SHBELD_BA17_11ViewController *viewController = [[[SHBELD_BA17_11ViewController alloc] initWithNibName:@"SHBELD_BA17_11ViewController" bundle:nil] autorelease];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-2"])
            {
                SHBELD_BA17_10ViewController *viewController = [[[SHBELD_BA17_10ViewController alloc] initWithNibName:@"SHBELD_BA17_10ViewController" bundle:nil] autorelease];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    [viewController.viewDataSource setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                    [viewController.viewDataSource setObject:[self getInvestment] forKey:@"_고객투자성향"];
                }
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
            break;
        case 3:
        {
            // 투자성향분석 다시하기
            
            SHBELD_BA17_7ViewController *viewController = [[[SHBELD_BA17_7ViewController alloc] initWithNibName:@"SHBELD_BA17_7ViewController" bundle:nil] autorelease];
            viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        case 4:
        {
            // BA17-6-1, BA17-6-2 가입하기
            
            SHBELD_BA17_9ViewController *viewController = [[[SHBELD_BA17_9ViewController alloc] initWithNibName:@"SHBELD_BA17_9ViewController" bundle:nil] autorelease];
            
            viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
            
            // 골드상품
            if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                
                [viewController.viewDataSource setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                [viewController.viewDataSource setObject:@"0" forKey:@"_초과등급여부"];
                [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_고객투자성향"];
                [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_파생상품투자경험"];
            }
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma Private Methods

- (void)setYPositionWithAddSubview:(UIView *)aView
{
    CGRect rectTemp = aView.frame;
    rectTemp.origin.y = _view1.frame.origin.y + _view1.frame.size.height;
    aView.frame = rectTemp;
    
    [_contentView1 addSubview:aView];
}

- (void)setImageWithViewStretching:(UIImageView *)aImageView imageType:(NSString *)aImageType view:(UIView *)aView
{
    UIImage *image = nil;
    
    if ([aImageType isEqualToString:@"안정형"]) {
        
        image = [UIImage imageNamed:@"invest_case01.png"];  // 이미지
    }
    else if ([aImageType isEqualToString:@"안정추구형"]) {
        
        image = [UIImage imageNamed:@"invest_case02.png"];
    }
    else if ([aImageType isEqualToString:@"위험중립형"]) {
        
        image = [UIImage imageNamed:@"invest_case03.png"];
    }
    else if ([aImageType isEqualToString:@"적극투자형"]) {
        
        image = [UIImage imageNamed:@"invest_case04.png"];
    }
    else if ([aImageType isEqualToString:@"공격투자형"]) {
        
        image = [UIImage imageNamed:@"invest_case05.png"];
    }
    else if ([aImageType isEqualToString:@"설명"]) {
        
        image = [UIImage imageNamed:@"invest_case.png"];
    }
    else {
        
        NSLog(@"imageType을 확인해 주세요.");  // 에러
        return;
    }
    
    aImageView.image = image;
    
    CGRect rectTemp;
    rectTemp = aImageView.frame;
    rectTemp.size.height = image.size.height;
    aImageView.frame = rectTemp;
    
    rectTemp = aView.frame;
    rectTemp.size.height += aImageView.frame.size.height;
    aView.frame = rectTemp;
}

- (CGFloat)heightOfContentView1:(UIView *)aView
{
    return aView.frame.origin.y + aView.frame.size.height;
}

- (NSInteger)getCustomerTendencyType:(NSString *)typeStr
{
    if ([typeStr isEqualToString:@"안정형"]) {
        
        return 5;
    }
    else if ([typeStr isEqualToString:@"안정추구형"]) {
        
        return 4;
    }
    else if ([typeStr isEqualToString:@"위험중립형"]) {
        
        return 3;
    }
    else if ([typeStr isEqualToString:@"적극투자형"]) {
        
        return 2;
    }
    else if ([typeStr isEqualToString:@"공격투자형"]) {
        
        return 1;
    }else {
        return 0;
    }
}

- (void)setLayout
{
    CGRect rectTemp;
    UIView *viewTemp = nil;
    UIImageView *imageViewTemp = nil;
    NSString *imageType = _D6011Dic[@"고객성향유형"];
    
    if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-1"] ||
        [_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-2"]) {
        
        viewTemp = _view2;
        
        UILabel *label = (UILabel *)[viewTemp viewWithTag:310]; // 하단문구
        
        if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-2"]) {
            [label setText:@"고객님의 투자성향 분석 유효기간이 지났습니다.\n투자성향 분석 후 상품가입이 가능합니다."];
        }
        
        imageViewTemp = nil;
        imageType = nil;
    }
    else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-3"] ||
             [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-1"]) {
        
        if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-3"]) {
            viewTemp = _view3;
            imageViewTemp = _imageView1;
        }
        else {
            viewTemp = _view7;
            imageViewTemp = _imageView5;
        }
        
        UILabel *label1 = (UILabel *)[viewTemp viewWithTag:310]; // 고객님의 투자성향은
        UILabel *label2 = (UILabel *)[viewTemp viewWithTag:320]; // 고객성향유형
        UILabel *label3 = (UILabel *)[viewTemp viewWithTag:330]; // 이고,
        UILabel *label4 = (UILabel *)[viewTemp viewWithTag:340]; // 투자자 정보 유효기간 만료일은
        UILabel *label5 = (UILabel *)[viewTemp viewWithTag:350]; // 날짜
        UILabel *label6 = (UILabel *)[viewTemp viewWithTag:360]; // 입니다.
        
        [label2 setText:_D6011Dic[@"고객성향유형"]];
        [label5 setText:_D6011Dic[@"성향분석최종적용일자"]];
        
        [label1 sizeToFit];
        [label2 sizeToFit];
        [label3 sizeToFit];
        [label4 sizeToFit];
        [label5 sizeToFit];
        [label6 sizeToFit];
        
        CGRect rect;
        rect = label1.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label2.frame.size.width;
        label2.frame = rect;
        
        rect = label2.frame;
        rect.origin.x += rect.size.width;
        rect.size.width = label3.frame.size.width;
        label3.frame = rect;
        
        rect = label4.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label5.frame.size.width;
        label5.frame = rect;
        
        rect = label5.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label6.frame.size.width;
        label6.frame = rect;
    }
    else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-4"] ||
             [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-2"]) {
        
        if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-4"]) {
            viewTemp = _view4;
            imageViewTemp = _imageView2;
        }
        else {
            viewTemp = _view8;
            imageViewTemp = _imageView6;
        }
        
        UILabel *label1 = (UILabel *)[viewTemp viewWithTag:310]; // 고객님의 투자성향은
        UILabel *label2 = (UILabel *)[viewTemp viewWithTag:320]; // 고객성향유형
        UILabel *label3 = (UILabel *)[viewTemp viewWithTag:330]; // 이고,
        UILabel *label4 = (UILabel *)[viewTemp viewWithTag:340]; // 투자자 정보 유효기간 만료일은
        UILabel *label5 = (UILabel *)[viewTemp viewWithTag:350]; // 날짜
        UILabel *label6 = (UILabel *)[viewTemp viewWithTag:360]; // 입니다.
        UILabel *label7 = (UILabel *)[viewTemp viewWithTag:370]; // 고객님의 투자성향은
        UILabel *label8 = (UILabel *)[viewTemp viewWithTag:380]; // 고객성향유형
        UILabel *label9 = (UILabel *)[viewTemp viewWithTag:390]; // 으로 고객님의 성향
        UILabel *label10 = (UILabel *)[viewTemp viewWithTag:400]; // 보다
        UILabel *label11 = (UILabel *)[viewTemp viewWithTag:410]; // 위험도가 높은
        UILabel *label12 = (UILabel *)[viewTemp viewWithTag:420]; // 상품을 선택하셨습니다.
        
        [label2 setText:_D6011Dic[@"고객성향유형"]];
        [label5 setText:_D6011Dic[@"성향분석최종적용일자"]];
        [label8 setText:_D6011Dic[@"고객성향유형"]];
        
        [label1 sizeToFit];
        [label2 sizeToFit];
        [label3 sizeToFit];
        [label4 sizeToFit];
        [label5 sizeToFit];
        [label6 sizeToFit];
        [label7 sizeToFit];
        [label8 sizeToFit];
        [label9 sizeToFit];
        [label10 sizeToFit];
        [label11 sizeToFit];
        [label12 sizeToFit];
        
        CGRect rect;
        rect = label1.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label2.frame.size.width;
        label2.frame = rect;
        
        rect = label2.frame;
        rect.origin.x += rect.size.width;
        rect.size.width = label3.frame.size.width;
        label3.frame = rect;
        
        rect = label4.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label5.frame.size.width;
        label5.frame = rect;
        
        rect = label5.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label6.frame.size.width;
        label6.frame = rect;
        
        rect = label7.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label8.frame.size.width;
        label8.frame = rect;
        
        rect = label8.frame;
        rect.origin.x += rect.size.width;
        rect.size.width = label9.frame.size.width;
        label9.frame = rect;
        
        rect = label10.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label11.frame.size.width;
        label11.frame = rect;
        
        rect = label11.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label12.frame.size.width;
        label12.frame = rect;
    }
    else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-6-1"]) {
        viewTemp = _view5;
        imageViewTemp = _imageView3;
        imageType = @"설명";
        
        UILabel *label1 = (UILabel *)[viewTemp viewWithTag:310]; // 고객님은
        UILabel *label2 = (UILabel *)[viewTemp viewWithTag:320]; // 투자성향분석 생략
        UILabel *label3 = (UILabel *)[viewTemp viewWithTag:330]; // 을 선택하셨습니다.
        
        [label1 sizeToFit];
        [label2 sizeToFit];
        [label3 sizeToFit];
        
        CGRect rect;
        rect = label1.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label2.frame.size.width;
        label2.frame = rect;
        
        rect = label2.frame;
        rect.origin.x += rect.size.width;
        rect.size.width = label3.frame.size.width;
        label3.frame = rect;
    }
    else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-6-2"]) {
        viewTemp = _view6;
        imageViewTemp = _imageView4;
        
        UILabel *label1 = (UILabel *)[viewTemp viewWithTag:310]; // 고객님은
        UILabel *label2 = (UILabel *)[viewTemp viewWithTag:320]; // 투자성향분석 생략
        UILabel *label3 = (UILabel *)[viewTemp viewWithTag:330]; // 을 선택하셨습니다.
        
        [label1 sizeToFit];
        [label2 sizeToFit];
        [label3 sizeToFit];
        
        CGRect rect;
        rect = label1.frame;
        rect.origin.x += rect.size.width + 5;
        rect.size.width = label2.frame.size.width;
        label2.frame = rect;
        
        rect = label2.frame;
        rect.origin.x += rect.size.width;
        rect.size.width = label3.frame.size.width;
        label3.frame = rect;
    }
    
    [self setYPositionWithAddSubview:viewTemp];
    
    NSLog(@"%@", _D6011Dic[@"고객성향유형"]);
    
    if (imageViewTemp) {
        [self setImageWithViewStretching:imageViewTemp imageType:imageType view:viewTemp];
    }
    
    rectTemp = _contentView1.frame;
    rectTemp.size.height = [self heightOfContentView1:viewTemp];
    _contentView1.frame = rectTemp;
    
    _scrollView1.contentSize = _contentView1.bounds.size;
    
    for (UIButton *btn in [viewTemp subviews]) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn.titleLabel setNumberOfLines:0];
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        }
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
    if (self.service.serviceId == kD6011Id) {
        self.D6011Dic = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        
        NSString *tranDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@"."];
        
        NSInteger type = [self getCustomerTendencyType:_D6011Dic[@"고객성향유형"]];
        
        NSInteger productType = 4; // 상품위험등급 (신한S뱅크에서 보여지는 등급은 모두 4 (ELD))
        
        // 골드 상품의 경우 상품위험등급이 2
        if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
            
            productType = 2;
        }
        
        if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-1"] ||
            [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-2"]) {
            
            if (type <= productType) {
                // BA17-8-1 투자성향분석 정보가 있는 경우(고객성향등급 >= 상품위험등급)
                
                [_viewDataSource setObject:@"0" forKey:@"고위험세이프예금신규"];
            }
            else if (type > productType) {
                // BA17-8-2 투자성향분석 정보가 있는 경우(고객성향등급 < 상품위험등급)
                
                [_viewDataSource setObject:@"1" forKey:@"고위험세이프예금신규"];
            }
        }
        else {
            if ([_D6011Dic[@"고객성향유형"] length] == 0 || !_D6011Dic[@"고객성향유형"] ||
                [_D6011Dic[@"성향분석최종적용일자->originalValue"] length] == 0 || !_D6011Dic[@"성향분석최종적용일자->originalValue"]) {
                
                // BA17-5-1 투자성향분석 정보가 없는 경우
                [_viewDataSource setObject:@"BA17-5-1" forKey:@"CASE"];
            }
            else {
                [_viewDataSource setObject:_D6011Dic[@"고객성향유형"] forKey:@"고객성향유형"];
                
                if ([tranDate integerValue] > [_D6011Dic[@"성향분석최종적용일자->originalValue"] integerValue]) {
                    // BA17-5-2 투자성향분석 정보가 있으나 유효기간이 지난 경우
                    [_viewDataSource setObject:@"BA17-5-2" forKey:@"CASE"];
                }
                else if (type <= productType) {
                    // BA17-5-3 투자성향분석 정보가 있는 경우(고객성향등급 >= 상품위험등급)
                    
                    [_viewDataSource setObject:@"BA17-5-3" forKey:@"CASE"];
                    [_viewDataSource setObject:@"0" forKey:@"고위험세이프예금신규"];
                }
                else if (type > productType) {
                    // BA17-5-4 투자성향분석 정보가 있는 경우(고객성향등급 < 상품위험등급)
                    
                    [_viewDataSource setObject:@"BA17-5-4" forKey:@"CASE"];
                    [_viewDataSource setObject:@"1" forKey:@"고위험세이프예금신규"];
                }
            }
        }
        
        [self setLayout];
    }
    else if (self.service.serviceId == kD6012Id) {
        
        self.data = aDataSet;
        
        if ([self.service.requestData[@"성향분석구분"] isEqualToString:@"3"]) // 투자성향분석 생략하기
        {
            if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-1"])
            {
                SHBELD_BA17_5ViewController *viewController = [[[SHBELD_BA17_5ViewController alloc] initWithNibName:@"SHBELD_BA17_5ViewController" bundle:nil] autorelease];
                
                viewController.D6011Dic = [NSMutableDictionary dictionaryWithDictionary:self.D6011Dic];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                [viewController.viewDataSource setObject:@"BA17-6-1" forKey:@"CASE"];
                [viewController.viewDataSource setObject:@"" forKey:@"고위험세이프예금신규"];
                
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    [viewController.viewDataSource setObject:@"0" forKey:@"_초과등급여부"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_고객투자성향"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_파생상품투자경험"];
                }
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-2"])
            {
                SHBELD_BA17_5ViewController *viewController = [[[SHBELD_BA17_5ViewController alloc] initWithNibName:@"SHBELD_BA17_5ViewController" bundle:nil] autorelease];
                
                viewController.D6011Dic = [NSMutableDictionary dictionaryWithDictionary:self.D6011Dic];
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                [viewController.viewDataSource setObject:@"BA17-6-2" forKey:@"CASE"];
                [viewController.viewDataSource setObject:@"" forKey:@"고위험세이프예금신규"];
                
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    [viewController.viewDataSource setObject:@"0" forKey:@"_초과등급여부"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_고객투자성향"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_파생상품투자경험"];
                }
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-3"] ||
                     [_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-4"])
            {
                SHBELD_BA17_9ViewController *viewController = [[[SHBELD_BA17_9ViewController alloc] initWithNibName:@"SHBELD_BA17_9ViewController" bundle:nil] autorelease];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                [viewController.viewDataSource setObject:@"" forKey:@"고위험세이프예금신규"];
                
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    [viewController.viewDataSource setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                    [viewController.viewDataSource setObject:@"0" forKey:@"_초과등급여부"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_고객투자성향"];
                    [viewController.viewDataSource setObject:@"투자성향분석 생략" forKey:@"_파생상품투자경험"];
                    
                }
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
        else {
            if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-3"])
            {
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    SHB_GoldTech_ManualViewController *viewController = [[[SHB_GoldTech_ManualViewController alloc]initWithNibName:@"SHB_GoldTech_ManualViewController" bundle:nil] autorelease];
                    
                    viewController.dicSelectedData = self.viewDataSource;
                    [viewController.dicSelectedData setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                    [viewController.dicSelectedData setObject:[self getInvestment] forKey:@"_고객투자성향"];
                    [viewController.dicSelectedData setObject:[self getOverClass] forKey:@"_초과등급여부"];
                    [viewController.dicSelectedData setObject:[self getDerivativesInvestmentExperience] forKey:@"_파생상품투자경험"];
                    
                    [self checkLoginBeforePushViewController:viewController animated:YES];
                    
                    return YES;
                }
                
                SHBELD_BA17_11ViewController *viewController = [[[SHBELD_BA17_11ViewController alloc] initWithNibName:@"SHBELD_BA17_11ViewController" bundle:nil] autorelease];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
            else if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-5-4"])
            {
                SHBELD_BA17_10ViewController *viewController = [[[SHBELD_BA17_10ViewController alloc] initWithNibName:@"SHBELD_BA17_10ViewController" bundle:nil] autorelease];
                
                viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource];
                
                // 골드상품
                if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
                    
                    [viewController.viewDataSource setObject:@"2등급:높은 위험" forKey:@"_위험등급"];
                    [viewController.viewDataSource setObject:[self getInvestment] forKey:@"_고객투자성향"];
                    [viewController.viewDataSource setObject:[self getOverClass] forKey:@"_초과등급여부"];
                    [viewController.viewDataSource setObject:[self getDerivativesInvestmentExperience] forKey:@"_파생상품투자경험"];
                }
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
            }
        }
    }
    
    return YES;
}

- (NSString *)getDerivatives
{
    // 만65세이상여부
    if ([self.data[@"part81"] isEqualToString:@"1"]) {
        
        if ([self.data[@"part74"] isEqualToString:@"1"]) {
            
            return @"원금비보존";
        }
    }
    else {
        
        if ([self.data[@"part73"] isEqualToString:@"1"] || [self.data[@"part74"] isEqualToString:@"1"]) {
            
            return @"원금비보존";
        }
    }
    
    return @"원금보존";
}

- (NSString *)getInvestment
{
    if (_viewDataSource[@"_고객투자성향"]) {
        
        return _viewDataSource[@"_고객투자성향"];
    }
    
    return _D6011Dic[@"고객성향유형"];
}

- (NSString *)getOverClass
{
    if (_viewDataSource[@"_초과등급여부"]) {
        
        return _viewDataSource[@"_초과등급여부"];
    }
    
    if ([_viewDataSource[@"고위험세이프예금신규"] isEqualToString:@"1"]) {
        
        if ([[self getDerivatives] isEqualToString:@"원금보존"]) {
            
            return @"3";
        }
        else {
            
            return @"1";
        }
    }
    else {
        
        if ([[self getDerivatives] isEqualToString:@"원금보존"]) {
            
            return @"2";
        }
    }
    
    return @"0";
}

- (NSString *)getDerivativesInvestmentExperience
{
    if (_viewDataSource[@"_파생상품투자경험"]) {
        
        return _viewDataSource[@"_파생상품투자경험"];
    }
    
    if ([self.data[@"part71"] isEqualToString:@"1"]) {
        
        return @"없음";
    }
    else if ([self.data[@"part72"] isEqualToString:@"1"]) {
        
        return @"1년미만";
    }
    else if ([self.data[@"part73"] isEqualToString:@"1"]) {
        
        return @"1년이상 ~ 3년미만";
    }
    else if ([self.data[@"part74"] isEqualToString:@"1"]) {
        
        return @"3년이상";
    }
    
    return @"";
}

#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.viewDataSource = nil;
    
    self.D6011Dic = nil;
    
    self.scrollView1 = nil;
    self.contentView1 = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.view4 = nil;
    self.view5 = nil;
    self.view6 = nil;
    self.view6 = nil;
    self.view7 = nil;
    self.imageView1 = nil;
    self.imageView2 = nil;
    self.imageView3 = nil;
    self.imageView4 = nil;
    self.imageView5 = nil;
    self.imageView6 = nil;
    
    [_itemNameLabel release];
    [_infoLabel1 release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"투자성향분석";
    
    if ([_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-1"] ||
        [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-2"]) {
        [self navigationBackButtonHidden];
    }
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"투자성향분석" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    [_itemNameLabel initFrame:self.itemNameLabel.frame];
    
    // 골드상품
    if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
        
        [_itemNameLabel setText:[NSString stringWithFormat:@"<midGray_15>%@</midGray_15>  <midRed_15>(2등급:높은 위험)</midRed_15>", _viewDataSource[@"상품명"]]];
        
        [_infoLabel1 setText:@"골드리슈를 포함한 금융투자상품을 가입하시기 전에 투자성향을 확인하셔야 합니다."];
    }
    else {
        
        [_itemNameLabel setText:[NSString stringWithFormat:@"<midGray_15>%@</midGray_15>  <midRed_15>(4등급:낮은 위험)</midRed_15>", _viewDataSource[@"상품한글명"]]];
        
        [_infoLabel1 setText:@"지수연동예금은 투자형 정기예금으로 가입 전 투자성향을 확인하셔야 합니다."];
    }
    
    if (!_viewDataSource[@"CASE"] ||
        [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-1"] ||
        [_viewDataSource[@"CASE"] isEqualToString:@"BA17-8-2"]) {
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:kD6011Id viewController:self] autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{ }];
        [self.service start];
    }
    else {
        [self setLayout];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
