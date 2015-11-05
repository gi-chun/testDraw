//
//  SHBWallPaperViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 배경화면 설정
 */
#import "SHBBaseViewController.h"

@interface SHBWallPaperViewController : SHBBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UIView *boxView;

@property (nonatomic, retain) NSData *previewImgData;	// 미리보기 이미지 데이터

@property (nonatomic, retain) UIImage *customImg;   // 사용자가 선택한 이미지

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
