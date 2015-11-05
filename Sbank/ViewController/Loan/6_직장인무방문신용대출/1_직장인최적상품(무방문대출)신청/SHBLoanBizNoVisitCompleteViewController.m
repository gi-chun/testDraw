//
//  SHBLoanBizNoVisitCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitCompleteViewController.h"
#import "SHBLoanService.h" // 서비스

#import "SHBLoanBizNoVisitApplyListViewController.h" // 신청 조회 및 실행

@interface SHBLoanBizNoVisitCompleteViewController ()

@end

@implementation SHBLoanBizNoVisitCompleteViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 완료";
    
    [self navigationBackButtonHidden];
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:@"직장인 최적상품(무방문대출) 신청"];
    
    [_info1 initFrame:_info1.frame];
    [_info1 setText:@"<midGray_13>문의사항은 신한은행 </midGray_13><midRed_13>스마트론센터 1588-8641(1)번</midRed_13><midGray_13>으로 연락 주시기 바랍니다.</midGray_13>"];
    
    if ([self.data[@"_상품코드"] isEqualToString:@"612211100"] || [self.data[@"_상품코드"] isEqualToString:@"612241100"]) {
        
        // 엘리트론인 경우
        
        [_eliteLoanView setHidden:NO];
    }
    else {
        
        [_eliteLoanView setHidden:YES];
        
        FrameResize(_contentView, width(_contentView), height(_contentView) - height(_eliteLoanView) - 9);
    }
    
    [_contentSV addSubview:_contentView];
    [_contentSV setContentSize:_contentView.frame.size];
    
    [_productName initFrame:_productName.frame
                  colorType:RGB(209, 75, 75)
                   fontSize:15
                  textAlign:2];
    [_productName setCaptionText:self.data[@"_상품명"]];
    
    [_rateName initFrame:_rateName.frame
               colorType:RGB(44, 44, 44)
                fontSize:15
               textAlign:2];
    [_rateName setCaptionText:self.data[@"_금리"]];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_info1 release];
    [_contentSV release];
    [_contentView release];
    [_eliteLoanView release];
    [_subTitleView release];
    [_productName release];
    [_rateName release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfo1:nil];
    [self setContentSV:nil];
    [self setContentView:nil];
    [self setEliteLoanView:nil];
    [self setSubTitleView:nil];
    [self setProductName:nil];
    [self setRateName:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 신청결과조회
            
            SHBLoanBizNoVisitApplyListViewController *viewController = [[[SHBLoanBizNoVisitApplyListViewController alloc] initWithNibName:@"SHBLoanBizNoVisitApplyListViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
