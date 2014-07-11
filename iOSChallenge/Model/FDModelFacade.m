//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import "FDModelFacade.h"
#import "RestKit.h"
#import "FDOperation.h"
#import "FDViewController.h"

static RKManagedObjectStore *managedObjectStore = nil;
static NSOperationQueue *operationQueue;

@implementation FDModelFacade

+ (void)build:(NSManagedObjectModel *)model {
    // Initialize RestKit
    managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:model];
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"iOSChallenge.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];

    operationQueue = [NSOperationQueue new];
}


+ (void)requestWithURL:(NSURL *)url sender:(NSString *)sender
{

    RKManagedObjectRequestOperation *operation = [FDOperation operationWithURL:url managedObjectStore:managedObjectStore sender:sender];

    [operationQueue addOperation:operation];

}

+ (NSManagedObjectContext *)managedObjectContext {
    return [managedObjectStore persistentStoreManagedObjectContext];
}


@end