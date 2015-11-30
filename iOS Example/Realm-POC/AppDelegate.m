//
//  AppDelegate.m
//  Realm-POC
//
//  Created by Sharon Nathaniel on 10/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "DeveloperRealmModal.h"

#import "ProjectRealmModal.h"

#import "ApplicationSharedManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // To do a clean database start uncomment the line below
//    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealmConfiguration defaultConfiguration].path error:nil];

#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    // Get Default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];

    RLMResults<Developer *> *developer = [Developer allObjects];
    
    if (developer.count == 0) {

        // Create a Sample Developer Object
        Developer *demoDeveloper = [[Developer alloc] init];
        demoDeveloper.name = @"Sharon Nathaniel";
        demoDeveloper.code = @"P339";
        
        // Create a sample Project Object
        Project *demoProject = [[Project alloc] init];
        demoProject.name = @"Demo Project";
        demoProject.code = @"SOWSIL000001";
        demoProject.isActive = FALSE;
        demoProject.clientName = @"Demo Client";
        demoProject.manager = @"Demo Manager";
        demoProject.type = @"Fixed Price";
        
        // Save demo project with transaction
        [realm beginWriteTransaction];
        [realm addObject:demoProject];
        [realm commitWriteTransaction];
        
        // Link demo project with demo developer
        [demoDeveloper.projects addObject:demoProject];
        
        // Save to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:demoDeveloper];
        [realm commitWriteTransaction];
    }
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
