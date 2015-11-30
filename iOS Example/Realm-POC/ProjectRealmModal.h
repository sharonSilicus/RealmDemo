//
//  ProjectRealmModel.h
//  Realm-POC
//
//  Created by Sharon Nathaniel on 10/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import <Realm/Realm.h>

@interface Project : RLMObject

// Properties

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *clientName;

@property (nonatomic, strong) NSString *manager;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ProjectRealmModel>
RLM_ARRAY_TYPE(Project)
