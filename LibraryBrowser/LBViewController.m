//
//  LBViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBViewController.h"

//these constants are defined for ease of code duplication in the subclasses
#define ENTITY @"Library"
#define SORT_KEY @"name"

@interface LBViewController ()

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get Name of library and set that to the nextPredicate
    Library * library = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedLibraryName = library.name;
    self.selectedLibrary = library;
    [self performSegueWithIdentifier:@"libraryToShelves" sender:self];
    // This method must be called in order to pass the necessary data to the next VC
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //pass all necessary data to the next VC
    LBViewController * nextController = segue.destinationViewController;
    nextController.managedObjectContext = self.managedObjectContext;
    nextController.selectedLibraryName = self.selectedLibraryName;
    nextController.selectedLibrary = self.selectedLibrary;
}



//This method is created to be able to inherit the cellForRowAt... method

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Library * aLibrary = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aLibrary.name;
}


#pragma mark - Fetched Results Controller


- (NSFetchRequest *) currentFetchRequest {
    if (_currentFetchRequest == nil) {
        _currentFetchRequest = [[NSFetchRequest alloc] init];
        
        //The next method call will make it easy to override this in subclasses
        
        [_currentFetchRequest setEntity:[self getEntityDescription]];
        [_currentFetchRequest setPredicate:self.currentPredicate];
        [self.currentFetchRequest setFetchBatchSize:20]; // set the batch size
    }
        return _currentFetchRequest;
}

// This is the one part of the fetch request that will change in subclasses

- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //The next method call will make it easy to override this in subclasses

    NSArray *sortDescriptors = [NSArray arrayWithObjects:[self getSortDescriptor], nil];
    [self.currentFetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.currentFetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;

}

// This is the other part of the fetch request that will change in subclasses


- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}



@end
