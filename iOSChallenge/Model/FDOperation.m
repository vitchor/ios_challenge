//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import "FDOperation.h"
#import "FDControllerProtocol.h"


@implementation FDOperation


+ (RKManagedObjectRequestOperation *)operationWithURL:(NSURL *)url managedObjectStore:(RKManagedObjectStore *)store sender:(NSString *)sender
{

    NSString *entity = [self entity];
    NSDictionary *mappingsDictionary = [self mappingDictionary];
    id (^block)(id) = [self responseBlock];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:entity inManagedObjectStore:store];
    mapping.identificationAttributes = @[@"title"];
    [mapping addAttributeMappingsFromDictionary:mappingsDictionary];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setWillMapDeserializedResponseBlock:block];
    operation.managedObjectContext = store.mainQueueManagedObjectContext;
    operation.managedObjectCache = store.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operationRequest, RKMappingResult *result) {
        NSLog(@":200 SUCCESS %@", [result array]);

        Class <FDControllerProtocol> class = NSClassFromString(sender);
        [class receiveSuccess];

    }                                failure:^(RKObjectRequestOperation *operationRequest1, NSError *err) {
        NSLog(@":XXX FAILED");
        NSLog(@"%@\n[%u] failure: %@ & %@", [[operationRequest1 HTTPRequestOperation] request], operationRequest1.HTTPRequestOperation.response.statusCode, [err localizedDescription], err);

        Class <FDControllerProtocol> class = NSClassFromString(sender);
        [class receiveError:err];
    }];

    return operation;
}


#pragma mark - Methods to custom the operation
+ (id (^)(id))responseBlock {
    return ^id(id deserializedResponseBody) {
        NSMutableDictionary *dictionary = [deserializedResponseBody mutableCopy];

        return dictionary;
    };
}


+ (NSDictionary *)mappingDictionary {
    return @{ //JSON : DataModel
            @"website" : @"website",
            @"date" : @"date",
            @"authors" : @"authors",
            @"title" : @"title"
    };
}


+ (NSString *)entity {
    return @"Data";
}

@end