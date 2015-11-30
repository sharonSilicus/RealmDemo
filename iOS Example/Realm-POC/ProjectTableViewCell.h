//
//  ProjectTableViewCell.h
//  Realm-POC
//
//  Created by Sharon Nathaniel on 18/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell

// IBOutlets
@property (nonatomic, weak) IBOutlet UILabel *projectNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *projectCodeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
