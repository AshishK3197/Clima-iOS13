//
//  WeatherDataModel+CoreDataProperties.swift
//  Clima
//
//  Created by Ashish Kumar on 31/01/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDataModel> {
        return NSFetchRequest<WeatherDataModel>(entityName: "WeatherDataModel")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var temperature: Double
    @NSManaged public var conditionName: String?

}
