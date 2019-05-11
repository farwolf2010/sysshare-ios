//
//  sysShare.m
//  sysShare
//
//  Created by 郑江荣 on 2019/2/25.
//  Copyright © 2019 郑江荣. All rights reserved.
//

#import "sysShare.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "farwolf.h"
#import "farwolf_weex.h"
@implementation sysShare
WX_PlUGIN_EXPORT_MODULE(sysShare,sysShare)
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(share:))
-(void)share:(NSMutableDictionary*)param
{
    NSString *type=param[@"type"];
    if([@"image" isEqualToString:type])
    {
        
        [self shareImg:param[@"image"]];
    }
    else{
           NSString *content=param[@"content"];
        [self shareTxt:content];
    }
}


-(void)shareImg:(NSString*)path{
    NSURL *url=nil;
    if([path startWith:@"http"]){
        url=[NSURL URLWithString:path];
    }else if([path startWith: PREFIX_SDCARD]){
        path=[path replace:PREFIX_SDCARD withString:@""];
        if([path startWith: @"file://"]){
            path=[path replace:@"file://" withString:@""];
        }
        url=[NSURL fileURLWithPath:path];
    }
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [self shareAc:image];
    }];
}

-(void)shareTxt:(NSString*)txt
{
    NSString *shareText = txt;
    //    UIImage *shareImage = [UIImage imageNamed:@"167x167.png"];
    NSURL *shareURL = [NSURL URLWithString:txt];
    [self shareAc:shareURL];
    
}
-(void)shareAc:(NSObject*)obj
{
//    NSString *shareText = txt;
//    UIImage *shareImage = [UIImage imageNamed:@"167x167.png"];
//    NSURL *shareURL = [NSURL URLWithString:txt];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:obj];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"%@",activityType);
        if (completed) {
            NSLog(@"分享成功");
        } else {
            NSLog(@"分享失败");
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;
    
    [self.weexInstance.viewController presentViewController:vc animated:YES completion:nil];

}
@end
