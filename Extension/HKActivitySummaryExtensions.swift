import HealthKit

@available(macOS 13.0, *)
extension HKActivitySummary {

    // Check if stand goal is met.
    var isStandGoalMet: Bool {
        if #available(iOS 16.0, watchOS 9.0, *) {
            return standHoursGoal == nil || standHoursGoal!.compare(appleStandHours) != .orderedDescending
        } else {
            return appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
        }
    }

    // Check if exercise time goal is met.
    var isExerciseTimeGoalMet: Bool {
        if #available(iOS 16.0, watchOS 9.0, *) {
            return exerciseTimeGoal == nil || exerciseTimeGoal!.compare(appleExerciseTime) != .orderedDescending
        } else {
            return appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
        }
    }

    // Check if active energy goal is met.
    var isEnergyBurnedGoalMet: Bool { activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending }
}
