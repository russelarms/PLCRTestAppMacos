//
//  TableViewController.h
//  TableDemo
//
//  Created by Kevin Gutowski on 8/12/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CrashLib/CrashLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSArray<MSCrash *> *crashes;

@end

NS_ASSUME_NONNULL_END
