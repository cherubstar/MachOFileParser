//
//  MPLCMain.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCMain.h"

@implementation MPLCMain

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                       entryoff:(uint64_t)_entryoff
                      stacksize:(uint64_t)_stacksize
                     entrypoint:(uint64_t)_entrypoint {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.entryoff = _entryoff;
        self.stacksize = _stacksize;
        self.entrypoint = _entrypoint;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Entry Offset",
                             @"Stack Size",
                             @"Entry Point", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%lld", _entryoff],
                       [NSString stringWithFormat:@"%lld", _stacksize],
                       [NSString stringWithFormat:@"0x%qX", _entrypoint], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        entryoff:(uint64_t)_entryoff
                       stacksize:(uint64_t)_stacksize
                      entrypoint:(uint64_t)_entrypoint {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                entryoff:_entryoff
                               stacksize:_stacksize
                              entrypoint:_entrypoint];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        
        if ( [self.descriptions[i] isEqualToString:@"Entry Offset"] ||
             [self.descriptions[i] isEqualToString:@"Stack Size"] ) {
            data = [cursor readLittleInt64];
        } else if ( [self.descriptions[i] isEqualToString:@"Entry Point"] ) {
            flag = true;
        } else {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:flag ? @"-" : [NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(entry_point_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(entry_point_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, entryoff: %lld, stacksize: %lld",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.entryoff, self.stacksize];
}

@end
