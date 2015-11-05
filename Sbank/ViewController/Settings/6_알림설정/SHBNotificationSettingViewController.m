//
//  SHBNotificationSettingViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNotificationSettingViewController.h"
#import "SHBSettingsService.h"

@interface SHBNotificationSettingViewController ()

@end

@implementation SHBNotificationSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_btnSet release];
	[_btnNoSet release];
    [_ivBox release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBtnSet:nil];
	[self setBtnNoSet:nil];
    [self setIvBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
	[self setTitle:@"알림설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	UIImage *img = [UIImage imageNamed:@"box_infor.png"];
	self.ivBox.image = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                              TASK_ACTION_KEY : @"getSbankPushToken",
						   @"고객번호" : AppInfo.customerNo,
						   }];
	
	self.service = [[[SHBSettingsService alloc]initWithServiceId:XDA_S00003 viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
	[self.btnNoSet setSelected:NO];
	[self.btnSet setSelected:NO];
	[sender setSelected:YES];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strYesOrNo = [self.btnSet isSelected] ? @"Y" : @"N";
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                              TASK_ACTION_KEY : @"updateSbankPushToken",
						   @"고객번호" : AppInfo.customerNo,
						   @"수신여부" : strYesOrNo,
						   }];
	
	self.service = [[[SHBSettingsService alloc]initWithServiceId:XDA_S00002 viewController:self]autorelease];
	self.service.requestData = dataSet;
    AppInfo.serviceCode = @"알림설정";
	[self.service start];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 337337) {
		[self.navigationController fadePopViewController];
	}
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
	Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == XDA_S00003)
	{
		if ([[aDataSet objectForKey:@"수신여부"]isEqualToString:@"Y"]) {
			[self.btnSet setSelected:YES];
			[self.btnNoSet setSelected:NO];
		}
		else
		{
			[self.btnSet setSelected:NO];
			[self.btnNoSet setSelected:YES];
		}
	}
	else if (self.service.serviceId == XDA_S00002)
	{
		[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:337337 title:@"" message:@"알림 설정이 변경 되었습니다."];
	}
	
	return NO;
}

@end
