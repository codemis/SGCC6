#import "Sermon.h"
@interface SermonsStore : NSObject
@property(readonly,nonatomic)NSUInteger count;

+(SermonsStore *)sharedStore;
-(void)updateSermonsFromWeb;

@end
