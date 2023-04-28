import CloudKit
import SwiftUI

struct DestinationDetailView: View {
    @ObservedObject var destination: Destination
    @State private var share: CKShare?
    @State private var showShareSheet = false
    @State private var showEditSheet = false
    private let stack = CoreDataStack.shared

    var body: some View {
    // swiftlint:disable trailing_closure
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    if let imageData = destination.image, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    Text(destination.caption)
                        .font(.headline)
                    Text(destination.details)
                        .font(.subheadline)
                    Text(destination.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
            }

            Section {
                if let share = share {
                    ForEach(share.participants, id: \.self) { participant in
                        VStack(alignment: .leading) {
                            Text(participant.userIdentity.nameComponents?.formatted(.name(style: .long)) ?? "")
                                .font(.headline)
                            Text("Acceptance Status: \(string(for: participant.acceptanceStatus))")
                                .font(.subheadline)
                            Text("Role: \(string(for: participant.role))")
                                .font(.subheadline)
                            Text("Permissions: \(string(for: participant.permission))")
                                .font(.subheadline)
                        }
                        .padding(.bottom, 8)
                    }
                }
            } header: {
                Text("Participants")
            }
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let share = share {
                CloudSharingView(share: share, container: stack.ckContainer, destination: destination)
            }     
        })
        .sheet(isPresented: $showEditSheet, content: {
            EditDestinationView(destination: destination)
        })
        .onAppear(perform: {
            self.share = stack.getShare(destination)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showEditSheet.toggle()
                } label: {
                    Text("Edit")
                }
                .disabled(!stack.canEdit(object: destination))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !stack.isShared(object: destination) {
                        Task {
                            await createShare(destination)
                        }
                    }
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }     
        }
    }
}

// MARK: Returns CKShare participant permission, methods and properties to share
extension DestinationDetailView {
    private func createShare(_ destination: Destination) async {
        do {
            let (_, share, _) = try await stack.persistentContainer.share([destination], to: nil)
            share[CKShare.SystemFieldKey.title] = destination.caption
            self.share = share
        } catch {
            print("Failed to create share")
        }
    } 

    private func string(for permission: CKShare.ParticipantPermission) -> String {
        switch permission {
        case .unknown:
            return "Unknown"
        case .none:
            return "None"
        case .readOnly:
            return "Read-Only"
        case .readWrite:
            return "Read-Write"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Permission")
        }
    } 

    private func string(for role: CKShare.ParticipantRole) -> String {
        switch role {
        case .owner:
            return "Owner"
        case .privateUser:
            return "Private User"
        case .publicUser:
            return "Public User"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Role")
        }
    }

    private func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
        switch acceptanceStatus {
        case .accepted:
            return "Accepted"
        case .removed:
            return "Removed"
        case .pending:
            return "Invited"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.AcceptanceStatus")
        }
    }

    private var canEdit: Bool {
        stack.canEdit(object: destination)
    }
}
