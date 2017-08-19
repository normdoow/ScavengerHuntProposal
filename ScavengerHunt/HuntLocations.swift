//
//  HuntLocations.swift
//  ScavengerHunt
//
//  Created by Noah Bragg on 8/15/16.
//  Copyright © 2016 NoahBragg. All rights reserved.
//

import Foundation
import CoreLocation

class HuntLocations {
    //TODO make real ones
    var latitudes = [39.741890, 39.6854723, 39.6896308, 39.6772919, 39.6328411]
    var longitudes = [-83.807492, -83.9308854, -83.9588848, -83.9751417, -84.1565808]
    var coordinates = [CLLocationCoordinate2D]()
    //clues
    //1. get ice cream
    //2. get a dress
    //3. get nails done
    //4. get flowers
    //5. get me
    var clues = [
                    "Drive to the shop in town that just changed it's name. Go up to the counter and tell them that your name is Melissa Ruhlman.",
                    "You met Drew's dad at this mexican restaurant in the middle of downtown Xenia. Go to the store right to the right of the restaurant. Go up to the desk and tell them your name is Melissa Ruhlman. They may do something to your hands...",
                    "Go to the place where you get a lot of groceries. Tell the people that have alive things that smell good that your name is Melissa Ruhlman",
                    "Go to the place where you first told me that you love me. There may be something there for you...",
                    "Go to this address 61 Lakeview Dr. Centerville. Keep the flowers with you. Park on the side of the road next to a house. You will see an opening to a trail. Walk to it and follow the path."
                ]
    
    init() {
        for (var k = 0; k < latitudes.count; k++) {
            let coord = CLLocationCoordinate2D.init(latitude: latitudes[k], longitude: longitudes[k])
            coordinates.append(coord)
        }
    }
    
    func getCoordinates() -> [CLLocationCoordinate2D] {
        return coordinates
    }
    
    func getClues() -> [String] {
        return clues
    }
    
}