//
//  WMCustomizedPageController.m
//  WMPageControllerExample
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import "WMCustomizedPageController.h"
#import "WMTableViewController.h"
#import "WMViewController.h"
#import "WMCollectionViewController.h"

@interface WMCustomizedPageController ()
@property (nonatomic, strong) UIView *redView;

@property (nonatomic, copy) NSArray *tagTitles;


@property (nonatomic, assign) NSInteger index;
@end

@implementation WMCustomizedPageController

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectZero];
        _redView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    }
    return _redView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        [self.view addSubview:self.redView];
    }
    
    self.tagTitles = nil;//@[@"LIST",@"INTRODUCTION", @"IMAGES", @"LIST1",@"INTRODUCTION1", @"IMAGES1"];
    [self reloadData];
    [self addActionButton];
}

- (void)refresh
{
    self.tagTitles = nil;
    if (_index%2 == 0)
    {
        self.tagTitles = @[@"LIST",@"INTRODUCTION", @"IMAGES", @"LIST1",@"INTRODUCTION1", @"IMAGES1"];
    }
    [self reloadData];
    _index++;
    
    [self addActionButton];
}

- (void)addActionButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 180.0f, 100.0f, 35.0f)];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn setTitle:@"Rfresh" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.redView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), self.view.frame.size.width, 2.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    switch (self.menuViewStyle) {
//        case WMMenuViewStyleFlood: return 3;
//        case WMMenuViewStyleSegmented: return 3;
//        default: return 10;
//    }
    
    return self.tagTitles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    switch (index % 3) {
//        case 0: return @"LIST";
//        case 1: return @"INTRODUCTION";
//        case 2: return @"IMAGES";
//    }
    if(index >= self.tagTitles.count)
    {
        return nil;
    }
    NSString *title = [self.tagTitles objectAtIndex:index];
    return title;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[WMTableViewController alloc] init];
        case 1: return [[WMViewController alloc] init];
        case 2: return [[WMCollectionViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        originY += self.redView.frame.size.height;
    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

@end
