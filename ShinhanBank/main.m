 //
//  main.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHBAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        #ifndef DEVELOPER_MODE
            disable_gdb();
        #endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SHBAppDelegate class]));
    }
}
