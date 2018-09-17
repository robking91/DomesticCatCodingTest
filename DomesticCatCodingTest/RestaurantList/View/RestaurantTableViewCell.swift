//
//  RestaurantTableViewCell.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class RestaurantTableViewCell: UITableViewCell {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var addressLabel: UILabel!
   @IBOutlet weak var restaurantImage: UIImageView!
   @IBOutlet weak var gradientView: UIView!
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
//   func configureGradientView() {
//      let gradientLayer = CAGradientLayer()
//      gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
//      gradientLayer.locations = [0.0,1.0]
//      gradientLayer.frame = gradientView.frame
//      gradientView.layer.insertSublayer(gradientLayer, at: 0)
//   }
//
//   func configureCell(_ restaurant: Restaurant) {
//      configureGradientView()
//      titleLabel.text = restaurant.restaurantName
//      addressLabel.text = restaurant.restaurantAddress
//      Alamofire.request(restaurant.restaurantImageURL).responseImage { response in
//         if let image = response.result.value {
//            self.restaurantImage.image = image
//         }
//      }
//   }
   
}
