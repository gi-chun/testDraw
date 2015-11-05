//
//  SHBSimpleLoanCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanCompleteViewController.h"

#import "SHBSimpleLoanResultViewController.h" // 약정업체 간편대출 - 신청결과 조회

@interface SHBSimpleLoanCompleteViewController ()

@end

@implementation SHBSimpleLoanCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    if (![self.data[@"응답상태"] isEqualToString:@"Y"]) {
        
        self.view = _errorView;
    }
    
    [super viewDidLoad];
    
    [self setTitle:@"약정업체 간편대출"];
    [self navigationBackButtonHidden];
    self.strBackButtonTitle = @"약정업체 간편대출 신청완료";
    
    if ([self.data[@"응답상태"] isEqualToString:@"Y"]) {
        
        OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
        
        if ([[AppInfo getPersonalPK] length] >= 6) {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@*******", [dataSet[@"주민번호"] substringToIndex:6]]
                           forKey:@"_주민번호"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"*************"
                           forKey:@"_주민번호"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"신청금액"]]]
                       forKey:@"_신청금액"
                      atIndex:0];
        
        [self.binder bind:self dataSet:dataSet];
    }
    else {
        
        [_errorLabel setText:[SHBUtility nilToString:self.data[@"응답결과내역"]]];
        
        CGSize labelSize = [_errorLabel.text sizeWithFont:_errorLabel.font
                                        constrainedToSize:CGSizeMake(_errorLabel.frame.size.width, 999)
                                            lineBreakMode:_errorLabel.lineBreakMode];
        
        CGRect frame = _errorLabel.frame;
        frame.size.height = labelSize.height + 2;
        
        [_errorLabel setFrame:frame];
        
        frame = _box.frame;
        frame.size.height = _errorLabel.frame.size.height + 10;
        
        [_box setFrame:frame];
        
        frame = _errorBottomView.frame;
        frame.origin.y = _errorLabel.frame.origin.y + _errorLabel.frame.size.height + 5;
        
        [_errorBottomView setFrame:frame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_errorView release];
    [_errorBottomView release];
    [_box release];
    [_errorLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setErrorView:nil];
    [self setErrorBottomView:nil];
    [self setBox:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    SHBSimpleLoanResultViewController *viewController = [[[SHBSimpleLoanResultViewController alloc] initWithNibName:@"SHBSimpleLoanResultViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
