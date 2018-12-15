//
//  CancelCellTask.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import UIKit

class CancelCellTask: UICollectionViewCell {
    
    var taskToCancelIfCellIsReused: URLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}
