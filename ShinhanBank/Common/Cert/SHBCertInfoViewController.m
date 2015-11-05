//
//  SHBCertInfoViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertInfoViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertInfoViewController ()

- (int) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen;

@end

@implementation SHBCertInfoViewController

@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize certImageView;
//@synthesize confirmBtn;
@synthesize notAfterTitle;

@synthesize cnLabel0;
@synthesize cnLabel1;
@synthesize cnLabel2;
@synthesize cnLabel3;
@synthesize cnLabel4;
@synthesize cnLabel5;
@synthesize cnLabel6;
@synthesize cnLabel7;
@synthesize cnLabel8;
@synthesize cnLabel9;
//인증서 정보 속성
//@synthesize version;					// 버전
//@synthesize serialNumber;				// 일련번호
//@synthesize signAlgorithm;			// 서명 알고리즘
//@synthesize issuerDN;					// 발급자
//@synthesize notBefore;				// 유효기간 시작
//@synthesize notAfter;					// 유효기간 종료
//@synthesize subjectDN;				// 주체
//@synthesize publicKeyAlgorithm;		// 공개키 알고리즘
//@synthesize publicKeyBit;				// 공개키 Bit
//@synthesize fingerPrint;				// 손도장
//@synthesize fingerPrintAlgorithm;		// 손도장 알고리즘
//@synthesize authorityKeyIdentifier;	// 기관 키 식별자
//@synthesize subjectKeyIdentifier;		// 주체 키 식별자
//@synthesize keyUsage;					// 키 사용
//@synthesize certificatePolicy;		// 정책
//@synthesize subjectAltName;			// 주체 대체 이름
//@synthesize CRLDistributionPoints;	// CRL배포지점
//@synthesize authorityInfoAcc;			// AIAs

- (void) dealloc
{
    [cnLabel9 release];
    [cnLabel8 release];
    [cnLabel7 release];
    [cnLabel6 release];
    [cnLabel5 release];
    [cnLabel4 release];
    [notAfterTitle release];
    //[confirmBtn release];
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
        self.strBackButtonTitle = @"인증서 관리";
    }
    
    self.subjectLabel.text = AppInfo.selectedCertificate.user;
    self.issuerAliasLabel.text = AppInfo.selectedCertificate.issuer;
    self.typeLabel.text = AppInfo.selectedCertificate.type;
    self.notAfterLabel.text = AppInfo.selectedCertificate.expire;
    
    int dDay = [SHBUtility getDDay:self.notAfterLabel.text];
    //int dDay = [SHBUtility getDDay:@"2012-11-23"];
    
    //만료된 인증서인지 확인하고 이미지와 색깔을 바꿔준다.
    if (dDay < 0)
    {
        self.notAfterTitle.textColor = RGB(209, 75, 75);
        self.notAfterLabel.textColor = RGB(209, 75, 75);
        certImageView.image = [UIImage imageNamed:@"icon_certificate_expire.png"];
    }
    
    //인증서 상세정보 가져오기
    unsigned char *cert = NULL;
	int certlen = 0;
	
	unsigned char *priv_str = NULL;
	int priv_len = 0;
	
	unsigned char *certDetailStr = NULL;
	int certDetailStrlen = 0;
	
	/* get cert and key */
	int ret = IXL_GetCertPkey([AppInfo.selectedCertificate index], &cert, &certlen, &priv_str, &priv_len);
	if(0 != ret){
		// error
	}
	
	ret = IXL_Make_CertDetail(cert, certlen, &certDetailStr, &certDetailStrlen);
	if(0 != ret){
        
	}
	
	ret = [self DetailInfoWithParsing:certDetailStr length:certDetailStrlen];
	if(0 != ret){
		
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmBtn:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeManage;
    [self.navigationController fadePopViewController];
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
		
		
		if( [@"version" isEqual:[tempArray2 objectAtIndex:0]])
		{
			self.cnLabel0.text =  tempContents;
            
		}
		if( [@"serial" isEqual:[tempArray2 objectAtIndex:0]])
		{
			NSArray *tempArray3 = [tempContents componentsSeparatedByString:@" ("];
			tempContents = [tempArray3 objectAtIndex:0];
            self.cnLabel1.text = tempContents;
		}
		if( [@"signatureAlg" isEqual:[tempArray2 objectAtIndex:0]])
		{
            self.cnLabel2.text = tempContents;
		}
		if( [@"issuerDN" isEqual:[tempArray2 objectAtIndex:0]])
		{
            self.cnLabel3.text = tempContents;
		}
		if( [@"validity_from" isEqual:[tempArray2 objectAtIndex:0]])
		{
            NSString *tmpStr = [NSString stringWithFormat:@"%@ 00:00:00",tempContents];
            self.cnLabel4.text = tmpStr;
		}
		if( [@"validity_to" isEqual:[tempArray2 objectAtIndex:0]])
		{
            NSString *tmpStr = [NSString stringWithFormat:@"%@ 23:59:59",tempContents];
            self.cnLabel5.text = tmpStr;
            
		}
		if( [@"subjectDN" isEqual:[tempArray2 objectAtIndex:0]])
		{
    
            NSArray *tempArray3 = [tempContents componentsSeparatedByString:@","];
            NSString *tmpStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",[tempArray3 objectAtIndex:0],[tempArray3 objectAtIndex:1],[tempArray3 objectAtIndex:2],[tempArray3 objectAtIndex:3],[tempArray3 objectAtIndex:4]];
            self.cnLabel6.text = tmpStr;
           
		}
		if( [@"pubkey" isEqual:[tempArray2 objectAtIndex:0]])
		{
			
			NSArray *tempArray3 = [tempContents componentsSeparatedByString:@" ("];
			self.cnLabel7.text = [[tempArray3 objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		}

		if( [@"keyusage" isEqual:[tempArray2 objectAtIndex:0]])
		{
			if ([tempContents length] > 34)
            {
                self.cnLabel8.text = [tempContents substringToIndex:34];
            }else
            {
                self.cnLabel8.text = tempContents;
            }
            
		}
		if( [@"certpolicy" isEqual:[tempArray2 objectAtIndex:0]])
		{
			
            NSArray *tempArray3 = [tempContents componentsSeparatedByString:@","];
            
            for (int i = 0; i < [tempArray3 count]; i++)
            {
                if ([SHBUtility isFindString:[[tempArray3 objectAtIndex:i] lowercaseString]  find:@"text"])
                {
                    self.cnLabel9.text = [[tempArray3 objectAtIndex:i] substringFromIndex:5];
                    break;
                }
                
            }
            
		}

	}
	return 0;
}

- (void)navigationButtonPressed:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeManage;
    [super navigationButtonPressed:sender];
}

@end
