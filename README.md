# TVOS-TVChannelandProgramCatalogue
This App Show a Catalogue of Channels and Programs which are schedule for a day.

Language Used is Swift

App is made for TVOS

Contents:
Architecture Used is VIPER. 

API calls are made from a Network Service Library which uses URLSession.

API Response is Stored in Decodable Models.

UIKit is Used for UI
Multidimensional CollectionView is used to display Programs according to the start time.

To make 'Multidimensional CollectionView' Custom UICollectionViewLayout was used.

Following code is used to handle the Focus in Collection View.
```
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
```
Note: There maybe some edge cases missing, as the project was done only in two days.
All the code is commented and clean, One can easily understand the code logic just by reading it.

