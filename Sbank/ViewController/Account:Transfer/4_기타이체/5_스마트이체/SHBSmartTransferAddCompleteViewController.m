//
//  SHBSmartTransferAddCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartTransferAddCompleteViewController.h"

@interface SHBSmartTransferAddCompleteViewController ()
{
    BOOL isSmailCheck;
}

@end

@implementation SHBSmartTransferAddCompleteViewController

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
    
    [self setTitle:@"스마트 이체 조회/등록/변경"];
    self.strBackButtonTitle = @"스마트 이체 조회/등록/변경";
    
    [self navigationBackButtonHidden];
    
    isSmailCheck = NO;
    
    [_info initFrame:_info.frame];
    [_info setText:@"<midGray_13>신한 저축습관만들기 적금의 </midGray_13><midRed_13>『스마트이체』 </midRed_13><midGray_13>서비스는 </midGray_13><midRed_13>『신한Smail』 </midRed_13><midGray_13>의 알림(Push) 기능을 통해 제공되며 </midGray_13><midRed_13>1기기당 1인에게만 제공 </midRed_13><midGray_13>됩니다."];
    
    CGFloat height = 55;
    
    if ([AppInfo.electronicSignCode isEqualToString:@"E5081_A"]) {
        
        FrameReposition(_view1, 0, height);
        [self.contentScrollView addSubview:_view1];
        
        height += height(_view1);
    }
    else if ([AppInfo.electronicSignCode isEqualToString:@"E5081_B"]) {
        
        FrameReposition(_view2, 0, height);
        [self.contentScrollView addSubview:_view2];
        
        height += height(_view2);
    }
    else if ([AppInfo.electronicSignCode isEqualToString:@"E5081_C"]) {
        
        FrameReposition(_view3, 0, height);
        [self.contentScrollView addSubview:_view3];
        
        height += height(_view3);
    }
    else if ([AppInfo.electronicSignCode isEqualToString:@"E5083"]) {
        
        FrameReposition(_view4, 0, height);
        [self.contentScrollView addSubview:_view4];
        
        height += height(_view4);
    }
    
    FrameReposition(_bottomView, 0, height);
    [self.contentScrollView addSubview:_bottomView];
    
    height += height(_bottomView);
    
    [self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), height)];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    
    [dataSet insertObject:AppInfo.tran_Date forKey:@"_일자" atIndex:0];
    [dataSet insertObject:AppInfo.tran_Time forKey:@"_시간" atIndex:0];
    
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_view1 release];
    [_view2 release];
    [_view3 release];
    [_view4 release];
    [_bottomView release];
    [_info release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setView1:nil];
    [self setView2:nil];
    [self setView3:nil];
    [self setView4:nil];
    [self setBottomView:nil];
    [self setInfo:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 확인
            
            if (isSmailCheck) {
                
                [self.navigationController fadePopToRootViewController];
                
                return;
            }
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                             message:@"『스마트이체』 서비스는 『신한Smail』 의 알림(Push)기능을 통해 제공되며 1기기당 1인에게만 제공됩니다\n\n알림메시지를 받기 위해서는 반드시 『신한Smail』 을 가입해 주세요!"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"신한Smail설치", @"닫기", nil] autorelease];
            [alert setTag:123];
            [alert show];
        }
            break;
            
        case 200: {
            
            // 신한 Smail 설치
            
            isSmailCheck = YES;
            
            SHBPushInfo *pushInfo = [SHBPushInfo instance];
            [pushInfo requestOpenURL:@"smartcaremgr://" Parm:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            
            SHBPushInfo *pushInfo = [SHBPushInfo instance];
            [pushInfo requestOpenURL:@"smartcaremgr://" Parm:nil];
            
            [self.navigationController fadePopToRootViewController];
        }
        else {
            
            [self.navigationController fadePopToRootViewController];
        }
    }
}

@end
