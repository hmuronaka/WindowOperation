//
//  AppDelegate.m
//  WindowOperation
//
//  Created by Muronaka Hiroaki on 2013/02/25.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "WindowOperationListViewController.h"
#import "LatestUseFileViewController.h"
#import "WindowsOperationClientProtocol.h"

@interface AppDelegate()

@property(nonatomic, strong) WindowsOperationClientProtocol* protocol;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.protocol = [[WindowsOperationClientProtocol alloc] init];
    
    WindowOperationListViewController* controller = [[WindowOperationListViewController alloc] initWithNibName:@"WindowOperationListViewController" bundle:nil];
    controller.protocol = self.protocol;
    controller.title = @"Window";
    
    LatestUseFileViewController* controller2 = [[LatestUseFileViewController alloc]
                                                initWithNibName:@"LatestUseFileViewController" bundle:nil];
    controller2.protocol = self.protocol;
    controller2.title = @"Files";

    
    ViewController* settingViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    settingViewController.protocol = self.protocol;
    settingViewController.title = @"Setting";
    
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:
                                          controller,
                                          controller2,
                                          settingViewController,
                                          nil]];

    settingViewController.hidesBottomBarWhenPushed = YES;
    [tabBarController setSelectedIndex:2];
    
    // Override point for customization after application launch.
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
