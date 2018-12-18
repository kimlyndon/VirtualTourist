//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/16/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var pin: Pin?
    
}

// MARK: Generated accessors for photos
extension Pin {
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
