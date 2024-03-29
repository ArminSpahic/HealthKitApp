/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import HealthKit

class WorkoutsTableViewController: UITableViewController {
  
  private enum WorkoutsSegues: String {
    case showCreateWorkout
    case finishedCreatingWorkout
  }
  
  private var workouts: [Workout]?
  
  private let prancerciseWorkoutCellID = "PrancerciseWorkoutCell"
  
  lazy var dateFormatter:DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .medium
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadWorkouts()
  }
  
  func reloadWorkouts() {
    WorkoutDataStore.loadPrancerciseWorkouts { (workouts, error) in
        if let _ = error {
            print("Error occured while loading workouts")
        }
        
        self.workouts = []
        workouts?.forEach({ self.workouts?.append(Workout(workout: $0)) })
        self.tableView.reloadData()
    }
  }
  
}

extension WorkoutsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workouts = workouts else {
            fatalError("""
            CellForRowAtIndexPath should \not get called if there are no workouts
            """)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: prancerciseWorkoutCellID, for: indexPath)
        
        let workout = workouts[indexPath.row]
        
        cell.textLabel?.text = workout.title
        cell.detailTextLabel?.text = workout.subtitle
        //cell.textLabel?.text = dateFormatter.string(from:  workout.startDate)
        
//        if let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())  {
//            let formattedCalories = String(format: "CaloriesBurned: %.2f", caloriesBurned)
//            cell.detailTextLabel?.text = formattedCalories
//        } else {
//            cell.detailTextLabel?.text = nil
//        }
        return cell
    }
}

struct Workout {
    let title: String
    let subtitle: String
    
    init(workout: HKWorkout) {
        
        self.title = BaseUtilities.shared.dateFormatter.string(from: workout.startDate)
        self.subtitle = String(format: "CaloriesBurned: %.2f", workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0)
    }
    
    
}
