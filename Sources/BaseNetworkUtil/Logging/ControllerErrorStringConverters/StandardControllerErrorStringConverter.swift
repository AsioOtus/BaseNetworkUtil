import Foundation

public struct StandardControllerErrorStringConverter: ControllerErrorStringConverter {
	public var urlRequestConverter: (URLRequest) -> String
	public var urlErrorConverter: (URLError) -> String
	
	public func convert (_ error: Controller.Error) -> String {
		let message: String
		
		switch error {
		case .preprocessingFailure(let error):
			message = "PREPROCESSING ERROR – \(error.localizedDescription)"
			
		case .networkFailure(_, let urlRequest, let urlError):
			let urlRequestMessage = urlRequestConverter(urlRequest)
			let urlErrorMessage = urlErrorConverter(urlError)
			message = "NETWORK ERROR – \(urlErrorMessage) | REQUEST – \(urlRequestMessage)"
			
		case .postprocessingFailure(let error):
			message = "POSTPROCESSING ERROR – \(error.localizedDescription)"
		}
		
		return message
	}
}