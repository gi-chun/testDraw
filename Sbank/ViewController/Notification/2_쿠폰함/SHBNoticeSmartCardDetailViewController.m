//
//  SHBNoticeSmartCardDetailViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 15..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartCardDetailViewController.h"
#import "SHBNotificationService.h"
#import "SHBSmartCardTelStipulationViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>


@interface SHBNoticeSmartCardDetailViewController ()
<SHBSmartCardTelStipulationDelegate, MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) SHBSmartCardTelStipulationViewController *smartCardTelStipulation;
@end

@implementation SHBNoticeSmartCardDetailViewController

@synthesize dicDataDictionary;
@synthesize bigView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    
    //[super viewDidLoad];
    //[self navigationViewHidden];
    [self setBottomMenuView];
    
    
    NSString *date1 = [self.dicDataDictionary[@"스마트명함조회기간"] substringToIndex:4];
    NSString *date2 = [self.dicDataDictionary[@"스마트명함조회기간"] substringWithRange:NSMakeRange(4,2)];
    NSString *date3 = [self.dicDataDictionary[@"스마트명함조회기간"] substringFromIndex:6];
    
    
    
    label1.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"직원명"]];
    
    
    label12.text = [NSString stringWithFormat:@"%@ %@", self.dicDataDictionary[@"지점명"],self.dicDataDictionary[@"직급"]];
    

    
    if (![self.dicDataDictionary[@"대화명"] isEqualToString:@""]) {
        label2.text = [NSString stringWithFormat:@"[%@]", self.dicDataDictionary[@"대화명"]];
    }
    
   
    label3.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"직장주소"]];
    label3.numberOfLines=2;
    label4.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"대표전화"]];
    label5.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"직통전화"]];
    label6.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"이메일"]];
    label7.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"핸드폰"]];
    label8.text = [NSString stringWithFormat:@"팩스: %@", self.dicDataDictionary[@"FAX"]];
    label9.text = [NSString stringWithFormat:@"명함조회기간: %@.%@.%@",  date1,date2,date3];
    if ([self.dicDataDictionary[@"전담직원여부"] isEqualToString:@"1"]) {
        label10.text = @"전담직원";
        label10.backgroundColor = [UIColor redColor];
        
        labelbig10.text = @"전담직원";
        labelbig10.backgroundColor = [UIColor redColor];
    }
    
    label11.text = [NSString stringWithFormat:@"%@", self.dicDataDictionary[@"스마트명함메세지"]];
    
    labelbig1.text = label1.text;
    labelbig2.text = label2.text;
    labelbig3.text = label3.text;
    labelbig4.text = label4.text;
    labelbig5.text = label5.text;
    labelbig6.text = label6.text;
    labelbig7.text = label7.text;
    labelbig8.text = label8.text;
    labelbig12.text = label12.text;
    
    if ([label4.text length] == 0) {
        
        [btnBig4 setHidden:YES];
    }
    if ([label5.text length] == 0) {
        
        [btnBig5 setHidden:YES];
    }
    if ([label6.text length] == 0) {
        
        [btnBig6 setHidden:YES];
    }
    if ([label7.text length] == 0) {
        
        [btnBig7 setHidden:YES];
    }
    
    NSString *tDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];

    

    

    
    

    
    
    if(![SHBUtility isOPDate:tDate] ||
       [self.dicDataDictionary[@"전화상담요청가능시작시간"] isEqualToString:@""] ||
       [self.dicDataDictionary[@"전화상담요청가능종료시간"] isEqualToString:@""] )
    {
        btn_tel.hidden= YES;
       
    }
    
//    else  // 시간제한 없이 버튼 노출 2014.9.23 개발의뢰
//    {
//        if ( tTime <  Tstart_tTime || tTime  > Tend_tTime)
//        {
//             btn_tel.hidden= YES;
//        }
//        
//
//    }
    
    if(![SHBUtility isOPDate:tDate] ||
       [self.dicDataDictionary[@"쪽지전송가능시작시간"] isEqualToString:@""] ||
       [self.dicDataDictionary[@"쪽지전송가능종료시간"] isEqualToString:@""])
    {
         btn_massege.hidden= YES;
    }
//    else  // 시간제한 없이 버튼 노출 2014.9.23 개발의뢰
//    {
//        
//        
//        if ( tTime <  Mstart_tTime || tTime  > Mend_tTime)
//        {
//            btn_massege.hidden= YES;
//        }
//
//    }
    

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"1111");
    [self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
}

- (void)adjustView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        
        NSLog(@"y :%f",self.view.frame.origin.y);
        if (self.view.frame.origin.y == 20)
        {
            NSLog(@"2222");
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height)];
        }
        
        
    }
    
}

- (void)adjustView1
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height)];
    }
}
- (void)setBottomMenuView{
	float	viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 548;
	else
		viewHeight = 460;
	
	if (!_bottomMenuView)
        // release 추가
		
        _bottomMenuView = [[[SHBBottomView alloc] initWithFrame:CGRectMake(0, viewHeight - (74+49), self.view.frame.size.width, 49)] autorelease];
	
	if (AppInfo.isLogin){
		[_bottomMenuView changeLogInOut:YES];
	}else{
		[_bottomMenuView changeLogInOut:NO];
	}
	
    [self changeBottmNotice:AppInfo.noticeState];
	[_bottomMenuView setDelegate:self];
	[self.view addSubview:_bottomMenuView];
	[self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
}
 
- (void)saveAddress:(ABAddressBookRef)addressBook
{
    NSString *number = @"";
    
    BOOL isPhoneNumber = NO;
    
    if ([self.dicDataDictionary[@"직통전화"] length] > 0) {
        
        number = self.dicDataDictionary[@"직통전화"];
    }
    else if ([self.dicDataDictionary[@"대표전화"] length] > 0) {
        
        number = self.dicDataDictionary[@"대표전화"];
    }
    else if ([self.dicDataDictionary[@"핸드폰"] length] > 0) {
        
        number = self.dicDataDictionary[@"핸드폰"];
        
        isPhoneNumber = YES;
    }
    
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([number length] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"제공된 연락처가 없습니다."];
        return;
    }
    
    CFArrayRef addressList = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // 연락처 중복 여부 체크
    for (int i = 0; i < CFArrayGetCount(addressList); i++) {
        
        ABRecordRef record = CFArrayGetValueAtIndex(addressList, i);
        
        NSString *name = [NSString stringWithFormat:@"%@", ABRecordCopyCompositeName(record)];
        
        // 직원명이 들어가는지 확인
        if ([SHBUtility isFindString:name find:self.dicDataDictionary[@"직원명"]]) {
            
            ABMultiValueRef phoneRef = ABRecordCopyValue(record, kABPersonPhoneProperty);
            
            for (int j = 0; j < ABMultiValueGetCount(phoneRef); j++) {
                
                NSString *str = [NSString stringWithFormat:@"%@", ABMultiValueCopyValueAtIndex(phoneRef, j)];
                
                // 전화번호가 동일한지 확인
                if ([str isEqualToString:number]) {
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"기존에 저장된 연락처가 있습니다."];
                    
                    CFRelease(phoneRef);
                    CFRelease(record);
                    CFRelease(addressList);
                    
                    return;
                }
            }
            
            CFRelease(phoneRef);
        }
        
        CFRelease(record);
    }
    
    ABRecordRef person = ABPersonCreate();
    
    // 이름
    ABRecordSetValue(person, kABPersonFirstNameProperty, self.dicDataDictionary[@"직원명"], NULL);
    
    // 전화번호
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    if (isPhoneNumber) {
        
        // 휴대전화
        ABMultiValueAddValueAndLabel(multiPhone, number, kABPersonPhoneMobileLabel, NULL);
    }
    else {
        
        // 대표
        ABMultiValueAddValueAndLabel(multiPhone, number, kABPersonPhoneMainLabel, NULL);
    }
    
    // FAX
    if ([self.dicDataDictionary[@"FAX"] length] > 0) {
        
        NSString *tmpStr = [self.dicDataDictionary[@"FAX"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        ABMultiValueAddValueAndLabel(multiPhone, tmpStr, kABPersonPhoneWorkFAXLabel, NULL);
    }
    
    ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, NULL);
    
    // E-mail
    
    if ([self.dicDataDictionary[@"이메일"] length] > 0) {
        
        ABMutableMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        ABMultiValueAddValueAndLabel(multiMail, self.dicDataDictionary[@"이메일"], kABWorkLabel, NULL);
        
        ABRecordSetValue(person, kABPersonEmailProperty, multiMail, NULL);
        
        CFRelease(multiMail);
    }
    
    // 연락처에 추가
    ABAddressBookAddRecord(addressBook, person, NULL);
    
    CFErrorRef error = NULL;
    
    // 추가한 연락처 저장
    ABAddressBookSave(addressBook, &error);
    
    CFRelease(multiPhone);
    
    CFRelease(person);
    
    if (error != NULL) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"연락처 저장에 실패하였습니다. 다시 시도하시거나 설정 > 개인정보보호 > 연락처에서 권한을 확인해 주세요."];
        
        return;
    }
    
    [UIAlertView showAlert:nil
                      type:ONFAlertTypeOneButton
                       tag:0
                     title:@""
                   message:@"연락처 저장이 완료되었습니다."];
}

#pragma mark - SHBSmartCardTelStipulation Delegate

- (void)smartCardTelStipulationBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_smartCardTelStipulation.view setAlpha:0];
    [_smartCardTelStipulation.view removeFromSuperview];
    
    [self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
    //[self performSelector:@selector(adjustView1) withObject:nil afterDelay:0.01];
    
}


#pragma mark -

- (NSString *)addTimeColon:(NSString *)time
{
    if ([time length] == 4) {
        
        return [NSString stringWithFormat:@"%@:%@",
                [time substringWithRange:NSMakeRange(0, 2)],
                [time substringWithRange:NSMakeRange(2, 2)]];
    }
    
    if ([time length] == 6) {
        
        return [NSString stringWithFormat:@"%@:%@:%@",
                [time substringWithRange:NSMakeRange(0, 2)],
                [time substringWithRange:NSMakeRange(2, 2)],
                [time substringWithRange:NSMakeRange(4, 2)]];
    }
    
    return time;
}

- (BOOL)isTelephoneConsultationRequest
{
    NSInteger Tstart_tTime =  [self.dicDataDictionary[@"전화상담요청가능시작시간"] integerValue];
    NSInteger Tend_tTime =  [self.dicDataDictionary[@"전화상담요청가능종료시간"] integerValue];
    
    
    
    NSString *tDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    //NSInteger tTime = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSString *Time = [AppInfo.tran_Time substringToIndex:5];
    
    NSInteger tTime = [[Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    NSLog(@" tTime %d Mstart_tTime %d, Mend_tTime %d ", tTime,Tstart_tTime,Tend_tTime);
    
    if (![SHBUtility isOPDate:tDate]) {  //영업일이 아닐떄
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:[NSString stringWithFormat:@"현재 위 직원이 설정한 전화상담요청 가능 시간은 영업일 %@~%@ 입니다. 급한 연락은 전화 부탁 드립니다.", [self addTimeColon:self.dicDataDictionary[@"전화상담요청가능시작시간"]], [self addTimeColon:self.dicDataDictionary[@"전화상담요청가능종료시간"]]]];
        return NO;
    }
    
    if( tTime < Tstart_tTime || tTime > Tend_tTime )
    {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:[NSString stringWithFormat:@"현재 위 직원이 설정한 전화상담요청 가능 시간은 영업일 %@~%@ 입니다. 급한 연락은 전화 부탁 드립니다.", [self addTimeColon:self.dicDataDictionary[@"전화상담요청가능시작시간"]], [self addTimeColon:self.dicDataDictionary[@"전화상담요청가능종료시간"]]]];
        return NO;
    }
    
    return YES;
}


- (BOOL)isMessageConsultationRequest
{
    // 메세지청 시간 확인
    NSString *tDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    //NSInteger tTime = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSString *Time = [AppInfo.tran_Time substringToIndex:5];
    
    NSInteger tTime = [[Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSInteger Mstart_tTime = [self.dicDataDictionary[@"쪽지전송가능시작시간"]integerValue] ;
    NSInteger Mend_tTime =  [self.dicDataDictionary[@"쪽지전송가능종료시간"]integerValue] ;
    
    NSLog(@" tTime %d Mstart_tTime %d, Mend_tTime %d ", tTime,Mstart_tTime,Mend_tTime);
    
    if (![SHBUtility isOPDate:tDate]) {  //영업일이 아닐떄
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:[NSString stringWithFormat:@"현재 위 직원이 설정한 메세지전송 가능 시간은 영업일 %@~%@ 입니다. 급한 연락은 전화 부탁 드립니다.", [self addTimeColon:self.dicDataDictionary[@"쪽지전송가능시작시간"]], [self addTimeColon:self.dicDataDictionary[@"쪽지전송가능종료시간"]]]];
        
        return NO;
    }
    
    if( tTime < Mstart_tTime || tTime > Mend_tTime )
    {
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:[NSString stringWithFormat:@"현재 위 직원이 설정한 메세지전송 가능 시간은 영업일 %@~%@ 입니다. 급한 연락은 전화 부탁 드립니다.", [self addTimeColon:self.dicDataDictionary[@"쪽지전송가능시작시간"]], [self addTimeColon:self.dicDataDictionary[@"쪽지전송가능종료시간"]]]];
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag])
    {
       NSString *strNumber = @"";
        case 1: //대표전화
        {
            
            if (![self.dicDataDictionary[@"대표전화"] isEqualToString:@""]) {
                strNumber =  [NSString stringWithFormat:@"telprompt:%@", self.dicDataDictionary[@"대표전화"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
            }
            

        }
            break;
            
        case 2: // 직통전화
        {
            
            if (![self.dicDataDictionary[@"직통전화"] isEqualToString:@""]) {
                strNumber = [NSString stringWithFormat:@"telprompt:%@",self.dicDataDictionary[@"직통전화"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
            }
            
            
        }
            break;
            
        case 3: // 이메일주소
        {
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeTwoButton
                               tag:3
                             title:@""
                           message:@"이메일을 작성 하시겠습니까?"];

            
        }
            break;
            
        case 4: // 핸드폰번호
        {
            if (![self.dicDataDictionary[@"핸드폰"] isEqualToString:@""]) {
                strNumber = [NSString stringWithFormat:@"telprompt:%@",self.dicDataDictionary[@"핸드폰"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
            }
            
        }
            break;
        case 11:        // 이전 버튼
        {
            [self.view removeFromSuperview];
            
        }
            break;
            
        case 12:        // 삭제
        {
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeTwoButton
                               tag:1
                             title:@""
                           message:@"받은 명함을 삭제하시겠습니까?"];
            
        }
            break;
            
        case 13:        // 연락처저장
        {
            if ([self.dicDataDictionary[@"직통전화"] length] == 0 &&
                [self.dicDataDictionary[@"대표전화"] length] == 0 &&
                [self.dicDataDictionary[@"핸드폰"] length] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"제공된 연락처가 없습니다."];
                return;
            }
            
            ABAddressBookRef addressBook;
            
            if ([[SHBUtilFile getOSVersion] floatValue] >= 6.0) {
                
                addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                
                if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
                    
                    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (granted) {
                                
                                [self saveAddress:addressBook];
                            }
                            else {
                                
                                [UIAlertView showAlert:nil
                                                  type:ONFAlertTypeOneButton
                                                   tag:0
                                                 title:@""
                                               message:@"연락처 접근 권한이 없습니다.\n설정 > 개인정보보호 > 연락처에서 권한을 설정해 주세요."];
                                return;
                            }
                        });
                    });
                }
                else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                    
                    [self saveAddress:addressBook];
                }
                else {
                    
                    // kABAuthorizationStatusRestricted, kABAuthorizationStatusDenied
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"연락처 접근 권한이 없습니다.\n설정 > 개인정보보호 > 연락처에서 권한을 설정해 주세요."];
                    return;
                }
            }
            else {
                
                addressBook = ABAddressBookCreate();
                
                [self saveAddress:addressBook];
            }
        }
            break;
        case 14:        // 확대
        {
            BOOL isFive = IS_IPHONE_5;
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*90/180.0);
			
            bigView.transform = transform;
            
            if (isFive) {
                
                bigView.bounds = CGRectMake(0, 0, 548, 320);
            }
            else {
                
                bigView.bounds = CGRectMake(0, 0, 460, 320);
            }
            
            CGPoint point = AppDelegate.navigationController.view.center;
            
            point.y += 10;
            
            [bigView setCenter:point];
            
            [AppDelegate.navigationController.view addSubview:bigView];
        }
            break;
            
        case 15:        // 닫기
        {
            
            [self.bigView removeFromSuperview];
            
        }
            break;

            
        case 21:        // 메세지전송
        {
            if ([self isMessageConsultationRequest])
            {
            
                self.smartCardTelStipulation = [[[SHBSmartCardTelStipulationViewController alloc] initWithNibName:@"SHBSmartCardTelStipulationViewController" bundle:nil] autorelease];
                self.smartCardTelStipulation.delegate = self;
                self.smartCardTelStipulation.type= @"A";
                self.smartCardTelStipulation.dicDataDictionary = dicDataDictionary;
                [self.view addSubview:self.smartCardTelStipulation.view];
            
                [self.smartCardTelStipulation.view setFrame:CGRectMake(0,
                                                               0,
                                                               self.smartCardTelStipulation.view.frame.size.width,
                                                               self.smartCardTelStipulation.view.frame.size.height - 74 - 49)];
            }
        }
            break;
            
        case 22:        // 전화상담요청
        {
            
            if ([self isTelephoneConsultationRequest])
            {
                
                self.smartCardTelStipulation = [[[SHBSmartCardTelStipulationViewController alloc] initWithNibName:@"SHBSmartCardTelStipulationViewController" bundle:nil] autorelease];
                self.smartCardTelStipulation.delegate = self;
                self.smartCardTelStipulation.type= @"B";
                self.smartCardTelStipulation.dicDataDictionary = dicDataDictionary;
                [self.view addSubview:self.smartCardTelStipulation.view];
            
                [self.smartCardTelStipulation.view setFrame:CGRectMake(0,
                                                                   0,
                                                                   self.smartCardTelStipulation.view.frame.size.width,
                                                                   self.smartCardTelStipulation.view.frame.size.height - 74 - 49)];
                
            }

        }
            break;
            
            
        default:
            break;
    }
    
    
}

            
#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1  && buttonIndex == 0) {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  @"거래구분" : @"02",
                                  @"발송번호" : self.dicDataDictionary[@"발송번호"],
                                  @"고객번호" : AppInfo.customerNo,
                                  }];
        
        self.service = nil;
        self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTCARD_E2821 viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];

    }
    
    if ([alertView tag] == 2) {
      
        if ([_delegate respondsToSelector:@selector(smartCardDetailBack)]) {
            
            [_delegate smartCardDetailBack];
        }
    }
    
    if ([alertView tag] == 3  && buttonIndex == 0)
    {
        
         NSString *strNumber = @"";
        if (![self.dicDataDictionary[@"이메일"] isEqualToString:@""])
        {
            strNumber = [NSString stringWithFormat:@"mailto:%@",self.dicDataDictionary[@"이메일"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
        }
        
    }

}



#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    
    if ([self.service.strServiceCode isEqualToString:SMARTCARD_E2821])
    {
         if ([aDataSet[@"처리결과"] isEqualToString:@"1"])
         {
             [UIAlertView showAlert:self
                               type:ONFAlertTypeOneButton
                                tag:2
                              title:@""
                            message:@"명함이 삭제되었습니다."];
        }
    
    }

    
    
    return NO;
}

    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [btnBig4 release];
    [btnBig5 release];
    [btnBig6 release];
    [btnBig7 release];
    [super dealloc];
}
@end
