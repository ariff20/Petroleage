//
//  MapView.swift
//  PetroLeage
//
//  Created by Sharifah Nazreen Ashraff ali on 8/27/15.
//  Copyright (c) 2015 Syed Mohamed Ariff. All rights reserved.
//

import  UIKit
import GoogleMaps
class MapView : UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var mapview: GMSMapView!
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    let dataProvider = GoogleDataProvider()
    
    var randomLineColor: UIColor {
        get {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }
    var mapRadius: Double {
        get {
            let region = mapview.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapview.clear()
        // 2
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                // 3
                let marker = PlaceMarker(place: place)
                // 4
                marker.map = self.mapview
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedcontrol.hidden = false
        mapview.delegate = self
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
    }
    
    @IBAction func segmentedpressed(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapview.mapType = kGMSTypeNormal
        case 1:
            mapview.mapType = kGMSTypeSatellite
        case 2:
            mapview.mapType = kGMSTypeHybrid
        default:
            mapview.mapType = mapview.mapType
        }
    }
    let locationmanager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationmanager.startUpdatingLocation()
            
            //4
            mapview.myLocationEnabled = true
            mapview.settings.myLocationButton = true
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // 6
            mapview.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            
            locationmanager.stopUpdatingLocation()
        }
    }
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        //self.addressLabel.unlock()
        let geocoder = GMSGeocoder()
        
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines as! [String]
                self.addressLabel.text = join("\n", lines)
                
                // 4
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapview.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        
        UIView.animateWithDuration(0.25) {
            //2
            self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
            self.view.layoutIfNeeded()
    }
    func mapView(mapview: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
        }
       
    }
  
    
    @IBAction func refreshData(sender: AnyObject) {
        fetchNearbyPlaces(mapview.camera.target)
    }
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        // 1
        let placeMarker = marker as! PlaceMarker
        
        // 2
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            // 3
            infoView.nameLabel.text = placeMarker.place.name
            
            // 4
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    func mapView(mapview: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    func mapView(mapview: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        // 1
        let googleMarker = mapview.selectedMarker as! PlaceMarker
        
        // 2
        dataProvider.fetchDirectionsFrom(mapview.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
            if let encodedRoute = optionalRoute {
                // 3
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                // 4
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapview
                
                // 5
                mapview.selectedMarker = nil
            }
        }
    }
}
