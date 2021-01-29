//
//  Routing.swift
//  ReStoreRouter
//
//  Created by Alexander Naumov on 06/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit

public protocol Routing {
    func controller() -> UIViewController
    static func open(from: UIViewController, to: UIViewController)
    static func close(vc: UIViewController)
}

extension Routing {
    static func controller() -> UIViewController {
        fatalError("not implemented")
    }
    static func close(vc: UIViewController) {}
}
