//
//  MPRow.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/1.
//

#import "MPRow.h"

@implementation MPRow

- (instancetype)initWithDataOffset:(NSString *)_offset
                              data:(NSString *)_data
                       description:(NSString *)_description
                             value:(NSString *)_value {
    
    if (self = [super init]) {
        self.offset = _offset;
        self.data = _data;
        self.descriptions = _description;
        self.value = _value;
    }
    
    return self;
}

+ (instancetype)_initWithDataOffset:(NSString *)_offset
                               data:(NSString *)_data
                        description:(NSString *)_description
                              value:(NSString *)_value {
    
    return [[self alloc] initWithDataOffset:_offset
                                       data:_data
                                description:_description
                                      value:_value];
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> offset: 0x%@, data: %@, description: %@, value: %@",
            NSStringFromClass([self class]), self,
            self.offset, self.data, self.descriptions, self.value];
}

@end
