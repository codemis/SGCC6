#import "Sermon.h"

@interface SermonsDataSource : NSObject

-(void)fetchSermons;
-(Sermon *)sermonAtIndexPath:(NSIndexPath *) indexPath;

@end
