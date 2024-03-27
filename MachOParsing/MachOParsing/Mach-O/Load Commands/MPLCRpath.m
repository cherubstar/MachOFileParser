//
//  MPLCRpath.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCRpath.h"

@implementation MPLCRpath

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                         offset:(uint32_t)_offset {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.offset = _offset;
        self.path = @"???";
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Str Offset",
                             @"Path", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _offset],
                       self.path, nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                          offset:(uint32_t)_offset {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                  offset:_offset];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    NSString *path_data;
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        
        if ( [self.descriptions[i] isEqualToString:@"Path"] ) {
            NSUInteger length = self.cmdsize - sizeof(rpath_command_t);
            self.path = [cursor readStringOfLength:length encoding:NSASCIIStringEncoding];
            value = self.path;

            path_data = [cursor readDataOfLength:length];
            path_data = [NSString stringWithFormat:@"%@00", [path_data substringToIndex:self.path.length * 2]];
            flag = true;
        } else {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:flag ? path_data : [NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(rpath_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(rpath_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, offset: %d, path: %@",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.offset, self.path];
}

@end
