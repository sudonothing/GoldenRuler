//
//  LSContestView.h
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSQuestion.h"
#import "LSExamDelegate.h"

@interface LSContestView : UIView

@property (strong, nonatomic)  id<LSExamDelegate> delegate;
@property (strong, nonatomic)  UILabel *testType;
@property (strong, nonatomic)  UILabel *usedTime;
@property (strong, nonatomic)  UIButton *selectBtn;

@property (strong, nonatomic)  UIView *operView;
@property (strong, nonatomic)  UIButton *preQuestion;
@property (strong, nonatomic)  UIButton *nextQuestion;
@property (strong, nonatomic)  UIButton *smtBtn;

@property (strong, nonatomic)  UITableView *questionView;
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (strong, nonatomic)  UIButton *yellowBtn;
@property (strong, nonatomic)  UITextView *textView;

@property (strong, nonatomic)  UIImageView *rightImage;
@property (strong, nonatomic)  UIImageView *wrongImage;
@property (strong, nonatomic)  UILabel *myAnswer;

@property (strong, nonatomic) UITextField *textFiled;
@property (strong, nonatomic) UILabel* textLabel;
@property (strong, nonatomic) UIView *operTop;

- (instancetype)initWithFrame:(CGRect)frame withQuestion:(LSQuestion *)question withIndex:(int)index;
@end
