import SwiftUI

// MARK: - Models
struct Plant: Identifiable {
    let id = UUID()
    var name: String
    var species: String
    var soilMoisture: Double // Da 0.0 a 1.0
    var lightLevel: Double // Da 0.0 a 1.0
    var temperature: Double // Celsius
    var lastWatered: Date
    var imageName: String // Nome immagine o systemName
}

let mockPlants = [
    Plant(
        name: "Gnorman The Cheed",
        species: "Avocado",
        soilMoisture: 0.42, // 42%
        lightLevel: 0.78, // 78%
        temperature: 24.5,
        lastWatered: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        imageName: "leaf.fill"
    )
]

// MARK: - Homepage View
struct HomepageView: View {
    @State private var plants: [Plant] = mockPlants
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Le mie care piantine 🌱")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    ForEach(plants) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            PlantCardView(plant: plant)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("KeepMeWet")
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - Plant Card View
struct PlantCardView: View {
    var plant: Plant
    
    var body: some View {
        HStack(spacing: 16) {
            // Icona Pianta
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 70, height: 70)
                
                Image(systemName: plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.green)
            }
            
            // Dati Principali
            VStack(alignment: .leading, spacing: 6) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(plant.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Label("\(Int(plant.soilMoisture * 100))%", systemImage: "drop.fill")
                        .font(.caption)
                        .foregroundColor(moistureColor(for: plant.soilMoisture))
                    
                    Label("\(Int(plant.lightLevel * 100))%", systemImage: "sun.max.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray.opacity(0.5))
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // Un piccolo helper per cambiare colore in base all'umidità
    private func moistureColor(for value: Double) -> Color {
        if value < 0.3 { return .red }
        if value < 0.6 { return .blue }
        return .green
    }
}

// MARK: - Plant Detail View
struct PlantDetailView: View {
    var plant: Plant
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Immagine
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 150, height: 150)
                    
                    Image(systemName: plant.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.green)
                }
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text(plant.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(plant.species)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // Statistiche (Sensori)
                HStack(spacing: 20) {
                    StatRingView(
                        title: "Umidità",
                        value: plant.soilMoisture,
                        color: .blue,
                        iconName: "drop.fill"
                    )
                    
                    StatRingView(
                        title: "Luce",
                        value: plant.lightLevel,
                        color: .yellow,
                        iconName: "sun.max.fill"
                    )
                }
                .padding(.horizontal)
                
                // Card Altre Info
                VStack(spacing: 16) {
                    InfoRow(icon: "thermometer", title: "Temperatura ideale", value: "\(String(format: "%.1f", plant.temperature))°C", color: .red) // Valore statico
                    
                    Divider()
                    
                    let formatter = RelativeDateTimeFormatter()
                    InfoRow(icon: "clock.fill", title: "Ultima innaffiatura", value: formatter.localizedString(for: plant.lastWatered, relativeTo: Date()), color: .blue)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Suggerimento Actionable
                VStack(alignment: .leading, spacing: 10) {
                    Text("Suggerimento per Gnorman")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(adviceText(moisture: plant.soilMoisture))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Dettagli Pianta")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func adviceText(moisture: Double) -> String {
        if moisture < 0.3 {
            return "Il terreno è abbastanza secco, Gnorman ha molta sete! Dagli un po' d'acqua appena possibile 💧."
        } else if moisture > 0.7 {
            return "Il terreno è molto umido. Aspetta un po' prima di innaffiare di nuovo o rischi dei marciumi radicali! 🚫💧"
        } else {
            return "Le condizioni sono ottimali. Gnorman sta benissimo! ✨"
        }
    }
}

// MARK: - Componenti di Supporto

struct StatRingView: View {
    var title: String
    var value: Double
    var color: Color
    var iconName: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 10)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(value))
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: value)
                
                VStack(spacing: 4) {
                    Image(systemName: iconName)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                    
                    Text("\(Int(value * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct InfoRow: View {
    var icon: String
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .cornerRadius(8)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
            }
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview
struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
