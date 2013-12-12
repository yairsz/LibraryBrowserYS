//
//  LBShelvesViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBShelvesViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

#define ENTITY @"Shelf"
#define SORT_KEY @"number"

@interface LBShelvesViewController ()

@end

@implementation LBShelvesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"Shelf No: %@",self.selectedLibraryName];
    self.currentPredicate = [NSPredicate predicateWithBlock:^BOOL(Shelf * shelf, NSDictionary *bindings) {
        return (self.selectedLibraryName == shelf.atLibrary.name);
    }];
}


#pragma mark - UI TABLE VIEW DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get Name of library and set that to the nextPredicate
    Shelf * shelf = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedShelfNumber = shelf.number;
    self.selectedShelf = shelf;
    [self performSegueWithIdentifier:@"shelvesToBooks" sender:self];
}

//This cell configuration is the only part that changes from the superclass, it gets data from the fetched results controller and uses it to configure each cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Shelf * aShelf = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Shelf No.: %@",aShelf.number];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //pass all necessary data to the next VC
    LBViewController * nextController = segue.destinationViewController;
    nextController.managedObjectContext = self.managedObjectContext;
    nextController.selectedLibraryName = self.selectedLibraryName;
    nextController.selectedLibrary = self.selectedLibrary;
    nextController.selectedShelf = self.selectedShelf;
    nextController.selectedShelfNumber = self.selectedShelfNumber;
}

#pragma mark - Fetched Results Controller

//Overriding these two methods was very easy thanks to modularization and the use of #define

- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}


@end
