//
//  TableViewController.m
//  TableDemo
//
//  Created by Kevin Gutowski on 8/12/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import "TableViewController.h"
#import <objc/runtime.h>

@implementation TableViewController

- (NSArray *)crashes {
  if (!_crashes) {
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
      classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
      numClasses = objc_getClassList(classes, numClasses);
      for (int i = 0; i < numClasses; i++) {
        Class someClass = classes[i];
        Class superClass = class_getSuperclass(someClass);
        if (superClass == [MSCrash class] && someClass != [MSCrash class]){
          [MSCrash registerCrash:[someClass alloc]];
        }
      }
      free(classes);
    }
    
    NSArray *crashes = [MSCrash allCrashes];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES];
    _crashes = [crashes sortedArrayUsingDescriptors:@[sortDescriptor]];
  }
  return _crashes;
}

// NSTableViewDataSource Protocol Method

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.crashes.count;
}


// NSTableViewDelegate Protocol Method

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSString *identifier = tableColumn.identifier;
  NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
  cell.textField.stringValue = [[self.crashes objectAtIndex:row] title];
  return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
  NSLog(@"We're going to crash with %@", [[self.crashes objectAtIndex:row] title]);
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    [[self.crashes objectAtIndex:row] crash];
  });
  return YES;
}

@end
