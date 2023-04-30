//
//  TVGuideViewController.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//  
//

import UIKit

final class TVGuideViewController: UIViewController, TVGuideViewInput {
   
    // MARK: Properties

    var presenter: TVGuideViewOutput?
    
    private var viewModel: TVGuideViewModel?

    // MARK: Views
    @IBOutlet weak var tableViewChannel: UITableView!
    @IBOutlet weak var collectionViewTime: UICollectionView!
    @IBOutlet weak var collectionViewProgram: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelError: UILabel!
    
    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnViewDidLoad()
        self.presenter?.viewLoaded()
    }

    // MARK: Setup Methods

    private func setupOnViewDidLoad() {
        setUpTableView()
        setUpCollectionView()
        hideAndUnHideViews(hide: true)
        self.labelError.isHidden = true
    }
    
    private func setUpTableView() {
        self.tableViewChannel.delegate = self
        self.tableViewChannel.dataSource = self
        self.tableViewChannel.registerCellWithIdentifier(ChannelTableViewCell.identifier)
        self.tableViewChannel.estimatedRowHeight = 100
        self.tableViewChannel.rowHeight = 100
    }
    
    private func setUpCollectionView() {
        self.collectionViewTime.delegate = self
        self.collectionViewTime.dataSource = self
        self.collectionViewTime.backgroundColor = .clear
        self.collectionViewTime.registerCellWithIdentifier(TimeCollectionViewCell.identifier)
        
        self.collectionViewProgram.delegate = self
        self.collectionViewProgram.dataSource = self
        self.collectionViewProgram.backgroundColor = .clear
        self.collectionViewProgram.registerCellWithIdentifier(ProgramItemCollectionViewCell.identifier)
        
    }
    
    // MARK: Private Methods
    private func hideAndUnHideViews(hide: Bool) {
        self.tableViewChannel.isHidden = hide
        self.collectionViewTime.isHidden = hide
        self.collectionViewProgram.isHidden = hide
        self.viewDate.isHidden = hide
        self.labelDate.isHidden = hide
    }
    
    private func setDate(date: String) {
        self.labelDate.text = date
    }
    
    private func showErrorMessage(message: String) {
        self.labelError.isHidden = false
        self.labelError.text = message
    }

    // MARK: TVGuideViewInput
    func configureViewModel(vm: TVGuideViewModel) {
        self.viewModel = vm
        if vm.errorMessage.isEmpty {
            self.hideAndUnHideViews(hide: false)
            self.tableViewChannel.reloadData()
            self.collectionViewTime.reloadData()
            self.setDate(date: vm.dateStr)
            setSizeOfProgramCollectionView(programData: vm.programData)
        } else {
            self.hideAndUnHideViews(hide: true)
            self.showErrorMessage(message: vm.errorMessage)
        }
    }
    
    func setSizeOfProgramCollectionView(programData: [TVProgramData]) {
        let layout = collectionViewProgram.collectionViewLayout as? ProgramItemCollectionViewLayout
        layout?.programData = programData
        self.collectionViewProgram.reloadData()
    }
    
    func showHideActivityIndicator(show: Bool) {
        if show {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
}

// MARK: - Table View Methods
extension TVGuideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _viewModel = self.viewModel else {
            return 0
        }
        return _viewModel.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _viewModel = self.viewModel else {
            fatalError("\(String(describing: viewModel)) not configured")
        }
        let channelList = _viewModel.channelList
        let cell: ChannelTableViewCell = self.tableViewChannel.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier) as! ChannelTableViewCell
        cell.setUpCell(data: channelList[indexPath.row])
        return cell
    }
}

// MARK: - Collection View Methods

extension TVGuideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let _viewModel = self.viewModel else {
            return 0
        }
        if collectionView == collectionViewProgram {
            return _viewModel.programData.count
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _viewModel = self.viewModel else {
            return 0
        }
        if collectionView == collectionViewProgram {
            return _viewModel.programData[section].programItems.count
        } else {
            return _viewModel.timeArray.count
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _viewModel = self.viewModel else {
            fatalError("\(String(describing: viewModel)) not configured")
        }
        if collectionView == collectionViewProgram {
            let programSection = _viewModel.programData[indexPath.section]
            let cell: ProgramItemCollectionViewCell = self.collectionViewProgram.dequeueReusableCell(withReuseIdentifier: ProgramItemCollectionViewCell.identifier, for: indexPath) as! ProgramItemCollectionViewCell
            cell.setUpCell(data: programSection.programItems[indexPath.item], isFocussed: false)
            return cell
        } else {
            let timeArr = _viewModel.timeArray
            let cell: TimeCollectionViewCell = self.collectionViewTime.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.identifier, for: indexPath) as! TimeCollectionViewCell
            cell.labelTime.text = timeArr[indexPath.item]
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewTime {
            return CGSize(width: 300, height: 103)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    // HANDLE Collection View Focus
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        if collectionView == collectionViewProgram {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let _viewModel = self.viewModel else {
            fatalError("\(String(describing: viewModel)) not configured")
        }
        
        let programItems = _viewModel.programData
        
        if collectionView == collectionViewProgram {
            if let indexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? ProgramItemCollectionViewCell {
                let data = programItems[indexPath.section].programItems[indexPath.item]
                cell.setUpCell(data: data, isFocussed: false)
            }
            
        if let indexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? ProgramItemCollectionViewCell {
                let data = programItems[indexPath.section].programItems[indexPath.item]
                cell.setUpCell(data: data, isFocussed: true)
            }
        }
    }
    
}

// MARK: - Scroll View Methods

extension TVGuideViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableViewChannel {
            self.collectionViewProgram.contentOffset.y =  self.tableViewChannel.contentOffset.y
        } else if scrollView == self.collectionViewTime {
            self.collectionViewProgram.contentOffset.x = self.collectionViewTime.contentOffset.x
        } else if scrollView == self.collectionViewProgram {
            self.tableViewChannel.contentOffset.y = self.collectionViewProgram.contentOffset.y
            self.collectionViewTime.contentOffset.x = self.collectionViewProgram.contentOffset.x
        }
    }
}
