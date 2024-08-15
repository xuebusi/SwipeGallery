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
                                Text("重置")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(vm.profiles.reversed()){ profile in
                            ProfileView(vm: vm, profile: profile, frame: g.frame(in: .global))
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
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
