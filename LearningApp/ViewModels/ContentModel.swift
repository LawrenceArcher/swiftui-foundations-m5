//
//  ContentModel.swift
//  LearningApp
//
//  Created by Lawrence Archer on 28/09/2021.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var modules = [Module]()
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    func getLocalData() {
        // get url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            //reda the fiel into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // try to decode the json into an array of objects
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // assign parsed modules to module property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        
        // Parse the stayle data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            //Read file into a data object
            let styleData = try  Data(contentsOf: styleUrl!)
            self.styleData = styleData
        }
        catch {
            //Log error
            print("Couldn't parse style data")
        }
        
    }
}
