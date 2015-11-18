//
//  UIViewController+Create.m
//  StartUp4iPhone
//
//  Created by Ron on 14-2-24.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UIViewController+Create.h"
#import "UIStoryboard+Addition.h"

@implementation UIViewController(Create)

+ (id)create
{
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"%@",className);
    NSLog(@"%@",[UIStoryboard fromName:className]);
    id newObj = [[UIStoryboard fromName:className] instantiateInitialViewController];
    NSLog(@"%@",newObj);
    return newObj;
}

+ (id)createFromStoryboardName:(NSString *)name withIdentifier:(NSString *)identifier;
{
    if (name && identifier) {
        UIStoryboard *storyboard = [UIStoryboard fromName:name];
        
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
        
    }
    return nil;
}

@end
