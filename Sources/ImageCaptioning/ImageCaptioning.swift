import CoreML
import Vision

public final class ImageCaptioningRequest {
    public init() throws {
        let vectornizer = try ResNet50().model
        let vectornizerMLModel = try VNCoreMLModel(for: vectornizer)
        vectornizerRequest = VNCoreMLRequest(model: vectornizerMLModel)
        tokenizer = try Tokenizer().model
    }
    
    let vectornizerRequest: VNCoreMLRequest
    let tokenizer: MLModel
    public fileprivate(set) var result: String? = nil
}

public struct ImageCaptioningRequestHandler {
    let handler: VNImageRequestHandler
    let startToken: NSNumber = 3
    let endToken = 4
    
    public init(cgImage: CGImage) {
        handler = VNImageRequestHandler(cgImage: cgImage)
    }
    
    public func perform(_ request: ImageCaptioningRequest) throws {
        try handler.perform([request.vectornizerRequest])
        let observations = request.vectornizerRequest.results as? [VNCoreMLFeatureValueObservation]
        let imageVector = observations?.first?.featureValue.multiArrayValue
        guard let imageVector else { return }
        
        let maxTokenCount = 34
        let totalTokenCount = 7955
        var textIndicies: [NSNumber] = [startToken]
        let tokensInput = try MLMultiArray(shape: [1, 34], dataType: .float32)
        let tokenizerInput = TokenizerInput(
            imageFeatureVector: imageVector,
            tokens: tokensInput
        )
        
        for _ in 0..<maxTokenCount {
            for i in textIndicies.indices {
                tokenizerInput.tokens[maxTokenCount - textIndicies.count + i] = textIndicies[i]
            }
            
            let output = try request.tokenizer.prediction(from: tokenizerInput)
            
            let yhat = output.featureValue(for: "Identity")!
            
            // argmax
            let argmax = yhat.multiArrayValue?.argmax(count: totalTokenCount)
            if let argmax {
                textIndicies.append(argmax as NSNumber)
                if argmax == endToken {
                    break
                }
            }
        }
        
        // remove start token
        textIndicies.removeFirst()
        // remove end token
        textIndicies.removeLast()
        
        let text = try tokenIndiciesToText(textIndicies)
        request.result = text
    }
    
    func tokenIndiciesToText(_ indicies: [NSNumber]) throws -> String? {
        let path = Bundle.module.url(forResource: "Tokens", withExtension: "txt")!.path()
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        var resultText = ""
        for index in indicies {
            let targetLineIndex = index.intValue - 1
            if lines.indices.contains(targetLineIndex) {
                let targetLine = lines[targetLineIndex]
                resultText.append(targetLine)
            }
        }
        return resultText
    }
}

extension MLMultiArray {
    func argmax(count: Int) -> Int? {
        guard self.count > 0 else { return nil }
        var maxIndex = 0
        var maxValue = self[0].doubleValue
        
        for index in 0..<count {
            let value = self[index].doubleValue
            if value > maxValue {
                maxValue = value
                maxIndex = index
            }
        }
        
        return maxIndex
    }
}
