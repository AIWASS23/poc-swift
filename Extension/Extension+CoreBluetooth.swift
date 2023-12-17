import Foundation
import CoreBluetooth

/*
Peripheral contém informações úteis sobre 1 ou mais serviços e intensidade do sinal de conexão. O Serviço 
pode ser entendido como uma coleta de dados que completa funções especificadas. O Serviço é composto 
por Característica, que fornece informações mais detalhadas para Serviço Periférico. Por exemplo: 
o Serviço de frequência cardíaca pode incluir uma Característica que mede dados de frequência cardíaca 
em diferentes posições do corpo e uma Característica que transmite dados de frequência cardíaca. Quando
a Central estabelece uma conexão bem-sucedida com o Peripheral, a Central pode descobrir toda a gama 
de serviços e características fornecidas pelo Peripheral. Os dados no pacote de transmissão são apenas 
uma pequena parte dos serviços disponíveis. A Central pode interagir com Service lendo ou escrevendo 
valores de Característica de Serviço. Seu APP pode precisar obter a temperatura interna atual do 
medidor digital de temperatura ambiente ou definir um valor de temperatura para o medidor digital de 
temperatura ambiente. Quando você interage com o periférico Peripheral através da Central local, você 
só precisa chamar o método Central, a menos que você configure um Peripheral local e o utilize para 
responder às solicitações interativas de outras Centrais. Na aplicação real, a maior parte do 
Bluetooth o processamento será feito no lado Central
*/
class BLEBootcamp: NSObject {
	private(set) var centralManager: CBCentralManager!
	private var foundPeripheral: CBPeripheral?
	private var localPeripheral: CBPeripheralManager?
	
	let characteristicUUID = CBUUID(string: "4614CB60-C66D-480F-AA2F-7B915CAE4962")
	let serviceUUID = CBUUID(string: "06D650AC-3B03-4AA2-8CC7-28D3ACF79937")
	let myCharacteristicValue = Data()
	lazy var myCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .read, value: myCharacteristicValue, permissions: .readable)
	override init() {
		super.init()
		let options: [String: Any] = [CBCentralManagerOptionShowPowerAlertKey: true]
		self.centralManager = CBCentralManager(delegate: self, queue: .global(qos: .background), options: options)
	}
	
	func overview() {}
	
	func connectDisconnectPeripheral() {
		if let foundPeripheral = foundPeripheral {
			let options: [String: Any] = [
				CBConnectPeripheralOptionNotifyOnConnectionKey: true,
				CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
				CBConnectPeripheralOptionNotifyOnNotificationKey: true,
				CBConnectPeripheralOptionEnableTransportBridgingKey: true,
				CBConnectPeripheralOptionRequiresANCS: true,
				CBConnectPeripheralOptionStartDelayKey: 2
			]
			centralManager.connect(foundPeripheral, options: options)
			centralManager.cancelPeripheralConnection(foundPeripheral)
		}
	}
	
	func scanPeripheral() {
		let services: [CBUUID] = [
		]
		let options: [String: Any] = [
			CBCentralManagerScanOptionAllowDuplicatesKey: true,
			CBCentralManagerScanOptionSolicitedServiceUUIDsKey: services
		]
		centralManager.scanForPeripherals(withServices: services, options: options)
	}
	
	func localCentral() {
		let localPeripheral = CBPeripheralManager(delegate: self, queue: .main, options: nil)
		let service = CBMutableService(type: serviceUUID, primary: true)
		service.characteristics = [
			myCharacteristic
		]
		localPeripheral.add(service)
		let advertisementData: [String: Any] = [ 
			CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
			CBAdvertisementDataLocalNameKey: ""
		]
		localPeripheral.startAdvertising(advertisementData)
		
		self.localPeripheral = localPeripheral
	}
}

extension BLEBootcamp: CBPeripheralManagerDelegate {
	
	func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {}
	
	func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
		let updated = Data()
		peripheral.updateValue(updated, for: myCharacteristic, onSubscribedCentrals: nil)
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
		print("Subscribed.")
		let newValue = Data()
		let didSendValue = peripheral.updateValue(newValue, for: myCharacteristic, onSubscribedCentrals: nil)
		print(didSendValue)
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
		for request in requests {
			myCharacteristic.value = request.value
			peripheral.respond(to: request, withResult: .invalidHandle)
		}
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
		if request.characteristic.uuid == characteristicUUID {
			guard request.offset <= myCharacteristicValue.count else {
				peripheral.respond(to: request, withResult: .invalidOffset)
				return
			}
			request.value = myCharacteristicValue.subdata(in: request.offset..<myCharacteristicValue.count - request.offset)
			peripheral.respond(to: request, withResult: .success)
		} else {
			peripheral.respond(to: request, withResult: .invalidHandle)
		}
	}
	
	func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {}
	func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {}
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {}
}

extension BLEBootcamp: CBPeripheralDelegate {
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
			return
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		if let data = characteristic.value {
			print(data)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let data = characteristic.value {
			print(data)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		if let characteristics = service.characteristics {
			for characteristic in characteristics {
				print(characteristic)
			}

			if let firstCharacteristic = characteristics.first {
				let characterProperties = firstCharacteristic.properties
				if characterProperties.contains(.read) {
					peripheral.readValue(for: firstCharacteristic)
				}
				if characterProperties.contains(.notify) || characterProperties.contains(.indicate) {
					peripheral.setNotifyValue(true, for: firstCharacteristic)
				}
				let writeInValue = Data()
				if characterProperties.contains(.write) {
					peripheral.writeValue(writeInValue, for: firstCharacteristic, type: .withResponse)
				}
				if characterProperties.contains(.writeWithoutResponse) {
					peripheral.writeValue(writeInValue, for: firstCharacteristic, type: .withoutResponse)
				}
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		if let services = peripheral.services {
			for service in services {
				print(service)
			}
			if let firstService = services.first {
				let characteristics: [CBUUID] = []
				peripheral.discoverCharacteristics(characteristics, for: firstService)
			}
		}
	}
}

extension BLEBootcamp: CBCentralManagerDelegate {
	
	func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.delegate = self
		let services: [CBUUID] = []
		peripheral.discoverServices(services)
	}
	
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		foundPeripheral = peripheral
		central.stopScan()
	}
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .unknown:
			break
		case .resetting:
			break
		case .unsupported:
			break
		case .unauthorized:
			break
		case .poweredOff:
			break
		case .poweredOn:
			break
		@unknown default:
			fatalError("NEW STATE TO HANDLE.")
		}
	}
}
