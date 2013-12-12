//
//  Book.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "Book.h"
#import "Library.h"
#import "Shelf.h"


@implementation Book

@dynamic enshelved;
@dynamic title;
@dynamic author;
@dynamic atLibrary;
@dynamic atShelf;


- (void) enshelve: (Shelf *) shelf{
    self.atShelf = shelf;
    self.enshelved = [NSNumber numberWithInt:1];
    
}

- (void) unshelve{
    self.atShelf = nil;
    self.enshelved = [NSNumber numberWithInt:0];
}




@end
