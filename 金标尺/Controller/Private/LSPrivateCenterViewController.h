//
//  LSPrivateCenterViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPrivateCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)BOOL isVip;
@property (nonatomic, assign)int pushNum;

@property (nonatomic ,strong)NSDate *expireDate;
@property (nonatomic, strong)UITableView *table;

@end
