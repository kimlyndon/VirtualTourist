//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class FlickrClient: NSObject {
    
    // Shared Session
    var session = URLSession.shared

    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //Get all photo URLs for the location
    func getPhotoURLsForLocation(_ latitude: Double, _ longitude: Double,  _ pageNumber: Int = 1, completionHandlerPhotos: @escaping (_ result: [String]?, _ numberOfPages: Int?, _ error: NSError?)
        -> Void) {
        
    //Specify parameters
        let request = URLRequest(url: URL(string: "\(Constants.Flickr.BaseURL)?\(Constants.FlickrParameterKeys.Method)=\(Constants.FlickrParameterValues.Method)&\(Constants.FlickrParameterKeys.APIKey)=\(Constants.FlickrParameterValues.APIKey)&\(Constants.FlickrParameterKeys.Latitude)=\(String(latitude))&\(Constants.FlickrParameterKeys.Longitude)=\(String(longitude))&\(Constants.FlickrParameterKeys.Extras)=\(Constants.FlickrParameterValues.SquareURL)&\(Constants.FlickrParameterKeys.PerPage)=\(Constants.FlickrParameterValues.PhotoPerPage)&\(Constants.FlickrParameterKeys.Page)=\(String(pageNumber))&\(Constants.FlickrParameterKeys.Format)=\(Constants.FlickrParameterValues.Format)&\(Constants.FlickrParameterKeys.NoJSONCallback)=\(Constants.FlickrParameterValues.NoJSONCallback)")!)
        
    //Make the request
        let _ = performRequest(request: request) { (parsedResult, error) in
            
            func displayError(_error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerPhotos(nil, nil, NSError(domain: "getPhotoURLsForLocation", code: 1, userInfo: userInfo))
            }
            
    //Send the values to the completion handler
            if let error = error {
                displayError("\(error)")
            } else {
                
                //Did Flickr return an error?
                guard let stat = parsedResult![Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.Status else {
                    displayError("Flickr returned an error")
                    return
                }
                
        //Check for "photos" key
                guard let photosDictionary = parsedResult![Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                    displayError("'Photos' key not found")
                    return
                }
                
        //Check for "photo" key in dictionary
                guard let photo = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    displayError("'Photo' key not in dictionary")
                    return
                }
                
                var photoURLs = [String]()
                
                for photo in photos {
                    let photoDictionary = photo as [String:Any]
                    
        // Does the photo have a key for url_q?
                    guard let photoURL = photoDictionary[Constants.FlickrResponseKeys.SquareURL] as? String else {
                        displayError("'url_q' key not in result!")
                        return
                    }
                    
                    photoURLs.append(photoURL)
                }
                
                completionHandlerPhotos(photoURLs, pages, nil)
            }
        }
    }
    func convertURLToPhotoData(photURL: String, completionHandler: @escaping(_ photoData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        
        }
     }
}
