//
//  ZQTestTVC.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/10/1.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "ZQTestTVC.h"
#import "UIImageView+RoundCorner.h"
#import "UIImage+RoundImage.h"
#import "UIImageView+WebCache.h"

#define kHeight 40

@interface ZQTestTVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *imageArrLocal;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, assign) CFTimeInterval endTime;

@property (nonatomic, strong) NSCache *cache;

@end
@implementation ZQTestTVC


- (void)dealloc {
    NSLog(@"ZQTestTVC dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.startTime = CACurrentMediaTime();
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", self.endTime - self.startTime);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSInteger total = CGRectGetWidth(self.view.frame)/kHeight;
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        for (int i=1; i<=total; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHeight * (i-1), 2, kHeight, kHeight)];
            imageView.layer.masksToBounds = NO;
            imageView.tag = i;
            [cell.contentView addSubview:imageView];
        }
        
    }
    
    
    for (int i=1; i<=total; i++) {
//        __weak __typeof(self) wSelf = self;
        UIImageView *imageView = [cell viewWithTag:i];
        imageView.image = nil;
        NSString *path = [self urlStr:indexPath.row];
//        NSURL *url = [NSURL URLWithString:[self urlStr:indexPath.row]];
        UIImage *image = [self.cache objectForKey:path];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:path];
            [self.cache setObject:image forKey:path];
        }
        
        switch (self.type) {
            case RenderTypeUIImageUIKit: {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *img = [image UIKitRoundImageWithSize:imageView.frame.size];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = img;
                    });
                });
                break;
            }
            case RenderTypeUIImageCG: {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *img = [image roundImageWithSize:imageView.frame.size];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = img;
                    });
                });
                break;
            }
            case RenderTypeUIImageViewUIKit: {
                [imageView UIKitRoundCorner:image];
                break;
            }
            case RenderTypeUIImageViewCG: {
                [imageView roundCorner:image];
                break;
            }
            case RenderTypeCornerRadius: {
                imageView.image = image;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.cornerRadius = imageView.frame.size.width/2;
                imageView.layer.masksToBounds = YES;
                break;
            }
        }
//        [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            __strong __typeof(self) sSelf = wSelf;
//            switch (sSelf.type) {
//                case RenderTypeUIImageUIKit: {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        UIImage *img = [image UIKitRoundImageWithSize:imageView.frame.size];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            imageView.image = img;
//                        });
//                    });
//                    break;
//                }
//                case RenderTypeUIImageCG: {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        UIImage *img = [image roundImageWithSize:imageView.frame.size];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            imageView.image = img;
//                        });
//                    });
//                    break;
//                }
//                case RenderTypeUIImageViewUIKit: {
//                    [imageView UIKitRoundCorner:image];
//                    break;
//                }
//                case RenderTypeUIImageViewCG: {
//                    [imageView roundCorner:image];
//                    break;
//                }
//                case RenderTypeCornerRadius: {
//                    imageView.image = image;
//                    imageView.contentMode = UIViewContentModeScaleAspectFill;
//                    imageView.layer.cornerRadius = imageView.frame.size.width/2;
//                    imageView.layer.masksToBounds = YES;
//                    break;
//                }
//            }
//        }];

        
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kHeight+4;
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (NSString *)urlStr:(NSInteger)row {
    NSInteger count = self.imageArrLocal.count;
    NSInteger index = arc4random() % count;
//    return [self.imageArr objectAtIndex:index];
    return [self.imageArrLocal objectAtIndex:index];
}

//- (NSArray *)imageArr {
//    if (!_imageArr) {
//        NSMutableArray *mArr = [NSMutableArray array];
//        for (NSUInteger i=0; i<100; i++) {
//            [mArr addObject:[UIImage imageNamed:@"天气"]];
//        }
//        _imageArr = [mArr copy];
//    }
//    return _imageArr;
//}
- (NSArray *)imageArrLocal {
    if (!_imageArrLocal) {
//        NSMutableArray *mArr = [NSMutableArray array];
        NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"JPG" inDirectory:@""];
        
        _imageArrLocal = [paths copy];
    }
    return _imageArrLocal;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/09.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/10.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/12/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/13/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/14/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/15/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/16/09.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/17/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/18/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/19/09.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/01.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/02.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/03.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/04.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/05.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/06.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/07.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/08.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/09.jpg",
                      @"http://pic.meizitu.com/wp-content/uploads/2015a/11/20/10.jpg"];
    }
    return _imageArr;
}
@end
