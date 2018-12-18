//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/16/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import CoreData


extension Pin {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: NSSet?
    
}

