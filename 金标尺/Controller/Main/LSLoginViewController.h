//
//  LSLoginViewController.h
//  金标尺
//
//  Created by Jiao on 14-4-13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *usernameField;
@property (nonatomic, strong)UITextField *pwdField;

@end
