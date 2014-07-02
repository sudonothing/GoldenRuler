//
//  LSAnalysisViewController.h
//  金标尺
//
//  Created by wzq on 14/7/2.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSExam.h"
#import "LSQuestion.h"
#import "UITextViewWithPlaceholder.h"
#import "LSExamView.h"
#import "LSComments.h"
#import "LSContestView.h"
#import "LSChooseQuestionViewController.h"
#import "LSTestResultViewController.h"

@interface LSAnalysisViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,LSExamDelegate,LSChooseQuestionDelegate>
@property (nonatomic,strong) NSMutableArray *questionList;
@property (nonatomic,strong) LSQuestion *currQuestion;
@end
