//
//  ViewController.swift
//  AudioMixer
//
//  Created by Gurdeep Singh on 28/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var waveformView: FDWaveformView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let thisBundle = NSBundle(forClass: self.dynamicType)
        let url = thisBundle.URLForResource("Submarine", withExtension: "aiff")
        
        // We wish to animate the waveform view in when it is rendered
        
        self.waveformView.delegate = self
        self.waveformView.alpha = 0.0
        
        self.waveformView.audioURL = url
        self.waveformView.progressSamples = 10000
        self.waveformView.doesAllowScrubbing = true
        self.waveformView.doesAllowStretch = true
        self.waveformView.doesAllowScroll = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doTheMagic() {
    
        //Here where load our movie Assets using AVURLAsset
        
        let existingAudioAsset = AVURLAsset(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gizmo", ofType: "mp4")!))

        let newAudioAsset = AVURLAsset(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gizmo", ofType: "mp4")!))

        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        let mixComposition = AVMutableComposition()

        let existingAudioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        try! existingAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, existingAudioAsset.duration), ofTrack: existingAudioAsset.tracksWithMediaType(AVMediaTypeAudio).first!, atTime: kCMTimeZero)
        
        let newAudioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        try! newAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, newAudioAsset.duration), ofTrack: newAudioAsset.tracksWithMediaType(AVMediaTypeAudio).first!, atTime: kCMTimeZero)

        let mix = AVMutableAudioMix()
        
        var inputParameters = [AVMutableAudioMixInputParameters]()

        let params1 = AVMutableAudioMixInputParameters(track: existingAudioTrack)
        params1.setVolume(0.2, atTime: kCMTimeZero)
        inputParameters.append(params1)

        let params2 = AVMutableAudioMixInputParameters(track: newAudioTrack)
        params2.setVolume(0.2, atTime: kCMTimeZero)
        inputParameters.append(params2)
        
        mix.inputParameters = inputParameters
        
        // Video
        let videoAsset = AVURLAsset(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gizmo", ofType: "mp4")!))
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        try! videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo).first!, atTime: kCMTimeZero)

        let MainInstruction = AVMutableVideoCompositionInstruction()
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        let FirstlayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)

        MainInstruction.layerInstructions = [FirstlayerInstruction]
        
        let MainCompositionInst = AVMutableVideoComposition()
        
        MainCompositionInst.instructions = [MainInstruction]
        MainCompositionInst.frameDuration = CMTimeMake(1, 30)
        MainCompositionInst.renderSize = CGSizeMake(640, 480)

        let finalItem = AVPlayerItem(asset: mixComposition)
        finalItem.videoComposition = MainCompositionInst
        finalItem.audioMix = mix;
        
    }

}


extension ViewController : FDWaveformViewDelegate {

    
    func waveformViewWillRender(waveformView: FDWaveformView!) {
        
        print("\(NSDate()) waveformViewDidLoad")
    }

    func waveformViewDidRender(waveformView: FDWaveformView!) {
        
        print("\(NSDate()) waveformViewDidRender")

        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.waveformView.alpha = 1.0
        }
        
    }
    
    func waveformViewWillLoad(waveformView: FDWaveformView!) {
        
        
    }
    
    
    func waveformViewDidLoad(waveformView: FDWaveformView!) {
        
        
    }
    
    
}
