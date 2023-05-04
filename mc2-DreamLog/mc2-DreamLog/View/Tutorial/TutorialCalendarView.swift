//
//  TutorialCalendarView.swift
//  mc2-DreamLog
//
//  Created by ChoiYujin on 2023/05/04.
//

import SwiftUI

struct TutorialCalendarView: View {
    
    @State private var date = Date()
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일"
        return formatter
    }()
    
    var body: some View {
        BgColorGeoView { geo in
            
            let width = geo.size.width
            let height = geo.size.height
            
            VStack {
                Spacer()
                Text("목표로 하는 날을 입력해주세요")
                    .padding(.bottom, 10)
                    .onAppear {
                        print("height: \(height)")
                    }
                    .brownText()
//                grayMediumText(text: "바탕화면에 드림로그를 추가해서\n목표와 오늘의 응원을 확인해보세요.")
                Text("바탕화면에 드림로그를 추가해서\n목표와 오늘의 응원을 확인해보세요.")
                    .grayText()

                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                Spacer()
                
                
                HStack {
                    NavigationLink {
                        MainView()
                    } label: {
                        Text("생략할래요")
                            .frame(width: abs(width - 40) / 2, height: 60)
                            .whiteWithBorderButton()

                    }
                    NavigationLink {
                        MainView()
                    } label: {
                        Text("시작하기")
                            .frame(width: abs(width - 40) / 2, height: 60)
                            .brownButton(isActive: true)
                    }
                }
            }
            .padding()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPreview {
            TutorialCalendarView()
        }
    }
}
