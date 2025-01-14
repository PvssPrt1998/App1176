import SwiftUI
import StoreKit

struct StylesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.openURL) var openURL
    @EnvironmentObject var source: Source
    
    @State var style: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.c606060.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Back")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
                    }
                    Text("Styles")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                        .frame(height: 52)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: 0) {
                    Text("Style")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.horizontal, 32)
                    Text("Video generation style")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .padding(.horizontal, 32)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            VStack(spacing: 8) {
                                Image("blackAndWhite")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 147, height: 147)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style == "Black and white video. " ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        if style == "Black and white video. " {
                                            style = ""
                                            source.style = ""
                                        } else {
                                            style = "Black and white video. "
                                            source.style = "Black and white video. "
                                        }
                                    }
                                Text("Black and white")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            VStack(spacing: 8) {
                                Image("anime")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 147, height: 147)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style == "Anime video. " ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        if style == "Anime video. " {
                                            style = ""
                                            source.style = ""
                                        } else {
                                            style = "Anime video. "
                                            source.style = "Anime video. "
                                        }
                                    }
                                Text("Anime style")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            VStack(spacing: 8) {
                                Image("sepia")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 147, height: 147)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style == "Sepia style video. " ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        if style == "Sepia style video. " {
                                            style = ""
                                            source.style = ""
                                        } else {
                                            style = "Sepia style video. "
                                            source.style = "Sepia style video. "
                                        }
                                    }
                                Text("Sepia")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            VStack(spacing: 8) {
                                Image("drawing")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 147, height: 147)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style == "Pencil drawing video. " ? Color.c2547413 : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        if style == "Pencil drawing video. " {
                                            style = ""
                                            source.style = ""
                                        } else {
                                            style = "Pencil drawing video. "
                                            source.style = "Pencil drawing video. "
                                        }
                                    }
                                Text("Pencil drawing")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 16)
                            .padding(.horizontal, 32)
                        }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .frame(maxHeight: .infinity)
                .background(Color.black)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct StylesView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .main
    
    static var previews: some View {
        StylesView(style: "")
            .environmentObject(Source())
    }
    
    
}
