//
//  Library.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "Library.h"
#import "Book.h"
#import "Shelf.h"


@implementation Library

@dynamic name;
@dynamic books;
@dynamic shelves;


- (NSSet *) reportAllBooks {
    return self.books;
}


@end
