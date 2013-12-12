//
//  Book.h
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Library, Shelf;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSNumber * enshelved;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) Library *atLibrary;
@property (nonatomic, retain) Shelf *atShelf;

- (void) enshelve: (Shelf *) shelve;
- (void) unshelve;

@end
