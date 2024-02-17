import CloudKit

extension CKRecord.ID {
    convenience init(
        recordName: String?,
        zoneID: CKRecordZone.ID?
    ) {
        if let zoneID = zoneID {
            self.init(
                recordName: recordName ?? UUID().uuidString,
                zoneID: zoneID
            )
        } else {
            self.init(recordName: recordName ?? UUID().uuidString)
        }
    }
}

