struct ShadowTitleExample: View {
    var body: some View {
        VStack {
            Text("Marcelo")
                .font(.largeTitle)
                .frame(width: 200, height: 200)
                .background(Color.white.shadow(color: .orange, radius: 2, x: 20, y: 20))
                
        }
    }
}