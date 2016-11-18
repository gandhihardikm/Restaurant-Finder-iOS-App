//
//  FavRestaurantList.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/21/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//

import Foundation
import RealmSwift

class FavRestaurantList: Object {
    
    
    let favrestaurants=List<FavoriteRestaurants>()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
