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
     }
}
