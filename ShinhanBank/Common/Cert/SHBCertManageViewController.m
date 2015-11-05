//
//  SHBCertManageViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertManageViewController.h"
#import "SHBCertManageCell.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertPwdChangeViewController.h"
#import "SHBCertIDConfirmViewController.h"
#import "SHBCertInfoViewController.h"
#import "SHBLoginViewController.h"
#import "SHBNoCertForCertLogInViewController.h"
#import "MoaSignSDK.h"
#import "SHBLoginSettingViewController.h"

@interface SHBCertManageViewController ()
{
    int openedRow;
}
- (void) loadCertificates;

@end

@implementation SHBCertManageViewController

@synthesize certListTable;
@synthesize certList;
@synthesize selected_row;
@synthesize isSignupProcess;
@synthesize certListTemp;
@synthesize idBtn;
@synthesize subTitleLabel;
@synthesize settingBtn;

- (void)dealloc
{
    [settingBtn release];
    [certListTemp release];
    [certListTable release], certListTable = nil;
    [certList release], certList = nil;
    //[selectedCertificate release], selectedCertificate = nil;
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
    //AppInfo.certProcessType = CertProcessTypeCopyPC;
    [super viewDidLoad];
    
    //단말기 날짜와 시스템 날짜를 비교 한달 이상 차이가 나면 사용자 알럿을 보여준다.
    //서버시간 가져오기
    NSString *sTime = [SHBUtility getCurrentDate:YES];
    if ([sTime length] > 0)
    {
        //NSLog(@"aaaa:%i",[SHBUtility getDDay:sTime]);
        //dDay 구하기
        if ([SHBUtility getDDay:sTime] > 30 || [SHBUtility getDDay:sTime] < -30)
        {
            //알럿 뿌려주기
            NSString *msg = @"스마트폰 날짜 정보가 일치하지 않습니다.\n스마트폰 환경설정>날짜 및 시간>자동날짜 및 시간에 체크후 이용 부탁드립니다.";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:msg];
        }
    }
    
    AppInfo.indexQuickMenu = 0;
    
    if (AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign || (AppInfo.certProcessType == CertProcessTypeInFotterLogin && !AppInfo.isLoginView) || AppInfo.certProcessType ==CertProcessTypeIssueLogin)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self setTitle:@"Digital Certificate Login"];
            [self navigationBackButtonEnglish];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self setTitle:@"電子証明書ログイン"];
            [self navigationBackButtonJapnes];
        }else
        {
           [self setTitle:@"공인인증서 로그인"]; 
        }
        
        
    } else if (AppInfo.certProcessType == CertProcessTypeCopySHCard)
    {
        [self setTitle:@"신한카드 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopySHInsure)
    {
        [self setTitle:@"신한생명 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay)
    {
        [self setTitle:@"신한카드 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopyPC)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self setTitle:@"Copy certificate  smart phone➞pc"];
            [self navigationBackButtonEnglish];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self setTitle:@"スマートフォン➞PC　電子証明書コピー"];
            [self navigationBackButtonJapnes];
        }else
        {
            [self setTitle:@"스마트폰➞PC 인증서 복사"];
        }
    }else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self setTitle:@"Certificate Management"];
            [self navigationBackButtonEnglish];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self setTitle:@"電子証明書管理"];
            [self navigationBackButtonJapnes];
        }else
        {
            [self setTitle:@"인증서 관리"];
        }
        
    }
   	
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.subTitleLabel.text = @"List of certificates that can be selected";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.subTitleLabel.text = @"List of certificates that can be selected";
    }else
    {
        
    }
    
    //[self show];
    openedRow = -1;
    Debug(@"certProcessType1:%i",AppInfo.certProcessType);
    
    if ((AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin) && (AppInfo.isLogin != LoginTypeIDPW))
    {
        idBtn.hidden = NO;
    } else
    {
//        if (AppInfo.certProcessType == CertProcessTypeIssue)
//        {
//            AppInfo.certProcessType = CertProcessTypeLogin;
//        }
        
        idBtn.hidden = YES;
        
        
    }
    
//    if (AppInfo.certProcessType == CertProcessTypeIssueLogin)
//    {
//        //인증서 발급받고 로그인을 시도할때...
//        AppInfo.certProcessType = CertProcessTypeLogin;
//    }
    
    [self loadCertificates];
    //    // 인증서 로드.
    //    if ([self.certList count] == 0 && AppInfo.certProcessType == CertProcessTypeManage)
    //    {
    //        [self.navigationController fadePopViewController];
    //        SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
    //        [AppDelegate.navigationController pushFadeViewController:viewController];
    //        [viewController release];
    //        return;
    //    }
    
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && AppInfo.isiPhoneFive)
    if (AppInfo.isiPhoneFive)
    {
        [self.certListTable setFrame:CGRectMake(self.certListTable.frame.origin.x, self.certListTable.frame.origin.y, self.certListTable.frame.size.width, self.view.frame.size.height - 37 - 30 - 64)];
        [self.settingBtn setFrame:CGRectMake(self.settingBtn.frame.origin.x, self.view.frame.size.height - 40, self.settingBtn.frame.size.width, self.settingBtn.frame.size.height)];
    }
}


- (void)viewDidUnload
{
    [self setCertListTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)navigationButtonPressed:(id)sender
{
    [super navigationButtonPressed:sender];
    if (AppInfo.certProcessType == CertProcessTypeMoasignLogin)
    {
        int nReturn = IXL_nFilterKeyCheck();
        if(nReturn == 0)
        {
            [MoaSignSDK sendCertificateToServer:nil passwordData:nil delegate:self];
        }else
        {
            [MoaSignSDK sendCertificateToServer:nil password:nil delegate:self];
        }
        
        AppInfo.certProcessType = CertProcessTypeNo;
    }
}

#pragma mark - 프라이빗 메서드

// 인증서 로드.
- (void)loadCertificates
{
    
    self.certList = [AppInfo loadCertificates];
    self.certListTemp = [NSMutableArray array];
    
    if (AppInfo.certProcessType != CertProcessTypeManage) //만료된 인증서는 보여주지 않는다.(인증서 관리는 보여준다.
    {
        NSString *dday;
        for (int i = 0; i < [self.certList count]; i++)
        {
            dday = [[self.certList objectAtIndex:i] expire];
            int dDay = [SHBUtility getDDay:dday];
//            NSLog(@"만료 여부:%i",[[self.certList objectAtIndex:i] expired]);
//            NSLog(@"expire:%@",[[self.certList objectAtIndex:i] expire]);
//            NSLog(@"user:%@",[[self.certList objectAtIndex:i] user]);
//            NSLog(@"dDay:%i",dDay);
            if (dDay < 0) //만료일이 지났으면...
            {
                
                
            }else //만료일이 지나지 않았으면 넣는다.
            {
                [certListTemp addObject:[self.certList objectAtIndex:i]];
            }
        }
        self.certList = self.certListTemp;
    }
    
    
	[self.certListTable reloadData];
    
    if ([self.certList count] == 0 && (AppInfo.certProcessType == CertProcessTypeManage || AppInfo.certProcessType == CertProcessTypeCopyPC))
    {
        [self.navigationController fadePopViewController];
        SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        
        if (AppInfo.certProcessType == CertProcessTypeCopyPC)
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                viewController.title = @"Copy certificate smart phone➞pc";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                viewController.title = @"スマートフォン➞PC　電子証明書コピー";
            }else
            {
                viewController.title = @"스마트폰➞PC 인증서 복사";
            }
            
            
        } else
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                viewController.title = @"Certificate Management";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                viewController.title = @"電子証明書管理";
            }else
            {
                viewController.title = @"인증서 관리";
            }
            
        }
        
        [viewController release];
        return;
    }
    //[self dismiss];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"opendRow:%i, row:%i",openedRow, indexPath.row);
    
    if(openedRow == indexPath.row)
    {
        return 118;
    }
    return 73;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.certList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SHBCertManageCell *cell = (SHBCertManageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBCertManageCell" owner:self options:nil];
		
		for(id oneObject in topLevelObjects)
			if([oneObject isKindOfClass:[SHBCertManageCell class]])
				cell = (SHBCertManageCell *)oneObject;
	}
	
	NSUInteger row = [indexPath row];
	NSString *subject = [NSString stringWithFormat:@"%@",[[self.certList objectAtIndex:row] user]];
	cell.subjectLabel.text = subject;
	cell.issuerAliasLabel.text = [[self.certList objectAtIndex:row] issuer];
	cell.typeLabel.text = [[self.certList objectAtIndex:row] type];
	cell.notAfterLabel.text = [[self.certList objectAtIndex:row] expire];
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        cell.issuerTitleLabel.text = @"Issuer :";
        cell.notAfterTitle.text = @"Expiration date :";
        [cell.notAfterTitle setFrame:CGRectMake(cell.notAfterTitle.frame.origin.x, cell.notAfterTitle.frame.origin.y, 100.0f, cell.notAfterTitle.frame.size.height)];
        [cell.notAfterLabel setFrame:CGRectMake(170.0f, cell.notAfterLabel.frame.origin.y, 100.0f, cell.notAfterLabel.frame.size.height)];
        
        [cell.certDelBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [cell.certPwdBtn setTitle:@"Chg PWD" forState:UIControlStateNormal];
        //[cell.certConfirmBtn setTitle:@"Identity" forState:UIControlStateNormal];
        [cell.certInfoBtn setTitle:@"Info" forState:UIControlStateNormal];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        cell.issuerTitleLabel.text = @"発行者 :";
        cell.notAfterTitle.text = @"満了日 :";
        [cell.certDelBtn setTitle:@"削除" forState:UIControlStateNormal];
        [cell.certPwdBtn setTitle:@"番号変更" forState:UIControlStateNormal];
        //[cell.certConfirmBtn setTitle:@"本人確認" forState:UIControlStateNormal];
        [cell.certInfoBtn setTitle:@"詳細情報" forState:UIControlStateNormal];
    }else
    {
        
    }
    
    //NSLog(@"expired:%i",[[self.certList objectAtIndex:row] expired]);
    
    int dDay = [SHBUtility getDDay:cell.notAfterLabel.text];
    //int dDay = [SHBUtility getDDay:@"2012-11-23"];
    
    //갱신 한달 남은 인증서는 만료일 항목을 빨간색으로
    if (dDay <= 30)
    {
        //만료된 인증서인지 확인하고 이미지와 색깔을 바꿔준다.
        if (dDay < 0)
        {
            cell.notAfterTitle.textColor = RGB(209, 75, 75);
            cell.notAfterLabel.textColor = RGB(209, 75, 75);
            cell.certImage.image = [UIImage imageNamed:@"icon_certificate_expire.png"];
        } else
        {
            cell.notAfterTitle.textColor = RGB(209, 75, 75);
            cell.notAfterLabel.textColor = RGB(209, 75, 75);
        }
        
    }
    
    if (AppInfo.certProcessType == CertProcessTypeManage)
    {
        cell.btnOpen.hidden = NO;
    } else
    {
        cell.btnOpen.hidden = YES;
    }
    cell.cellButtonActionDelegate = self;
    
    if(openedRow == indexPath.row){
        cell.bgView.hidden = NO;
        cell.certDelBtn.hidden = NO;
        cell.certPwdBtn.hidden = NO;
        //cell.certConfirmBtn.hidden = NO;
        cell.certInfoBtn.hidden = NO;
        cell.lineImage.hidden = YES;
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    } else
    {
        cell.bgView.hidden = YES;
        cell.certDelBtn.hidden = YES;
        cell.certPwdBtn.hidden = YES;
        //cell.certConfirmBtn.hidden = YES;
        cell.certInfoBtn.hidden = YES;
        cell.lineImage.hidden = NO;
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
    }
    cell.row = indexPath.row;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!(indexPath.row == openedRow))
    {
        openedRow = -1;
    }
    //NSLog(@"openedRow:%i, ndexPath.row:%i",openedRow, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selected_row = [indexPath row];
    
    //선택된 인증서를 전역으로 저장한다.
    if (AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign)
    {
        CertificateInfomation *certificate = [self.certList objectAtIndex:[indexPath row]];
        AppInfo.selectCertificateInfomation = certificate;
    } else
    {
        CertificateInfo *certificate = [self.certList objectAtIndex:[indexPath row]];
        AppInfo.selectedCertificate = certificate;
    }
    
    
    if (AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeCopyPC || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign || AppInfo.certProcessType == CertProcessTypeIssue ||  AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay || AppInfo.certProcessType == CertProcessTypeIssueLogin)
    {
        
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        
        if (isSignupProcess) //루트로 가기 위해
        {
            viewController.isSignupProcess = YES;
        }
        [self.navigationController pushFadeViewController:viewController];
        if (AppInfo.certProcessType == CertProcessTypeRenew)
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                viewController.title = @"Certificate renewal";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                viewController.title = @"電子証明書更新";
            }else
            {
                viewController.title = @"인증서 갱신";
            }
            
        }
        
        [viewController release];
        
    } else
    {
        openedRow = indexPath.row;
        [self.certListTable reloadData];
    }
    
}

#pragma mark -
#pragma mark SHBCellActionProtocol

- (void)cellButtonActionisOpen:(int)aRow
{
    
    if( openedRow == aRow )        // 같은 cell의 경우
    {
        openedRow = -1;
    }
    else                                // 다른 cell의 경우
    {
        openedRow = aRow;
        CertificateInfo *certificate = [self.certList objectAtIndex:openedRow];
        AppInfo.selectedCertificate = certificate;
    }
    self.selected_row = aRow;
    [certListTable reloadData];
}

- (void)cellButtonAction:(int)aTag
{
    
    NSString *msg;
    
    if (aTag == 2001)
    {
        //AppInfo.certProcessType = CertProcessTypeDel;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Are you sure  that you want to delete the certificate?";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"電子証明書を削除しましょうか。";
        }else
        {
            msg = @"인증서를 삭제하시겠습니까?";
        }
        
        if (AppInfo.isLogin == LoginTypeCert)
        {
            CertificateInfo *certificate = [self.certList objectAtIndex:self.selected_row];
            if ([AppInfo.loginCertificate.user isEqualToString:certificate.user] && [AppInfo.loginCertificate.issuer isEqualToString:certificate.issuer] && [AppInfo.loginCertificate.type isEqualToString:certificate.type] && [AppInfo.loginCertificate.expire isEqualToString:certificate.expire])
            {
                msg = @"삭제하실 인증서로 로그인 하셨습니다.\n로그아웃 후 메인화면으로 이동합니다.\n인증서를 삭제하시겠습니까?";
                AppInfo.loginCertificate = nil;
            }
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeTwoButton tag:2001 title:@"" message:msg language:AppInfo.LanguageProcessType];
        
    } else if (aTag == 2002)
    {
        AppInfo.certProcessType = CertProcessTypePwdChange;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertPwdChangeViewController *viewController = [[SHBCertPwdChangeViewController alloc] initWithNibName:@"SHBCertPwdChangeViewControllerEng" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBCertPwdChangeViewController *viewController = [[SHBCertPwdChangeViewController alloc] initWithNibName:@"SHBCertPwdChangeViewController" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
    } else if (aTag == 2003)
    {
        AppInfo.certProcessType = CertProcessTypeIDConfirm;
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertIDConfirmViewController *viewController = [[SHBCertIDConfirmViewController alloc] initWithNibName:@"SHBCertIDConfirmViewControllerEng" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBCertIDConfirmViewController *viewController = [[SHBCertIDConfirmViewController alloc] initWithNibName:@"SHBCertIDConfirmViewController" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
    } else if (aTag == 2004)
    {
        AppInfo.certProcessType = CertProcessTypeInfo;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertInfoViewController *viewController = [[SHBCertInfoViewController alloc] initWithNibName:@"SHBCertInfoViewControllerEng" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBCertInfoViewController *viewController = [[SHBCertInfoViewController alloc] initWithNibName:@"SHBCertInfoViewController" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
        
    } else
    {
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *msg;
    
    if (alertView.tag == 2001 && buttonIndex == 0) //삭제
    {
        
        
        openedRow = -1; //버튼이 보이지 않게 하기 위함
        [[self.certList objectAtIndex:self.selected_row] deleteCert]; //키체인 삭제
        [self.certList removeObjectAtIndex:self.selected_row];
        [self.certListTable reloadData];
        
        AppInfo.certProcessType = CertProcessTypeManage;
        
        if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected)
        {
         
            [AppInfo loadCertificates];
            if (AppInfo.selectedCertificate == nil)
            {
                [[NSUserDefaults standardUserDefaults]setCertificateData:nil];
            }
        }
        if ([self.certList count] == 0)
        {
            [self.navigationController fadePopViewController];
            SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                viewController.title = @"Certificate Management";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                viewController.title = @"電子証明書管理";
            }else
            {
                viewController.title = @"인증서 관리";
            }
            
            [viewController release];
            //return;
        }
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"You have successfully deleted a digital certificate.No matter what the certificate deleted, you can use a digital certificate which was stored on other devices. You have successfully deleted a digital certificate.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"電子証明書削除が完了しました。他の機器に保存された有効な電子証明書がある場合、削除された電子証明書とは関係なくご利用できます。";
        }else
        {
           msg = @"인증서 삭제가 완료되었습니다.\n다른 기기에 저장된 유효한\n인증서가 있을경우 삭제된\n인증서와 무관하게\n사용이 가능합니다."; 
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        if (AppInfo.isLogin == LoginTypeCert && AppInfo.loginCertificate == nil)
        {
            [AppInfo logout];
            [AppDelegate.navigationController fadePopToRootViewController];
        }
        
    }
}

- (IBAction) pushIDPWDLoginView:(id)sender
{
    [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    
    AppInfo.certProcessType = CertProcessTypeNo;
    SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}

- (IBAction) pushLoginSettingView:(id)sender
{
    [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    
    AppInfo.certProcessType = CertProcessTypeNo;
    SHBLoginSettingViewController *viewController = [[SHBLoginSettingViewController alloc] initWithNibName:@"SHBLoginSettingViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}
#pragma mark - 모아싸인 델리게이트 콜백
- (void)finishSendCertificate:(NSString*)errorCode
{
    NSString *resultString = nil;
    if ([@"0" isEqualToString:errorCode]) {
        //인증서 데이터 전송처리와 동시에 제출처리 완료가 되므로 따로 처리를 호출할 필요가 없음.
        //화면위치 초기화
        [self.navigationController fadePopToRootViewController];
        //종료처리는 별도로 호출해야함
        [MoaSignSDK callbackWebPage];
        
    }else{
        resultString = [NSString stringWithFormat: @"인증서 제출에 실패하였습니다.\n(error code:%@)",errorCode];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"인증서 제출"
                              message:resultString
                              delegate:nil
                              cancelButtonTitle:@"확인"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];        // release 처리
    }
    
}
@end
