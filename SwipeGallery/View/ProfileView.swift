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
    @State var profile : Profile
    var frame : CGRect
    
    var body: some View{
        VStack {
            Image(profile.image)
                .resizable()
                .scaledToFit()
                .overlay {
                    ColorOverlayView(offsetY: profile.offsetY)
                }
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .overlay(alignment: .topTrailing) {
                    if profile.offsetY > 0 {
                        CircleOverlayView(title: "-1星", color: .red)
                            .offset(x: 30, y: -30)
                    }
                }
                .overlay(alignment: .bottom) {
                    if profile.offsetY < 0 {
                        CircleOverlayView(title: "+1星", color: .green)
                            .offset(y: 40)
                    }
                }
        }
        .frame(width: frame.width, height: frame.height)
        .offset(x: profile.offsetX, y: profile.offsetY)
        //.rotationEffect(.init(degrees: profile.offset == 0 ? 0 : (profile.offset > 0 ? -12 : 12)))
        .rotationEffect(.init(degrees: calcDegrees(offsetY: profile.offsetY)))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    handleGestureChanged(value: value)
                })
                .onEnded({ value in
                    handleGestureEnd(value: value)
                })
        )
    }
    
    func handleGestureChanged(value: DragGesture.Value) {
        withAnimation(.default){
            profile.offsetY = value.translation.height
            if value.translation.height > 200 {
                profile.offsetX = -value.translation.height * 0.5
            } else {
                profile.offsetX = 0
            }
        }
    }
    
    func handleGestureEnd(value: DragGesture.Value) {
        withAnimation(.easeIn(duration: 0.3)){
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

struct ColorOverlayView: View {
    var offsetY: CGFloat
    
    var body: some View {
        (offsetY < 0 ? Color.green : Color.red)
            .opacity(0.8)
            .opacity(offsetY != 0 ? 0.7 : 0)
    }
}

struct CircleOverlayView: View {
    let title: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 90)
            .shadow(radius: 3)
            .overlay {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
    }
}

#Preview {
    ContentView()
}
