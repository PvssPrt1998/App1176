import SwiftUI

struct GenerationChoice: View {
    @EnvironmentObject var source: Source
    @Binding var screen: TabScreen
    
    @State var text = ""
    
    var body: some View {
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
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 28)
                            
                        Image("kitty")
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                LinearGradient(colors: [.c494949.opacity(0), .c282828], startPoint: .top, endPoint: .bottom)
                                    .padding(.top, 56)
                            )
                            .overlay(
                                Text("Transform your photos into stunning\nvideos using AI. Experience the seamless\nmagic of transitioning from photo to\nvideo!")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                ,alignment: .bottom
                            )
                            .padding(.top, 20)
                        
                        Button {
                            withAnimation {
                                screen = .videoImageGenerator
                            }
                        } label: {
                            HStack {
                                Image(systemName: "wand.and.stars.inverse")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                                
                                Text("Generate")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(Color.c2547413)
                            .clipShape(.rect(cornerRadius: 40))
                        }
                        .padding(.top, 5)
                        
                        Text("AI Hug Video Generator")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 28)
                            
                        Image("grandparents")
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                LinearGradient(colors: [.c494949.opacity(0), .c282828], startPoint: .top, endPoint: .bottom)
                                    .padding(.top, 56)
                            )
                            .overlay(
                                Text("Create a hug video from two photos using an AI video generator")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 14)
                                ,alignment: .bottom
                            )
                            .padding(.top, 20)
                        
//                        Button {
//                            
//                        } label: {
//                            HStack {
//                                Image(systemName: "wand.and.stars.inverse")
//                                    .font(.system(size: 15, weight: .regular))
//                                    .foregroundColor(.white)
//                                
//                                Text("Generate")
//                                    .font(.system(size: 15, weight: .regular))
//                                    .foregroundColor(.white)
//                            }
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 34)
//                            .background(Color.c2547413)
//                            .clipShape(.rect(cornerRadius: 40))
//                        }
//                        .padding(.top, 5)
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

struct GenerationChoice_Preview: PreviewProvider {
    
    @State static var screen: TabScreen = .generationChoice
    
    static var previews: some View {
        GenerationChoice(screen: $screen)
            .environmentObject(Source())
    }
    
    
}
