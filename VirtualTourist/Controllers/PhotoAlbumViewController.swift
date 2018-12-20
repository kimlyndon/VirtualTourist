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

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var dataController: DataController!
    
    //indexes to track
    var insertedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    
    var thread = Thread.current
    //the location passed from Travel Location Map VC, and whose photos will be displayed
    var pin: Pin!
    
    //the ID passed from the selected pin in prev VC
    var objectID: NSManagedObjectID!
    
    var location: NSManagedObject!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var currentPinLatitude: Double!
    var currentPinLongitude: Double!
    var currentCoordinate: CLLocationCoordinate2D!
    
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var barButton: UIBarButtonItem!
        @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var downloadedPhotos = [Data]()
    var photoInfo: [FlickrClient.Photo]?
    var urlsToDownload = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension2)
        
    
        mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        configMap()
        setupFetchedResultsController()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view WIll Appear")
        print("current pin info: \(String(describing: pin))")
        setupFetchedResultsController()
        downloadPhotosOrFetchPhotos()
        reloadView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
        clearAll()
    }
    
   
    func clearAll() {
        print("Clearing all local arrays")
        photoInfo = []
        downloadedPhotos = []
        urlsToDownload = []
        FlickrClient.sharedInstance().clearFlickrResults()
    }
    
    fileprivate func downloadPhotos(_ completionForDownload: @escaping (_ success: Bool) -> Void) {
        print("downloadPhotos")
        
        clearAll()
        FlickrClient.sharedInstance().downloadPhotosForLocation1(lat: pin.latitude, lon: pin.longitude) { (success, urls) in
            
            guard let urls = urls else {
                print("no url's returned in completion handler")
                return
            }
            
            if (success == false) {
                print("JSON DL did not complete")
                return
            }
      
            
            self.urlsToDownload.append(contentsOf: urls)
            
            DispatchQueue.main.async {
                //print("thread during url core data save: \(self.thread)")
                for url in urls {
                    let photo = Photo(context: self.dataController.viewContext)
                    photo.name = url.absoluteString
                    photo.pin = self.pin
                    try? self.dataController.viewContext.save()
                }

           
                print("urlsToDownload count: \(self.urlsToDownload.count)\nurls: \(self.urlsToDownload)")
                completionForDownload(true)
            }
            
            
        }
        
    }
    
    func downloadPhotosOrFetchPhotos() {
        print("downloadPhotosOrFetchPhotos")
        if let photoCount = pin.photos?.count {
            if photoCount <= 0 {
                downloadPhotos({ (success) in
                    if success == true {
                        print("success completion")
                    }
                })
            } else {
                
            }
        } else {
            print("there are no photos to load.")
        }
    }
    
    private func reloadView() {
        print("collectionView reloadData")
        collectionView.reloadData()
    }
    
    private func resetDownloadedPhotos() {
        downloadedPhotos = []
    }
    
    fileprivate func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func fetchPhotos() {
        print("fetchPhotos")
        resetDownloadedPhotos()
        performFetch()
        
       
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            print("fetched Objects count: \(fetchedObjects.count)")
            for photo in fetchedObjects {
                if let imageURLstring = photo.name, let imageURL = URL(string: imageURLstring) {
                    urlsToDownload.append(imageURL)
                } else {
                    print("no image data present in fetched Object.")
                }
            }
        } else {
            print("nothing was fetched")
        }
    }
    
    
    @IBAction func newCollectionButtonPressed(_ sender: UIBarButtonItem) {
        
        //fetch request is already established
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            print("confirming fetched count: \(fetchedObjects.count)")
            for photo in fetchedObjects {
                print("photo info: \(String(describing: photo.image?.description))")
                dataController.viewContext.delete(photo)
            }
          
        } else {
            print("no fetched photos present to delete for NewCollection")
        }
        
        //clear any photos from Flickr search, or local arrays
        clearAll()
        print("Flickr photo results count: \(FlickrClient.sharedInstance().photoResults.count)")
        
        //download new set of photos
        downloadPhotos { (success) in
            if success == true {
                print("success completion for new collection")
            }
        }
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate: NSPredicate?
        
        predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "location", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func configMap() {
        let lat = currentCoordinate.latitude
        let long = currentCoordinate.longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: mapSpan)
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin2"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = UIColor.red
            pinView?.animatesDrop = false
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - PHOTO DOWNLOAD FUNCTIONS
    
    
    // MARK: - PERSIST PHOTOS
    
    func savePhotos() {
        if self.dataController.viewContext.hasChanges {
            print("there were changes.  Attempting to save.")
            do {
                try self.dataController.viewContext.save()
            } catch {
                print("an error occurred while saving: \(error.localizedDescription)")
            }
        } else {
            print("no changes were made.  Not saving.")
        }
        
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        return CGSize(width: dimension, height: dimension2)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("***Collection View: Number of items in section***")
        return fetchedResultsController.sections?[section].numberOfObjects ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 3 {
            print("***Collection View: Cell For Row at Index Path***")
        }
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        
    
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = cell.bounds
        cell.backgroundColor = UIColor.darkGray
        cell.imageView.alpha = 0.5
        cell.addSubview(activityIndicator)
        cell.imageView.image = #imageLiteral(resourceName: "VirtualTourist_1024")
        activityIndicator.startAnimating()
        
        let aPhoto = fetchedResultsController.object(at: indexPath)
        
        if aPhoto.image != nil {
            
            cell.imageView.image = UIImage(data: aPhoto.image!)
            cell.imageView.alpha = 1.0
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            return cell
        
        } else {
            
            
            DispatchQueue.global(qos: .background).async {
                if let urlString = aPhoto.name, let imageURL = URL(string: urlString), let image = self.downloadSinglePhoto1(photoURL: imageURL) {
                    
                    // do not save to coreData here!!!
                    //print("image data present.")
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: image)
                        cell.imageView.alpha = 1.0
                        activityIndicator.stopAnimating()
                        
                        if aPhoto.image == nil {
                            print("still nil")
                            aPhoto.image = image
                            do {
                                try self.dataController.viewContext.save()
                            } catch {
                                print("error saving in cellforItem: \(error.localizedDescription)")
                            }
                        }
                      
                      
                    }
                    
                }
            }
        }
        
        return cell
        
    }
    
    
    func downloadSinglePhoto1(photoURL: URL) -> Data? {
       
        return FlickrClient.sharedInstance().makeImageDataFrom1(flickrURL: photoURL)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoToDelete = fetchedResultsController.object(at: indexPath)
        print("did select: \(photoToDelete.image!)")
        
        dataController.viewContext.delete(photoToDelete)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //clear arrays
        insertedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("insert object")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .update:
            print("update object")
            updatedIndexPaths.append(indexPath!)
            break
        case .delete:
            print("delete object")
            deletedIndexPaths.append(indexPath!)
            break
        default:
            print("DEFAULT - no other action needed")
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                print("indexPathinfo: \(indexPath)")
                self.collectionView.reloadItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                print("indexPathinfo: \(indexPath)")
                self.collectionView.deleteItems(at: [indexPath])
            }
        }, completion: nil)
    }
}
