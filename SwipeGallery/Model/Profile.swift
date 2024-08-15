//
//  Profile.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI

struct Profile : Identifiable {
    var id = UUID().uuidString
    var image : String
    var offsetY : CGFloat = 0
    var offsetX : CGFloat = 0
}
