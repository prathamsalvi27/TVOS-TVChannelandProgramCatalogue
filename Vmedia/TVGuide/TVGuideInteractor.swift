//
//  TVGuideInteractor.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import Foundation

final class TVGuideInteractor: TVGuideInteractorInput {

    // MARK: Properties

    weak var presenter: TVGuideInteractorOutput?
    
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private var responseModel: TVResponseModels = TVResponseModels()

    // MARK: Initialization

    init() {
       
    }
    
    private func callChannelApi() {
        let request = NetworkRequest(url: APIEndpoints.channelURLString, headers: ["":""], httpRequest: .get)
        self.dispatchGroup.enter()
        NetworkService.shared.startRequest(request: request) { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let modelArr = try decoder.decode([Channel].self, from: data)
                    self.responseModel.channelList = modelArr
                    self.dispatchGroup.leave()
                } catch {
                    self.responseModel.errorMessage = "Unable To Load Data!"
                    self.dispatchGroup.leave()
                }
            } else {
                self.responseModel.errorMessage = "Unable To Load Data!"
                self.dispatchGroup.leave()
            }
        }
        
    }
    
    private func callProgramsApi() {
        let request = NetworkRequest(url: APIEndpoints.programItemsURLString, headers: ["":""], httpRequest: .get)
        self.dispatchGroup.enter()
        NetworkService.shared.startRequest(request: request) { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let modelArr = try decoder.decode([ProgramItem].self, from: data)
                    self.responseModel.programList = modelArr
                    self.dispatchGroup.leave()
                } catch {
                    self.responseModel.errorMessage = "Unable To Load Data"
                    self.dispatchGroup.leave()
                }
            } else {
                self.responseModel.errorMessage = "Unable To Load Data"
                self.dispatchGroup.leave()
            }
        }
    }
    
    // MARK: TVGuideInteractorInput methods
    func callChannelAndProgramList() {
        self.callChannelApi()
        self.callProgramsApi()
        
        dispatchGroup.notify(queue: .main) {
            if !self.responseModel.channelList.isEmpty && !self.responseModel.programList.isEmpty {
                self.presenter?.channelAndProgramListResponse(channelList: self.responseModel.channelList, programItems: self.responseModel.programList)
            } else {
                self.presenter?.errorResponse(message: self.responseModel.errorMessage)
            }
       
        }
    }
}
