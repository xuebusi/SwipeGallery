//
//  HomeView.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            SwipeView()
        }
    }
}

#Preview {
    ContentView()
}
