//
//  Library.h
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

// This class was generated by Core Data  by using the CReate Managed object Subclass. I added the two required methods.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Shelf;

@interface Library : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *books;
@property (nonatomic, retain) NSOrderedSet *shelves;

- (NSSet *) reportAllBooks;

@end

@interface Library (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

- (void)insertObject:(Shelf *)value inShelvesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromShelvesAtIndex:(NSUInteger)idx;
- (void)insertShelves:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeShelvesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInShelvesAtIndex:(NSUInteger)idx withObject:(Shelf *)value;
- (void)replaceShelvesAtIndexes:(NSIndexSet *)indexes withShelves:(NSArray *)values;
- (void)addShelvesObject:(Shelf *)value;
- (void)removeShelvesObject:(Shelf *)value;
- (void)addShelves:(NSOrderedSet *)values;
- (void)removeShelves:(NSOrderedSet *)values;
@end
