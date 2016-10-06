//
//  ViewController.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/28.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+RoundCorner.h"
#import "UIImage+RoundImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"天气"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = image;
    
    /**
     *  方法1：cornerRadius
     */
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.layer.cornerRadius = 50;
//    imageView.layer.masksToBounds = YES;
    
    
    /**
     *  imageView Core Graphics绘制圆角: CGBitmapContextCreate & CGContextDrawImage
     */
//    [imageView roundCorner];
//    [imageView UIKitRoundCorner];
    
    /**
     *  UIImage Core Graphics绘制圆角: CGBitmapContextCreate & CGContextDrawImage
     */
    image = [image UIKitRoundImageWithSize:imageView.frame.size];
//    image = [image roundImageWithSize:imageView.frame.size];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = image;
//
    [self.view addSubview:imageView];
}



@end
