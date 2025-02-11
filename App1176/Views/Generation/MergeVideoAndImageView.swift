import SwiftUI

struct MergeVideoAndImageView: View {
    @EnvironmentObject var source: Source
    
    @Binding var screen: TabScreen
    @State var startFrameImage: Data?
    @State var endFrameImage: Data?
    @State var aspectRatio: String = "16:9"
    @State var buttonText = "Styles"
    
    @State var selection = 0
    
    @State var uiImage: UIImage?
    
    @State var showVideoChoice = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Color.c606060.ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Generate")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                        .frame(height: 52)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            Text("AI Hug Video Generator")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 28)
                            
                            VStack(spacing: 8) {
                                startFrame
                                Picker("", selection: $selection) {
                                    Text("Start frame").tag(0)
                                    Text("End frame").tag(1)
                                }
                                .pickerStyle(.segmented)
                                .labelsHidden()
                            }
                            .padding(.top, 20)
                            
                            textEditorCustom
                                .padding(.top, 15)
                            
                            Button {
                                source.isMerge = true
                                source.mergeStartFrame = nil
                                source.mergeEndFrame = nil
                                if startFrameImage != nil && selection == 0 {
                                    print("Start frame")
                                    source.mergeStartFrame = startFrameImage
                                } else if startFrameImage != nil && selection == 1 {
                                    source.mergeEndFrame = startFrameImage
                                }
                                screen = .videoResult
                            } label: {
                                HStack {
                                    Image(systemName: "wand.and.stars.inverse")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white)
                                    
                                    Text("Generate Video")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white)
                                }
                                .disabled(source.mergeVideo == nil && startFrameImage == nil)
                                .opacity(source.mergeVideo == nil && startFrameImage == nil ? 0.5 : 1)
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color.c2547413)
                                .clipShape(.rect(cornerRadius: 40))
                            }
                            .padding(.top, 15)
//                            Button {
//
//                            } label: {
//                                HStack {
//                                    Image(systemName: "arrowtriangle.down.fill")
//                                        .font(.system(size: 15, weight: .regular))
//                                        .foregroundColor(.white)
//
//                                    Text("16:9")
//                                        .font(.system(size: 15, weight: .regular))
//                                        .foregroundColor(.white)
//                                }
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 34)
//                                .background(Color.c2547413)
//                                .clipShape(.rect(cornerRadius: 40))
//                            }
//                            .padding(.top, 15)
                            
                            HStack(spacing: 8) {
                                Text("16:9")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(aspectRatio == "16:9" ? Color.c2547413 : Color.black)
                                    .clipShape(.rect(cornerRadius: 40))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(aspectRatio != "16:9" ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        source.aspectRatio = "16:9"
                                        aspectRatio = "16:9"
                                    }
                                
                                Text("4:3")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(aspectRatio == "4:3" ? Color.c2547413 : Color.black)
                                    .clipShape(.rect(cornerRadius: 40))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(aspectRatio != "4:3" ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        source.aspectRatio = "4:3"
                                        aspectRatio = "4:3"
                                    }
                                
                                Text("1:1")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(aspectRatio == "1:1" ? Color.c2547413 : Color.black)
                                    .clipShape(.rect(cornerRadius: 40))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(aspectRatio != "1:1" ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        source.aspectRatio = "1:1"
                                        aspectRatio = "1:1"
                                    }
                            }
                            .padding(.top, 15)
                            
                            NavigationLink {
                                StylesView(style: source.style)
                            } label: {
                                HStack {
                                    Image(systemName: "pencil.circle")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white)
                                    
                                    Text(buttonText)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white)
                                        .onAppear {
                                            buttonText = buttonStyleText
                                        }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color.c2547413)
                                .clipShape(.rect(cornerRadius: 40))
                            }
                            .padding(.top, 15)
                            
                            Text("Inspiration")
                                .font(.system(size: 22, weight: .regular))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 33)
                                .padding(.top, 6)
                            
                            Image("kitty")
                                .resizable()
                                .scaledToFit()
                                .overlay(
                                    Button {
                                        screen = .promtResult
                                    } label: {
                                        HStack {
                                            Image(systemName: "wand.and.stars.inverse")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.white)
                                            Text("Try promt")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.white)
                                        }
                                    }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 34)
                                        .background(Color.c2547413)
                                        .clipShape(.rect(cornerRadius: 40))
                                        .padding(7)
                                    ,alignment: .top
                                )
                                .overlay(
                                    LinearGradient(colors: [.c343434.opacity(0), .c494949], startPoint: .top, endPoint: .bottom)
                                        .frame(height: 60)
                                        .overlay(
                                            Text("A joyful kitten runs across a field\nwith a rainbow in the background")
                                                .font(.system(size: 13, weight: .regular))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                        )
                                    ,alignment: .bottom
                                )
                                .clipShape(.rect(cornerRadius: 10))
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 16)
                        
                    }
                    .background(Color.black)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $showVideoChoice) {
            VideoChoice(show: $showVideoChoice) {
                guard let urlString = source.mergeVideo?.previewImageUrl, let url = URL(string: urlString) else { return }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.uiImage = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    @ViewBuilder private var textEditorCustom: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 167)
                .clipped()
                .clipShape(.rect(cornerRadius: 9))
                .onTapGesture {
                    showVideoChoice = true
                }
        } else {
            Text("Video merge")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.c2547413, lineWidth: 2)
                )
                .background(Color.c343434)
                .clipShape(.rect(cornerRadius: 9))
                .frame(height: 167)
                .onTapGesture {
                    showVideoChoice = true
                }
        }
    }
    
    private var buttonStyleText: String {
        switch source.style {
        case "Anime video. " : return "Anime"
        case "Pencil drawing video. ": return "Pencil drawing"
        case "Sepia style video. ": return "Sepia"
        case "Black and white video. ": return "Black and white"
        default:
            return "Style"
        }
    }
    
    private var startFrame: some View {
        FrameImageView(emptyText: "", imageData: $startFrameImage)
    }
    
    private var endFrame: some View {
        FrameImageView(emptyText: "End frame", imageData: $endFrameImage)
    }
    
    func placeholderView(isShow: Bool) -> some View {
        Text(isShow ? "Generation text" : "")
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.white.opacity(0.5))
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct MergeVideoAndImageView_Preview: PreviewProvider {
    
    @State static var screen: TabScreen = .videoImageGenerator
    
    static var previews: some View {
        MergeVideoAndImageView(screen: $screen)
            .environmentObject(Source())
    }
}
