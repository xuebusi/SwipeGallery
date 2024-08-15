//
//  SwipeView.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI

struct SwipeView: View {
    @StateObject var vm = ProfileViewModel()
    
    var body: some View {
        VStack{
            GeometryReader { g in
                ZStack{
                    if vm.profiles.isEmpty {
                        VStack {
                            Button {
                                vm.reloadData()
                            } label: {
                                Text("重置图集")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(width: g.size.width, height: g.size.height)
                        .background(.purple.opacity(0.5))
                    } else {
                        ForEach(vm.profiles.reversed()){ profile in
                            ProfileView(vm: vm, profile: profile, frame: g.frame(in: .global))
                        }
                    }
                }
            }
        }
        .background(
            Color.black
                .opacity(0.06)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    ContentView()
}
