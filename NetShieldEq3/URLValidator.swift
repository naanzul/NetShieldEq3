//
//  URLValidator.swift
//  NetShieldEq3
//
//  Created by Rodrigo Mendoza on 14/09/26.
//

//
//  URLValidator.swift
//  NetShieldEq3
//
//  Utilidad de validación de URLs, separada de la vista para que sea
//  reutilizable en cualquier otra pantalla que necesite el mismo
//  chequeo (por ejemplo, si más adelante se agrega edición de
//  reportes o una pantalla de búsqueda por URL).
//

import Foundation

/// Valida si una cadena de texto tiene el formato mínimo de una URL
/// utilizable (esquema + host), sin verificar que el sitio exista
/// realmente ni hacer ninguna petición de red.
enum URLValidator {

    /// Revisa si `texto` tiene forma de URL válida.
    ///
    /// Reglas actuales de validación:
    /// - Un texto vacío se considera "válido" (para no marcar error
    ///   antes de que el usuario empiece a escribir).
    /// - Debe poder interpretarse como `URLComponents`.
    /// - Debe tener un esquema (`http`, `https`, etc.) y un host
    ///   (`banco-falso.com`, por ejemplo).
    ///
    /// - Parameter texto: El texto ingresado por el usuario en el
    ///   campo de "URL o sitio sospechoso".
    /// - Returns: `true` si el texto está vacío o tiene forma válida
    ///   de URL; `false` si tiene contenido pero no es una URL bien
    ///   formada.
    static func esValida(_ texto: String) -> Bool {
        guard !texto.isEmpty else { return true }

        guard let componentes = URLComponents(string: texto) else {
            return false
        }

        return componentes.scheme != nil && componentes.host != nil
    }
}
