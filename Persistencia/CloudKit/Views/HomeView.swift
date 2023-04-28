import SwiftUI

struct HomeView: View {
    @State private var showAddDestinationSheet = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)])
    var destinations: FetchedResults<Destination>
    private let stack = CoreDataStack.shared

    var body: some View {
        NavigationView {
      // swiftlint:disable trailing_closure
            VStack {
                List {
                    ForEach(destinations, id: \.objectID) { destination in
                        NavigationLink(destination: DestinationDetailView(destination: destination)) {
                            VStack(alignment: .leading) {
                                Image(uiImage: UIImage(data: destination.image ?? Data()) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()

                                Text(destination.caption)
                                    .font(.title3)
                                    .foregroundColor(.primary)

                                Text(destination.details)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)

                                if stack.isShared(object: destination) {
                                    Image(systemName: "person.3.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                stack.delete(destination)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .disabled(!stack.canDelete(object: destination))
                        }
                    }
                }
                Spacer()
                Button {
                    showAddDestinationSheet.toggle()
                } label: {
                    Text("Add Destination")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 8)
            }
            .emptyState(destinations.isEmpty, emptyContent: {
                VStack {
                    Text("No destinations quite yet")
                        .font(.headline)
                Button {
                    showAddDestinationSheet.toggle()
                } label: {
                    Text("Add Destination")
                }
                .buttonStyle(.borderedProminent)
                }
            })
            .sheet(isPresented: $showAddDestinationSheet, content: {
                AddDestinationView()
            })
            .navigationTitle("My Travel Journal")
            .navigationViewStyle(.stack)
        }
    }
}

extension View {
    func emptyState<EmptyContent>(_ isEmpty: Bool, emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
        modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
    }
}

struct EmptyStateViewModifier<EmptyContent>: ViewModifier where EmptyContent: View {
    var isEmpty: Bool
    let emptyContent: () -> EmptyContent

    func body(content: Content) -> some View {
        if isEmpty {
            emptyContent()
        } else {
            content
        }
    }
}
