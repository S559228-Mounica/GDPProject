import UIKit

class AdminHistoryDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fileName = ""
    var studentDataRecord: [StudentRecord] = []
    var studentAssignment: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        let btnFilter = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(filterRecord))
        navigationItem.rightBarButtonItem = btnFilter
        
        CoreDataHelper.shared.fetchFileRecord(forFileName: fileName) { studentDataRecord, error in
            self.studentDataRecord = studentDataRecord ?? []
            if self.studentDataRecord.isEmpty {
                self.showAlert(message: "No Record Found")
            }else {
                
                for item in self.studentDataRecord {
                    if(!self.studentAssignment.contains(item.assessmentTitle!)){
                        self.studentAssignment.append(item.assessmentTitle ?? "" )
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableView DataSource and Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentDataRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let record = studentDataRecord[indexPath.row]
        
        let displayText = """
            Account Name: \(record.accountName ?? "")
            Course Name: \(record.courseName ?? "")
            Assessment Title: \(record.assessmentTitle ?? "")
            Learning Outcome Name: \(record.learningOutcomeName ?? "")
            Learning Outcome Rating: \(record.learningOutcomeRating ?? "")
            Created On: \(record.fileName ?? "")
            """
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = attributedText(for: displayText)
        
        return cell
    }
        
    @objc func filterRecord() {
        guard !studentAssignment.isEmpty else { return }
        
        let PickerView = PickerView()
        PickerView.stringArray = studentAssignment
        PickerView.modalPresentationStyle = .overCurrentContext
        PickerView.onDone = { [weak self] index in
            guard let self = self else { return }
            let selectedAssignment = self.studentAssignment[index]
            
            let filteredRecords = self.studentDataRecord.filter { $0.assessmentTitle == selectedAssignment }
            
            self.studentDataRecord = filteredRecords
            self.tableView.reloadData()
        }
        present(PickerView, animated: true, completion: nil)
    }

    
    private func attributedText(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        if let range = text.range(of: "Learning Outcome Rating: ") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: nsRange)
        }
        
        return attributedString
    }
}
