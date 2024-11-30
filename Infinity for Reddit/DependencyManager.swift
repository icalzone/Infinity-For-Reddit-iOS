//
//  DependencyManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-29.
//
import Swinject

class DependencyManager {
    static let shared: Container = {
        func registerDependencies(_ c: Container) {
            // TODO register dependencies on container
        }
        
        let container = Container()
        registerDependencies(container)
        
        return container
    }()
}
