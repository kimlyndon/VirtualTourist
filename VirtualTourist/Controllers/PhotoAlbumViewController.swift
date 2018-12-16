//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    
    var pin: Pin!
    var photos: [Photo] = [Photo]()
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    //Indices of photos for fetchedResultsController
    var photoIndicesToInsert = [IndexPath]()
    var photoIndicesToDelete = [IndexPath]()
    var photoIndicesToUpdate = [IndexPath]()
    var selectedPhotoIndices = [IndexPath]()
    //Determine if collection button is enabled
    var numberOfDownloadedImages: Int = 0
    //Total number of pages returned by Flickr call for pin
    var numberOfPagesForPin: Int = 0
    var currentPageNumber: Int = 1
    
    //MARK: Actions
    @IBAction func collectionButtonPressed(_ sender: UIBarButtonItem) {
        //Remove all photos
        if sender.title == Constants.BarButtonTitles.NewCollection {
            collectionButton.isEnabled = false
            for photo in fetchedResultsController.fetchedObjects! {
                dataController.viewContext.delete(photo)
            }
            
            dataController.save()
            //Update current page number of photo results from Flickr
            if currentPageNumber < numberOfPagesForPin {
                currentPageNumber += 1
                
            } else {
                
                currentPageNumber = numberOfPagesForPin
            }
            
            collectionView.isHidden = false
            
            //Get all new photos
            retrievePhotosFromFlickr(forPage: currentPageNumber)
            
        } else {
        //Remove only selected photos
            for photoIndex in selectedPhotoIndices {
                let photo = fetchedResultsController.object(at: photoIndex)
                dataController.viewContext.delete(photo)
            }
            
            dataController.save()
            //Reset selected indices
            selectedPhotoIndices.removeAll()
            collectionButton.title = Constants.BarButtonTitles.NewCollection
        }
        
        
    }
    
}
