import SwiftUI
import AVFoundation
import UserNotifications

let synthesizer = AVSpeechSynthesizer()
let enAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] //String of english latin alphabet

var PopupViewed="true"

struct ContentView: View {
    @State var letterSize = 130
    @State var appOpenedOnce = !checkFileExist()
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columnWidth) {
                ForEach(enAlphabet, id: \.self) { string in
                    Button(action: {
                        
                        speak(string: string, language: "en-us")
                        
                    }, label: {
                        Text(string).font(.custom("LiberationSerif-Regular", size: 130)).bold().foregroundColor(.red).shadow(color: .black, radius: 5, x: 0, y: 0)
                        
                    })
                }
            }
        }
        .sheet(isPresented: $appOpenedOnce) {
            Text("Welcome to ABCs!").font(.title)
            Text("An educational app to help children connect the written Alphabet with the spoken Alphabet, using the power of an interactive soundboard. Click or touch a letter and hear it!")
            Button("Okay") {
                appOpenedOnce = false
                writeToFile()
            }
        }
    }
    
    var columnWidth: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return Array(repeating: .init(.flexible()), count: 3)
        } else {
            return Array(repeating: .init(.flexible()), count: 6)
        }
    }
}

struct Previews_LtrView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func speak(string: String, language: String) {
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("الصوط خربت")
    }
    
    let utterance = AVSpeechUtterance(string: string.lowercased())
    utterance.voice = AVSpeechSynthesisVoice(language: language)
    
    synthesizer.speak(utterance)
}

func writeToFile() {
    let fileName = "appOpenedOnce.txt"
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(fileName)
        
        do {
            try PopupViewed.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Erreur")
        }
    }
}

func checkFileExist() -> Bool {
    let fileName = "appOpenedOnce.txt"
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    return FileManager.default.fileExists(atPath: fileURL.path)
}
