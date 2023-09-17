//
//  RoomQrOnboardingView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/09/12.
//

import SwiftUI

struct RoomQrOnboardingView: View {
    let dismiss: (() -> Void)
    @State private var selectedTab = 0

    init(dismiss: @escaping (() -> Void)) {
        self.dismiss = dismiss

        // PageTabViewStyle ページ番号を示す点々の色を指定
        let currenTintColor = UIColor.black
        UIPageControl.appearance().currentPageIndicatorTintColor = currenTintColor
        UIPageControl.appearance().pageIndicatorTintColor = currenTintColor.withAlphaComponent(0.2)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Description1View().tag(0)
            Description2View().tag(1)
            Description3View(dismiss: dismiss).tag(2)
        }
        .padding(10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(width: 482 * 0.65, height: 764 * 0.6)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(.gray, lineWidth: 2)
        )
        .background(.white)
        .cornerRadius(50)
        .interactiveDismissDisabled()
    }
}

struct Description1View: View {
    var body: some View {
        Image("room-qr-description-1")
            .resizable()
            .frame(width: 482 * 0.5, height: 764 * 0.5)
    }
}

struct Description2View: View {
    var body: some View {
        Image("room-qr-description-2")
            .resizable()
            .frame(width: 482 * 0.5, height: 764 * 0.5)
    }
}

struct Description3View: View {
    let dismiss: (() -> Void)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("room-qr-description-3")
                .resizable()
                .frame(width: 482 * 0.5, height: 764 * 0.5)

            Button(action: {
                self.dismiss()
            }) {
                Image(systemName: "multiply.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.top, 15)
        }
    }
}

struct RoomQrOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        RoomQrOnboardingView(dismiss: {
            print("dismiss")
        })
    }
}
