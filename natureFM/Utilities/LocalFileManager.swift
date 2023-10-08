import Foundation
import SwiftUI
import AVKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    // MARK: Images
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // Create Folder
        createFolderIfNeeded(folderName: folderName)
        // Get Path for Image
        guard
            let data = image.jpegData(compressionQuality: CGFloat(1.0)),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            
        else { return }
        // Save image to path
        do {

            try data.write(to: url)
        } catch let error {
            print("Error saving image: \(error)")
        }
        
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName)
    }
    
    // MARK: Sounds
    func getSoundURL(soundName: String, folderName: String) -> URL? {
        guard let url = getURLForAudio(audioName: soundName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return url
    }
    
    func getSound(url: URL, soundName: String, folderName: String) -> Data? {
       guard let url = getURLForAudio(audioName: soundName, folderName: folderName),
             FileManager.default.fileExists(atPath: url.path)
       else {
        return nil
       }
        let data = try? Data(contentsOf: url)
        return data
    }
    
    func saveSound(soundData: Data, soundName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getURLForAudio(audioName: soundName, folderName: folderName) else { return }
        
        do {
            try soundData.write(to: url)
            print("Saved Audio Successfully...?")
        } catch let error {
            print("Error saving Audio: \(error)")
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("""
                            Error creating directory: \(error)
                            Folder Name: \(folderName)
                    """)
            }
        }
    }
    
    private func getURLForAudio(audioName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(audioName)
    }
    
    
    // MARK: Helper Functions
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
            
        }
        return url.appendingPathComponent(folderName)
    }
}
