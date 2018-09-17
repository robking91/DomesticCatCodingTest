//
//  StateBasedViewModeling.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Foundation

protocol StateBasedViewModeling {
   associatedtype State
   var stateChangedHandler: ((State) -> Void)? { get set }
   var state: State { get }
}
