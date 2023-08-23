import SwiftUI

struct ContentView: View {

    @ObservedObject var sharedData: SharedData = SharedData()

    let screen = UIScreen.main.bounds

    var body: some View {
        VStack {
            Text("Controller with content.")

            HStack {
                Rectangle()
                    .foregroundColor(Color.red)
                    .frame(width: 200, height: 200)

                Rectangle()
                    .foregroundColor(Color.green)
                    .frame(width: 200, height: 200)
            }

            HStack {
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(width: 200, height: 200)

                Rectangle()
                    .foregroundColor(Color.yellow)
                    .frame(width: 200, height: 200)
            }

            HStack {
                Rectangle()
                    .foregroundColor(Color.black)
                    .frame(width: 200, height: 200)

                Rectangle()
                    .foregroundColor(Color.brown)
                    .frame(width: 200, height: 200)
            }

            Spacer()
                .frame(width: screen.width, height: 60)

            Button(action: {
                exportPDF {
                    self
                } completion: { status, url in
                    if let url = url, status {
                        print("Button was pressed with url: \(url)")
                        sharedData.PDFUrl = url
                        sharedData.showShareSheet.toggle()
                    } else {
                        print("Failed to produce PDF.")
                    }
                }

            }, label: {
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.title2)
                    .foregroundColor(Color.red)
            })
        }
        .sheet(isPresented: $sharedData.showShareSheet) {
            sharedData.PDFUrl = nil
        } content: {
            if let PDFUrl = sharedData.PDFUrl {
                ShareSheet(urls: [PDFUrl])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Share Sheet

struct ShareSheet: UIViewControllerRepresentable {

    var urls: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
