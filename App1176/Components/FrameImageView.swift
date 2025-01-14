import PhotosUI
import SwiftUI

struct FrameImageView: View {
   
    let emptyText: String
    @Binding var imageData: Data?
    @State var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 167)
                .background(Color.c343434)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    Button {
                        self.image = nil
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 4.7)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                )
                .layoutPriority(0.5)
            } else {
                ZStack {
                    Text(emptyText)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.top, 4)
                        .frame(maxHeight: .infinity, alignment: .top)
                    Image(systemName: "camera")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 167)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.c2547413, style: StrokeStyle(lineWidth: 2, dash: [6]))
                )
                .background(
                    Color.c343434
                        .clipShape(.rect(cornerRadius: 10))
                )
                .layoutPriority(0.5)
            }
        }
        .onTapGesture {
            showingImagePicker = true
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
                .ignoresSafeArea()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        imageData = inputImage.pngData()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
