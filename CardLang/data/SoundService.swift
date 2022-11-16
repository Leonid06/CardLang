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
        
        let destinationUrl = directory.appendingPathComponent(soundPath)
        
        let urlString = SoundService.HEAD_URL + "\(soundPath.first)/\(soundPath).mp3"
        
        let session = URLSession(configuration:  .default)
        
        if let url = URL(string: urlString){
            let task = session.downloadTask(with: url){ localPath, response, error in
                if let localPath = localPath {
                    do {
                        try self.fileManager.moveItem(at: localPath, to: destinationUrl)
                    }catch{
                        print(error)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func playSound(soundPath: String){
        do {
            if let url = Bundle.main.url(forResource: soundPath, withExtension: "mp3"){
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            }
        }catch {
            print(error)
        }
    }
}


extension SoundService {
    private static let HEAD_URL = "https://media.merriam-webster.com/audio/prons/en/us/mp3/"
}
