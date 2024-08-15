//
//  ProfileView.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI

struct ProfileView : View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    @ObservedObject var vm: ProfileViewModel
    @State private var animationAmount: CGFloat = 1
    @State var profile : Profile
    var frame : CGRect
    var body: some View{
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            Image(profile.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: frame.width,height: frame.height)
            
            (profile.offsetY < 0 ? Color.green : Color.red)
                .opacity(profile.offsetY != 0 ? 0.7 : 0)
        })
        .cornerRadius(20)
        .overlay(alignment: .topTrailing) {
            if profile.offsetY > 0 {
                // Button Red
                Circle()
                    .fill(.red)
                    .frame(width: 90)
                    .shadow(radius: 3)
                    .overlay {
                        Text("-1星")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .offset(x: 30, y: -30)
            }
        }
        .overlay(alignment: .bottom) {
            if profile.offsetY < 0 {
                // Button Green
                Circle()
                    .fill(.green)
                    .frame(width: 90)
                    .shadow(radius: 3)
                    .overlay {
                        Text("+1星")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .offset(y: 40)
            }
        }
        .offset(x: profile.offsetX, y: profile.offsetY)
        //.rotationEffect(.init(degrees: profile.offset == 0 ? 0 : (profile.offset > 0 ? -12 : 12)))
        .rotationEffect(.init(degrees: calcDegrees(offsetY: profile.offsetY)))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation(.default){
                        profile.offsetY = value.translation.height
                        if value.translation.height > 200 {
                            profile.offsetX = -value.translation.height * 0.5
                        }
                    }
                })
                .onEnded({ value in
                    withAnimation(.easeIn(duration: 0.3)){
                        // Profile Offset Conditions
                        if profile.offsetY > 200 {
                            profile.offsetY = screenHeight
                            profile.offsetX = -screenWidth
                        } else if profile.offsetY < -200 {
                            profile.offsetY = -screenHeight
                        } else{
                            profile.offsetY = 0
                            profile.offsetX = 0
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if profile.offsetY > 200 || profile.offsetY < -200 {
                            if let index = vm.profiles.firstIndex(where: { $0.id == profile.id }) {
                                vm.profiles.remove(at: index)
                            }
                        }
                    }
                })
        )
    }
    
    func calcDegrees(offsetY: CGFloat) -> Double {
        if offsetY >= 200 {
            return -15
        }
        
        if offsetY < -200 {
            return 15
        }
        
        return 0
    }
}

#Preview {
    ContentView()
}
