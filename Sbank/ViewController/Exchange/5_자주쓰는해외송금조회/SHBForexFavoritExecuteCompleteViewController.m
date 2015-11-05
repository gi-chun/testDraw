//
//  SHBForexFavoritExecuteCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritExecuteCompleteViewController.h"

@interface SHBForexFavoritExecuteCompleteViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBForexFavoritExecuteCompleteViewController

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
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    [self navigationBackButtonHidden];
    
    [self.contentScrollView addSubview:_mainView];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    // 가변 길이 설정
    CGFloat yy = _name.frame.origin.y;
    
    [self adjustToView:_name originX:_name.frame.origin.x originY:yy text:_name.text];
    
    yy += _name.frame.size.height + 9;
    
    [self adjustToView:_phoneNumberLabel originX:_phoneNumberLabel.frame.origin.x originY:yy text:_phoneNumberLabel.text];
    [self adjustToView:_phoneNumber originX:_phoneNumber.frame.origin.x originY:yy text:_phoneNumber.text];
    
    yy += _phoneNumber.frame.size.height + 9;
    
    [self adjustToView:_juminLabel originX:_juminLabel.frame.origin.x originY:yy text:_juminLabel.text];
    [self adjustToView:_jumin originX:_jumin.frame.origin.x originY:yy text:_jumin.text];
    
    yy += _jumin.frame.size.height + 9;
    
    [self adjustToView:_addressLabel originX:_addressLabel.frame.origin.x originY:yy text:_addressLabel.text];
    [self adjustToView:_address originX:_address.frame.origin.x originY:yy text:_address.text];
    
    yy += _address.frame.size.height + 9;
    
    [self adjustToView:_bankNameLabel originX:_bankNameLabel.frame.origin.x originY:yy text:_bankNameLabel.text];
    [self adjustToView:_bankName originX:_bankName.frame.origin.x originY:yy text:_bankName.text];
    
    yy += _bankName.frame.size.height + 9;
    
    [self adjustToView:_branchNameLabel originX:_branchNameLabel.frame.origin.x originY:yy text:_branchNameLabel.text];
    [self adjustToView:_branchName originX:_branchName.frame.origin.x originY:yy text:_branchName.text];
    
    yy += _branchName.frame.size.height + 9;
    
    [self adjustToView:_bankAddressLabel originX:_bankAddressLabel.frame.origin.x originY:yy text:_bankAddressLabel.text];
    [self adjustToView:_bankAddress originX:_bankAddress.frame.origin.x originY:yy text:_bankAddress.text];
    
    yy += _bankAddress.frame.size.height + 9;
    
    [_addressBottomView setFrame:CGRectMake(_addressBottomView.frame.origin.x,
                                            yy,
                                            _addressBottomView.frame.size.width,
                                            _addressBottomView.frame.size.height)];
    
    [_subMainView setFrame:CGRectMake(0,
                                      37,
                                      _subMainView.frame.size.width,
                                      _addressBottomView.frame.origin.y + _addressBottomView.frame.size.height)];
    
    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   37 + _addressBottomView.frame.origin.y + _addressBottomView.frame.size.height)];
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainView release];
    [_name release];
    [_phoneNumberLabel release];
    [_phoneNumber release];
    [_juminLabel release];
    [_jumin release];
    [_addressLabel release];
    [_address release];
    [_bankNameLabel release];
    [_bankName release];
    [_branchNameLabel release];
    [_branchName release];
    [_bankAddressLabel release];
    [_bankAddress release];
    [_addressBottomView release];
    [_subMainView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setName:nil];
    [self setPhoneNumberLabel:nil];
    [self setPhoneNumber:nil];
    [self setJuminLabel:nil];
    [self setJumin:nil];
    [self setAddressLabel:nil];
    [self setAddress:nil];
    [self setBankNameLabel:nil];
    [self setBankName:nil];
    [self setBranchNameLabel:nil];
    [self setBranchName:nil];
    [self setBankAddressLabel:nil];
    [self setBankAddress:nil];
    [self setAddressBottomView:nil];
    [self setSubMainView:nil];
	[super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    if (labelSize.height > 36) {
        labelSize.height = 36;
    }
    else {
        labelSize.height = 16;
    }
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
