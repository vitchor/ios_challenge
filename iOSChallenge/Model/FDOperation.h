//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface FDOperation : NSObject

/**
* Return a operation to be added at the queue
* @param url Which URL will the request use
* @param store A ManagedObjectStore needed to save in Data Model
* @param sender The class who sent the request
* @returns A operation that implements object mapping and has the right url
*/
+ (RKManagedObjectRequestOperation *)operationWithURL:(NSURL *)url managedObjectStore:(RKManagedObjectStore *)store sender:(NSString *)sender;
@end