//
// Created by Alexandre Santana on 09/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import "FDTableViewController.h"
#import "Data.h"
#import "FDModelFacade.h"
#import "FDNoContentView.h"
#import "KeepLayout.h"

static NSString *const kEntityName = @"Data";

@interface FDTableViewController ()

@end

@implementation FDTableViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self setTitle:NSLocalizedString(@"JSON_TITLE", nil)];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    [self dataFromDatabase];
}

- (void)setCustomSortDescription:(NSArray *)customSortDescription
{
    _customSortDescription = customSortDescription;


    [_dataArray sortUsingDescriptors:customSortDescription];
    [self.tableView reloadData];
}


- (void)dataFromDatabase
{
    if ([_dataArray count] > 0) {
        [_dataArray removeAllObjects];
    }

    [_dataArray addObjectsFromArray:[self.fetchedResultsController fetchedObjects]];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    Data *data = [_dataArray objectAtIndex:(NSUInteger) indexPath.row];
    [cell.textLabel setText:data.title];
    [cell.detailTextLabel setText:data.authors];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of Rows: %u", [_dataArray count]);
    return [_dataArray count];
}


#pragma mark - Fetched results controller

- (NSFetchRequest *)contentFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    [fetchRequest setSortDescriptors:self.customSortDescription];

    return fetchRequest;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self contentFetchRequest]
                                                                                                managedObjectContext:__managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        abort();
    }

    return __fetchedResultsController;

}


- (void)reloadContent
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        abort();
    }
    [self.tableView reloadData];
}


#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch (type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end