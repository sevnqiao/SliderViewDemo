//
//  ViewController.m
//  Demo
//
//  Created by xiong on 2017/3/17.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"

@interface ViewController ()<UIScrollViewDelegate, SliderViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SliderView *sliderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    self.sliderView = [[SliderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.sliderView.itemArray = @[@"全部",@"上次搜索搜索",@"浏览过的",@"收藏的",@"全部",@"上次搜索搜索",@"浏览过的",@"收藏的",@"全部",@"上次搜索搜索",@"浏览过的",@"收藏的"] ;
    self.sliderView.delegate = self;
    [self.view addSubview:self.sliderView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.sliderView.itemArray.count, self.view.frame.size.height-44);
    
    for (int i = 0; i<self.sliderView.itemArray.count; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self.scrollView addSubview:view];
    }
    
}

- (void)sliderView:(SliderView *)sliderView slideAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * index, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.sliderView.indexOffset = scrollView.contentOffset.x / self.view.frame.size.width;
}

@end
