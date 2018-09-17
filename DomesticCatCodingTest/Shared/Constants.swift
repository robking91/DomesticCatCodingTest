//
//  Constants.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
   struct RestaurantList {
      static let restaurantCellHeight: CGFloat = 200
      static let zomatoKey: String = "a38959c6fd1d4b9e78fe10b0793fc342"
      static let abbotsfordRestaurantsURL: String = "https://developers.zomato.com/api/v2.1/search?entity_id=98284&entity_type=subzone&q=abbotsford&count=10&radius=0.0&sort=rating"
      static let restaurantCount: Int = 10
   }
}
