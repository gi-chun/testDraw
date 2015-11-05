//
//  SHBUserInfoEditInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 고객센터 - 고객정보변경
 고객정보변경 화면
 */

@interface SHBUserInfoEditInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBTextField *homeZipCode1; // 자택우편번호1
@property (retain, nonatomic) IBOutlet SHBTextField *homeZipCode2; // 자택우편번호2
@property (retain, nonatomic) IBOutlet SHBTextField *homeAddress1; // 자택주소1
@property (retain, nonatomic) IBOutlet SHBTextField *homeAddress2; // 자택주소2
@property (retain, nonatomic) IBOutlet SHBTextField *homeNumber1; // 자택전화번호1
@property (retain, nonatomic) IBOutlet SHBTextField *homeNumber2; // 자택전화번호2
@property (retain, nonatomic) IBOutlet SHBTextField *homeNumber3; // 자택전화번호3
@property (retain, nonatomic) IBOutlet SHBTextField *homeFaxNumber1; // 자택FAX번호1
@property (retain, nonatomic) IBOutlet SHBTextField *homeFaxNumber2; // 자택FAX번호2
@property (retain, nonatomic) IBOutlet SHBTextField *homeFaxNumber3; // 자택FAX번호3
@property (retain, nonatomic) IBOutlet SHBTextField *officeZipCode1; // 직장우편번호1
@property (retain, nonatomic) IBOutlet SHBTextField *officeZipCode2; // 직장우편번호2
@property (retain, nonatomic) IBOutlet SHBTextField *officeAddress1; // 직장주소1
@property (retain, nonatomic) IBOutlet SHBTextField *officeAddress2; // 직장주소2
@property (retain, nonatomic) IBOutlet SHBTextField *officeNumber1; // 직장전화번호1
@property (retain, nonatomic) IBOutlet SHBTextField *officeNumber2; // 직장전화번호2
@property (retain, nonatomic) IBOutlet SHBTextField *officeNumber3; // 직장전화번호3
@property (retain, nonatomic) IBOutlet SHBTextField *officeFaxNumber1; // 직장FAX번호1
@property (retain, nonatomic) IBOutlet SHBTextField *officeFaxNumber2; // 직장FAX번호2
@property (retain, nonatomic) IBOutlet SHBTextField *officeFaxNumber3; // 직장FAX번호3
@property (retain, nonatomic) IBOutlet SHBTextField *officeName; // 직장명
@property (retain, nonatomic) IBOutlet SHBTextField *dept; // 부서명
@property (retain, nonatomic) IBOutlet SHBTextField *email; // 이메일
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber1; // 휴대폰번호1
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber2; // 휴대폰번호2
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber3; // 휴대폰번호3
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIButton *noHomeNumber; // 자택전화번호 없음
@property (retain, nonatomic) IBOutlet UIButton *noOffice; // 직장 없음
@property (retain, nonatomic) IBOutlet UIButton *noHomeFaxNumber; // 자택FAX번호 없음
@property (retain, nonatomic) IBOutlet UIButton *noOfficeFaxNumber; // 직장FAX번호 없음
@end
