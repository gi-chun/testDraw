//
//  SHBLoanBizNoVisitApplyCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyCompleteViewController.h"

@interface SHBLoanBizNoVisitApplyCompleteViewController ()

@end

@implementation SHBLoanBizNoVisitApplyCompleteViewController

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
    self.strBackButtonTitle = @"직장인 무방문 신용대출 신청 조회 및 실행 6단계 실행 완료";
    
    [self navigationBackButtonHidden];
    
    if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
        
        // 한도 (한도의 경우 실행일자가 보이지 않음)
        
        [_startDateView setHidden:YES];
        
        FrameReposition(_endDateView, left(_endDateView), top(_startDateView));
    }
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    [_productName initFrame:_productName.frame
                  colorType:RGB(44, 44, 44)
                   fontSize:15
                  textAlign:2];
    [_productName setCaptionText:self.data[@"_상품명"]];
    
    [_loanRate initFrame:_loanRate.frame
               colorType:RGB(44, 44, 44)
                fontSize:15
               textAlign:2];
    [_loanRate setCaptionText:self.data[@"_대출금리"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_productName release];
    [_loanRate release];
    [_startDateView release];
    [_endDateView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setProductName:nil];
    [self setLoanRate:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
