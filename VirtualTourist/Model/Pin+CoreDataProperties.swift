//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import CoreData


extension Pin {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: NSSet?
    
}

// MARK: Accessors for photos
extension Pin {
    
    @objc(addPinObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(addPinObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPinObject:)
    @NSManaged public func addToPhotos(_ value: NSSet)
    
    @objc(addPinObject:)
    @NSManaged public func removeFromPhotos(_ value: NSSet)
    
    
}
