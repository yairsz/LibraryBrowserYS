//
//  LBBooksViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBBooksViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

#define ENTITY @"Book"
#define SORT_KEY @"title"

@interface LBBooksViewController ()

@end

@implementation LBBooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentPredicate = [NSPredicate predicateWithBlock:^BOOL(Book * book, NSDictionary *bindings) {
        return (self.selectedLibraryName == book.atLibrary.name) && (self.selectedShelfNumber == book.atShelf.number);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //Get Name of library and set that to the nextPredicate
//    Shelf * shelf = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    self.nextPredicate = [NSPredicate predicateWithFormat:@"atShelf.number CONTAINS %@", shelf.number];
//    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Book * aBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aBook.title;
    cell.detailTextLabel.text = aBook.author;
}


#pragma mark - Fetched Results Controller


- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}

@end
