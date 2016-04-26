//
//  MineViewController.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MineViewController.h"
#import "AvatarView.h"
#import "CommonHeaders.h"
#import "LoginViewController.h"
#import "CommonFunctions.h"
#import "SettingViewController.h"
#import "OldTasksViewController.h"
#import "NewTasksViewController.h"

@implementation MineLabel

- (void)awakeFromNib
{
    [self shadow];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self shadow];
    }
    return self;
}

- (void)shadow
{
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
}

@end

@interface MineViewController ()<UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UIView *navBar;
    __weak IBOutlet MineLabel *navTitleLabel;
    
    __weak IBOutlet UIView *personView;
    __weak IBOutlet AvatarView *avatarView;
    __weak IBOutlet UIImageView *bgImgView;
    
    __weak IBOutlet UIButton *loginButton;
    
    __weak IBOutlet UIView *careFansView;
    __weak IBOutlet MineLabel *careCountLabel;
    __weak IBOutlet MineLabel *fansCountLabel;
    
    
    __weak IBOutlet UILabel *newTaskNumLabel;
    __weak IBOutlet UILabel *oldTaskNumLabel;
    
}
@end

@implementation MineViewController

#pragma mark - 重写
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCustomView];
    [self updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    scroll.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+100);
}


#pragma mark - 布局
- (void)initCustomView
{
    navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    
    avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarView.layer.borderWidth = 1;
    //更换头像
    [avatarView setClickBlock:^{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
        [sheet showInView:self.view];
    }];
}

#pragma mark - 刷新个人中心数据
- (void)updateInfo
{
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        loginButton.hidden = YES;
        careFansView.hidden = NO;
        avatarView.userInteractionEnabled = YES;
    }else{
        loginButton.hidden = NO;
        careFansView.hidden = YES;
        avatarView.userInteractionEnabled = NO;
    }
    
    if (user.username && user.username) {
        navTitleLabel.text = user.username;
    }
    
    careCountLabel.text = StringFromNumber(user.careCount);
    fansCountLabel.text = StringFromNumber(user.fansCount);
    
    newTaskNumLabel.text = StringFromNumber(user.newSendTaskCount + user.newGetTaskCount);
    oldTaskNumLabel.text = StringFromNumber(user.oldSendTaskCount + user.oldGetTaskCount);
    
    //头像
    [avatarView getAvatar:user.avatarUrl];
}


+ (void)updateUserBaseInfo
{
    __weak UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    __weak UINavigationController *nc = ((UITabBarController *)vc).viewControllers.lastObject;
    __weak MineViewController *mineVC = nc.viewControllers.firstObject;
    [mineVC updateInfo];
}

#pragma mark - 获取数据
- (void)getInfoFormServer
{
    
}


#pragma mark - 事件
///我的任务
- (IBAction)newTaskButtonPressed:(UIButton *)sender {
    [BmobUser dealBlock:^{
        NewTasksViewController *nVC = [NewTasksViewController new];
        nVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nVC animated:YES];
    }];
}

///任务历史
- (IBAction)oldTaskButtonPressed:(UIButton *)sender {
    [BmobUser dealBlock:^{
        OldTasksViewController *oVC = [OldTasksViewController new];
        oVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:oVC animated:YES];
    }];
}

///设置
- (IBAction)settingButtonPressed:(UIButton *)sender {
    SettingViewController *sVC = [SettingViewController new];
    sVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVC animated:YES];
}

///登录
- (IBAction)loginButtonPressed:(UIButton *)sender {
    [BmobUser dealBlock:nil];
}

#pragma mark - 上传并缓存头像
- (void)uploadHeadData:(NSData *)headData
{
    [LPCustomHUD startLoading];
    [NetTool uploadAvatarData:headData complete:^(NSString *url) {
        [LPCustomHUD endLoading];
        if (url) {
            [avatarView getAvatar:url];
        }else{
            [AlertView showWithTitle:@"提示" message:@"上传失败" leftTitle:@"放弃此图" rightTitle:@"重新上传" leftBlock:nil rightBlock:^{
                [self uploadHeadData:headData];
            }];
        }
    }];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    //导航栏背景色
    if (y > 0) {
        navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:MIN(y/60.0l-0.05, 0.9)];
    }
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1) {
        UIImagePickerController *iPC = [UIImagePickerController new];
        iPC.sourceType = buttonIndex;
        iPC.allowsEditing = YES;
        iPC.delegate = self;
        [self presentViewController:iPC animated:YES completion:nil];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadHeadData:UIImagePNGRepresentation(img)];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
