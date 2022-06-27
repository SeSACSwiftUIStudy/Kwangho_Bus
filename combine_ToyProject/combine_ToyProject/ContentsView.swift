//
//  ContentsView.swift
//  combine_ToyProject
//
//  Created by 최광호 on 2022/06/21.
//

import SwiftUI

//MARK: 공통 뷰
struct ContentsView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    VStack {
                        Text("버스찾기")
                        Image(systemName: "magnifyingglass")
                    }
                }
            SecondView()
                .tabItem {
                    VStack {
                        Text("즐겨찾기")
                        Image(systemName: "star")
                    }
                }
        }
    }
}

//MARK: 첫번째 뷰
struct FirstView: View {
    @StateObject var viewModel = ViewModel()
    @State private(set) var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("찾을 버스 번호를 입력해주세요", text: $searchText)
                .padding()
                .onChange(of: self.searchText) { text in
                    self.viewModel.searchStringInput(text)
                }
            List {
                ForEach(viewModel.busDataArray, id: \.id) { data in
                    SearchViewContents(id: data.id, busNumber: data.name, status: data.isBookmarked, viewModel: .constant(viewModel))
                }
            }
        }
    }
}

//MARK: 첫번째 뷰_List ContentView
struct SearchViewContents: View {
    @State private(set) var id: String
    @State private(set) var busNumber: String
    @State var status: Bool
    
    @Binding var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(busNumber)
            Spacer()
            Button(action: { self.viewModel.shiftStatus(id) }) {
                let imageName = status ? "bookmark.fill" : "bookmark"
                Image(uiImage: UIImage(systemName: imageName)!)
            }
        }
        .padding()
        .border(.gray, width: 1)
    }
}

//MARK: 두번째 뷰
struct SecondView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.bookmarkArray, id: \.id) { data in
                SearchViewContents(id: data.id, busNumber: data.name, status: data.isBookmarked, viewModel: .constant(viewModel))
            }
        }
    }
}

struct ContentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsView()
    }
}
