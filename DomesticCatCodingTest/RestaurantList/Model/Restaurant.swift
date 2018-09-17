//
//  Restaurant.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Foundation
import RealmSwift

class Restaurant: Object {
   @objc dynamic var restaurantName: String = ""
   @objc dynamic var restaurantAddress: String = ""
   @objc dynamic var restaurantImageURL: String = ""
   @objc dynamic var creationDate: TimeInterval = 0
   @objc dynamic var isFavorite: Bool = false
   
   convenience init(name: String, address: String, imageURL: String, creationDate: TimeInterval, favorite: Bool) {
      self.init()
      self.restaurantName = name
      self.restaurantAddress = address
      self.restaurantImageURL = imageURL
      self.creationDate = creationDate
      self.isFavorite = favorite
   }
   
   override class func primaryKey() -> String {
      return "restaurantName"
   }
   
   static func fromDict(restaurantDict: [String:Any]) -> Restaurant? {
      guard let restaurantName = restaurantDict[RestaurantKeys.restaurantName] as? String,
         let restaurantLocation = restaurantDict[RestaurantKeys.location] as? [String:Any],
         let address = restaurantLocation[RestaurantKeys.address] as? String,
         let imageURL = restaurantDict[RestaurantKeys.mainImage] as? String else {
            return nil
      }
      let creationDate = Date().timeIntervalSince1970
      return Restaurant(name: restaurantName, address: address, imageURL: imageURL, creationDate: creationDate, favorite: false)
   }
}

struct RestaurantKeys {
   static let restaurants = "restaurants"
   static let restaurant = "restaurant"
   static let restaurantName = "name"
   static let location = "location"
   static let address = "address"
   static let mainImage = "featured_image"
}
