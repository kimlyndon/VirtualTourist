//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 11/20/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "VirtualTourist")
    var coordinate = [CLLocationDegrees]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()
        
        //Inject dependency 'dataController' into TravelLocationsMapViewController
        let navigationController = window?.rootViewController as! UINavigationController
        let travelLocationsMapController = navigationController.topViewController as! TravelLocationsMapViewController
        travelLocationsMapController.dataController = dataController
        
        //Set default coordinate values
        coordinate.append(37.1328 as CLLocationDegrees)
        coordinate.append(-95.7855 as CLLocationDegrees)
        
        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(coordinate, forKey: "centerCoordinate")
    }

}

