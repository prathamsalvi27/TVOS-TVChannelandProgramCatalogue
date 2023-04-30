//
//  TVGuideRouter.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import UIKit

final class TVGuideRouter: TVGuideRouterInput {

    // MARK: Properties

    private weak var viewController: TVGuideViewController?

    // MARK: Init

    init(viewController: TVGuideViewController) {
        self.viewController = viewController
    }

    // MARK: TVGuideRouterInput methods
}
