//
//  PlaceMarker.swift
//  PetroLeage
//
//  Created by Sharifah Nazreen Ashraff ali on 8/27/15.
//  Copyright (c) 2015 Syed Mohamed Ariff. All rights reserved.
//

import UIKit
import GoogleMaps
class PlaceMarker: GMSMarker {
    
    let place: GooglePlace
    
    // 2
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
   
}
