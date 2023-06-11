struct DevTechieBubbleChart: View {
    @State private var data: [DataPoint] = DataPoint.sampleData
    
    var body: some View {
        NavigationStack {
            VStack {
                PackedBubbleChart(data: $data, spacing: 0, startAngle: 180, clockwise: true)
                    .font(.caption)
                    .frame(height: 300)
                    .padding()
                    
                List(data) { datum in
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(datum.color.gradient)
                        Text(datum.title)
                        Spacer()
                        Text(datum.value.formatted())
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
            }
            .navigationTitle("Marcelo")
        }
    }
}