//
//  Constants.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

struct Constants {
    
    struct Flickr {
        static let BaseURL = "https://api.flickr.com/services/rest/"
    }
    
    //MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let PhotoPerPage = "per_page"
        static let Page = "page"
        static let Radius = "radius"
        static let SafeSearch = "safe_search"
    }
    
    //MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "eaedf0ede48ccdf6f821944917e9d053"
        static let Format = "json"
        static let NoJSONCallback = "1"
        static let Method = "flickr.photos.search"
        static let Extras = "url_m"
        static let Radius = "5"
        static let SafeSearch = "1"
        static let PhotoPerPage = "21"
    }
    
    //MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let SquareURL = "url_q"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    //MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    //MARK: UIBarButtonItem Titles
    struct BarButtonTitles {
        static let NewCollection = "New Collection"
        static let RemoveSelectedPhotos = "Remove selected photos"
    }
}
