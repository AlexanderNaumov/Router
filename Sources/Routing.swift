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
    func open(from: UIViewController, to: UIViewController)
    func close(vc: UIViewController)
}

extension Routing {
    func close(vc: UIViewController) {}
}
