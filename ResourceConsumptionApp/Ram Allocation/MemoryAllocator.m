//
//  MemoryAllocator.m
//  RAMAllocator
//
//  Created by Radoslaw Cieciwa on 12/07/2019.
//  Copyright © 2019 BeardDev. All rights reserved.
//

#import "MemoryAllocator.h"
#import <sys/types.h>
#import <sys/sysctl.h>

#define MEMORY_WARNINGS_FILE_NAME @"MemoryWarnings.dat"
#define CRASH_MEMORY_FILE_NAME @"CrashMemory.dat"

// TODO: Touch pages
@interface MemoryAllocator() {
    Byte *p[10000];
    int allocatedMB;
}

@property(nonatomic) NSMutableArray *memoryWarnings;
@property(assign) BOOL firstMemoryWarningReceived;

@end

@implementation MemoryAllocator

- (void)refreshMemoryInfo {
    // Get memory info
    int mib[2];
    size_t length;
    mib[0] = CTL_HW;

    mib[1] = HW_MEMSIZE;
    length = sizeof(int64_t);
    sysctl(mib, 2, &_physicalMemorySize, &length, NULL, 0);

    mib[1] = HW_USERMEM;
    length = sizeof(int64_t);
    sysctl(mib, 2, &_userMemorySize, &length, NULL, 0);

    if (self.onMemoryUpdate) {
        self.onMemoryUpdate(self.physicalMemorySize, self.userMemorySize);
    }
}

- (void)clearAll {
    for (int i = 0; i < allocatedMB; i++) {
        free(p[i]);
    }

    allocatedMB = 0;
    [self refreshMemoryInfo];
}

- (void)allocateMemory:(int)megabytes {
    for(int i = 0; i < megabytes; i++) {
        size_t memoryToAllocate = 1048576;
        p[allocatedMB] = malloc(memoryToAllocate);
        memset(p[allocatedMB], 0, memoryToAllocate);
        allocatedMB += 1;
    }

    [self refreshMemoryInfo];
}

@end
