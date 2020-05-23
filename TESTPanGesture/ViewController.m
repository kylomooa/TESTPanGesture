//
//  ViewController.m
//  TESTPanGesture
//
//  Created by maoqiang on 2020/5/15.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "ViewController.h"
#import "hitTestViewController.h"
#import "bezierPathHiteTestViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//MARK: - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"响应者链";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"CAShapeLayer 绘制图形的点击事件判断";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//MARK: - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        hitTestViewController *vc = [[hitTestViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 1){
        bezierPathHiteTestViewController *vc = [[bezierPathHiteTestViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
