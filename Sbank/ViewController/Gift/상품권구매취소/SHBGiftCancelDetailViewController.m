//
//  SHBGiftCancelDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelDetailViewController.h"

#import "SHBGiftCancelConfirmViewController.h" // 상품권 취소 정보확인

@interface SHBGiftCancelDetailViewController ()

@end

@implementation SHBGiftCancelDetailViewController

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
    
    [self setTitle:@"모바일상품권 구매취소"];
    self.strBackButtonTitle = @"모바일상품권 구매취소 상품권 취소";
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    CGSize labelSize = [_messageView.text sizeWithFont:_messageView.font
                                     constrainedToSize:CGSizeMake(_messageView.frame.size.width, 999)
                                         lineBreakMode:_messageView.lineBreakMode];
    
    if (labelSize.height > 20) {
        
        FrameResize(_messageView, _messageView.frame.size.width, labelSize.height + 2);
    }
    else {
        
        FrameResize(_messageView, _messageView.frame.size.width, labelSize.height);
    }
    
    FrameReposition(_bottomView, 0, _messageView.frame.origin.y + _messageView.frame.size.height + 10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (IBAction)buttonPresssed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 구매취소
            
            SHBGiftCancelConfirmViewController *viewController = [[[SHBGiftCancelConfirmViewController alloc] initWithNibName:@"SHBGiftCancelConfirmViewController" bundle:nil] autorelease];
            
            viewController.data = self.data;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 200: {
            
            // 취소
            
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [_bottomView release];
    [_messageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBottomView:nil];
    [self setMessageView:nil];
    [super viewDidUnload];
}
@end
