//
//  SHBFirstLogInSettingType2ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFirstLogInSettingType2ViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBLoginSettingViewController.h"
#import "INISAFEXSafe.h"

@interface SHBFirstLogInSettingType2ViewController ()
{
    NSMutableArray *marrCertificates;
    NSString *notBefore;
}

- (int) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen;

@end

@implementation SHBFirstLogInSettingType2ViewController
@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize certIndex;

- (void) dealloc
{
    [subjectLabel release];
    [issuerAliasLabel release];
    [notAfterLabel release];
    [typeLabel release];
    
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
    //[self navigationViewHidden];
    [self setTitle:@"인증서 관리"];
    self.certArray = [AppInfo loadCertificates];
    
    if ([self.certArray count] == 1)
    {
        self.subjectLabel.text = [[self.certArray objectAtIndex:0] user];
        self.issuerAliasLabel.text = [[self.certArray objectAtIndex:0] issuer];
        self.typeLabel.text = [[self.certArray objectAtIndex:0] type];
        self.notAfterLabel.text = [[self.certArray objectAtIndex:0] expire];
        
    } else
    {
        NSString *toDay = [SHBUtility getCurrentDate:YES];
        
        for (int i = 0; i < [self.certArray count]; i++)
        {
            //인증서 상세정보 가져오기
            unsigned char *cert = NULL;
            int certlen = 0;
            
            unsigned char *priv_str = NULL;
            int priv_len = 0;
            
            unsigned char *certDetailStr = NULL;
            int certDetailStrlen = 0;
            
            /* get cert and key */
            int ret = IXL_GetCertPkey([[self.certArray objectAtIndex:i] index], &cert, &certlen, &priv_str, &priv_len);
            if(0 != ret){
                // error
            }
            
            ret = IXL_Make_CertDetail(cert, certlen, &certDetailStr, &certDetailStrlen);
            if(0 != ret){
                
            }
            
            ret = [self DetailInfoWithParsing:certDetailStr length:certDetailStrlen];
            if(0 != ret){
                
            }
            
            if ([toDay isEqualToString:notBefore])
            {
               
                
                self.certIndex = i; //찾은 인덱스 정보를 저장
                break;
            }
        }
        
        self.subjectLabel.text = [[self.certArray objectAtIndex:self.certIndex] user];
        self.issuerAliasLabel.text = [[self.certArray objectAtIndex:self.certIndex] issuer];
        self.typeLabel.text = [[self.certArray objectAtIndex:self.certIndex] type];
        self.notAfterLabel.text = [[self.certArray objectAtIndex:self.certIndex] expire];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    self.certArray = [AppInfo loadCertificates];
    
    if ([self.certArray count] == 1)
    {
        NSUInteger row = [self.certArray count] - 1;
        NSString *subject = [NSString stringWithFormat:@"%@",[[self.certArray objectAtIndex:row] user]];
        
        //선택된 인증서를 전역으로 저장한다.
        CertificateInfo *certificate = [self.certArray objectAtIndex:row];
        AppInfo.selectedCertificate = certificate;
        
        //인증서 지정
        [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeCertificateSelected];
        
        NSMutableDictionary *certInfoDic = [NSMutableDictionary dictionary];
        NSDictionary *forwardDic =
        @{
        @"1" : subject,
        @"2" : [[self.certArray objectAtIndex:row] issuer],
        @"3" : [[self.certArray objectAtIndex:row] expire],
        @"4" : [[self.certArray objectAtIndex:row] type],
        };
        
        [certInfoDic setDictionary:forwardDic];
        [[NSUserDefaults standardUserDefaults]setCertificateData:certInfoDic];
        
        NSString *msg = @"복사된 인증서로\n로그인 되도록 설정 되었습니다.\n로그인 화면으로 이동합니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg];
    } else
    {
//        [self dismissModalViewControllerAnimated:NO];
//        SHBLoginSettingViewController *viewController = [[SHBLoginSettingViewController alloc] initWithNibName:@"SHBLoginSettingViewController" bundle:nil];
//        [AppDelegate.navigationController pushFadeViewController:viewController];
//        [viewController release];
        
        marrCertificates = [NSMutableArray array];
        for (int i = 0; i < [self.certArray count]; i++)
        {
            //NSLog(@"bbbb:%@",[[self.certList objectAtIndex:i] user]);
            if ([[self.certArray objectAtIndex:i] expired] == 0)
            {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                [mdic setObject:[[self.certArray objectAtIndex:i] user] forKey:@"1"];
                [mdic setObject:[[self.certArray objectAtIndex:i] issuer] forKey:@"2"];
                [mdic setObject:[[self.certArray objectAtIndex:i] expire] forKey:@"3"];
                [mdic setObject:[[self.certArray objectAtIndex:i] type] forKey:@"4"];
                [marrCertificates addObject:mdic];
            }
            
        }
        
        SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"인증서 목록"
                                                                       options:marrCertificates
                                                                       CellNib:@"SHBLoginSettingCell"
                                                                         CellH:69
                                                                   CellDispCnt:5
                                                                    CellOptCnt:3] autorelease];
        [popupView setDelegate:self];
        [popupView showInView:self.view animated:YES];
    }
}
- (IBAction) cancelClick:(id)sender
{
    [AppInfo loadCertificates];
    if (AppInfo.certificateCount == 1)
    {
        // 인증서 로그인.
        if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
        }
        
        //[AppDelegate.navigationController fadePopViewController];
        [self dismissModalViewControllerAnimated:NO];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        viewController.whereAreYouFrom = FromLogin;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    } else
    {
        SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
        
        // 인증서 목록 로그인.
        if (AppInfo.certProcessType == CertProcessTypeInFotterLogin) {
            
            viewController.isSignupProcess = YES;
            
        } else
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
        }
        //[AppDelegate.navigationController fadePopViewController];
        [self dismissModalViewControllerAnimated:NO];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        
        viewController.whereAreYouFrom = FromLogin;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 10) {
        
        [AppDelegate.navigationController fadePopToRootViewController];
        
        //로그인 화면으로 이동
        AppInfo.certProcessType = CertProcessTypeLogin;
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        
    }
    
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	//NSLog(@"aaaa:%i",anIndex);
    
    //선택된 인증서를 전역으로 저장한다.
    CertificateInfo *certificate = [self.certArray objectAtIndex:anIndex];
    AppInfo.selectedCertificate = certificate;
    NSString *subject = [NSString stringWithFormat:@"%@",[[self.certArray objectAtIndex:anIndex] user]];
    //인증서 지정
    [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeCertificateSelected];
    
    NSMutableDictionary *certInfoDic = [NSMutableDictionary dictionary];
    NSDictionary *forwardDic =
    @{
    @"1" : subject,
    @"2" : [[self.certArray objectAtIndex:anIndex] issuer],
    @"3" : [[self.certArray objectAtIndex:anIndex] expire],
    @"4" : [[self.certArray objectAtIndex:anIndex] type],
    };
    
    [certInfoDic setDictionary:forwardDic];
    [[NSUserDefaults standardUserDefaults]setCertificateData:certInfoDic];
    
    
    NSString *msg = @"선택된 인증서로\n로그인 되도록 설정 되었습니다.\n로그인 화면으로 이동합니다.";
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg];
	//self.selectedData = [self.marrCertificates objectAtIndex:anIndex];
	
	
}

- (void)listPopupViewDidCancel
{
	//[self.sbCertificate setState:SHBSelectBoxStateNormal];
}

- (int) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen
{
    
	// 받은 정보를 파싱해서 각 변수에 보존
	//NSString *tempCertString = [NSString stringWithCString:line length:strlen];
    NSString *tempCertString = [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
	
	NSArray *tempArray1 = nil;
	NSArray *tempArray2 = nil;
	NSString *tempString = nil;
	unsigned char* pEncoding = NULL;
	int nEncodinglen = 0;
	int nRet = 0;
	
	
	tempArray1 = [tempCertString componentsSeparatedByString:@"&"];
	
	//NSLog(@" CertDetailInfo : %@", tempArray1);
	
	for (int index = 0; ([tempArray1 count]-1)>index; index++) {
		pEncoding = NULL;
		
		tempString = [tempArray1 objectAtIndex:index];
		tempArray2 = [tempString componentsSeparatedByString:@"^"];
		
//		NSString *tempTitle = [tempArray2 objectAtIndex:0];
		
		char *buf = (char*)[[tempArray2 objectAtIndex:1] UTF8String];
		nRet = IXL_DataDecode(ENCODE_URL_OR_BASE64,
							  (unsigned char*)buf,
							  [[tempArray2 objectAtIndex:1] length],
							  &pEncoding,&nEncodinglen);
		
		NSString *tempContents = [NSString stringWithCString:pEncoding
                                                    encoding:NSEUCKRStringEncoding];
		
		
        
        if( [@"validity_from" isEqual:[tempArray2 objectAtIndex:0]])
        {
            //self.notBefore = tempContents;
//            tempTitle = @"유효기간 시작";
            //NSLog(@"aaaa:%@",tempContents);
            notBefore = tempContents;
        }
        
	}
	return 0;
}


@end
