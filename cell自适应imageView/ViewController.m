//
//  ViewController.m
//  cell自适应imageView
//
//  Created by 陈世美 on 2018/3/16.
//  Copyright © 2018年 陈世美. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong)NSArray *ImgArray;
@property (nonatomic,strong)NSMutableArray *rowHeightArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rowHeightArray = [NSMutableArray new];
    self.ImgArray = @[@"http://39.108.57.113/public/upload/goods/2018/03-01/2351f6546c799c5765981d03f2b70328.jpg",@"http://39.108.57.113/public/upload/temp/2018/03-01/249487443055db732363c9d855000372.jpg"];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //图片少不用dispatch
    for (NSString *urlString in self.ImgArray) {
        
        CGSize size = [self getImageSizeWithURL:[NSURL URLWithString:urlString]];
        NSLog(@"size.width==%f,size.height==%f",size.width,size.height);
        
        //按比例,避免图片变形
        CGFloat fitHeight = size.height *rect.size.width/size.width;
        [self.rowHeightArray addObject:[NSString stringWithFormat:@"%f",fitHeight]];
    }
}
//根据url获取图片高度
- (CGSize)getImageSizeWithURL:(NSURL *)url
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0.0f, height = 0.0f;
    
    if (imageSource)
    {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (imageProperties != NULL)
        {
            CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNum != NULL) {
                CFNumberGetValue(widthNum, kCFNumberFloat64Type, &width);
                
                
            }
            
            CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNum != NULL) {
                CFNumberGetValue(heightNum, kCFNumberFloat64Type, &height);
            }
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
        NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    }
    return CGSizeMake(width, height);
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.ImgArray[indexPath.row]]];
    //    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *rowHeightString = self.rowHeightArray[indexPath.row];
    NSLog(@"rowHeightString==%@",rowHeightString);
    return rowHeightString.floatValue;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
