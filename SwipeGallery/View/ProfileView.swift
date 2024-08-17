//
//  ProfileView.swift
//  SwipeGallery
//
//  Created by shiyanjun on 2024/8/15.
//

import SwiftUI

// 拖动方向
enum Direction: String {
    case left = "向左"
    case right = "向右"
    case none = "无"
    
    var degrees: Double {
        switch(self) {
        case .left:
            return -15
        case .right:
            return 15
        case .none:
            return 0
        }
    }
    
    // 星星对齐位置
    var starAlign: Alignment {
        switch(self) {
        case .left:
            return .topTrailing
        case .right:
            return .topLeading
        case .none:
            return .center
        }
    }
    
    // 星星X轴偏移
    var starOffsetXValue: CGFloat {
        switch(self) {
        case .left:
            return 30
        case .right:
            return -30
        case .none:
            return 0
        }
    }
}


struct ProfileView : View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 拖动阈值
    private let threshold: CGFloat = 200
    
    @ObservedObject var vm: ProfileViewModel
    @State var profile : Profile
    @State var direction: Direction = .none
    var frame : CGRect
    
    var body: some View{
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(min(1, max(0, 1 - abs(Double(profile.offsetY) / 800))))
            
            VStack {
                Image(profile.image)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        ColorOverlayView(offsetY: profile.offsetY)
                    }
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .overlay(alignment: self.direction.starAlign) {
                        if profile.offsetY > 0 {
                            CircleOverlayView(title: "-1星", color: .red)
                                .offset(x: self.direction.starOffsetXValue, y: -30)
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
            .shadow(radius: 10)
            .offset(x: profile.offsetX, y: profile.offsetY)
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
        .overlay {
            Text(self.direction.rawValue)
                .foregroundColor(.white)
                .padding()
                .frame(width: 70)
                .background(.black)
        }
    }
    
    func handleGestureChanged(value: DragGesture.Value) {
        withAnimation(.default){
            // 计算方向
            self.direction = calcDirection(offsetX: value.translation.width)
            
            profile.offsetY = value.translation.height
            if value.translation.height > threshold {
                if self.direction == .left {
                    profile.offsetX = -value.translation.height * 0.5
                }
                if self.direction == .right {
                    profile.offsetX = value.translation.height * 0.5
                }
            } else {
                profile.offsetX = 0
            }
        }
    }
    
    func handleGestureEnd(value: DragGesture.Value) {
        withAnimation(.easeIn(duration: 0.3)){
            if profile.offsetY > threshold {
                // 向下拖动超过阈值
                profile.offsetY = screenHeight
                if self.direction == .left {
                    profile.offsetX = -screenWidth
                }
                if self.direction == .right {
                    profile.offsetX = screenWidth
                }
            } else if profile.offsetY < -threshold {
                // 向上拖动超过阈值
                profile.offsetY = -screenHeight
            } else{
                profile.offsetY = 0
                profile.offsetX = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if profile.offsetY > threshold || profile.offsetY < -threshold {
                if let index = vm.profiles.firstIndex(where: { $0.id == profile.id }) {
                    vm.profiles.remove(at: index)
                }
            }
            // 当前图片移除后再重置方向
            self.direction = .none
        }
    }
    
    func calcDirection(offsetX: CGFloat) -> Direction {
        return offsetX >= 0 ? .right : .left
    }
    
    func calcDegrees(offsetY: CGFloat) -> Double {
        /**
         // 向下拖动超过阈值
         if offsetY >= threshold {
             return -15
         }
         
         // 向上拖动超过阈值
         if offsetY <= -threshold {
             return 15
         }
         
         return 0
         */
        
        return offsetY >= threshold || offsetY <= -threshold ? self.direction.degrees : 0
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
