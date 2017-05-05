#import "DateModel.h"


@implementation DateModel
+(NSMutableArray *)setModelClass:(NSString *)modelClass setModelSource:(NSArray *)arrData {
    
    Class className = NSClassFromString(modelClass);

    NSMutableArray *tempArr = [NSMutableArray array];
    for(NSDictionary *dict in arrData){
        id model = [[className alloc] initWithDict:dict];
        [tempArr addObject:model];
    }

    return tempArr;
}
@end
