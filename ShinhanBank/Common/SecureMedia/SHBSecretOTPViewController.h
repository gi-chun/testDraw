//
//  SHBSecretOTPViewController.h
//  ShinhanBank
//
//  Created by RedDragon on 12. 10. 28..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@protocol SHBSecretOTPDelegate

@required
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType;

@optional
- (void) cancelSecretMedia;
@optional

@end

@interface SHBSecretOTPViewController : SHBBaseViewController <UITextFieldDelegate,SHBSecureDelegate>

@property (nonatomic, assign) int indexCurrentField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *pwTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *otpTextField;

@property (nonatomic, assign) id<SHBSecretOTPDelegate> delegate;
@property (nonatomic, retain) SHBBaseViewController *targetViewController;
@property(nonatomic, assign) int selfPosY;
/**
 확인/취소 버튼 영역 뷰 : 히든 시키기위해 아웃렛 연결
 */
@property (retain, nonatomic) IBOutlet UIView *bottomView;

@property(nonatomic, assign) IBOutlet UIButton *okButton;
@property(nonatomic, assign) IBOutlet UIButton *cancelButton;

//보안카드 3회 정상 입력인데도 계속 인증 시도해 보안카드 번호를 획득하는 해킹을 방지하기 위해 C2098전문에 다음 전문 코드를 입력하기 위해 사용한다
@property(nonatomic, retain) NSString *nextSVC;

@property (nonatomic, assign) UITextField *prevTF; // 이체비밀번호를 넣기 전에 입력받는 텍스트필드가 있는 경우 넣어주면 된다.

- (IBAction) confirmSecretOTPNumber; //확인 버튼을 눌렀을때 실행 되는 함수
- (IBAction) cancelSecretMedia;
- (void) returnResult:(OFDataSet *)resultData;

@end
