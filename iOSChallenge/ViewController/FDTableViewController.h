//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Table who will show the results of a JSON
*/
@interface FDTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
NSMutableArray *_dataArray;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *customSortDescription;


- (void)dataFromDatabase;
@end