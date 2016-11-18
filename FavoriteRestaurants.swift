//
//  FavoriteRestaurants.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/21/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteRestaurants: Object {
    dynamic var restaurantId = ""
    dynamic var restaurantName = ""
    dynamic var restaurantAddress=""
    dynamic var restaurantImageUrl=""
    dynamic var restaurantRatingUrl=""
    dynamic var restaurantReviewCount=""
    dynamic var restaurantPhone=""
    dynamic var restaurantCoordinates=""
    dynamic var restaurantDistance=""
    dynamic var restaurantCategories=""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
