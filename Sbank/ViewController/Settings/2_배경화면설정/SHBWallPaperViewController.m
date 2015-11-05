//
//  SHBWallPaperViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBWallPaperViewController.h"
#import "SHBSettingsService.h"
#import "UIDevice+Hardware.h"

@interface SHBWallPaperViewController ()

@property (nonatomic, retain) NSString *strPlatform;	// 플랫폼 구분

@end

@implementation SHBWallPaperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_customImg release];
	[_previewImgData release];
	[_strPlatform release];
	[_boxView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBoxView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"배경화면 설정"];
    [self.view viewWithTag:NAVI_BACK_BTN_TAG].accessibilityLabel = [NSString stringWithFormat:@"%@ 뒤로이동", @"환경설정"];
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"custom_bg.png"];
    
    self.customImg = [UIImage imageWithContentsOfFile:imagePath];
    
    if(self.customImg != nil)
    {
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:117];
        [imgView setHighlightedImage:self.customImg];
    }
    
	// 배경화면으로 설정된 값 찾아서 세팅
	SettingsWallpaperValue nValue = [[NSUserDefaults standardUserDefaults]wallpaper];
	UIButton *btn = (UIButton *)[self.boxView viewWithTag:nValue];
    [btn setSelected:YES];
	
	for (int nIdx = SettingsWallpaperValue1; nIdx <= SettingsWallpaperValue8; nIdx++) {
		UIButton *btn = (UIButton *)[self.boxView viewWithTag:nIdx];
		if ([btn isSelected]) {
			[self setHighlitedImage:btn.tag];
			break;
		}
	}

	btn = (UIButton *)[self.boxView viewWithTag:107];	// 사용자 지정 배경
	if ([btn isSelected]) {
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:117];
		[iv setHighlighted:YES];
	}
	else
	{
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:117];
		[iv setHighlighted:NO];
	}
    
	if (AppInfo.isiPhoneFive) {
		self.strPlatform = @"I_6401136";	// IOS 640*1136(아이폰5)
	}
	else if ([[UIDevice currentDevice]hasRetinaDisplay])
	{
		self.strPlatform = @"I_640920";		// IOS 640*920(레티나)
	}
	else
	{
		self.strPlatform = @"I_320460";		// IOS 320*460(아이폰3)
	}

	// 미리보기 때문에 처음에 전문 날린다.
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
												TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
											  TASK_ACTION_KEY : @"getWallpaper",
						   @"배경구분" : self.strPlatform,
						   }];
	
	self.service = [[[SHBSettingsService alloc]initWithServiceId:XDA_S00004 viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
    
    self.contentScrollView.contentSize = CGSizeMake(317, 460);
    contentViewHeight = 460;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)setHighlitedImage:(NSInteger)nTag
{
	for (int nIdx = SettingsWallpaperValue1; nIdx <= SettingsWallpaperValue8; nIdx++) {
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:nIdx+10];
		for (UIImageView *v in iv.subviews)
		{
			[v removeFromSuperview];
		}
	}
	
	UIImageView *ivDefault = (UIImageView *)[self.boxView viewWithTag:nTag+10];
	UIImageView *ivHighlited = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_selectbg"]]autorelease];
	[ivHighlited setFrame:CGRectMake(0, 0, 64, 62)];
	[ivDefault addSubview:ivHighlited];
}

#pragma mark - Image mask
- (UIImage *)maskedImageWithImage:(UIImage *)sourceImage
{
	CGImageRef imageRef = [sourceImage CGImage];
	CGImageRef maskRef = [[UIImage imageNamed:@"bg_type4mask.png"] CGImage];
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef),
										NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
	CGImageRelease(mask);
    
	UIImage *maskedImage = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
	
	return maskedImage;
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
	for (int nIdx = SettingsWallpaperValue1; nIdx <= SettingsWallpaperValue8; nIdx++) {
		UIButton *btn = (UIButton *)[self.boxView viewWithTag:nIdx];
		[btn setSelected:NO];
	}

	[sender setSelected:YES];
	
	UIButton *btn = (UIButton *)[self.boxView viewWithTag:106];	// 신한은행 홈페이지 배경
	if ([btn isSelected]) {
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:116];
		[iv setHighlighted:YES];
	}
	else
	{
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:116];
		[iv setHighlighted:NO];
	}
    
	btn = (UIButton *)[self.boxView viewWithTag:107];	// 사용자 지정 배경
	if ([btn isSelected]) {
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:117];
		[iv setHighlighted:YES];
	}
	else
	{
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:117];
		[iv setHighlighted:NO];
	}
    
    if([sender tag] == 107)
    {
        UIImagePickerController *picker		= [[UIImagePickerController alloc] init];
        picker.delegate						= self;
//        picker.allowsEditing				= YES;
//        picker.view.userInteractionEnabled	= YES;
//        picker.wantsFullScreenLayout		= NO;
        picker.sourceType                   = UIImagePickerControllerSourceTypePhotoLibrary ;
        
        NSString *strIOS_Version = [[UIDevice currentDevice].systemVersion substringToIndex:1];
        
        if([strIOS_Version intValue] > 4)
        {
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self.navigationController presentModalViewController:picker animated:YES];
        }

        [picker release];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *strIOS_Version = [[UIDevice currentDevice].systemVersion substringToIndex:1];
    
    if([strIOS_Version intValue] > 4)
    {
        [picker dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        [picker dismissModalViewControllerAnimated:NO];
    }
    
    
    float xRate = 64.0;
    float yRate = AppInfo.isiPhoneFive ? 114.0 : 92.0;
    
    float imgWidth = 0;
    float imgHeight = 0;

    UIImage *imgOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGImageRef imgRef = imgOriginal.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    
    CGRect bounds = CGRectMake(0, 0, CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight = 0.0;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch(imgOriginal.imageOrientation)
    {
        case UIImageOrientationUp: // 1
        {
            transform = CGAffineTransformIdentity;
        }
            break;
        case UIImageOrientationUpMirrored: // 2
        {
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
        }
            break;
        case UIImageOrientationDown: // 3
        {
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
        }
            break;
        case UIImageOrientationDownMirrored: // 4
        {
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
        }
            break;
        case UIImageOrientationLeftMirrored: // 5
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
        }
            break;
        case UIImageOrientationLeft: //6
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
        }
            break;
        case UIImageOrientationRightMirrored: // 7
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
        }
            break;
        case UIImageOrientationRight: // 8
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
        }
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (imgOriginal.imageOrientation == UIImageOrientationRight ||
        imgOriginal.imageOrientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -1, 1);
        CGContextTranslateCTM(context, -imageSize.height, 0);
    }
    else {
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -imageSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, imageSize.width, imageSize.height), imgRef);
    
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(imageCopy.size.width >= imageCopy.size.height)
    {
        imgWidth = imageCopy.size.height * xRate / yRate;
        imgHeight = imageCopy.size.height;
    }
    else if(imageCopy.size.width / xRate < imageCopy.size.height / yRate)
    {
        imgWidth = imageCopy.size.width;
        imgHeight = imageCopy.size.width * yRate / xRate;
    }
    else
    {
        imgWidth = imageCopy.size.height * xRate / yRate;
        imgHeight = imageCopy.size.height;
    }
    
    CGRect cropRect = CGRectMake(0, 0, imgWidth, imgHeight);
    
    if(imgWidth < imageCopy.size.width)
    {
        cropRect.origin.x = (imageCopy.size.width - imgWidth) / 2;
    }
    
    if(imgHeight < imageCopy.size.height)
    {
        cropRect.origin.y = (imageCopy.size.height - imgHeight) / 2;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageCopy CGImage], cropRect);
    self.customImg = [UIImage imageWithCGImage:imageRef];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:117];
    [imgView setHighlightedImage:self.customImg];
    
    CGImageRelease(imageRef);
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSString *strIOS_Version = [[UIDevice currentDevice].systemVersion substringToIndex:1];
    
    if([strIOS_Version intValue] > 4)
    {
        [picker dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        [picker dismissModalViewControllerAnimated:NO];
    }
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	// SettingsWallpaperValue7 값일 경우 서버통신후 얼럿 띄우기
	for (int nIdx = SettingsWallpaperValue1; nIdx <= SettingsWallpaperValue8; nIdx++) {
		UIButton *btn = (UIButton *)[self.boxView viewWithTag:nIdx];
		if ([btn isSelected]) {
			if (btn.tag == SettingsWallpaperValue7) {
#if 1
				NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:self.data];
				[mdic setObject:self.previewImgData forKey:@"배경이미지"];
				
				[[NSUserDefaults standardUserDefaults] setWallpaper:SettingsWallpaperValue7];
				[[NSUserDefaults standardUserDefaults] setWallpaperData:mdic];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedWallpaper" object:nil];
#else
				SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
									   TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
									   TASK_ACTION_KEY : @"getWallpaper",
									   @"배경구분" : self.strPlatform,
									   }];
				
				self.service = [[[SHBSettingsService alloc] initWithServiceId:XDA_S00004 viewController:self] autorelease];
				self.service.requestData = dataSet;
				[self.service start];
				
				return;
#endif
			}
			else if(btn.tag == SettingsWallpaperValue8)
            {
                if(self.customImg != nil)
                {
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *imagePath = [path stringByAppendingPathComponent:@"custom_bg.png"];
                    
                    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self.customImg)];
                    [imageData writeToFile:imagePath atomically:YES];
                    
                    NSFileManager *man = [[[NSFileManager alloc] init] autorelease];
                    
                    NSDictionary *attrs = [man attributesOfItemAtPath: imagePath error: NULL];
                    unsigned long long result = [attrs fileSize];
                    
                    if( result >= 1000000)
                    {
                        imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.customImg, 0.2)];
                        [imageData writeToFile:imagePath atomically:YES];
                    }
                    else if(result >= 500000)
                    {
                        imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.customImg, 0.4)];
                        [imageData writeToFile:imagePath atomically:YES];
                    }
                    else if(result >=200000)
                    {
                        imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.customImg, 0.6)];
                        [imageData writeToFile:imagePath atomically:YES];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setWallpaper:btn.tag];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedWallpaper" object:nil];
                }
                else
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"선택된 사진이 없습니다. 앨범에서 사진을 선택하여 주십시오."];
                    return;
                }
            }
            else
			{
				[[NSUserDefaults standardUserDefaults] setWallpaper:btn.tag];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedWallpaper" object:nil];
				
				break;
			}
		}
	}
	
	[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:337337 title:@"" message:@"배경화면 설정이 변경되었습니다."];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 337337) {
		AppInfo.indexQuickMenu = 0;
		[self.navigationController fadePopToRootViewController];
	}
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
	Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == XDA_S00004)
	{
#if 1
		self.data = aDataSet;
		
		self.previewImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:aDataSet[@"배경URL"]]];
		
		UIImage *img = [self maskedImageWithImage:[UIImage imageWithData:self.previewImgData]];
		UIImageView *iv = (UIImageView *)[self.boxView viewWithTag:116];	// 신한은행 홈페이지 배경
		[iv setHighlightedImage:img];
		
		UIButton *btn = (UIButton *)[self.boxView viewWithTag:106];	// 신한은행 홈페이지 배경 버튼
		if ([btn isSelected]) {
			[iv setHighlighted:YES];
		}		
#else
		/**
		 배경구분 = I_640920;
		 배경적용일시 = 201212110000;
		 배경URL = http://imgdev.shinhan.com/sbank/bg/bg_4@2x.png;
		 */

		NSData *bgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:aDataSet[@"배경URL"]]];
		
		[aDataSet setObject:bgData forKey:@"배경이미지"];
		NSDictionary *dic = [NSDictionary dictionaryWithDictionary:aDataSet];
		
		[[NSUserDefaults standardUserDefaults]setWallpaper:SettingsWallpaperValue7];
		[[NSUserDefaults standardUserDefaults]setWallpaperData:dic];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"ChangedWallpaper" object:nil];
		
		[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:337337 title:@"" message:@"배경화면 설정이 변경되었습니다."];
#endif
	}
	
	
	return NO;
}

@end
