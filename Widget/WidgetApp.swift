//
//  Widget.swift
//  Widget
//
//  Created by Andreas on 2/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetEntryView : View {
    var entry: Provider.Entry
    @State var color1 = UIColor(named: "Primary")
    @State var color2 = UIColor(named: "Secondary")
    @State var textColor = UIColor(.white)
    @State var course = "Math"
    @State var font = "Montserrat-Bold"
    @Environment(\.widgetFamily) var size
    var body: some View {
        switch size {
             case .systemSmall:
                SmallWidgetEntryView(entry: entry)
             case .systemMedium:
                SmallWidgetEntryView(entry: entry)
             case .systemLarge:
                SmallWidgetEntryView(entry: entry)
                  //  LargeWidgetEntryView(entry: entry)
                 
             @unknown default:
                SmallWidgetEntryView(entry: entry)
             }
       
    }
}


import Foundation
import SwiftUI
import Combine

final class UserData: ObservableObject {
    
    public static let shared = UserData()
    
   
    @Published(key: "userID")
    var userID: String = UUID().uuidString
    
    @Published(key: "name")
    var name: String = ""
    
    @Published(key: "favWorkout")
    var favWorkout: String = "Situps"
    
    @Published(key: "isFirstRun")
    var isFirstRun: Bool = true
    
    @Published(key: "isOnboardingCompleted")
    var isOnboardingCompleted: Bool = false
  
    @Published(key: "streak")
    var streak: Int = 0
    
    @Published(key: "date")
    var date: String = ""
}

import Foundation
import CryptoKit

extension UserDefaults {
    
    public struct Key {
        public static let lastFetchDate = "lastFetchDate"
    }
    
    @objc dynamic public var lastFetchDate: Date? {
        return object(forKey: Key.lastFetchDate) as? Date
    }
}

import Foundation
import Combine

extension Published {
    
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        projectedValue.receive(subscriber: Subscribers.Sink(receiveCompletion: { (_) in
            ()
        }, receiveValue: { (value) in
            UserDefaults.standard.set(value, forKey: key)
        }))
    }
    
}



@main
struct WidgetApp: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
struct SmallWidgetEntryView : View {
    @EnvironmentObject var userData: UserData
   
    var entry: Provider.Entry
   
    @State var day = 0.0
       
    
  
    @State var color1 = UIColor(.blue)
    @State var color2 = UIColor(Color(.systemBlue))
    @State var textColor = UIColor(.white)
    @State var loaded = false
    @State var workout = "Today"
    @State var font  = "Montserrat-Bold"
    @State var ready = false
    var body: some View {
    ZStack {
        Color.clear
            .onAppear() {
               
               
                let container = UserDefaults(suiteName:"group.com.studeo")
                color1 = container?.colorForKey(key: "color1M") ?? color1
                color2 = container?.colorForKey(key: "color2M") ?? color2
                textColor = container?.colorForKey(key: "textColor") ?? textColor
                workout = container?.string(forKey: "workout") ?? "Pushups"
                day = container?.double(forKey: "day") ?? 0.0
                ready = true
            }
        if ready {
            LinearGradient(gradient: Gradient(colors: [Color(color1 ?? .blue), Color(color2 ?? .systemBlue)]), startPoint: .leading, endPoint: .bottomTrailing)
        VStack {
            HStack {
            Image(systemName: "figure.walk")
                .font(.system(size: 24))
                .foregroundColor(Color(textColor))
                Spacer()
            } .padding(.top)
            Spacer()
          
            HStack {
            Text("\(day)")
                .font(.custom(font, size: 48, relativeTo: .title))
                .bold()
                .foregroundColor(Color(textColor))
                
                Spacer()
            }
            HStack {
            Text("\(workout)")
                .font(.custom(font, size: 12, relativeTo: .title))
                .bold()
                .foregroundColor(Color(textColor))
                
                Spacer()
            } .padding(.bottom)
            Spacer()
         
        } .padding()
        }
    }
}
}

extension UserDefaults {
 func colorForKey(key: String) -> UIColor? {
  var color: UIColor?
  if let colorData = data(forKey: key) {
   color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
  }
  return color
 }

 func setColor(color: UIColor?, forKey key: String) {
  var colorData: NSData?
   if let color = color {
    colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
  }
  set(colorData, forKey: key)
 }

}
