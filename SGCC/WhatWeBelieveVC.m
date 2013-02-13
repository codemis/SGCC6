#define kFileName @"WhatWeBelieve"
#define kFileType @"attrstr"

#import "WhatWeBelieveVC.h"

@interface WhatWeBelieveVC ()
@property(weak,nonatomic)IBOutlet UITextView *textView;
@property(readonly)NSAttributedString *whatWeBelieve;
@end

@implementation WhatWeBelieveVC
-(NSAttributedString *)messageForError:(NSString *)error with:(NSString *)parm {
    NSString *message =
      [NSString stringWithFormat:@"Failed %@ %@",error,parm];
    return [[NSAttributedString alloc] initWithString:message];
}
-(NSAttributedString *)whatWeBelieve {
    NSAttributedString *attributedString;
    NSString *path = [[NSBundle mainBundle] pathForResource:kFileName
                                                     ofType:kFileType];
    if (path) {
        attributedString = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!attributedString)
            attributedString = [self messageForError:@"unarchiving" with:path];
    } else attributedString = [self messageForError:@"opening"
                                               with:kFileName @"." kFileType];
    return attributedString;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.textView.attributedText = self.whatWeBelieve;
}
@end
