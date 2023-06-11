struct DeleteFromListExample: View {
    
    @State private var courses = [
        "Mastering WidgetKit iOS 16", 
        "Practical iOS 16", 
        "New in SwiftUI: Charts", 
        "Complete Machine Learning"
    ]
    @State private var editingMode = EditMode.inactive
    @State private var selectedItems = Set<String>()
    
    private var deleteButton: some View {
        Group {
            if editingMode == .inactive {
                EmptyView()
            } else {
                Button(action: deleteCourses) {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    private var editButton: some View {
        Group {
            if editingMode == .inactive {
                Button(action: {
                    self.editingMode = .active
                    self.selectedItems = Set<String>()
                }) {
                    Text("Edit")
                }
            }
            else {
                Button(action: {
                    self.editingMode = .inactive
                    self.selectedItems = Set<String>()
                }) {
                    Text("Done")
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedItems) {
                ForEach(courses, id: \.self) { course in
                    Text(course)
                }
            }
            .navigationTitle("DevTechie Courses")
            .environment(\.editMode, $editingMode)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    deleteButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    editButton
                }
            }
        }
    }
    
    private func deleteCourses() {
        for item in selectedItems {
            if let index = courses.lastIndex(where: { $0 == item })  {
                courses.remove(at: index)
            }
        }
        selectedItems = Set<String>()
    }
}