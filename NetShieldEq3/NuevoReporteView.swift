//
//  File.swift
//  NetShieldEq3
//
//  Created by Rodrigo Mendoza on 11/09/26.
//

//
//  NuevoReporteView.swift
//  NetShieldEq3
//
//  Pantalla "Nuevo reporte" reconstruida desde el diseño de Figma.
//

import SwiftUI

// MARK: - Modelo simple de subcategoría (para los "chips")

struct Subcategoria: Identifiable {
    let id = UUID()
    let nombre: String
    let icono: String        // SF Symbol
    let color: Color
}

// MARK: - Vista principal

struct NuevoReporteView: View {

    // Estados del formulario (equivalen a lo que en UIKit
    // hubieras guardado en variables del ViewController)
    @State private var url: String = ""
    @State private var descripcion: String = ""
    @State private var subcategoriaSeleccionada: String? = nil
    @State private var imagenEvidencia: UIImage? = nil
    @State private var mostrarSelectorImagen = false
    @Environment(\.dismiss) private var dismiss

    let subcategorias: [Subcategoria] = [
        Subcategoria(nombre: "Banco", icono: "creditcard.fill", color: .blue.opacity(0.2)),
        Subcategoria(nombre: "Compra en línea", icono: "bag.fill", color: .orange.opacity(0.2)),
        Subcategoria(nombre: "Escuela", icono: "book.fill", color: .green.opacity(0.2)),
        Subcategoria(nombre: "Red social", icono: "person.fill", color: .purple.opacity(0.2)),
        Subcategoria(nombre: "Otro", icono: "ellipsis", color: .gray.opacity(0.3))
    ]

    // Layout de 2 columnas para los chips (como en tu Figma)
    let columnas = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {

            // ---------- HEADER (equivalente a tu "Header View" en UIKit) ----------
            headerView

            // ---------- CONTENIDO CON SCROLL (equivalente a tu ScrollView + Card) ----------
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Card gris contenedora del formulario
                    VStack(alignment: .leading, spacing: 20) {

                        campoURL
                        selectorSubcategoria
                        zonaEvidencia
                        campoDescripcion
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }

            // ---------- BOTÓN FIJO ABAJO ----------
            botonEnviar
        }
        .background(Color(red: 0.03, green: 0.05, blue: 0.2).ignoresSafeArea(edges: .top))
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }

            Spacer()

            VStack(spacing: 2) {
                Text("NetShield")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text("Nuevo reporte")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }

            Spacer()

            // Reemplaza "shield.checkerboard" por el nombre de tu logo
            // real una vez que lo importes a Assets.xcassets
            Image(systemName: "shield.checkerboard")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 20)
    }

    // MARK: - Campo URL

    private var campoURL: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("URL o sitio sospechoso")
                .font(.headline)

            HStack {
                Image(systemName: "link")
                    .foregroundColor(.gray)
                TextField("", text: $url)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)

            Text("Ej: https://banco-falso.com · http://sorteo-premio.xyz")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Subcategoría (los "chips")

    private var selectorSubcategoria: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Subcategoría")
                .font(.headline)

            LazyVGrid(columns: columnas, spacing: 12) {
                ForEach(subcategorias) { sub in
                    Button {
                        subcategoriaSeleccionada = sub.nombre
                    } label: {
                        HStack {
                            Image(systemName: sub.icono)
                            Text(sub.nombre)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(sub.color)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    subcategoriaSeleccionada == sub.nombre ? Color.black : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }

    // MARK: - Zona de evidencia (imagen)

    private var zonaEvidencia: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evidencia")
                .font(.headline)
            Text("Capturas de pantalla del sitio sospechoso")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button {
                mostrarSelectorImagen = true
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .foregroundColor(.gray)
                    .frame(height: 180)
                    .overlay(
                        Group {
                            if let imagen = imagenEvidencia {
                                Image(uiImage: imagen)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                    )
            }
            .sheet(isPresented: $mostrarSelectorImagen) {
                // Aquí conectarías PHPickerViewController vía
                // UIViewControllerRepresentable si necesitas selector real
                Text("Selector de imagen (pendiente de implementar)")
                    .padding()
            }
        }
    }

    // MARK: - Descripción

    private var campoDescripcion: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Describe brevemente qué pasó")
                .font(.headline)

            TextEditor(text: $descripcion)
                .frame(height: 100)
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        }
    }

    // MARK: - Botón enviar

    private var botonEnviar: some View {
        Button {
            enviarReporte()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Enviar reporte")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .padding(.top, 10)
        .background(Color(red: 0.03, green: 0.05, blue: 0.2))
    }

    // MARK: - Acción de envío (conecta aquí tu llamada a la API)

    private func enviarReporte() {
        // TODO: conectar con tu backend (Networking/APIClient.swift)
        print("Reporte enviado: \(url), \(subcategoriaSeleccionada ?? "sin categoría"), \(descripcion)")
    }
}

// MARK: - Preview (solo para Xcode Canvas, no afecta la app)

struct NuevoReporteView_Previews: PreviewProvider {
    static var previews: some View {
        NuevoReporteView()
    }
}
