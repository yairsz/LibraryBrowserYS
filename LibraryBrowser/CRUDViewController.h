//
//  CRUDViewController.h
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/12/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

@interface CRUDViewController : UIViewController

@property (strong, nonatomic) Book * selectedBook;
@property (strong, nonatomic) Library * selectedLibrary;
@property (strong, nonatomic) Shelf * selectedShelf;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
