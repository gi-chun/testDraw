//
//  SHBSmithingDeviceQueryDelViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmithingDeviceQueryDelViewController.h"
#import "SHBSmithingSecureMediaViewController.h"
#import "SHBVersionService.h"

@interface SHBSmithingDeviceQueryDelViewController ()
{
    int buttonTagValue;
}
@end

@implementation SHBSmithingDeviceQueryDelViewController
@synthesize subContentsView;
@synthesize device1View;
@synthesize device2View;
@synthesize device3View;
@synthesize device4View;
@synthesize device5View;

@synthesize device1askDate;
@synthesize device1phoneNumber;
@synthesize device1phoneModel;
@synthesize device1askType;

@synthesize device2askDate;
@synthesize device2phoneNumber;
@synthesize device2phoneModel;
@synthesize device2askType;

@synthesize device3askDate;
@synthesize device3phoneNumber;
@synthesize device3phoneModel;
@synthesize device3askType;

@synthesize device4askDate;
@synthesize device4phoneNumber;
@synthesize device4phoneModel;
@synthesize device4askType;

@synthesize device5askDate;
@synthesize device5phoneNumber;
@synthesize device5phoneModel;
@synthesize device5askType;

- (void)dealloc
{
    [device1askDate release];
    [device1phoneNumber release];
    [device1phoneModel release];
    [device1askType release];
    
    [device2askDate release];
    [device2phoneNumber release];
    [device2phoneModel release];
    [device2askType release];
    
    [device3askDate release];
    [device3phoneNumber release];
    [device3phoneModel release];
    [device3askType release];
    
    [device4askDate release];
    [device4phoneNumber release];
    [device4phoneModel release];
    [device4askType release];
    
    [device5askDate release];
    [device5phoneNumber release];
    [device5phoneModel release];
    [device5askType release];
    
    [device1View release];
    [device2View release];
    [device3View release];
    [device4View release];
    [device5View release];
    [subContentsView release];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"안심거래 서비스"];
    self.strBackButtonTitle = @"안심거래 서비스 기기 조회/삭제";
    
    CGRect rect = self.subContentsView.bounds;
    [self.contentScrollView addSubview:self.subContentsView];
    [self.contentScrollView setContentSize:CGSizeMake(317, rect.size.height)];
    
    self.dataList = AppInfo.smsInfo[@"smsdeviceinfo"];
    NSLog(@"aaaa:%@",AppInfo.smsInfo[@"smsdeviceinfo"]);
    
    self.device1View.hidden = YES;
    self.device2View.hidden = YES;
    self.device3View.hidden = YES;
    self.device4View.hidden = YES;
    self.device5View.hidden = YES;
    for (int i = 0; i < [self.dataList count]; i++)
    {
        NSDictionary *tmpDic = self.dataList[i];
        if (i == 0)
        {
            self.device1View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 256)];
            self.device1askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device1phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device1phoneNumber.text = number;
            }
            
            self.device1phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device1askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device1askType.text = @"영업점에서 신청";
            }
        }else if (i == 1)
        {
            self.device2View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 390)];
            self.device2askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device2phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device2phoneNumber.text = number;
            }
            self.device2phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device2askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device2askType.text = @"영업점에서 신청";
            }
        }else if (i == 2)
        {
            self.device3View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 526)];
            self.device3askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device3phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device3phoneNumber.text = number;
            }
            self.device3phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device3askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device3askType.text = @"영업점에서 신청";
            }
        }else if (i == 3)
        {
            self.device4View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 665)];
            self.device4askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device4phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device4phoneNumber.text = number;
            }
            self.device4phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device4askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device4askType.text = @"영업점에서 신청";
            }
        }else if (i == 4)
        {
            self.device5View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, rect.size.height)];
            self.device5askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device5phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device5phoneNumber.text = number;
            }
            self.device5phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device5askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device5askType.text = @"영업점에서 신청";
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    NSDictionary *tmpDic;
    switch (tmpBtn.tag)
    {
        case 1001:
        {
            //device1  삭제
            tmpDic = self.dataList[0];
            buttonTagValue = 0;
            if ([tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기는\n삭제가 불가합니다.\n\n서비스해지를\n이용해 주시기 바랍니다."];
                return;
            }
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5551 title:nil message:@"삭제된 기기에서는\n신한S뱅크의 이체 거래가 불가합니다.\n\n삭제하시겠습니까?"];
            
        }
            break;
        case 1002:
        {
            //device2  삭제
            tmpDic = self.dataList[1];
            buttonTagValue = 1;
            if ([tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기는\n삭제가 불가합니다.\n\n서비스해지를\n이용해 주시기 바랍니다."];
                return;
            }
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5551 title:nil message:@"삭제된 기기에서는\n신한S뱅크의 이체 거래가 불가합니다.\n\n삭제하시겠습니까?"];
        }
            break;
        case 1003:
        {
            //device3  삭제
            tmpDic = self.dataList[2];
            buttonTagValue = 2;
            if ([tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기는\n삭제가 불가합니다.\n\n서비스해지를\n이용해 주시기 바랍니다."];
                return;
            }
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5551 title:nil message:@"삭제된 기기에서는\n신한S뱅크의 이체 거래가 불가합니다.\n\n삭제하시겠습니까?"];
        }
            break;
        case 1004:
        {
            //device4  삭제
            tmpDic = self.dataList[3];
            buttonTagValue = 3;
            if ([tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기는\n삭제가 불가합니다.\n\n서비스해지를\n이용해 주시기 바랍니다."];
                return;
            }
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5551 title:nil message:@"삭제된 기기에서는\n신한S뱅크의 이체 거래가 불가합니다.\n\n삭제하시겠습니까?"];
        }
            break;
        case 1005:
        {
            //device5  삭제
            tmpDic = self.dataList[4];
            buttonTagValue = 4;
            if ([tmpDic[@"MASTER_YN"] isEqualToString:@"Y"])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신한S뱅크에서 등록된 기기는\n삭제가 불가합니다.\n\n서비스해지를\n이용해 주시기 바랍니다."];
                return;
            }
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5551 title:nil message:@"삭제된 기기에서는\n신한S뱅크의 이체 거래가 불가합니다.\n\n삭제하시겠습니까?"];
        }
            break;
        default:
            break;
    }
}

- (void)refreshDevice
{
    [AppInfo.smsInfo removeAllObjects];
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                     TASK_ACTION_KEY : @"selectSmishingDeviceList",
                                }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBVersionService alloc] initWithServiceId:SMSDEVICE_INFO viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 5551 && buttonIndex == 0)
    {

        SHBSmithingSecureMediaViewController *viewController = [[SHBSmithingSecureMediaViewController alloc]initWithNibName:@"SHBSmithingSecureMediaViewController" bundle:nil];
        viewController.deviceIndex = buttonTagValue;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.data = aDataSet;
    self.dataList = [self.data arrayWithForKey:@"DEVICE_LIST.vector.data"];
    [AppInfo.smsInfo setObject:self.data forKey:@"smsbaseinfo"];
    if (self.dataList > 0)
    {
        [AppInfo.smsInfo setObject:self.dataList forKey:@"smsdeviceinfo"];
    }
    
    
    CGRect rect = self.subContentsView.bounds;
    [self.contentScrollView addSubview:self.subContentsView];
    [self.contentScrollView setContentSize:CGSizeMake(317, rect.size.height)];
    
    //self.dataList = AppInfo.smsInfo[@"smsdeviceinfo"];
    NSLog(@"aaaa:%@",AppInfo.smsInfo[@"smsdeviceinfo"]);
    
    self.device1View.hidden = YES;
    self.device2View.hidden = YES;
    self.device3View.hidden = YES;
    self.device4View.hidden = YES;
    self.device5View.hidden = YES;
    for (int i = 0; i < [self.dataList count]; i++)
    {
        NSDictionary *tmpDic = self.dataList[i];
        if (i == 0)
        {
            self.device1View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 256)];
            self.device1askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device1phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device1phoneNumber.text = number;
            }
            self.device1phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device1askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device1askType.text = @"영업점에서 신청";
            }
        }else if (i == 1)
        {
            self.device2View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 390)];
            self.device2askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device2phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device2phoneNumber.text = number;
            }
            self.device2phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device2askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device2askType.text = @"영업점에서 신청";
            }
        }else if (i == 2)
        {
            self.device3View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 526)];
            self.device3askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device3phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device3phoneNumber.text = number;
            }
            self.device3phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device3askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device3askType.text = @"영업점에서 신청";
            }
        }else if (i == 3)
        {
            self.device4View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, 665)];
            self.device4askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device4phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device4phoneNumber.text = number;
            }
            self.device4phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device4askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device4askType.text = @"영업점에서 신청";
            }
        }else if (i == 4)
        {
            self.device5View.hidden = NO;
            [self.contentScrollView setContentSize:CGSizeMake(317, rect.size.height)];
            self.device5askDate.text = tmpDic[@"REG_DT"];
            if ([tmpDic[@"PHONE_NO"] length] == 0)
            {
                self.device5phoneNumber.text = @"정보없음";
            }else
            {
                NSString *number = tmpDic[@"PHONE_NO"];
                number = [NSString stringWithFormat:@"%@-%@-****", [number substringWithRange:NSMakeRange(0, 3)],[number substringWithRange:NSMakeRange(3, 4)]];
                self.device5phoneNumber.text = number;
            }
            self.device5phoneModel.text = tmpDic[@"PHONE_MODEL"];
            if ([tmpDic[@"BRANCH_YN"] isEqualToString:@"N"])
            {
                self.device5askType.text = @"신한S뱅크에서 신청";
            }else
            {
                self.device5askType.text = @"영업점에서 신청";
            }
        }
    }
    return NO;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    return YES;
}

@end
