import UIKit

class AdminHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filesRecord: [Files] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        if let fetchedFiles = CoreDataHelper.shared.getFiles() {
            filesRecord = fetchedFiles
            if(filesRecord.isEmpty){showAlert(message: "No Record Found")}
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let file = filesRecord[indexPath.row]
        
        cell.textLabel?.text = "CSV \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "File Name: \(file.fileName ?? "")"
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminHistoryDetailsVC") as! AdminHistoryDetailsVC
        vc.fileName = self.filesRecord[indexPath.row].fileName!
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let fileName = filesRecord[indexPath.row].fileName
            CoreDataHelper.shared.deleteAllRecordsFromTable(with: fileName!)
            
            let fileToDelete = filesRecord[indexPath.row]
            CoreDataHelper.shared.deleteFile(file: fileToDelete)
            filesRecord.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
           
        }
    }
    
}
