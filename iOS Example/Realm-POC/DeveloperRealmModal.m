//
//  DeveloperRealmModal.m
//  Realm-POC
//
//  Created by Sharon Nathaniel on 10/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import "DeveloperRealmModal.h"

@implementation Developer

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}


// Specify Primary Key or Keys

+ (NSString *)primaryKey {
    return @"code";
}

@end
