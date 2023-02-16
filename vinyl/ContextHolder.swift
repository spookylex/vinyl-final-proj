//
//  ContextHolder.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/13/22.

// CoreData implementation for saving drafted reviews

// Title: Todo List using Core Data SwiftUI Xcode Example Tutorial | Part 1
// URL: https://www.youtube.com/watch?v=OgYluh5sYBA

// Title: Building TodoList App in SwiftUI Using Core Data
// URL: https://youtu.be/CZ79PpB7HIo

import SwiftUI
import CoreData

class ContextHolder: ObservableObject {
    
    init (_ context: NSManagedObjectContext ){
        
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
       do {
           try context.save()
       }catch {
           let nsError = error as NSError
           fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
       }
   }
    
}
