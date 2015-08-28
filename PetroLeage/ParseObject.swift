//
//  ParseObject.swift
//  PetroLeage
//
//  Created by Sharifah Nazreen Ashraff ali on 8/28/15.
//  Copyright (c) 2015 Syed Mohamed Ariff. All rights reserved.
//

import Foundation

struct ParseObject {
    var Car_model : String
    var Current_fuel : Int
    var estimated_fuel : Int
}

class FuelDetails : NSObject {
    var Car_model : String? = ""
    var Current_fuel : Int? = 0
    var estimated_fuel : Int? = 0
}