//
//  MPLCLinkeditData.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/6.
//

#import "MPLCLinkeditData.h"

@implementation MPLCLinkeditData

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                        dataoff:(uint32_t)_dataoff
                       datasize:(uint32_t)_datasize {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.dataoff = _dataoff;
        self.datasize = _datasize;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Data Offset",
                             @"Data Size", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _dataoff],
                       [NSString stringWithFormat:@"%d", _datasize], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                         dataoff:(uint32_t)_dataoff
                        datasize:(uint32_t)_datasize {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                 dataoff:_dataoff
                                datasize:_datasize];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = [cursor readLittleInt32];
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(linkedit_data_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(linkedit_data_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, dataoff: %d, datasize: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.dataoff, self.datasize];
}

@end
