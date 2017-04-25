//
//  KDSocialShare.m
//  ReactNativeSocialShare
//
//  Created by Kim Døfler Sand Laursen on 25-04-15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "KDSocialShare.h"
#import <React/RCTConvert.h>
#import <Social/Social.h>

@implementation KDSocialShare

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(tweet:(NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    NSString *serviceType = SLServiceTypeTwitter;
    SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    if ([options objectForKey:@"link"] && [options objectForKey:@"link"] != [NSNull null]) {
        NSString *link = [RCTConvert NSString:options[@"link"]];
        [composeCtl addURL:[NSURL URLWithString:link]];
    }
    
    if ([options objectForKey:@"image"] && [options objectForKey:@"image"] != [NSNull null]) {
        [composeCtl addImage: [UIImage imageNamed: options[@"image"]]];
    } else if ([options objectForKey:@"imagelink"] && [options objectForKey:@"imagelink"] != [NSNull null]) {
        NSString *imagelink = [RCTConvert NSString:options[@"imagelink"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagelink]]];
        [composeCtl addImage:image];
    }
    
    if ([options objectForKey:@"text"] && [options objectForKey:@"text"] != [NSNull null]) {
        NSString *text = [RCTConvert NSString:options[@"text"]];
        [composeCtl setInitialText:text];
    }
    
    [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            // Sent
            callback(@[@"success"]);
        }
        else if (result == SLComposeViewControllerResultCancelled){
            // Cancelled
            callback(@[@"cancelled"]);
        }
    }];
    
    [[self topViewController] presentViewController:composeCtl animated:YES completion: nil];
}

RCT_EXPORT_METHOD(shareOnFacebook:(NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    NSString *serviceType = SLServiceTypeFacebook;
    SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    if ([options objectForKey:@"link"] && [options objectForKey:@"link"] != [NSNull null]) {
        NSString *link = [RCTConvert NSString:options[@"link"]];
        [composeCtl addURL:[NSURL URLWithString:link]];
    }
    
    if ([options objectForKey:@"image"] && [options objectForKey:@"image"] != [NSNull null]) {
        [composeCtl addImage: [UIImage imageNamed: options[@"image"]]];
    } else if ([options objectForKey:@"imagelink"] && [options objectForKey:@"imagelink"] != [NSNull null]) {
        NSString *imagelink = [RCTConvert NSString:options[@"imagelink"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagelink]]];
        [composeCtl addImage:image];
    }
    
    if ([options objectForKey:@"text"] && [options objectForKey:@"text"] != [NSNull null]) {
        NSString *text = [RCTConvert NSString:options[@"text"]];
        [composeCtl setInitialText:text];
    }
    
    [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            // Sent
            callback(@[@"success"]);
        }
        else if (result == SLComposeViewControllerResultCancelled){
            // Cancelled
            callback(@[@"cancelled"]);
        }
    }];
    
    [[self topViewController] presentViewController:composeCtl animated:YES completion: nil];
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else if (rootViewController.childViewControllers.count > 0) {
        return [self topViewControllerWithRootViewController:rootViewController.childViewControllers.lastObject];
    }
    else {
        return rootViewController;
    }
}

@end
