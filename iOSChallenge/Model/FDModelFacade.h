//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDViewController;

/**
* Class to manage everything related to Model Layer
*/
@interface FDModelFacade : NSObject

/**
* Build a EDModelFacade with default configuration, make sure to run this at least once in code
* @param model The AppDelegate managedObjectModel needed to configure RestKit
*/
+ (void)build:(NSManagedObjectModel *)model;

/**
* Request something using http GET protocol
* @param url The base url the http GET will use
* @param sender The class who sent the request
*/
+ (void)requestWithURL:(NSURL *)url sender:(NSString *)sender;

+ (NSManagedObjectContext *)managedObjectContext;
@end