//
//  DownloadManager.swift
//  natureFM
//
//  Created by Adam Reed on 11/22/21.
//

import Foundation
import SwiftUI
import AVKit


struct ImageFromFileManager: View {
    
    @ObservedObject var imageLoader: ImageLoaderFromFileManager

    init(url: String) {
        imageLoader = ImageLoaderFromFileManager(ImageUrl: url)
    }

    var body: some View {
        Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
              .resizable()
              .aspectRatio(contentMode: .fill)
              .clipped()
        
    }
}

class ImageLoaderFromFileManager: ObservableObject {
    
    // Published variable to update the UIImage from the data
    @Published var imageData = Data()
    
    
    // When initialized, check to see if the image exists inside of the filemanager
    init(ImageUrl: String) {
        print("Inside imageloaderfromfilemanager init")

        // Create the url to the documents directory
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        // Add the path component name to the end of the documents directory url
        let destinationUrl = docsUrl?.appendingPathComponent("\(ImageUrl).jpg")
        
        // If creating the URL was successfull....
        if let destinationUrl = destinationUrl {
            print("The destination is: \(destinationUrl)")
            // If the url exists inside of the FileManager
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                // Create an UIImage from the url path
                let image = UIImage(contentsOfFile: destinationUrl.path)
                
                // Unwrap the optional data from converting to JPEG Data
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    // update the imageData observed variable with the data created from the FileManager
                    imageData = data
                }
                
            } else {
                print("Error getting image from FileManager")
            }
        } else {
            print("Error getting image from FileManager")
        }
    }
}


// MARK: Download manager for saving to and from local file manager
class DownloadManagerFromFileManager: ObservableObject {
    
    @Published var isDownloadingImage = false
    @Published var isDownloadingAudio = false

    
    func getImageFileAsset(urlName: String) -> UIImage? {
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsURL?.appendingPathComponent("\(urlName).jpg")
        
        if let destinationURL = destinationURL {
            if (FileManager().fileExists(atPath: destinationURL.path)) {
                // If file exists, create image object
                let image = UIImage(contentsOfFile: destinationURL.path)
                // return image object
                return image
            } else {
                print("returned nothing 1")
                return nil
            }

        } else {
            return nil
        }
    
    }
    
    func downloadImageFile(urlString: String, urlName: String) {
        isDownloadingImage = true
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsURL?.appendingPathComponent("\(urlName).jpg")
        
        if let destinationURL = destinationURL {
            if FileManager().fileExists(atPath: destinationURL.path) {
                print("This image file already exists")
                isDownloadingImage = false
                return
            } else {

                let urlRequest = URLRequest(url: URL(string: urlString)!)
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        self.isDownloadingImage = false
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
    
                        guard let data = data else {
                            self.isDownloadingImage = false
     
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                    
                                try data.write(to: destinationURL, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloadingImage = false
                                }
                            } catch let error {
                                self.isDownloadingImage = false
                            }
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    func deleteImageFile(urlName: String) {
           let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

           let destinationUrl = docsUrl?.appendingPathComponent("\(urlName).jpg")
           if let destinationUrl = destinationUrl {
               guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
               do {
                   try FileManager().removeItem(atPath: destinationUrl.path)
                   print("File deleted successfully")
                   isDownloadingImage = false
               } catch let error {
                   print("Error while deleting video file: ", error)
               }
           }
       }
    
    func deleteAudioFile(urlName: String) {
           let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

           let destinationUrl = docsUrl?.appendingPathComponent("\(urlName).aif")
           if let destinationUrl = destinationUrl {
               guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
               do {
                   try FileManager().removeItem(atPath: destinationUrl.path)
                   print("File deleted successfully")
                   isDownloadingAudio = false
               } catch let error {
                   print("Error while deleting video file: ", error)
               }
           }
       }

    
    func getImageFileAssetReturningString(urlName: String) -> String {
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsURL?.appendingPathComponent("\(urlName).jpg")
        
        if let destinationURL = destinationURL {
            if (FileManager().fileExists(atPath: destinationURL.path)) {
                // If file exists, create image object
                let imageString = destinationURL.path
                // return image object
                return imageString
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func getAudioFileAsset(urlName: String) -> AVPlayerItem? {
        
        print("URL Name is \(urlName)")
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsURL?.appendingPathComponent("\(urlName).aif")
        
        print("The destination URL is: \(destinationURL)")
        
        if let destinationURL = destinationURL {
            if (FileManager().fileExists(atPath: destinationURL.path)) {
                // If file exists, create avaudioplayer item
                let avItem = AVPlayerItem(url: destinationURL)
                return avItem
            } else {
                print("returned nothing 1")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func downloadAudioFile(urlString: String, urlName: String) {
        isDownloadingAudio = true
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsURL?.appendingPathComponent("\(urlName).aif")
        
        print("DestinationURL: \(destinationURL)")
        
        if let destinationURL = destinationURL {
            if FileManager().fileExists(atPath: destinationURL.path) {
                print("This Audio File Already Exists")
                isDownloadingAudio = false
                return
            } else {
                
                let urlRequest = URLRequest(url: URL(string: urlString)!)

                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        print("error: \(error)")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
                        print("status code 200")
                      
                        guard let data = data else {
                            self.isDownloadingAudio = false
                            return
                        }
                        
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationURL, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloadingAudio = false
                                }
                            } catch let error {
                                print("error: \(error)")
                                self.isDownloadingAudio = false
                            }
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    
}
