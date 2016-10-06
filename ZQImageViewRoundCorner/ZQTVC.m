//
//  ZQTVC.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/10/5.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "ZQTVC.h"
#import "ZQTestTVC.h"

@interface ZQTVC ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation ZQTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"UIImage UIKit";
            break;
        case 1:
            cell.textLabel.text = @"UIImage Core Graphics";
            break;
        case 2:
            cell.textLabel.text = @"UIImageView UIKit";
            break;
        case 3:
            cell.textLabel.text = @"UIImageView Core Graphics";
            break;
        case 4:
            cell.textLabel.text = @"cornerRadius";
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQTestTVC *tvc = [[ZQTestTVC alloc] init];
    switch (indexPath.row) {
        case 0:
            tvc.type = RenderTypeUIImageUIKit;
            break;
        case 1:
            tvc.type = RenderTypeUIImageCG;
            break;
        case 2:
            tvc.type = RenderTypeUIImageViewUIKit;
            break;
        case 3:
            tvc.type = RenderTypeUIImageViewCG;
            break;
        case 4:
            tvc.type = RenderTypeCornerRadius;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:tvc animated:YES];
}
@end
