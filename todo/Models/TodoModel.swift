//
//  TodoModel.swift
//  todo
//
//  Created by umut yalçın on 16.03.2023.
//

import Foundation


struct Todo {
    var id  = UUID()
    var name = String()
    var desc = String()
    var date = String()
    var isCompleted = false
}
