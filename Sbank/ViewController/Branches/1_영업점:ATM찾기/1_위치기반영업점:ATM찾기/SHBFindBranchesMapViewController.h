//
//  SHBFindBranchesMapViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > 위치기반 영업점/ATM 찾기 > 맵뷰화면
 */

#import "SHBBaseViewController.h"
#import "KMapView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SHBPopupView.h"

@interface SHBFindBranchesMapViewController : SHBBaseViewController <KMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, OverlayDelegate>

@property (retain, nonatomic) IBOutlet KMapView *mapView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UILabel *lblTopGuide;
@property (retain, nonatomic) IBOutlet UILabel *lblBottomGuide;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) SHBPopupView *popupView;
@property (retain, nonatomic) IBOutlet UIView *popupContentView;


- (IBAction)myLocationBtnAction:(UIButton *)sender;
- (IBAction)appointedLocationBtnAction:(UIButton *)sender;
- (IBAction)seeListBtnAction:(UIButton *)sender;
- (IBAction)settingBtnAction:(UIButton *)sender;
- (IBAction)searchBtnAction:(UIButton *)sender;

- (IBAction)waitingPeopleBtnActionInPopupView:(SHBButton *)sender;
- (IBAction)seeDetailBtnActionInPopupView:(SHBButton *)sender;

@end
