//
//  LSAppDelegate.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)showLoginView:(UIViewController *)viewC;

@end
