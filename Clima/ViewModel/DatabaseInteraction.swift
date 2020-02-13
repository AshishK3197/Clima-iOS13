//
//  DatabaseInteraction.swift
//  Clima
//
//  Created by Ashish Kumar on 31/01/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseInteraction{
    
    static let sharedInstance = DatabaseInteraction()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(object: WeatherModel){
        let data = NSEntityDescription.insertNewObject(forEntityName: "WeatherDataModel", into: context) as? WeatherDataModel
        data?.cityName = object.cityName
        data?.conditionName = object.conditionName
        data?.temperature = object.temperature
     
        do {
            try context.save()
        } catch  {
            print("Data could Not be Saved")
        }
    }
    
    func fetchData()-> [WeatherDataModel]{
        var data = [WeatherDataModel]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherDataModel")
        fetchRequest.returnsObjectsAsFaults = false
        for item in data{
            print(item)
        }
        do {
            data = try context.fetch(fetchRequest) as! [WeatherDataModel]
            print("Data fetched Successfull")
            for item in data{
                print(item)
            }
        } catch  {
            print("Could Not Fetch Data")
        }
        return data
    }
    
    
}
