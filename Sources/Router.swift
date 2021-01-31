//
//  Router.swift
//
//
//  Created by Alexander Naumov.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import ReStore

struct OpenRouting: Action {
    let type: Routing.Type
}

struct CloseRouting: Action {
    let type: Routing.Type
}

public struct Router {
    
    private static weak var store: Store?
    private static let viewControllers = NSHashTable<UIViewController>(options: .weakMemory)
    private let vc: UIViewController
    
    fileprivate init(_ vc: UIViewController) { self.vc = vc }
    
    public static func setStore(_ store: Store) {
        self.store = store
    }
    
    public func open(_ routing: Routing) {
        Router.store?.dispatch(OpenRouting(type: type(of: routing)))
        let newVc = routing.controller()
        newVc.__routingContainer = RoutingContainer(parent: vc, routing: routing)
        Router.viewControllers.add(newVc)
        routing.open(from: vc, to: newVc)
    }
    
    public func close(_ routingType: Routing.Type) {
        for vc in Router.viewControllers.allObjects where type(of: vc.__routingContainer.routing) == routingType && (self.vc == vc || self.vc == vc.__routingContainer.parent) {
            Router.store?.dispatch(CloseRouting(type: routingType))
            vc.__routingContainer.routing.close(vc: vc)
            return
        }
    }
}

private class RoutingContainer {
    weak var parent: UIViewController!
    let routing: Routing
    init(parent: UIViewController!, routing: Routing) { self.parent = parent; self.routing = routing }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var routingContainer: UInt8 = 0
    }
    fileprivate var __routingContainer: RoutingContainer {
        get { objc_getAssociatedObject(self, &AssociatedKeys.routingContainer) as! RoutingContainer }
        set { objc_setAssociatedObject(self, &AssociatedKeys.routingContainer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    public var router: Router { return Router(self) }
}
