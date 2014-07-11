//
// Created by Alexandre Santana on 10/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDControllerProtocol.h"
#import "FDNoContentView.h"

/**
* Class who will show the TableView when the content is ready, or the error if any.
*/
@interface FDViewController : UIViewController <FDNoContentViewDelegate, FDControllerProtocol, UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end