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
    
    
    func saveSound(soundPath: String){
        
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let sourceUrlString = SoundService.HEAD_URL + "\(soundPath.first)/\(soundPath).mp3"
        
        let sourceURL = URL(string: sourceUrlString)
        
        
        let session = URLSession(configuration:  .default)
        
        if let url = sourceURL {
            do {
                let data = try Data(contentsOf: url)
                
                let soundLocalUrl = directory.appendingPathComponent(url.lastPathComponent)
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
                    let audioPlayer = try AVAudioPlayer(contentsOf: soundLocalUrl)
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
