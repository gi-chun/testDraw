//
//  SHBTaxQRCodeLocalTaxPaymentViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBTaxQRCodeLocalTaxPaymentViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ZBarReaderViewController.h" // QR리더
#import "SHBGiroTaxListService.h" // 서비스

#import "SHBElectronDistricTaxPaymentAccountViewController.h" // ETax 납부

@interface SHBTaxQRCodeLocalTaxPaymentViewController () <ZBarReaderDelegate>
{
    ZBarReaderViewController *readerZ;
}

@property (retain, nonatomic) NSString *ETaxCode;

@end

@implementation SHBTaxQRCodeLocalTaxPaymentViewController

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
    
    [self setTitle:@"QR코드 납부"];
    self.strBackButtonTitle = @"QR코드 납부";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.ETaxCode = nil;
    
    [_overlayView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setOverlayView:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)moveToETax
{
    OFDataSet *aDataSet = [OFDataSet dictionaryWithDictionary:@{
                                                                @"전문종별코드" : @"0200",
                                                                @"거래구분코드" : @"531002",
                                                                @"이용기관지로번호" : @"000000000",
                                                                @"조회구분" : @"E",
                                                                @"전자납부번호" : _ETaxCode,
                                                                @"예비1" : @""
                                                                }];
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId:TAX_DISTRIC_PAYMENT_DETAIL viewController:self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    self.data = aDataSet;
}

- (void)showReader
{
    if (readerZ == nil) {
        
        readerZ = [ZBarReaderViewController new];
    }
    
    readerZ.readerDelegate = self;
    readerZ.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    readerZ.showsZBarControls = NO;
    readerZ.cameraOverlayView = _overlayView;
    readerZ.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //readerZ.readerView.zoom = 2;
    
    ZBarImageScanner *scanner = readerZ.scanner;
    
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    [self.navigationController pushSlideUpViewController:readerZ];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // QR
            
            if ([[SHBUtilFile getOSVersion] floatValue] >= 7.0) {
                
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                
                if (status == AVAuthorizationStatusAuthorized) {
                    
                    [self showReader];
                }
                else if (status == AVAuthorizationStatusDenied) {
                    
                    // 설정 - 개인정보보호에서 사용 제한
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"카메라 접근 권한이 없습니다.\n설정 > 개인정보보호 > 카메라에서 권한을 설정해 주세요."];
                }
                else if (status == AVAuthorizationStatusRestricted) {
                    
                    // 설정 - 일반 - 차단에서 사용 제한
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"카메라 사용이 제한되었습니다.\n설정 > 일반 > 차단에서 허용해 주세요."];
                }
                else if (status == AVAuthorizationStatusNotDetermined) {
                    
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (granted) {
                                
                                [self showReader];
                            }
                            else {
                                
                                // 설정 - 개인정보보호에서 사용 제한
                                
                                [UIAlertView showAlert:nil
                                                  type:ONFAlertTypeOneButton
                                                   tag:0
                                                 title:@""
                                               message:@"카메라 접근 권한이 없습니다.\n설정 > 개인정보보호 > 카메라에서 권한을 설정해 주세요."];
                            }
                        });
                    }];
                }
            }
            else {
                
                [self showReader];
            }
        }
            break;
            
        case 200: {
            
            // QR 취소
            
            [self.navigationController PopSlideDownViewController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"G1412"]) {
        
        if ([aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"]) {
            
            SHBElectronDistricTaxPaymentAccountViewController *viewController = [[[SHBElectronDistricTaxPaymentAccountViewController alloc] initWithNibName:@"SHBElectronDistricTaxPaymentAccountViewController" bundle:nil] autorelease];
            
            viewController.dicDataDictionary = [NSMutableDictionary dictionaryWithDictionary:self.data];
            
            [self.navigationController pushFadeViewController:viewController];
        }
    }
    
    return NO;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - QR

//카메라가 찍고 난뒤 호출되는 Delegate 함수
- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for (symbol in results)
        break;
    
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    NSLog(@"data = %@", symbol.data);
    NSLog(@"data length : %d", [symbol.data length]);

    NSMutableString *QRData = [NSMutableString string];
    
    for (int i = 0; i < [symbol.data length]; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        
        NSString *tmpStr = [symbol.data substringWithRange:range];
        
        //NSLog(@"tmp : %@", tmpStr);
        
        NSString *str = [tmpStr stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];

        if (!str) {
            
            NSLog(@"nilStr : %@",tmpStr);
            
            break;
        }
        else {
            
            [QRData appendString:tmpStr];
        }
    }

    NSLog(@"QRData : %@", QRData);
    
    NSLog(@"data = %@", symbol.data);
    
    NSLog(@"QRData length = %d", [QRData length]);
    
    if ([QRData length] >= 129) {
        
        NSString *compareStr = [QRData substringWithRange:NSMakeRange(127, 2)];
        
        if ([compareStr isEqualToString:@"||"]) {
            
            // 전자납부번호가 17자리인 경우
            
            self.ETaxCode = [QRData substringWithRange:NSMakeRange(110, 17)];
        }
        else {
            
            // 전자납부번호가 19자리인 경우
            
            self.ETaxCode = [QRData substringWithRange:NSMakeRange(110, 19)];
        }
        
        NSLog(@"_ETaxCode : %@", _ETaxCode);
        
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:110
                         title:@""
                       message:@"QR코드 확인이 완료되었습니다. 납부 화면으로 이동합니다."];
        
        [self.navigationController PopSlideDownViewController];
    }
    else {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"QR코드 인식에 실패하였습니다. 다시 시도하여 주시기 바랍니다."];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110) {
        
        [self moveToETax];
    }
}


@end
