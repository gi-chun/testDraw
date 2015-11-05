//
//  UIAlertView+NetworkError.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 17..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "UIAlertView+NetworkError.h"
#import <AudioToolBox/AudioServices.h>
//#import "AudioToolbox/AudioToolbox.h"

@implementation UIAlertView (NetworkError)


//int myTag;
UIAlertView *myAlert;
int myAlertCnt = 0;

+ (UIAlertView *)showWithError:(NSError *)networkError
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[networkError localizedDescription]
                                                    message:[networkError localizedRecoverySuggestion]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Confirm", @"확인")
                                          otherButtonTitles:nil];
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView *)showAlert:(id)obj
                      type:(int)type
                       tag:(int)tag
                     title:(NSString *)title
                   message:(NSString *)msg;
{
    if (UIAccessibilityIsVoiceOverRunning())
    {
        //사운드와 진동을 동시에
        @try {
            id soundpath = nil;
            NSString *sound = @"alertsound.wav";
            soundpath = [[NSBundle mainBundle] pathForResource:sound ofType:@"" inDirectory:@"/"];
            CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:soundpath];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID (baseURL, &soundID);
            AudioServicesPlaySystemSound (soundID);
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
	// 확인 버튼만 있는 경우.
	if (type == ONFAlertTypeOneButton)
    {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:title
							  message:msg
							  delegate:obj
							  cancelButtonTitle:@"확인"
							  otherButtonTitles:nil, nil];
        alert.tag = tag;
		[alert show];
		
        return [alert autorelease];
	}
	
	// 확인/취소 버튼 모두 있는 경우.
	if (type == ONFAlertTypeTwoButton)
    {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:title
							  message:msg
							  delegate:obj
							  cancelButtonTitle:@"확인"
							  otherButtonTitles:@"취소", nil];
        alert.tag = tag;
		[alert show];
        
		return [alert autorelease];
	}
    
    return nil;
}

+ (UIAlertView *)showAlertCustome:(id)obj
                            type:(int)type
                             tag:(int)tag
                           title:(NSString *)title
                     buttonTitle:(NSString *)btnTitle
                         message:(NSString *)msg
{
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        //사운드와 진동을 동시에
        @try {
            id soundpath = nil;
            NSString *sound = @"alertsound.wav";
            soundpath = [[NSBundle mainBundle] pathForResource:sound ofType:@"" inDirectory:@"/"];
            CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:soundpath];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID (baseURL, &soundID);
            AudioServicesPlaySystemSound (soundID);
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
     //일반 확인 버튼만 있는 경우.
     if (type == ONFAlertTypeOneButton)
     {
         UIAlertView *alert = [[UIAlertView alloc]
         initWithTitle:title
         message:msg
         delegate:obj
         cancelButtonTitle:@"확인"
         otherButtonTitles:nil, nil];
         
         alert.tag = tag;
         myAlert = alert;
         myAlertCnt++;
         NSString *btTitle = @"확인";
         if ([btnTitle length] > 0)
         {
             btTitle = btnTitle;
         }
         SHBAlertPopupView *popupView = [[SHBAlertPopupView alloc] initWithString:msg ButtonCount:1 SubViewHeight:160 alertTag:tag aTarget:self tSelector:@selector(popupViewDidResult:) btnTitle:btTitle alertType:ONFAlertTypeOneButton];
         [popupView showInView:AppDelegate.window animated:YES];
         [popupView release];
         
         return myAlert;
     }
     
     //일반 확인,취소 버튼 모두 있는 경우.
     if (type == ONFAlertTypeTwoButton)
     {
         UIAlertView *alert = [[UIAlertView alloc]
         initWithTitle:title
         message:msg
         delegate:obj
         cancelButtonTitle:@"확인"
         otherButtonTitles:@"취소", nil];
         
         
         alert.tag = tag;
         myAlert = alert;
         myAlertCnt++;
         NSString *btTitle = @"확인,취소";
         if ([btnTitle length] > 0)
         {
             btTitle = btnTitle;
         }
         SHBAlertPopupView *popupView = [[SHBAlertPopupView alloc] initWithString:msg ButtonCount:2 SubViewHeight:160 alertTag:tag aTarget:self tSelector:@selector(popupViewDidResult:) btnTitle:btTitle alertType:ONFAlertTypeTwoButton];
         [popupView showInView:AppDelegate.window animated:YES];
         [popupView release];
         
         return myAlert;
     }
    
    
    //서버 확인 버튼만 있는 경우.
    if (type == ONFAlertTypeOneButtonServer)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:obj
                              cancelButtonTitle:@"확인"
                              otherButtonTitles:nil, nil];
        
        alert.tag = tag;
        myAlert = alert;
        myAlertCnt++;
        NSString *btTitle = @"확인";
        if ([btnTitle length] > 0)
        {
            btTitle = btnTitle;
        }
        SHBAlertPopupView *popupView = [[SHBAlertPopupView alloc] initWithString:msg ButtonCount:1 SubViewHeight:160 alertTag:tag aTarget:self tSelector:@selector(popupViewDidResult:) btnTitle:btTitle alertType:ONFAlertTypeOneButtonServer];
        [popupView showInView:AppDelegate.window animated:YES];
        [popupView release];
        
        return myAlert;
    }
    
    //서버 확인,취소 버튼 모두 있는 경우.
    if (type == ONFAlertTypeTwoButtonServer)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:obj
                              cancelButtonTitle:@"확인"
                              otherButtonTitles:@"취소", nil];
        
        
        alert.tag = tag;
        myAlert = alert;
        myAlertCnt++;
        NSString *btTitle = @"확인,취소";
        if ([btnTitle length] > 0)
        {
            btTitle = btnTitle;
        }
        SHBAlertPopupView *popupView = [[SHBAlertPopupView alloc] initWithString:msg ButtonCount:2 SubViewHeight:160 alertTag:tag aTarget:self tSelector:@selector(popupViewDidResult:) btnTitle:btTitle alertType:ONFAlertTypeTwoButtonServer];
        [popupView showInView:AppDelegate.window animated:YES];
        [popupView release];
        
        return myAlert;
    }
    return nil;
}

+ (UIAlertView *)showAlertLan:(id)obj
                      type:(int)type
                       tag:(int)tag
                     title:(NSString *)title
                   message:(NSString *)msg
                  language:(int)lanType
{
    
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        //사운드와 진동을 동시에
        @try {
            id soundpath = nil;
            NSString *sound = @"alertsound.wav";
            soundpath = [[NSBundle mainBundle] pathForResource:sound ofType:@"" inDirectory:@"/"];
            CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:soundpath];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID (baseURL, &soundID);
            AudioServicesPlaySystemSound (soundID);
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    // 확인 버튼만 있는 경우.
	if (type == ONFAlertTypeOneButton)
    {
        NSString *buttonTitle;
        if (lanType == 1)
        {
            buttonTitle = @"Confirm";
        } else if (lanType == 2)
        {
            buttonTitle = @"確認";
        } else
        {
            buttonTitle = @"확인";
        }
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:title
							  message:msg
							  delegate:obj
							  cancelButtonTitle:buttonTitle
							  otherButtonTitles:nil, nil];
        alert.tag = tag;
		[alert show];
		
        return [alert autorelease];
	}
	
	// 확인/취소 버튼 모두 있는 경우.
	if (type == ONFAlertTypeTwoButton)
    {
        NSString *buttonTitle1, *buttonTitle2;
        if (lanType == 1)
        {
            buttonTitle1= @"Confirm";
            buttonTitle2= @"Cancel";
        } else if (lanType == 2)
        {
            buttonTitle1 = @"確認";
            buttonTitle2= @"取消";
        } else
        {
            buttonTitle1 = @"확인";
            buttonTitle2= @"취소";
        }
        
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:title
							  message:msg
							  delegate:obj
							  cancelButtonTitle:buttonTitle1
							  otherButtonTitles:buttonTitle2, nil];
        alert.tag = tag;
		[alert show];
        
		return [alert autorelease];
	}
    
    return nil;
}

+ (void)popupViewDidResult:(int)buttonIdx
{
    NSLog(@"popupViewDidResult:%i",buttonIdx);

    if ([myAlert.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [myAlert.delegate alertView:myAlert clickedButtonAtIndex:buttonIdx];
    }
    NSLog(@"myAlertCnt:%i",myAlertCnt);
    myAlertCnt--;
    //if (myAlertCnt == 0)
    //{
        myAlert = nil;
        [myAlert release];
    //}
    
    
}

+ (int)myAlertTotCnt
{
    return myAlertCnt;
}
@end
