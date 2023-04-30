//
//  TVGuideProtocols.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import UIKit

// MARK: - View

// MARK: ViewInput (Presenter to ViewController communication)

protocol TVGuideViewInput: AnyObject {
    func configureViewModel(vm: TVGuideViewModel)
    func showHideActivityIndicator(show: Bool)
}

// MARK: ViewOutput (ViewController to Presenter communication)

protocol TVGuideViewOutput: AnyObject {
    func viewLoaded()
}

// MARK: - Presenter

protocol TVGuideModuleInput: AnyObject {
    // MARK: Variables
    var view: TVGuideViewInput? { get set }
    var interactor: TVGuideInteractorInput? { get set }
    var router: TVGuideRouterInput? { get set }
}

// MARK: - Interactor

// MARK: InteractorInput (Presenter to Interactor communication)

protocol TVGuideInteractorInput: AnyObject {
    func callChannelAndProgramList()
}

// MARK: InteractorOutput (Interactor to Presenter communication)

protocol TVGuideInteractorOutput: AnyObject {
    func channelAndProgramListResponse(channelList: [Channel], programItems: [ProgramItem])
    func errorResponse(message: String)
}

// MARK: - Router

protocol TVGuideRouterInput: AnyObject {
}

// MARK: - DataModel

struct TVGuideDataModel {
    private(set) var channelList: [Channel] = []
    private(set) var programItems: [ProgramItem] = []
    // Date is Fixed For Now, We can take this date from API Response once it gets configure
    let dateString: String = "TODAY, \n JULY 9"
    
    mutating func setData(channelList: [Channel], programItems: [ProgramItem]) {
        self.channelList = channelList
        self.programItems = programItems
    }
    
    // Makes Data for Each Channels
    var programData: [TVProgramData] {
        var sectionArr: [TVProgramData] = []
        for channel in channelList {
            // Filters Program for Each Channel
            let programList = programItems.filter { item in
                let date = item.dateAndTime
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: date!)
                let dayOfMonth = components.day
                return item.recentAirTime.channelID == channel.id && (dayOfMonth ?? 1) == 9
            }
            var programArr = [ProgramItemVm]()
            let secsOfDay = 86400
            var startOfDay = 0
            // Make List of Programs for whole day of Selected channnel
            for item in programList {
                if item.startTimeInSecs != startOfDay {
                    let timeDurationinSecs = (item.startTimeInSecs ?? 0) - startOfDay
                    let vm = ProgramItemVm(programItem: nil, name: "", lengthInSec: timeDurationinSecs)
                    startOfDay += timeDurationinSecs
                    programArr.append(vm)
                }
                
                let vm = ProgramItemVm(programItem: item, name: item.name, lengthInSec: item.lengthInSecs)
                startOfDay += item.lengthInSecs
                programArr.append(vm)
                
            }
            
            while startOfDay < secsOfDay {
                let remainingtime = secsOfDay - startOfDay
                let vm = ProgramItemVm(programItem: nil, name: "", lengthInSec: remainingtime)
                startOfDay += remainingtime
                programArr.append(vm)
            }
            
            let section = TVProgramData(channel: channel, programItems: programArr)
            sectionArr.append(section)
        }
        
        return sectionArr
    }
    // Fixed Time Array of Whole day which is displayed on Top Header of Screen
    var timeArray: [String] {
      return [
        "00:00 AM",
        "00:30 AM",
        "01:00 AM",
        "01:30 AM",
        "02:00 AM",
        "02:30 AM",
        "03:00 AM",
        "03:30 AM",
        "04:00 AM",
        "04:30 AM",
        "05:00 AM",
        "05:30 AM",
        "06:00 AM",
        "06:30 AM",
        "07:00 AM",
        "07:30 AM",
        "08:00 AM",
        "08:30 AM",
        "09:00 AM",
        "09:30 AM",
        "10:00 AM",
        "10:30 AM",
        "11:00 AM",
        "11:30 AM",
        "12:00 PM",
        "12:30 PM",
        "01:00 PM",
        "01:30 PM",
        "02:00 PM",
        "02:30 PM",
        "03:00 PM",
        "03:30 PM",
        "04:00 PM",
        "04:30 PM",
        "05:00 PM",
        "05:30 PM",
        "06:00 PM",
        "06:30 PM",
        "07:00 PM",
        "07:30 PM",
        "08:00 PM",
        "08:30 PM",
        "09:00 PM",
        "09:30 PM",
        "10:00 PM",
        "10:30 PM",
        "11:00 PM",
        "11:30 PM",
        ]
    }
}

struct TVProgramData {
    let channel: Channel
    let programItems: [ProgramItemVm]
}

// MARK: - ViewModel

struct TVGuideViewModel {
    let timeArray: [String]
    let channelList: [Channel]
    let programData: [TVProgramData]
    let dateStr: String
    let errorMessage: String 
}
