import SwiftUI

struct VideoImageGenerator: View {
    @EnvironmentObject var source: Source
    
    @Binding var screen: TabScreen
    @State var text = ""
    @State var startFrameImage: Data?
    @State var endFrameImage: Data?
    @State var aspectRatio: String = "16:9"
    @State var buttonText = "Styles"
    
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
                            Text("Video Image Generator")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 28)
                                
                            textEditorCustom
                                .padding(.top, 20)
                            HStack(spacing: 24) {
                                startFrame
                                endFrame
                            }
                            .padding(.top, 15)
                            
                            Button {
                                source.videoEndFrame = nil
                                source.videoStartFrame = nil
                                if startFrameImage == nil && endFrameImage == nil {
                                    source.videoGenerationText = text
                                } else if startFrameImage != nil && endFrameImage == nil {
                                    print("Start frame")
                                    source.videoGenerationText = text
                                    source.videoStartFrame = startFrameImage
                                } else if startFrameImage == nil && endFrameImage != nil {
                                    source.videoGenerationText = text
                                    source.videoEndFrame = endFrameImage
                                } else {
                                    source.videoGenerationText = text
                                    source.videoEndFrame = endFrameImage
                                    source.videoStartFrame = startFrameImage
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
                                .disabled(text == "")
                                .opacity(text == "" ? 0.5 : 1)
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
    }
    
    @ViewBuilder private var textEditorCustom: some View {
        if #available(iOS 16.0, *) {
            TextEditor(text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11))
                .background(
                    placeholderView(isShow: text == "")
                )
                .padding(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.c2547413, lineWidth: 2)
                )
                .background(Color.c343434)
                .clipShape(.rect(cornerRadius: 9))
                .frame(height: 167)
        } else {
            TextEditor(text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11))
                .background(
                    placeholderView(isShow: text == "")
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.c2547413, lineWidth: 2)
                )
                .background(Color.c343434)
                .clipShape(.rect(cornerRadius: 9))
                .frame(height: 167)
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
        FrameImageView(emptyText: "Start frame", imageData: $startFrameImage)
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

struct VideoImageGenerator_Preview: PreviewProvider {
    
    @State static var screen: TabScreen = .videoImageGenerator
    
    static var previews: some View {
        VideoImageGenerator(screen: $screen)
            .environmentObject(Source())
    }
}
