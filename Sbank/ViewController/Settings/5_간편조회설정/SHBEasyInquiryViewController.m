//
//  SHBEasyInquiryViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBEasyInquiryViewController.h"
#import "SHBSettingsService.h"

@interface SHBEasyInquiryViewController ()

@property (nonatomic, retain) NSMutableArray *marrAccounts;	// 출금계좌번호리스트
@property (nonatomic, retain) NSDictionary *selectedData;	// 선택한 계좌번호
@property (nonatomic, retain) NSString *exAccountData;      // 선택했었던 계좌번호 (삭제시 필요)

@end

@implementation SHBEasyInquiryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_exAccountData release];
	[_selectedData release];
	[_marrAccounts release];
	[_btnNoSet release];
	[_btnSet release];
	[_sbAccountList release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBtnNoSet:nil];
	[self setBtnSet:nil];
	[self setSbAccountList:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"간편조회 설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.sbAccountList setDelegate:self];
	
    //	self.marrAccounts = [self outAccountList];
	self.marrAccounts = [NSMutableArray array];
	//for (NSDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
    for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
	{
		NSString *strAccountNoSub = [dic[@"계좌번호"]substringToIndex:3];
		NSInteger nAccountNoSub = [strAccountNoSub integerValue];
		
		if ((nAccountNoSub >= 100 && nAccountNoSub <= 149)
			|| (nAccountNoSub >= 150 && nAccountNoSub <= 159)) {
            
			NSDictionary *dicData = @{
			@"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
			@"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
            //			@"2" : [dic objectForKey:@"계좌번호"],
			};
			
			[self.marrAccounts addObject:dicData];
		}
	}
	
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                            TASK_ACTION_KEY : @"Main_Select",
                            @"고객번호" : AppInfo.customerNo,
                            }];
    
    self.service = [[[SHBSettingsService alloc] initWithServiceId:EASY_INQUIRY_SELECT viewController:self] autorelease];
    self.service.requestData = aDataSet;
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
	
	if (sender == self.btnNoSet) {
		[self.sbAccountList setState:SHBSelectBoxStateDisabled];
		[self.sbAccountList setText:@"선택하세요"];
	}
	else if (sender == self.btnSet) {
		[self.sbAccountList setState:SHBSelectBoxStateNormal];
	}
}

- (IBAction)confirmBtnAction:(SHBButton *)sender
{
	if ([self.btnNoSet isSelected]) {
        if (_exAccountData) {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                    TASK_ACTION_KEY : @"Main_Delete",
                                    @"고객번호" : AppInfo.customerNo,
                                    @"메인계좌번호" : _exAccountData,
                                    }];
            
            self.service = [[[SHBSettingsService alloc] initWithServiceId:EASY_INQUIRY_DELETE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setEasyInquiryData:@"2"];
            [[NSUserDefaults standardUserDefaults] removeEasyInquiryData];
            
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:33 title:@"" message:@"간편조회 설정이 변경 되었습니다."];
        }
	}
	else if ([self.btnSet isSelected]) {
		if ([self.sbAccountList.text isEqualToString:@"선택하세요"]) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"간편조회로 설정하실 계좌를 선택하여 주십시오."];
			
			return;
		}
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                TASK_ACTION_KEY : @"Main_Update",
                                @"고객번호" : AppInfo.customerNo,
                                @"메인계좌번호" : [self.sbAccountList.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                }];
        
        self.service = [[[SHBSettingsService alloc] initWithServiceId:EASY_INQUIRY_UPDATE viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
	}
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
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
    if (self.service.serviceId == EASY_INQUIRY_SELECT) {
        if (!aDataSet[@"메인계좌번호"])
        {
            [self.btnNoSet setSelected:YES];
            [self.btnSet setSelected:NO];
            
            [self.sbAccountList setState:SHBSelectBoxStateDisabled];
            [self.sbAccountList setText:@"선택하세요"];
        }
        else
        {
            [self.btnNoSet setSelected:NO];
            [self.btnSet setSelected:YES];
            
            [self.sbAccountList setState:SHBSelectBoxStateNormal];
            
            for (int i = 0; i < [self.marrAccounts count]; i++) {
                NSString *accountNumber = [self.marrAccounts[i][@"2"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if ([accountNumber isEqualToString:aDataSet[@"메인계좌번호"]]) {
                    [self.sbAccountList setText:self.marrAccounts[i][@"2"]];
                    
                    [aDataSet insertObject:self.marrAccounts[i][@"2"]
                                    forKey:@"2"
                                   atIndex:0];
                    
                    self.exAccountData = accountNumber;
                    
                    [[NSUserDefaults standardUserDefaults] setEasyInquiryData:@"1"];
                    
                    break;
                }
            }
        }
    }
    else if (self.service.serviceId == EASY_INQUIRY_UPDATE) {
        [[NSUserDefaults standardUserDefaults] setEasyInquiryData:@"1"];
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:33 title:@"" message:@"간편조회 설정이 변경 되었습니다."];
    }
    else if (self.service.serviceId == EASY_INQUIRY_DELETE) {
        [[NSUserDefaults standardUserDefaults] setEasyInquiryData:@"2"];
        [[NSUserDefaults standardUserDefaults] removeEasyInquiryData];
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:33 title:@"" message:@"간편조회 설정이 변경 되었습니다."];
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 33) {
        [self.navigationController fadePopViewController];
    }
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
    if (selectBox == self.sbAccountList) {
        
        if ([self.marrAccounts count]) {
            [selectBox setState:SHBSelectBoxStateSelected];
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"입출금계좌"
                                                                           options:self.marrAccounts
                                                                           CellNib:@"SHBAccountListPopupCell"
                                                                             CellH:50
                                                                       CellDispCnt:5
                                                                        CellOptCnt:4] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
        else
        {
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"보유중인 출금계좌가 없습니다. 간편조회를 설정하실 수 없습니다."];
        }
    }
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    [self.sbAccountList setState:SHBSelectBoxStateNormal];
    
    self.selectedData = self.marrAccounts[anIndex];
    
    [self.sbAccountList setText:[self.selectedData objectForKey:@"2"]];
}

- (void)listPopupViewDidCancel
{
    [self.sbAccountList setState:SHBSelectBoxStateNormal];
}

@end
