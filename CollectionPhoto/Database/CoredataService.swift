//
//  CoredataService.swift.swift
//  CollectionPhoto
//
//  Created by Art on 28.10.2021.
//

import Foundation
import CoreData
import UIKit

class CoredataService {
    
    //сохранение в CoreData
    func saveCoreData(image: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Images", in: context) else { return }
        
        let imageObject = Images(entity: entity, insertInto: context)
        imageObject.imageString = image
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //чтение из CoreData
    func getCoreData() -> [Images] {
        var image: [Images] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Images> = Images.fetchRequest()
        do {
            image = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return image
    }
    
    //удаление из CoreData
    func deleteCoreData(with images: [Images]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        DispatchQueue.global().async {
            images.forEach { image in
                context.delete(image)
                try? context.save()
            }
        }
    }
}
