//
//  DreamBoardView.swift
//  mc2-DreamLog
//
//  Created by ChoiYujin on 2023/05/04.
//

import SwiftUI

struct DreamBoardView: View {
    @EnvironmentObject var data: TutorialBoardElement
    @State var isDone = false
    @State var text = ""
    @State private var showingAlert: Bool = false
    @State private var confirmAlert: Bool = false
    @StateObject var cheerModel = dataModel()
    @State private var boardImage: UIImage = Tab1Model.instance.image ?? UIImage(named: "BoardDummy")!
    
    @State private var showDDayCalendar = false
    
    @State private var dDayString = "calendar"
    
    let dbHelper = DBHelper.shared
    let imageFileManager = ImageFileManager.shared
    
    var photo: TransferableUIImage {
        return .init(uiimage: boardImage, caption: "드림보드를 공유해보세요🚀")
    }
    
    var body: some View {
        
        BgColorGeoView { geo in
            
            let width = geo.size.width
            let height = geo.size.height
            
            
            
            VStack {
                
                VStack(spacing: 0) {
                    
                    Image(uiImage: boardImage)
                    
                    Text(text == "" ? "스스로를 위한 응원을 작성해보세요" : text)
                        .grayText(fontSize: 22)
                        .fontWeight(.semibold)
                        .frame(width: abs(width), height: 40, alignment: .center)
                        .padding(.top, 10)
                        .background(.white)
                }
                
                
                HStack {
                    if let selectedDate = UserDefaults.standard.object(forKey: "selectedDate") as? Date {
                        
                        NavigationLink(destination: DDayCalendarView(showDDayCalendar: $showDDayCalendar)) {
                            Text(dDayString)
                                .fontWeight(.bold)
                        }
                        
                    } else {
                        NavigationLink(destination: DDayCalendarView(showDDayCalendar: $showDDayCalendar)) {
                            Image(systemName: dDayString)
                        }
                    }
                    Spacer()
                    ShareLink(item: photo, preview: SharePreview(
                        photo.caption,
                        image: photo.image)) {
                            Label("", systemImage: "square.and.arrow.up")
                        }
                    
                    NavigationLink(value: isDone, label:{
                        Button {
                            data.viewArr.removeAll()
                            data.viewArr = dbHelper.readData()
                            isDone = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    })
                    .navigationDestination(isPresented: $isDone, destination: {
                        DreamBoardEditView()
                    })
                }
                .font(.system(size: 24))
                .padding(.horizontal)
                .foregroundColor(.textGreen)
                
                Rectangle()
                    .frame(width: width, height: 1)
                    .shadow(color: Color.gray.opacity(0.6), radius: 1.5, x: 0, y: 2)
                    .foregroundColor(.bgColor)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("나에게 주는 응원 한마디")
                        
                        Spacer()
                        Button {
                            showingAlert = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.textGreen)
                        }
                        .alert("나에게 주는 응원 한마디를\n작성해주세요", isPresented: $showingAlert, actions: {
                            TextField("응원의 한 마디를 작성해보아요", text: $cheerModel.cheerText)
                            
                            Button("완료", action: {
                                confirmAlert = true
                            })
                            Button("취소", role: .cancel, action: {})
                        })
                        .alert(isPresented: $confirmAlert, content: {
                            Alert(title: Text("\(cheerModel.cheerText)으로\n응원을 추가하시겠어요?"),
                                  message: Text("작성하신 응원은 위젯에 표시됩니다."),
                                  primaryButton: .default(Text("확인"), action: {
                                text = cheerModel.cheerText
                                cheerModel.writtenDateText = getCurrentDate()
                                cheerModel.writeData() // 첫 번째 액션
                                print(getCurrentDate())
                                print($cheerModel.cheerText)
                                
                            }),
                                  secondaryButton: .cancel(Text("취소"), action: {
                                // 액션 없음
                            }))
                        })
                    }
                }
                .padding(.horizontal, 16)
                .frame(width: width - 30)
                .frame(height: 50)
                .background(.white)
                .cornerRadius(12)
                .padding(.bottom, 20)
                .shadow(color: Color.shadowGray, radius: 2, x: 0, y: 2)
            }
            .onAppear {
                print("\(dbHelper.readDreamLogDataOne().imagePath)")
                self.boardImage = imageFileManager.getSavedImage(named: dbHelper.readDreamLogDataOne().imagePath)!
            }
            .onAppear {
                getDDayDate()
            }
            
            
        }
    }
    
}


extension DreamBoardView {
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    private func getDDayDate() -> String {
        
        if let selectedDate = UserDefaults.standard.object(forKey: "selectedDate") as? Date {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: Date(), to: tomorrow)
            if let days = components.day {
                dDayString = days > 0 ? "D - \(days)" : (days == 0 ? "D - DAY !" : "D + \(abs(days)+1)")
            }
        }
        return dDayString
    }
    
}


struct MainTab1View_Previews: PreviewProvider {
    static var previews: some View {
        MultiPreview {
            DreamBoardView()
        }
    }
}

