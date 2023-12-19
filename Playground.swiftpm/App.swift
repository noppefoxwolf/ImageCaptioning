import SwiftUI
import PhotosUI
import ImageCaptioning

@main
struct App: SwiftUI.App {
    
    @State var image: UIImage? = nil
    @State var resultText: String? = nil
    @State var photoPickerItems: [PhotosPickerItem] = []
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if let resultText {
                    Text(resultText)
                }
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                PhotosPicker(
                    selection: $photoPickerItems,
                    maxSelectionCount: 1,
                    matching: .images,
                    preferredItemEncoding: .current,
                    label: {
                        Image(systemName: "photo")
                    }
                )
            }
            .onChange(of: photoPickerItems) { newPhotoPickerItems in
                Task {
                    let item = newPhotoPickerItems.first
                    guard let item else { return }
                    do {
                        let data = try await item.loadTransferable(type: Data.self)
                        guard let data else { return }
                        let uiImage = UIImage(data: data)
                        guard let image = uiImage?.cgImage else { return }
                        let request = try ImageCaptioningRequest()
                        let handler = ImageCaptioningRequestHandler(cgImage: image)
                        try handler.perform(request)
                        self.resultText = request.result
                        self.image = uiImage
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
