//
//  SHBUserInfoEditCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 고객센터 - 고객정보변경
 고객정보변경 완료 화면
 */

@interface SHBUserInfoEditCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UILabel *homeAddress; // 자택주소
@property (retain, nonatomic) IBOutlet UILabel *homeNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *homeNumber; // 자택전화번호
@property (retain, nonatomic) IBOutlet UILabel *homeFAXLabel;
@property (retain, nonatomic) IBOutlet UILabel *homeFAX; // 자택FAX번호

@property (retain, nonatomic) IBOutlet UILabel *officeAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *officeAddress; // 직장주소
@property (retain, nonatomic) IBOutlet UILabel *officeNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *officeNumber; // 직장전화번호
@property (retain, nonatomic) IBOutlet UILabel *officeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *officeName; // 직장명
@property (retain, nonatomic) IBOutlet UILabel *officeFAXLabel;
@property (retain, nonatomic) IBOutlet UILabel *officeFAX; // 직장FAX번호
@property (retain, nonatomic) IBOutlet UILabel *deptLabel;
@property (retain, nonatomic) IBOutlet UILabel *dept; // 부서명
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *mainView;


@end
