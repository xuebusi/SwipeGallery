//
//  ProfileViewModel.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI

let sampleData = (0...13).map({ Profile(image: "p\($0)") })

class ProfileViewModel: ObservableObject {
    
    @Published var profiles: [Profile] = sampleData
    
    func reloadData() {
        self.profiles = sampleData
    }
}
