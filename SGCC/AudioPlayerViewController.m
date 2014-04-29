#import "AudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#define STREAM_URL @"http://sgucandcs.org/podcast_item/38/268/2014.1.12.mp3"
#define FILE_URL @"code_monkey.mp3"

@interface AudioPlayerViewController ()
@property(nonatomic,retain)AVPlayer *audioPlayer;
@property BOOL isPlaying;
@property(nonatomic)CMTime audioDuration;
@property(nonatomic)id timeObserver;
@property(weak,nonatomic)IBOutlet UIButton *playButton;
@property(weak,nonatomic)IBOutlet UILabel *elapsedLabel;
@property(weak,nonatomic)IBOutlet UILabel *remainingLabel;
@property(weak,nonatomic)IBOutlet UISlider *timeSlider;
@property(weak,nonatomic)IBOutlet UIButton *backwardButton;
@property(weak,nonatomic)IBOutlet UIButton *forwardButton;
@property(weak,nonatomic)IBOutlet UISlider *volumeSlider;
@end

@implementation AudioPlayerViewController
-(IBAction)timeChanged:(UISlider *)slider {
    [self changePlayerTime:CMTimeMake((int)roundf(slider.value),1)];
}
-(IBAction)movePlayerTimeBackward {
    CMTime newTime = CMTimeSubtract(self.audioPlayer.currentTime,
                                    CMTimeMake(15,1));
    [self changePlayerTime:newTime];
}
-(IBAction)movePlayerTimeForward {
    CMTime newTime = CMTimeAdd(self.audioPlayer.currentTime,CMTimeMake(15,1));
    [self changePlayerTime:newTime];
}
-(void)changePlayerTime:(CMTime)time {
    [self.audioPlayer seekToTime: time];
    [self updatePlayerUIWithTime:time];
}
-(CMTime)makeTimeScale1ForTime:(CMTime)time {
    return CMTimeMake(CMTimeGetSeconds(time),1);
}
-(void)updatePlayerUIWithTime:(CMTime)time {
    CMTime remainingTime = CMTimeSubtract(self.audioDuration,
                                          [self makeTimeScale1ForTime:time]);
    if (CMTimeGetSeconds(remainingTime) <= 0) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                   forState:UIControlStateNormal];
        self.forwardButton.enabled = self.isPlaying = self.playButton.enabled = NO;
        remainingTime = CMTimeMake(0,1);
    } else {
        self.forwardButton.enabled = self.playButton.enabled = YES;
    }
    self.remainingLabel.text = [self timeFormattedWith:remainingTime];
    self.elapsedLabel.text = [self timeFormattedWith:time];
    int elapsedSeconds = CMTimeGetSeconds(time);
    self.backwardButton.enabled = elapsedSeconds > 0;
    self.timeSlider.value = elapsedSeconds;
}
-(IBAction)volumeChanged:(UISlider *)slider {
    self.audioPlayer.volume = slider.value;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    NSURL *audioFileLocationURL = self.sermon.localUrlString ?
      [NSBundle.mainBundle URLForResource:self.sermon.localUrlString
                            withExtension:nil] :
      [NSURL URLWithString:self.sermon.remoteUrlString];
    self.title = self.sermon.title;
    self.audioPlayer = [AVPlayer playerWithURL:audioFileLocationURL];
    self.audioDuration = [self makeTimeScale1ForTime:self.audioPlayer.currentItem.asset.duration];
    self.audioPlayer.volume = self.volumeSlider.value;
    self.remainingLabel.text = [self timeFormattedWith:self.audioDuration];
    self.timeSlider.maximumValue = CMTimeGetSeconds(self.audioDuration);
    self.isPlaying = NO;
}
-(IBAction)play {
    if (!self.timeObserver) {
        __block AudioPlayerViewController *blockSafeSelf = self;
        self.timeObserver =
          [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1,1)
                                                         queue:NULL
                                                    usingBlock:
           ^(CMTime time) {
               [blockSafeSelf updatePlayerUIWithTime:time];
        }];
    }
    if (!self.isPlaying) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer play];
    } else {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pause];
    }
    self.isPlaying = !self.isPlaying;
}
-(NSString *)timeFormattedWith:(CMTime)time {
    NSUInteger totalSeconds = CMTimeGetSeconds(time);
    NSUInteger seconds = totalSeconds % 60;
    NSUInteger minutes = (totalSeconds / 60) % 60;
    NSUInteger hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)hours,
            (unsigned long)minutes,(unsigned long)seconds];
}
@end