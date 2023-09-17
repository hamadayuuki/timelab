//
//  CalendarDescriptionView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/09/17.
//

import SwiftUI

struct CalendarDescriptionView: View {
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
            DescriptionCalendarView().tag(0)
            DescriptionColorView(dismiss: dismiss).tag(1)
        }
        .padding(10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(width: 590 * 0.55, height: 772 * 0.55)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(.gray, lineWidth: 2)
        )
        .background(.white)
        .cornerRadius(50)
        .interactiveDismissDisabled()
    }
}

struct DescriptionCalendarView: View {
    var body: some View {
        Image("description-calendar")
            .resizable()
            .frame(width: 590 * 0.5, height: 772 * 0.5)
    }
}

struct DescriptionColorView: View {
    let dismiss: (() -> Void)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("description-color")
                .resizable()
                .frame(width: 590 * 0.5, height: 772 * 0.5)

            Button(action: {
                self.dismiss()
            }) {
                Image(systemName: "multiply.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.top, 15)
            .padding(.trailing, 15)
        }
    }
}

struct CalendarDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDescriptionView(dismiss: {
            print("dismiss")
        })
    }
}
