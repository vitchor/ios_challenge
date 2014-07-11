//
//  Data.h
//  iOSChallenge
//
//  Created by Alexandre Santana on 09/07/14.
//  Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Data : NSManagedObject

@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * authors;
@property (nonatomic, retain) NSString * title;

@end
