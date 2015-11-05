//
//  SHBCertCopyQRViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "ZBarReaderViewController.h"
#import "QRRelay.h"

@interface SHBCertCopyQRViewController : SHBBaseViewController < ZBarReaderDelegate >
{
    QRRelay* qrRelay; //QR복사 클레스
    //ZBarReaderViewController *reader;
    ZBarReaderViewController *readerZ;
}

/**
 최초 실행되어 로그인 설정 단계인지...
 */
@property (nonatomic, assign) BOOL isFirstLoginSetting;

- (IBAction) confirmClick:(id)sender; //확인

@end
