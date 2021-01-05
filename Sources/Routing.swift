//
//  Routing.swift
//  ReStoreRouter
//
//  Created by Alexander Naumov on 06/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit

public protocol RoutingType {
    func controller(_ payload: Any?) -> UIViewController
    func open(from: UIViewController, to: UIViewController)
    func close(vc: UIViewController)
}

public protocol Routing: RoutingType {
    associatedtype T
    func controller(payload: T) -> UIViewController
    func controller() -> UIViewController
    func open(from: UIViewController, to: UIViewController)
    func close(vc: UIViewController)
}

extension Routing {
    func controller(_ payload: Any?) -> UIViewController {
        if let payload = payload as? T {
            return controller(payload: payload)
        } else {
            return controller()
        }
    }
    
    func controller(payload: Void) -> UIViewController {
        fatalError("not implemented")
    }
    
    func controller() -> UIViewController {
        fatalError("not implemented")
    }
    
    func close(vc: UIViewController) {}
}
