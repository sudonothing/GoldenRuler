//
//  LSPrivateCollectionDetailViewController.m
//  金标尺
//
//  Created by Jiao on 14-6-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCollectionDetailViewController.h"

@interface LSPrivateCollectionDetailViewController ()
{
    LSExamView *eview;
    int selectedRow;
}

@end

@implementation LSPrivateCollectionDetailViewController

@synthesize qid;
@synthesize question;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        question = [[LSQuestion alloc] init];
        selectedRow = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadQestion];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // homeBtn
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)loadQestion
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/question?key=%d&uid=%d&qid=%d",[LSUserManager getKey],[LSUserManager getUid],qid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            question = [LSQuestion initWithDictionary:data];
            [self initExameView];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

- (void)initExameView
{
    eview = [[LSExamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withQuestion:question withIndex:1];
    eview.questionView.delegate = self;
    eview.questionView.dataSource = self;
    eview.delegate = self;
//    [eview.selectBtn setTitle:@"1/1" forState:UIControlStateNormal];
    eview.selectBtn.hidden = YES;
    if ([question.tid intValue] == kJudge || [question.tid intValue] == kSingleChoice || [question.tid intValue] == kSimpleAnswer || [question.tid intValue] == kDiscuss) {
        [eview.currBtn setTitle:@"答案及解析" forState:UIControlStateNormal];
    }
    if ([question.tid intValue] == kBlank) {
        [eview.questionView setEditing:NO];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
    [self.view addSubview:eview];
}

- (void)tapDismissKeyboard
{
    [eview endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - handleBtnClicked
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
    return answers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if ([question.tid intValue] != kBlank) {
        NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
        NSString *asContent = [answers objectAtIndex:indexPath.row];
        cell.textLabel.text = asContent;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.x, rect.width, rect.height);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
    NSString *asContent = [answers objectAtIndex:indexPath.row];
    CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return rect.height+20;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedRow) {
        selectedRow = -1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //单选和判断 点击一次就提交服务器
    if ([question.tid integerValue] == kSingleChoice || [question.tid integerValue] == kJudge || [question.tid integerValue] == kSimpleAnswer || [question.tid integerValue] == kDiscuss)
    {
        
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
        selectedRow = indexPath.row;
        NSString *myAnswer = nil;
        if([question.tid integerValue] == kSingleChoice)
        {
            eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",[cell.textLabel.text substringToIndex:1]];
            myAnswer = [cell.textLabel.text substringToIndex:1];
            
        }
        else
        {
            eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",cell.textLabel.text];
            myAnswer = cell.textLabel.text;
        }
        
        if ([myAnswer isEqualToString:question.right]) {//答案正确
            question.rightOrWrong = YES;
        }else {//答案错误
            question.rightOrWrong = NO;
        }
    }
}

#pragma mark - exam delegate
- (void)showAnalysis
{
    if (![LSUserManager getIsVip]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能查看解析，充值成为VIP会员即可查看解析" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上充值", nil];
        [alert show];
        return;
    }
    [eview.textLabel setHidden:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LSPrivateChargeViewController *vc = [[LSPrivateChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)smtAnswer
{
    NSString *myAnswer = @"";
    if ([question.tid integerValue] == kMultipleChoice) {
        NSArray *array = [eview.questionView indexPathsForSelectedRows];
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *o1 = (NSIndexPath *)obj1;
            NSIndexPath *o2 = (NSIndexPath *)obj2;
            
            return o1.row > o2.row ? NSOrderedDescending:NSOrderedAscending;
            
        }];
        NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
        for (NSIndexPath *path in array) {
            NSString *s = [answers objectAtIndex:path.row];
            myAnswer = [myAnswer stringByAppendingString:[s substringToIndex:1]];
        }
        [eview.operTop setHidden:NO];
        eview.yellowBtn.hidden = NO;
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",myAnswer];
        if ([myAnswer isEqualToString:question.right]) {
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        } else
        {
            [eview.rightImage setHidden:YES];
            [eview.wrongImage setHidden:NO];
        }
    }
    if ([question.tid integerValue] == kBlank)
    {
        NSString *myAnswer = [eview.textFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [eview.operTop setHidden:NO];
        eview.myAnswer.text = myAnswer;
        question.myAser = myAnswer;
        [eview.textFiled resignFirstResponder];
        [eview.textFiled setEnabled:NO];
        [eview.currBtn setEnabled:NO];
        if ([myAnswer isEqualToString:question.right]) {
            question.rightOrWrong = YES;
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        } else
        {
            question.rightOrWrong = NO;
            [eview.rightImage setHidden:YES];
            [eview.wrongImage setHidden:NO];
        }
        eview.yellowBtn.hidden = NO;
    }
    else
    {
        [eview.yellowBtn setHidden:NO];
        [eview.operTop setHidden:NO];
        if (question.rightOrWrong) {//答案正确
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
            
        }else {//答案错误
            
            [eview.wrongImage setHidden:NO];
            [eview.rightImage setHidden:YES];
        }
    }
    
    if ([question.tid integerValue] != kDiscuss && [question.tid integerValue] != kSimpleAnswer) {
        eview.operTop.backgroundColor = RGB(240, 240, 240);
        eview.myAnswer.hidden = NO;
        eview.rtAnswer.hidden = NO;
    }
    else
    {
        [eview.rightImage setHidden:YES];
        [eview.wrongImage setHidden:YES];
    }
    
    eview.textLabel.hidden = [LSUserManager getIsVip] ? NO : YES;
    eview.questionView.userInteractionEnabled = NO;
    eview.currBtn.enabled = NO;
}

@end
