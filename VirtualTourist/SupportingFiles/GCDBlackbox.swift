//
//  File.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/19/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(_ updates: @escaping()-> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
