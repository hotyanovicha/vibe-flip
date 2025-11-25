import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Month Header (Simplified for MVP)
                Text(DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1].capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Days Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Placeholder for days (Simplified logic for demo)
                    // In a real app, we would calculate the exact days of the month
                    ForEach(1...30, id: \.self) { day in
                        DayCell(day: day)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title2)
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DayCell: View {
    let day: Int
    let isOpened: Bool
    let isToday: Bool
    
    init(day: Int) {
        self.day = day
        let today = Calendar.current.component(.day, from: Date())
        self.isToday = day == today
        
        // Check if this specific day was opened (mock logic for demo)
        // In real app, construct Date object and check HistoryManager
        self.isOpened = day < today || (day == today && HistoryManager.shared.isOpened(date: Date()))
    }
    
    var body: some View {
        VStack {
            if isOpened {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 30, height: 30)
                    Text("\(day)")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            } else if isToday {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 30, height: 30)
                    Text("\(day)")
                        .foregroundColor(.black)
                        .font(.caption)
                }
            } else {
                Text("\(day)")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }
}
