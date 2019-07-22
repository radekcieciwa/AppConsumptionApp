//
//  MemoryAllocator.h
//  RAMAllocator
//
//  Created by Radoslaw Cieciwa on 12/07/2019.
//  Copyright © 2019 BeardDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryAllocator : NSObject
@property(assign) uint64_t physicalMemorySize;
@property(assign) uint64_t userMemorySize;
@property (nonatomic, copy, nullable) void (^onMemoryUpdate)(uint64_t physicalMemory, uint64_t userMemorySize);

- (void)allocateMemory:(int)megabytes;
- (void)clearAll;

@end

NS_ASSUME_NONNULL_END
