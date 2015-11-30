//
//  ApplicationSharedManager.h
//  Realm-POC
//
//  Created by Sharon Nathaniel on 18/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Realm/Realm.h>

#import "DeveloperRealmModal.h"

@interface ApplicationSharedManager : NSObject

+ (ApplicationSharedManager *) manager;

+ (ApplicationSharedManager *) sharedManager;

#pragma mark -
#pragma mark Properties
#pragma mark -

@property (nonatomic, strong) Developer *developerModal;


@end
