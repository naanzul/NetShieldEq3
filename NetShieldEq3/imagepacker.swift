//
//  ImagePicker.swift
//  NetShieldEq3
//
//  Envuelve PHPickerViewController (UIKit) para poder usarlo dentro
//  de una jerarquía de vistas SwiftUI, ya que SwiftUI no trae un
//  selector de fotos nativo propio.
//

import SwiftUI
import PhotosUI

/// Selector de imágenes de la librería de fotos del dispositivo.
///
/// SwiftUI no tiene un componente propio para elegir imágenes, así que
/// este `struct` actúa como puente hacia `PHPickerViewController`
/// (que sí es de UIKit) usando el protocolo `UIViewControllerRepresentable`.
///
/// Uso típico dentro de un `.sheet`:
/// ```swift
/// .sheet(isPresented: $mostrarSelector) {
///     ImagePicker(imagenSeleccionada: $miImagen)
/// }
/// ```
struct ImagePicker: UIViewControllerRepresentable {

    /// Binding hacia la vista que presenta el picker. Cuando el usuario
    /// elige una foto, esta variable se actualiza automáticamente y
    /// la vista padre reacciona al cambio.
    @Binding var imagenSeleccionada: UIImage?

    /// Permite cerrar el picker desde el Coordinator una vez que el
    /// usuario terminó de seleccionar (o canceló).
    @Environment(\.dismiss) private var dismiss

    /// Crea y configura el `PHPickerViewController` que se va a mostrar.
    ///
    /// - Parameter context: Contexto que SwiftUI provee automáticamente,
    ///   incluye el `Coordinator` creado en `makeCoordinator()`.
    /// - Returns: El controlador de UIKit ya configurado para elegir
    ///   una sola imagen.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images        // Solo muestra fotos, no videos
        config.selectionLimit = 1      // Solo permite elegir una imagen

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    /// Requerido por el protocolo `UIViewControllerRepresentable`.
    /// No se necesita actualizar nada dinámicamente en este picker,
    /// por eso el cuerpo queda vacío.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Sin lógica de actualización necesaria.
    }

    /// Crea el `Coordinator`, que es quien realmente recibe los
    /// eventos del picker (como delegate de UIKit) y los traduce
    /// de vuelta hacia SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Puente entre el mundo de delegates de UIKit (`PHPickerViewControllerDelegate`)
    /// y el `Binding` de SwiftUI.
    ///
    /// Es necesario porque `UIViewControllerRepresentable` no puede
    /// recibir directamente callbacks de UIKit; siempre se hace a
    /// través de un objeto `Coordinator` como este.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        /// Referencia al `ImagePicker` que lo creó, para poder
        /// actualizar su `imagenSeleccionada`.
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        /// Se llama automáticamente cuando el usuario termina de
        /// interactuar con el picker (eligió una foto o canceló).
        ///
        /// - Parameters:
        ///   - picker: El controlador que disparó el evento.
        ///   - results: Arreglo con la(s) foto(s) elegidas. Como
        ///     `selectionLimit = 1`, aquí solo esperamos un elemento
        ///     como máximo.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Cierra el picker sin importar si el usuario eligió
            // una foto o canceló.
            parent.dismiss()

            // Si no hay resultados (el usuario canceló) o el resultado
            // no puede cargarse como UIImage, no hacemos nada más.
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }

            // Cargar la imagen es asíncrono porque puede tardar
            // (foto en iCloud, tamaño grande, etc.), por eso se usa
            // un closure en vez de retorno directo.
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                // loadObject regresa en un hilo secundario; hay que
                // regresar al hilo principal antes de tocar @Binding,
                // porque actualizar la UI desde otro hilo causa
                // comportamiento indefinido o crashes.
                DispatchQueue.main.async {
                    self.parent.imagenSeleccionada = image as? UIImage
                }
            }
        }
    }
}
