//
//  MPLCUuid.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCUuid.h"

@implementation MPLCUuid

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                           uuid:(uint8_t[16])_uuid {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.UUID = [[NSUUID alloc] initWithUUIDBytes:_uuid];
        self.uuid = [self.UUID UUIDString];
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"UUID", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       self.uuid, nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                            uuid:(uint8_t[16])_uuid {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                    uuid:_uuid];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    NSString *uuid_data;
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        
        if ( [self.descriptions[i] isEqualToString:@"UUID"] ) {
            
            uuid_data = [cursor readBigInt128];
            flag = true;
        } else {
            data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:flag ? uuid_data : [NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(uuid_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(uuid_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, uuid: %@",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self->_uuid];
}

@end
