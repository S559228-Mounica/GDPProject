import UIKit
import DGCharts

class VisualizationDetailVC: UIViewController {
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var department = ""
    var course = ""
    var outcome = ""
    var assignment = ""
    let coreDataHelper = CoreDataHelper.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coreDataHelper.fetchLearningOutcomeRatings(forAssessmentTitle: assignment, learningOutcome: outcome) { (proficient, notProficient, highlyProficientStudents, meetsExpectationsStudents, notMeetsExpectationsStudents, emergingProficientStudents, error) in
            if let error = error {
                print("Error fetching ratings for \(self.title): \(error.localizedDescription)")
                return
            }
            self.pieChartUpdateRecord(proficientCount: proficient?.count ?? 0,
                                highlyProficientCount: highlyProficientStudents?.count ?? 0,
                                emergingProficientCount: emergingProficientStudents?.count ?? 0,
                                notProficientCount: notProficient?.count ?? 0,
                                meetsExpectationsCount: meetsExpectationsStudents?.count ?? 0,
                                notMeetsExpectationsCount: notMeetsExpectationsStudents?.count ?? 0)
            
            self.barChartUpdateRecord(proficientCount: proficient?.count ?? 0,
                                highlyProficientCount: highlyProficientStudents?.count ?? 0,
                                emergingProficientCount: emergingProficientStudents?.count ?? 0,
                                notProficientCount: notProficient?.count ?? 0,
                                meetsExpectationsCount: meetsExpectationsStudents?.count ?? 0,
                                notMeetsExpectationsCount: notMeetsExpectationsStudents?.count ?? 0)
        }
    }
    
    func pieChartUpdateRecord(proficientCount: Int, highlyProficientCount: Int, emergingProficientCount: Int, notProficientCount: Int, meetsExpectationsCount: Int, notMeetsExpectationsCount: Int) {
        let entries = [
            PieChartDataEntry(value: Double(proficientCount), label: "Proficient"),
            PieChartDataEntry(value: Double(highlyProficientCount), label: "Highly Proficient"),
            PieChartDataEntry(value: Double(emergingProficientCount), label: "Emerging Proficient"),
            PieChartDataEntry(value: Double(notProficientCount), label: "Not Proficient"),
            PieChartDataEntry(value: Double(meetsExpectationsCount), label: "Meets Expectations"),
            PieChartDataEntry(value: Double(notMeetsExpectationsCount), label: "Not Meets Expectations")
        ]
        
        let pieChartDataSet = PieChartDataSet(entries: entries, label: "Proficiency Levels")
        
        pieChartDataSet.colors = ChartColorTemplates.vordiplom()
        
        let data = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = data
        pieChartView.noDataText = "No data available"
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = "Proficiency Levels"
        pieChartView.holeColor = UIColor.clear
    }
    
    func barChartUpdateRecord(proficientCount: Int, highlyProficientCount: Int, emergingProficientCount: Int, notProficientCount: Int, meetsExpectationsCount: Int, notMeetsExpectationsCount: Int) {

        let barChartEntries = [
            BarChartDataEntry(x: 0, y: Double(proficientCount), data: "Proficient"),
            BarChartDataEntry(x: 1, y: Double(highlyProficientCount), data: "Highly Proficient"),
            BarChartDataEntry(x: 2, y: Double(emergingProficientCount), data: "Emerging Proficient"),
            BarChartDataEntry(x: 3, y: Double(notProficientCount), data: "Not Proficient"),
            BarChartDataEntry(x: 4, y: Double(meetsExpectationsCount), data: "Meets Expectations"),
            BarChartDataEntry(x: 5, y: Double(notMeetsExpectationsCount), data: "Not Meets Expectations")
        ]
        
        let barChartDataSet = BarChartDataSet(entries: barChartEntries, label: "Proficiency Levels")
        
        barChartDataSet.colors = ChartColorTemplates.vordiplom()
        
        let data = BarChartData(dataSet: barChartDataSet)
        
        barChartView.data = data
        barChartView.noDataText = "No data available"
    }
}
