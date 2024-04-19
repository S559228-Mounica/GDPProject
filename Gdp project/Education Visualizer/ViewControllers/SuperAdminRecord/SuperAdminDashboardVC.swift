import UIKit
import UniformTypeIdentifiers
 
class SuperAdminDashboardVC: UIViewController, UIDocumentPickerDelegate {
    
    @IBAction func clickOnUploadCSV(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            print("No file selected")
            return
        }
        
        let csv = try! String(contentsOf: url)
        
        var records = [CSVData]()
        do {
            let reader = try CSVReader(string: csv, hasHeaderRow: true)
            let decoder = CSVRowDecoder()
            while reader.next() != nil {
                let row = try decoder.decode(CSVData.self, from: reader)
                records.append(row)
            }
        } catch {
            
        }
        
        if(records.isEmpty) {return}
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        
        let timestampString = dateFormatter.string(from: Date())

         
        for item in records {

            CoreDataHelper.shared.saveStudentRecord(accountName: item.accountName,
                                                    courseName: item.courseName,
                                                    assessmentTitle: item.assessmentTitle,
                                                    learningOutcomeName: item.learningOutcomeName,
                                                    learningOutcomeRating: item.learningOutcomeRating, fileName: timestampString)
        }
        
        
        if(!records.isEmpty) {
           
            CoreDataHelper.shared.saveFileName(fileName: timestampString)
        }
        
        showAlert(message: "Data Filtered and Inserted successful, Visualization Updated.")
    }

    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    

    
}
