//
//  MPLCDylinker.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/5.
//

#import "MPLCDylinker.h"

@implementation MPLCDylinker

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                         offset:(uint32_t)_offset {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.offset = _offset;
        self.name = @"???";
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Str Offset",
                             @"Name", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _offset],
                       self.name, nil];
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
    
    NSString *name_data;
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        
        if ( [self.descriptions[i] isEqualToString:@"Name"] ) {
            NSUInteger length = self.cmdsize - sizeof(dylinker_command_t);
            self.name = [cursor readStringOfLength:length encoding:NSASCIIStringEncoding];
            value = self.name;

            name_data = [cursor readDataOfLength:length];
            name_data = [name_data substringToIndex:(self.name.length + 1) * 2];
            flag = true;
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
//    cursor->_offset += self.cmdsize - sizeof(dylinker_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(dylinker_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, offset: %d, name: %@",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.offset, self.name];
}

@end
