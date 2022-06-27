//
//  ViewModel.swift
//  combine_ToyProject
//
//  Created by 최광호 on 2022/06/21.
//

import Foundation
import Combine

struct Model: Codable {
    var id: String
    var name: String
    var isBookmarked: Bool
}

class ViewModel: ObservableObject {
    var originBusData = [Model]()
    var disposables = Set<AnyCancellable>()
    
    @Published var busDataArray = [Model]()
    @Published var bookmarkArray = [Model]()
    
    //MARK: transform
    func searchStringInput(_ input: String) {
        // 이거 맞나..? 얘가 내보내면 character로 나와서 이렇게 하긴 했는데
        input.publisher
            .collect()
            .reduce("") { $0 + $1 }
            .sink { [weak self] text in
                guard let self = self else { return }
                if text == "" {
                    self.busDataArray = self.originBusData
                } else {
                    self.busDataArray = self.originBusData.filter { $0.name.contains(text) }
                }
            }
            .store(in: &disposables)
    }
    
    //MARK: Status 변경
    func shiftStatus(_ id: String) {
        if let index = self.originBusData.firstIndex(where: { $0.id == id }) {
            self.originBusData[index].isBookmarked = !self.originBusData[index].isBookmarked
            print(self.originBusData[index])
        }
        
        let bookmarkData = self.originBusData.filter { $0.isBookmarked == true }
        self.bookmarkArray = bookmarkData
        self.dataToJson(bookmarkData)
    }
    
    //MARK: Model -> JSON Encorder
    func dataToJson(_ data: [Model]) {
        let encoder = JSONEncoder()
        if let encode = try? encoder.encode(data) {
            UserDefaults.standard.set(encode, forKey: "bookmark")
        }
    }
    
    //MARK: JSON -> Model Decorder
    func jsonToData(_ data: Data, completion: @escaping ([Model]) -> Void) {
        if let jsonData = try? JSONDecoder().decode([Model].self, from: data) {
            completion(jsonData)
        }
    }
    
    //MARK: JSON file Loader
    func jsonFileLoader() {
        let fileName = "BusList"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            let data = try Data(contentsOf: fileLocation)
            /*
             아 그냥 Model.self 로 적어서 헤맸네ㅎㅎ..
            guard let stringToData = String(data: data, encoding: .utf8) else { return }
            print("=== data: ===",stringToData)
             */
            self.jsonToData(data) { newModel in
                self.busDataArray = newModel
                self.originBusData = newModel
            }
        } catch {
            return
        }
    }
    
    init() {
        print("초기화됨")
        jsonFileLoader()
        
        guard let savedUserDefaults = UserDefaults.standard.object(forKey: "bookmark") as? Data else { return }
        
        self.jsonToData(savedUserDefaults) { [weak self] newModel in
            guard let self = self else { return }
            self.bookmarkArray = newModel
            
            print(self.bookmarkArray, "===== : bookmarkArray")
            
            self.bookmarkArray.forEach { model in
                if let index = self.originBusData.firstIndex(where: { $0.id == model.id }) {
                    self.originBusData[index].isBookmarked = model.isBookmarked
                }
            }
        }

    }
}
