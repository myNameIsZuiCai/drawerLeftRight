//
//  ViewController.m
//  抽屉效果（简单实现）
//
//  Created by 张艳楠 on 2017/1/16.
//  Copyright © 2017年 zhang yannan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *mainView;
@property(nonatomic,strong) UIView *rightView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createThreeVCs];
    //添加pan手势
    UIPanGestureRecognizer *panGes=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGes];
    //利用KVO监听mainView的frame属性
    //observer:谁想监听
    //keyPath:被监听的对象
    //option:监听新值的改变
    [self.mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark 只要被监听的属性属性发生改变，就会调用这个方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"当前frame：%@",NSStringFromCGRect(self.mainView.frame));
    if (self.mainView.frame.origin.x > 0) {
        //向右滑
        self.rightView.hidden=YES;
    }else if (self.mainView.frame.origin.x < 0){
        self.rightView.hidden=NO;
    }else{
        
    }
}
#pragma mark 移除观察者
-(void)dealloc{
    [self.mainView removeObserver:self forKeyPath:@"frame"];
}
#pragma mark 拖动事件
-(void)pan:(UIPanGestureRecognizer *)pan{
    //获取手势的移动位置
    CGPoint pointEnd=[pan translationInView:self.view];
    //获取x轴的偏移量
    CGFloat offsetX=pointEnd.x;

    self.mainView.frame=[self frameWithOffset:offsetX];

    //复位
    [pan setTranslation:CGPointZero inView:self.view];
}
#pragma mark 根据offset计算mainView的frame
-(CGRect)frameWithOffset:(CGFloat)offsetx{
    //修改mainView的frame
    CGRect frame=self.mainView.frame;
    frame.origin.x += offsetx;
    NSLog(@"%f,%f",frame.origin.x,frame.origin.y);
    return frame;
}
#pragma mark 创建三个子控制器
-(void)createThreeVCs{
    //左边的
    self.leftView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.leftView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.leftView];
    //右边的
    self.rightView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.rightView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.rightView];
    //中间的
    self.mainView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.mainView.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.mainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
