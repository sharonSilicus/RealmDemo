//
//  ApplicationSharedManager.m
//  Realm-POC
//
//  Created by Sharon Nathaniel on 18/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import "ApplicationSharedManager.h"

@implementation ApplicationSharedManager

+ (ApplicationSharedManager *)manager
{
    ApplicationSharedManager *applicationManager = [[ApplicationSharedManager alloc] init];
    
    return applicationManager;
}

+ (ApplicationSharedManager *)sharedManager {
    
    static ApplicationSharedManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[self alloc] init];
        
    });
    
    return sharedManager;
}

@end
