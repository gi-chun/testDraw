//
//  SHBFishingDefenceDoneViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 4. 2..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBFishingDefenceDoneViewController.h"
#import "NKDCode128Barcode.h"
#import "UIImage-NKDBarcode.h"


@interface SHBFishingDefenceDoneViewController ()

@property(nonatomic, retain) IBOutlet UIImageView *barcodeImageView;
@end

@implementation SHBFishingDefenceDoneViewController
@synthesize subTitleLabel;
@synthesize messageLabel;
@synthesize barcodeImageView;

- (void)dealloc
{
    [barcodeImageView release];
    [subTitleLabel release];
    [messageLabel release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"피싱방지 보안설정";
    [self navigationBackButtonHidden];
    if ([AppInfo.serviceOption isEqualToString:@"fishing_register"])
    {
        self.subTitleLabel.text = @"피싱방지 서비스 설정 완료";
        self.messageLabel.text = @"피싱방지 서비스가 설정 되었습니다.";
    }else if ([AppInfo.serviceOption isEqualToString:@"fishing_change"])
    {
        self.subTitleLabel.text = @"피싱방지 서비스 변경 완료";
        self.messageLabel.text = @"피싱방지 서비스가 변경 되었습니다.";
        
    }else if ([AppInfo.serviceOption isEqualToString:@"fishing_dismiss"])
    {
        self.subTitleLabel.text = @"피싱방지 서비스 해지 완료";
        self.messageLabel.text = @"피싱방지 서비스 해지 되었습니다.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(id)sender
{
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

- (IBAction)barcodeTouched:(id)sender
{
    NKDBarcode *bCode = [NKDCode128Barcode alloc];
    bCode = [bCode initWithContent:@"123456789876543210" printsCaption:YES];
    //[bCode calculateWidth];
    NSLog(@"desc:%@",[bCode description]);
    UIImage *tempImg = [UIImage imageFromBarcode:bCode inRect:self.barcodeImageView.frame];
    //[self.barcodeImageView setFrame:CGRectMake(self.barcodeImageView.frame.origin.x, self.barcodeImageView.frame.origin.y, bCode.width, bCode.height)];
    self.barcodeImageView.image = tempImg;
}
@end
