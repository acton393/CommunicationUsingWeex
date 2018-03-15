//
//  ViewController.m
//  WeexSampleApplication
//
//  Created by zifan.zx on 2018/3/14.
//  Copyright © 2018年 zifan.zx. All rights reserved.
//

#import "ViewController.h"
#import "WeexDemoViewController.h"

@interface ViewController ()
@property (nonatomic,strong)NSArray * sectionArray;
@property (nonatomic,strong)NSArray * urlData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sectionArray = @[@[@"Weex Page", @"Weex Page --> native", @"Weex page <--> Weex Page (broadcast)"],
                      @[@"native", @"native --> Weex Page (globalEvent)", @"native --> Weex Page (custom Event)"],
                      @[@"Web", @"Weex Page --> web", @"Web --> Weex Page"]];
    _urlData = @[@"http://dotwe.org/raw/dist/d9c4c33c4b571c449b94e19cf87c9efd.bundle.wx",
                 @"http://dotwe.org/raw/dist/d9a413a6ad2aabf682eef9f34e932fb8.bundle.wx",
                 @"http://dotwe.org/raw/dist/a990489ff198b8936fad621c6ae9af01.bundle.wx",
                 @"http://dotwe.org/raw/dist/225b3d4d3f5fd313ff404fd1037126f3.bundle.wx",
                 @"http://dotwe.org/raw/dist/203e0ff3641c95571eb52e79f540170d.bundle.wx",
                 @"http://dotwe.org/raw/dist/203e0ff3641c95571eb52e79f540170d.bundle.wx",
                 ];
    self.tableView.allowsSelection = YES;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * headerView = [UILabel new];
    headerView.text = [NSString stringWithFormat:@"     %@", _sectionArray[section][0]];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"WXSampleApplicationViewController"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.showsReorderControl = YES;
        cell.textLabel.text = _sectionArray[indexPath.section][indexPath.row+1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeexDemoViewController * demoController = [WeexDemoViewController new];
    NSString * urlString = _urlData[(indexPath.row)+(indexPath.section*2)];
    if (!urlString.length) {
        return;
    }
    demoController.url = [NSURL URLWithString:urlString];
    [self.navigationController pushViewController:demoController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
