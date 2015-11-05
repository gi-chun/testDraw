//
//  SHBSettingsCell.h
//  ShinhanBank
//
//  Created by Joon on 13. 2. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSettingsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *subject; // 메뉴
@property (retain, nonatomic) IBOutlet UIImageView *arrow; // >
@property (retain, nonatomic) IBOutlet UILabel *versionLabel; // 버전
@property (retain, nonatomic) IBOutlet UIImageView *update; // 업데이트 이미지

@end
