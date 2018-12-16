//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/16/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var pin: Pin?
    
}
