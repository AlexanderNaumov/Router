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
    let type: RoutingType.Type
}

struct CloseRouting: Action {
    let type: RoutingType.Type
}

public struct Router {
    
    private static weak var store: Store?
    private static let viewControllers = NSHashTable<UIViewController>(options: .weakMemory)
    private let vc: UIViewController
    
    fileprivate init(_ vc: UIViewController) { self.vc = vc }
    
    public static func setStore(_ store: Store) {
        self.store = store
    }
    
    public func open(_ routing: RoutingType, payload: Any? = nil) {
        let routingType = type(of: routing)
        Router.store?.dispatch(OpenRouting(type: routingType))
        let newVc = routing.controller(payload)
        newVc.__routing = (vc, routingType)
        Router.viewControllers.add(newVc)
        routing.open(from: vc, to: newVc)
    }
    
    public func close(_ routing: RoutingType) {
        let routingType = type(of: routing)
        Router.store?.dispatch(CloseRouting(type: routingType))
        for vc in Router.viewControllers.allObjects where vc.__routing.1 == routingType && (self.vc == vc || self.vc == vc.__routing.0) {
            routing.close(vc: vc)
            return
        }
    }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var routingContainer: UInt8 = 0
    }
    private class RoutingContainer {
        weak var parent: UIViewController!
        let type: RoutingType.Type
        init(parent: UIViewController!, type: RoutingType.Type) { self.parent = parent; self.type = type }
    }
    fileprivate var __routing: (UIViewController?, RoutingType.Type) {
        get {
            let obj = objc_getAssociatedObject(self, &AssociatedKeys.routingContainer) as! RoutingContainer
            return (obj.parent, obj.type)
        }
        set {
            let container = RoutingContainer(parent: newValue.0, type: newValue.1)
            objc_setAssociatedObject(self, &AssociatedKeys.routingContainer, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var router: Router { return Router(self) }
}
