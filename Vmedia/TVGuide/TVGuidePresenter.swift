//
//  TVGuidePresenter.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import Foundation

final class TVGuidePresenter: TVGuideModuleInput {

    // MARK: Properties

    weak var view: TVGuideViewInput?
    var router: TVGuideRouterInput?
    var interactor: TVGuideInteractorInput?
    
    private var dataModel: TVGuideDataModel

    // MARK: Initialization

    init() {
        dataModel = TVGuideDataModel()
    }

    // MARK: TVGuideModuleInput methods
    private func getChannelAndProgramList() {
        guard let _interactor = self.interactor else {
            return
        }
        self.view?.showHideActivityIndicator(show: true)
        _interactor.callChannelAndProgramList()
    }
}

// MARK: - TVGuideViewOutput methods

extension TVGuidePresenter: TVGuideViewOutput {

    func viewLoaded() {
        self.getChannelAndProgramList()
    }
}

// MARK: - TVGuideInteractorOutput methods

extension TVGuidePresenter: TVGuideInteractorOutput {
    // If Response is Successfull
    func channelAndProgramListResponse(channelList: [Channel], programItems: [ProgramItem]) {
        self.dataModel.setData(channelList: channelList, programItems: programItems)
        let vm = TVGuideViewModel(timeArray: self.dataModel.timeArray, channelList: self.dataModel.channelList, programData: self.dataModel.programData, dateStr: self.dataModel.dateString, errorMessage: "")
        self.view?.showHideActivityIndicator(show: false)
        self.view?.configureViewModel(vm: vm)
    }
    // If Response has Error
    func errorResponse(message: String) {
        let vm = TVGuideViewModel(timeArray: [], channelList: [], programData: [], dateStr: "", errorMessage: message)
        self.view?.showHideActivityIndicator(show: false)
        self.view?.configureViewModel(vm: vm)
    }
    
}
