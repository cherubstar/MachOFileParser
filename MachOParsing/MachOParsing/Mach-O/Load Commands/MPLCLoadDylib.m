//
//  MPLCLoadDylib.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCLoadDylib.h"

@implementation MPLCLoadDylib

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                         offset:(uint32_t)_offset
                      timestamp:(uint32_t)_timestamp
                current_version:(uint32_t)_current_version
          compatibility_version:(uint32_t)_compatibility_version {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.offset = _offset;
        self.timestamp = _timestamp;
        self.current_version = _current_version;
        self.compatibility_version = _compatibility_version;
        self.name = @"???";
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Str Offset",
                             @"Time Stamp",
                             @"Current Version",
                             @"Compatibility Version",
                             @"Name", nil];
        
        time_t time = _timestamp;
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _offset],
                       [NSString stringWithFormat:@"%s", ctime(&time)],
                       [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%u.%u.%u",
                                                          (_current_version >> 16),
                                                          ((_current_version >> 8) & 0xff),
                                                          (_current_version & 0xff)]],
                       [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%u.%u.%u",
                                                          (_compatibility_version >> 16),
                                                          ((_compatibility_version >> 8) & 0xff),
                                                          (_compatibility_version & 0xff)]],
                       self.name, nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                          offset:(uint32_t)_offset
                       timestamp:(uint32_t)_timestamp
                 current_version:(uint32_t)_current_version
           compatibility_version:(uint32_t)_compatibility_version {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                  offset:_offset
                               timestamp:_timestamp
                         current_version:_current_version
                   compatibility_version:_compatibility_version];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    NSString *name_data;
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        
        if ( [self.descriptions[i] isEqualToString:@"Name"] ) {
            NSUInteger length = self.cmdsize - sizeof(dylib_command_t);
            self.name = [cursor readStringOfLength:length encoding:NSASCIIStringEncoding];
            value = self.name;
                        
            name_data = [cursor readDataOfLength:length];
            name_data = [NSString stringWithFormat:@"%@00", [name_data substringToIndex:self.name.length * 2]];
            flag = true;
            
            // Cut the last part
            self.name = [self.name lastPathComponent];
        } else {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:flag ? name_data : [NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(dylib_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(dylib_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, offset: %x, timestamp: %d, current_version: %x, compatibility_version: %d, name: %@",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.offset, self.timestamp, self.current_version, self.compatibility_version, self.name];
}

@end
