//
// Created by Alexandre Santana on 10/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Protocol which the ViewController has to implement to receive the Error when the request fail
*/
@protocol FDControllerProtocol <NSObject>

/**
* Receive an error from request
* @param error The error
*/
+ (void)receiveError:(NSError *)error;

/**
* Receive a success message from request
*/
+ (void)receiveSuccess;

@end