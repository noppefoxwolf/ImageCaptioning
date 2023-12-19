# ImageCaptioning

> [!IMPORTANT]  
> This project is experimental. It is not intended for production use.

![](https://github.com/noppefoxwolf/ImageCaptioning/blob/main/.github/example.png)

```swift
let image = UIImage(resource: .baseball)
let request = try ImageCaptioningRequest()
let handler = ImageCaptioningRequestHandler(cgImage: image.cgImage!)
try handler.perform(request)
request.result
```
