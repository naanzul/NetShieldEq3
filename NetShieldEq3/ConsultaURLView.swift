import SwiftUI

// MARK: - Modelo simple para la lista de búsquedas recientes

struct BusquedaReciente: Identifiable {
    let id = UUID()
    let url: String
    let estado: EstadoURL
}

enum EstadoURL {
    case peligroso
    case seguro

    var icono: String {
        switch self {
        case .peligroso: return "exclamationmark.triangle.fill"
        case .seguro: return "checkmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .peligroso: return Color(red: 0.98, green: 0.35, blue: 0.35)
        case .seguro: return Color(red: 0.30, green: 0.85, blue: 0.55)
        }
    }

    var etiqueta: String {
        switch self {
        case .peligroso: return "Reportado como phishing"
        case .seguro: return "Sin reportes"
        }
    }
}

// MARK: - Vista principal

struct ConsultarURLView: View {

    @State private var textoURL: String = ""
    @State private var resultadoActual: BusquedaReciente? = nil
    @FocusState private var campoActivo: Bool

    @State private var busquedasRecientes: [BusquedaReciente] = [
        BusquedaReciente(url: "banco-seguro-mx.phishi...", estado: .peligroso),
        BusquedaReciente(url: "promo-envios.mx", estado: .peligroso),
        BusquedaReciente(url: "bbva-actualiza.xyz", estado: .peligroso),
        BusquedaReciente(url: "gooogle.com.mx", estado: .seguro)
    ]

    private let dominiosPeligrosos = [
        "banco-seguro-mx.phishi", "promo-envios.mx", "bbva-actualiza.xyz", "gooogle.com.mx"
    ]

    // Paleta
    private let colorFondoInicio = Color(red: 0.04, green: 0.05, blue: 0.16)
    private let colorFondoFin = Color(red: 0.08, green: 0.09, blue: 0.26)
    private let colorNaranjaClaro = Color(red: 1.00, green: 0.72, blue: 0.20)
    private let colorNaranjaOscuro = Color(red: 0.93, green: 0.55, blue: 0.05)

    private var gradienteNaranja: LinearGradient {
        LinearGradient(colors: [colorNaranjaClaro, colorNaranjaOscuro],
                        startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [colorFondoInicio, colorFondoFin],
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Barra superior
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 28, height: 28)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }

                        Spacer()

                        VStack(spacing: 1) {
                            Text("NETSHIELD")
                                .font(.system(size: 9, weight: .semibold))
                                .tracking(1.2)
                                .foregroundColor(.white.opacity(0.5))
                            Text("Consultar URL")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Image(systemName: "shield.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(gradienteNaranja)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)

                    // Campo de búsqueda + botón verificar (sin cambios de tamaño/posición)
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                            TextField("Pega o escribe la URL a verificar", text: $textoURL)
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                                .focused($campoActivo)
                                .submitLabel(.search)
                                .onSubmit { verificarURL() }

                            if !textoURL.isEmpty {
                                Button(action: { textoURL = ""; resultadoActual = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .font(.system(size: 13))
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)

                        Button(action: verificarURL) {
                            HStack(spacing: 5) {
                                Image(systemName: "bolt.shield.fill")
                                    .font(.system(size: 11, weight: .semibold))
                                Text("Verificar")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(gradienteNaranja)
                            .cornerRadius(10)
                            .shadow(color: colorNaranjaOscuro.opacity(0.4), radius: 6, y: 2)
                        }
                        .disabled(textoURL.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity(textoURL.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1)
                    }
                    .padding(.horizontal)

                    // Resultado de la verificación (sin cambios de tamaño/posición)
                    if let resultado = resultadoActual {
                        HStack(spacing: 8) {
                            Image(systemName: resultado.estado.icono)
                                .font(.system(size: 15))
                                .foregroundColor(resultado.estado.color)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(resultado.url)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Text(resultado.estado.etiqueta)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(resultado.estado.color.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(resultado.estado.color.opacity(0.35), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // Ícono central + texto explicativo
                    if resultadoActual == nil {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(gradienteNaranja.opacity(0.15))
                                    .frame(width: 50, height: 50)
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(gradienteNaranja)
                            }

                            Text("Verifica antes de confiar")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)

                            Text("Pega cualquier enlace sospechoso y comprueba si la comunidad ya lo reportó.")
                                .font(.system(size: 10.5))
                                .foregroundColor(.white.opacity(0.55))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Spacer(minLength: 12)

                    // Búsquedas recientes — más angosta y centrada
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Búsquedas recientes")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(busquedasRecientes.count)")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                        }

                        VStack(spacing: 5) {
                            ForEach(busquedasRecientes) { item in
                                Button {
                                    withAnimation { textoURL = item.url; resultadoActual = item }
                                } label: {
                                    HStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(item.estado.color.opacity(0.15))
                                                .frame(width: 20, height: 20)
                                            Image(systemName: item.estado.icono)
                                                .foregroundColor(item.estado.color)
                                                .font(.system(size: 9))
                                        }

                                        Text(item.url)
                                            .foregroundColor(.black.opacity(0.85))
                                            .font(.system(size: 11, weight: .medium))
                                            .lineLimit(1)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.system(size: 9, weight: .semibold))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(Color.white.opacity(0.96))
                                    .cornerRadius(9)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 340)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 28)

                    // Tarjeta de estadísticas — más angosta y centrada
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("SITIOS EN NUESTRA BASE DE DATOS")
                                .font(.system(size: 8, weight: .semibold))
                                .tracking(0.4)
                                .foregroundColor(.black.opacity(0.55))

                            Text("\(busquedasRecientes.count > 4 ? 12847 + (busquedasRecientes.count - 4) : 12847)")
                                .font(.system(size: 22, weight: .heavy))
                                .foregroundColor(.black)

                            HStack(spacing: 3) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 8, weight: .bold))
                                Text("143 reportes esta semana")
                                    .font(.system(size: 9, weight: .medium))
                            }
                            .foregroundColor(.black.opacity(0.6))
                        }

                        Spacer()

                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black.opacity(0.55))
                    }
                    .padding(12)
                    .background(gradienteNaranja)
                    .cornerRadius(14)
                    .shadow(color: colorNaranjaOscuro.opacity(0.35), radius: 10, y: 5)
                    .frame(maxWidth: 340)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 18)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Lógica simulada de verificación

    private func verificarURL() {
        let limpio = textoURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !limpio.isEmpty else { return }

        let esPeligroso = dominiosPeligrosos.contains { limpio.lowercased().contains($0.lowercased()) }
        let nuevo = BusquedaReciente(url: limpio, estado: esPeligroso ? .peligroso : .seguro)

        withAnimation {
            resultadoActual = nuevo
            busquedasRecientes.removeAll { $0.url == nuevo.url }
            busquedasRecientes.insert(nuevo, at: 0)
        }

        campoActivo = false
    }
}

// MARK: - Preview

struct ConsultarURLView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultarURLView()
    }
}