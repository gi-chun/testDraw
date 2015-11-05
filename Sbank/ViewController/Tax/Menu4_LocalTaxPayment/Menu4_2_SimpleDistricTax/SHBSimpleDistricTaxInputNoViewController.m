//
//  SHBSimpleDistricTaxInputNoViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 11..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSimpleDistricTaxInputNoViewController.h"
#import "SHBGiroTaxListService.h"           // 지로 지방세 서비스
#import "SHBSimpleDistricTaxListViewController.h"       // 다음 view


@interface SHBSimpleDistricTaxInputNoViewController ()

@end

@implementation SHBSimpleDistricTaxInputNoViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    [self didCompleteButtonTouch];
    
    switch ([sender tag]) {
            
        case 11:            // 조회버튼
        {
            if ( nil == textField1.text || [textField1.text isEqualToString:@""])
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"간편납부번호를 입력해 주세요.(15자리 입력)"];
                return;
            }
            
            OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"전문종별코드" : @"0200",
                                    @"거래구분코드" : @"531001",
                                    @"이용기관지로번호" : @"000000000",
                                    @"조회구분" : @"Z",
                                    @"간편납부번호" : textField1.text,
                                    //@"고지주민번호" : AppInfo.ssn,
                                    //@"고지주민번호" : [AppInfo getPersonalPK],
                                    @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    @"총고지건수" : @"",
                                    @"총고지금액" : @"",
                                    @"지정번호" : @"1",
                                    @"데이터건수" : @""
                                    }] autorelease];
            
            self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_DISTRIC_PAYMENT_LIST viewController: self ] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
            [self.dicDataDictionary removeAllObjects];
            self.dicDataDictionary = aDataSet;
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G1411"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            SHBSimpleDistricTaxListViewController *viewController = [[SHBSimpleDistricTaxListViewController alloc] initWithNibName:@"SHBSimpleDistricTaxListViewController" bundle:nil];
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
    
    return NO;
}


#pragma mark -
#pragma mark SHBTextField Delegate

- (void)didCompleteButtonTouch
{
    [super didCompleteButtonTouch];
}


#pragma mark -
#pragma mark Notifications

- (void)textFieldDidChange
{
    if (curTextField == textField1)
    {
        if ([curTextField.text length] > 15)
        {
            curTextField.text = [curTextField.text substringToIndex:15];
        }
    }
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    // title 설정
    self.title = @"지방세납부";
    self.strBackButtonTitle = @"간편납부번호 입력";
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
    
    textField1.accDelegate = self;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    // text 수정 notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    
    [super dealloc];
}

@end
