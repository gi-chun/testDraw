//
//  SHBTelephoneConsultationRequestViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 10. 21..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  전화상담요청 화면

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBTelephoneConsultationRequestViewController : SHBBaseViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    BOOL _isReadStipulation;    // 개인정보 수집, 이용 동의서를 읽었는지에 대한 Flag (NO:안읽음, YES:읽음)
    NSArray *_collections;      // 컬렉션 리스트
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection1;    // 개인신용정보동의 필수적정보 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection2;    // 개인신용정보동의 선택적정보 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection3;    // 개인신용정보동의 고유식별정보 컬렉션
@property (nonatomic, retain) IBOutlet SHBTextField *textField1;                    // 상담 받을 전화번호1(앞)
@property (nonatomic, retain) IBOutlet SHBTextField *textField2;                    // 상담 받을 전화번호2(중간)
@property (nonatomic, retain) IBOutlet SHBTextField *textField3;                    // 상담 받을 전화번호3(끝)
@property (nonatomic, retain) IBOutlet SHBTextField *textField4;                    // 더미 텍스트필드
@property (nonatomic, retain) IBOutlet UITextView *textView1;                       // 문의내용
@property (nonatomic, retain) IBOutlet UIView *contentView;                         // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UIView *toolBarView;                         // 툴바 뷰

- (BOOL)isTelephoneConsultationRequest;             // 전화상담 요청 시간 확인
- (IBAction)buttonDidPush:(id)sender;               // 버튼 이벤트 처리
- (IBAction)toolBarViewButtonDidPush:(id)sender;    // 툴바 뷰 버튼 이벤트 처리

@end
