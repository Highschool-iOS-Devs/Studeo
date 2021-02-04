//
//  StudeoWidget.swift
//  StudeoWidget
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
struct SmallWidgetEntryView : View {
   
   
    var entry: Provider.Entry
   
    @State var day = 0
    @State var color1 = UIColor(Color("Primary"))
    @State var color2 = UIColor(Color("Secondary"))
    @State var textColor = UIColor(.white)
    @State var loaded = false
   
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
              
                day = Int(container?.double(forKey: "day") ?? 0.0)
                ready = true
            }
        if ready {
            LinearGradient(gradient: Gradient(colors: [Color(color1 ), Color(color2)]), startPoint: .leading, endPoint: .bottomTrailing)
        VStack {
            HStack {
            Image(systemName: "doc")
                .font(.system(size: 20))
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
            VStack {
            HStack {
            Text("Hours Studied")
                .font(.custom(font, size: 12, relativeTo: .callout))
                .bold()
                .foregroundColor(Color(textColor))
                
                Spacer()
            }
                HStack {
                Text("Today")
                    .font(.custom(font, size: 12, relativeTo: .callout))
                    .bold()
                    .foregroundColor(Color(textColor))
                    
                    Spacer()
                } .padding(.bottom)
            }
            Spacer()
         
        } .padding()
        }
    }
}
}

struct StudeoWidgetEntryView : View {
    var entry: Provider.Entry
   
    @Environment(\.widgetFamily) var size
    var body: some View {
        switch size {
             case .systemSmall:
                SmallWidgetEntryView(entry: entry)
             case .systemMedium:
                SmallWidgetEntryView(entry: entry)
             case .systemLarge:
                 
                SmallWidgetEntryView(entry: entry)
                 
             @unknown default:
                SmallWidgetEntryView(entry: entry)
             }
       
    }
}

@main
struct StudeoWidget: Widget {
    let kind: String = "StudeoWidget"
@State var myDescriptionString = "Hello"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StudeoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description(myDescriptionString)
    }
}

struct StudeoWidget_Previews: PreviewProvider {
    static var previews: some View {
        StudeoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
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
