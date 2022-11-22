//
//  SoundService.swift
//  CardLang
//
//  Created by Leonid on 15.11.2022.
//

import Foundation
import AVFoundation



class SoundService {
    
    static let shared = SoundService()
    
    
    private let fileManager = FileManager.default
    
    private var audioPlayer = AVAudioPlayer()
    
    
    func saveSound(soundPath: String){
        
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let upperBound = soundPath.index(soundPath.startIndex, offsetBy: 0)
        
        var sourceUrl : URL? = nil
        
        if(soundPath.count > 0){
            sourceUrl = URL(string: "\(SoundService.HEAD_URL)\(soundPath[...upperBound])/\(soundPath).mp3")
        }
        
        if let url = sourceUrl {
            do {
                let data = try Data(contentsOf: url)
                
                let soundLocalUrl = directory.appendingPathComponent(url.lastPathComponent)
                
                print("sound local url:" + soundLocalUrl.absoluteString)
                try data.write(to: soundLocalUrl)
            }catch {
                print(error)
            }
        }
    }
    
    func playSound(soundPath: String){
        do {
            
            
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            
            let upperBound = soundPath.index(soundPath.startIndex, offsetBy: 0)
            
            
            let sourceUrl = URL(string: "\(SoundService.HEAD_URL)\(soundPath[...upperBound])/\(soundPath).mp3")
            
            print(sourceUrl)
            
            if let sourceUrl = sourceUrl {
                let soundLocalUrl = URL(string: directory.absoluteString + sourceUrl.lastPathComponent)
                
                if let soundLocalUrl = soundLocalUrl {
                    print("sound local url:" + soundLocalUrl.absoluteString)
                    audioPlayer = try AVAudioPlayer(contentsOf: soundLocalUrl)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                }
                
            }
            
        }catch {
            print(error)
        }
    }
}


extension SoundService {
    private static let HEAD_URL = "https://media.merriam-webster.com/audio/prons/en/us/mp3/"
}
