//
//  TVGuideModuleBuilder.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import UIKit

struct TVGuideModuleBuilder {

    // MARK: TVGuideBuilder method

    static func buildModule() -> TVGuideViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TVGuideVC") as! TVGuideViewController
        let router = TVGuideRouter(viewController: viewController)
        let interactor = TVGuideInteractor()
        let presenter = TVGuidePresenter()

        viewController.presenter = presenter
        interactor.presenter = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        return viewController
    }
}
