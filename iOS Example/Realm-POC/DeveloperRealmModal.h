//
//  DeveloperRealmModal.h
//  Realm-POC
//
//  Created by Sharon Nathaniel on 10/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import <Realm/Realm.h>

#import "ProjectRealmModal.h"

@interface Developer : RLMObject

// Properties

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *code;

// Relations
@property RLMArray<Project> *projects;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DeveloperRealmModal>
RLM_ARRAY_TYPE(Developer)
