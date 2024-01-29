import SwiftUI

// MARK: Double wave with progress change test
struct TestView: View {

    @State var progress: Float = 0.6

    var back = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    var front = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)

    var body: some View {
        ZStack{
            Wave(progress: $progress, waveHeight: 13, wavePhaseDegree: 0, waveDuration: 2.5, waveColor: Color(back).opacity(0.2), progressAnimation: .easeInOut(duration: 0.8))
                .edgesIgnoringSafeArea(.all)
            Wave(progress: $progress, waveHeight: 15, wavePhaseDegree: 180, waveDuration: 2.5, waveColor: Color(front).opacity(0.4), progressAnimation: .easeInOut(duration: 0.8))
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 30) {
                Text("progress: \(String(format: "%.1f", progress))")
                Stepper(value: $progress, in: 0.0...1.0, step: 0.1) {
                }
                .frame(width: 0, height: 0, alignment: .center)
            }
        }
    }
}




// MARK: Pure DoubleWave
//struct TestView: View {
//
//    @State var progress: Float = 0.6
//
//    var back = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//    var front = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
//
//    var body: some View {
//        ZStack{
//            Wave(progress: $progress, waveHeight: 13, wavePhaseDegree: 0, waveDuration: 2.5, waveColor: Color(back).opacity(0.2))
//                .edgesIgnoringSafeArea(.all)
//            Wave(progress: $progress, waveHeight: 15, wavePhaseDegree: 180, waveDuration: 2.5, waveColor: Color(front).opacity(0.4))
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}




// MARK: Single wave
//struct TestView: View {
//
//    @State var progress: Float = 0.6
//
//    var front = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
//
//    var body: some View {
//        ZStack{
//            Wave(progress: $progress,waveColor: Color(front).opacity(0.65))
//                .edgesIgnoringSafeArea(.all)
//            VStack(alignment: .center, spacing: 30) {
//                Text("progress: \(String(format: "%.1f", progress))")
//                Stepper(value: $progress, in: 0.0...1.0, step: 0.1) {
//                }
//                .frame(width: 0, height: 0, alignment: .center)
//            }
//        }
//    }
//}




#Preview {
    TestView()
}
