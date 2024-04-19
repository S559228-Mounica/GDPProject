
import UIKit

class VisualizationRecordVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var departmentData: [String] = []
    var courseData: [String] = []
    var learningOutComeData: [String] = ["critical thinking", "communicating","managing information","leadership"]
    var assignmentData: [String] = []
    
    var currentData: [String] = []
    var selectedCourse = ""
    var selectedDepartment = ""
    var selectedLearning = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let fetchedFiles = CoreDataHelper.shared.getFiles() {
            
            if(fetchedFiles.isEmpty){showAlert(message: "No Record Found Please upload csv")}
            
        }
        
        if(UserDefaultsManager.shared.getUserType() == .ADMIN || UserDefaultsManager.shared.getUserType() == .FACULTY) {
            self.departmentData.append(UserDefaultsManager.shared.getDepartment())
            self.currentData = self.departmentData
        } else {
            self.departmentData = Array(courses.keys)
            self.currentData = self.departmentData
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        cell.titleLabel.text = currentData[indexPath.item]
        animateCell(cell, at: indexPath)

        return cell
    }
    
    func animateCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
           cell.alpha = 0
           UIView.animate(withDuration: 0.4, delay: 0.1 * Double(indexPath.item), options: [], animations: {
               cell.alpha = 1
           }, completion: nil)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = currentData[indexPath.item]
        if currentData == departmentData {
            self.selectedDepartment = item
            courseData = courses[item]!
            currentData = courseData
        } else if currentData == courseData {
            self.selectedCourse = item
            currentData = learningOutComeData
            
        } else if currentData == learningOutComeData {
            self.selectedLearning = item
            self.showAssignmentList()
        } else if currentData == assignmentData {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisualizationDetailVC") as! VisualizationDetailVC
            vc.department = selectedDepartment
            vc.course = selectedCourse
            vc.outcome = selectedLearning
            vc.assignment =  item
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
        }
        
        collectionView.reloadData()
    }
    
    func showAssignmentList() {
        
        CoreDataHelper.shared.fetchAssignments(forCourse: selectedCourse) { [weak self] (assignments, error) in
            if let error = error {
                print("Error fetching assignments: \(error.localizedDescription)")
                self?.showAlert(message: "Error fetching assignments")
            } else if let assignments = assignments {
                
                if(assignments.isEmpty) {
                    self!.showAlert(message: "No Assignment Found For Selected Course")
                    return
                }
                
                self?.assignmentData = assignments
                self?.currentData = self?.assignmentData ?? [""]
                self?.collectionView.reloadData()
                
            }
        }
    }
}




class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        configureLayout()
    }
    
    private func configureLayout() {
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let itemWidth = (availableWidth - minimumInteritemSpacing) / 2
        
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}
