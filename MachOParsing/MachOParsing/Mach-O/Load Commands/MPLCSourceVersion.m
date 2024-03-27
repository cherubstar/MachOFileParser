//
//  MPLCSourceVersion.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCSourceVersion.h"

@implementation MPLCSourceVersion

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                        version:(uint64_t)_version {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.version = _version;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Version", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%lld", _version], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                         version:(uint64_t)_version {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                 version:_version];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        if ( [self.descriptions[i] isEqualToString:@"Version"] ) {
            data = [cursor readLittleInt64];
        } else {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(source_version_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(source_version_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, version: %lld",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.version];
}

@end
