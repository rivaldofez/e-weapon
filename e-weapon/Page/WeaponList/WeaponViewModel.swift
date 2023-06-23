//
//  WeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 14/06/23.
//

import UIKit
import xlsxwriter


class WeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    @Published var weapons: [Weapon] = []
    @Published var documentItemsExport: [Any] = []
    
    func fetchWeapon(){
        
        self.weapons = databaseManager.fetchWeapon()
            .map {
                return Weapon(id: $0.id, name: $0.name, addedAt: $0.addedAt, price: $0.price, stock: $0.stock, imageUrl: $0.imageUrl, location: $0.location, status: $0.status)
            }
    }
    
    func filterSearch(query: String){
        if query.isEmpty {
            fetchWeapon()
        } else {
            fetchWeapon()
            self.weapons = self.weapons.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    func deleteWeapon(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        self.weapons.removeAll { $0.id == id}
        print(weapons)
        print(weapons.count)
        
        databaseManager.deleteWeapon(id: id, completion: completion)
    }
    
    func generateFileExportName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM"
        return "Weapon \(formatter.string(from: Date.now))"
    }
    
    private func generateDocDirectory() -> String{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)
        return dirPaths[0].appending("/")
    }
    
    func generateExcelFile(){
        let filename = generateFileExportName() + ".xlsx"
                
        var workbook: UnsafeMutablePointer<lxw_workbook>?
        var worksheet: UnsafeMutablePointer<lxw_worksheet>?
        var format_header: UnsafeMutablePointer<lxw_format>?
        var format_1: UnsafeMutablePointer<lxw_format>?
        
        
        
        var destination_path = generateDocDirectory()
        destination_path.append(filename)
        
        workbook = workbook_new(destination_path)
        worksheet = workbook_add_worksheet(workbook, nil)
        
        // Add style
        format_header = workbook_add_format(workbook)
        format_set_bold(format_header)
        format_1 = workbook_add_format(workbook)
        format_set_bg_color(format_1, 0xDDDDDD)
        
        //cell size
        let cell_width: Double = 50
        let cell_height: Double = 50
        var writingLine: UInt32 = 0
        
        //build header
        writingLine = 0
        let format = format_header
        format_set_bold(format)
        worksheet_write_string(worksheet, writingLine, 0, "No", format)
        worksheet_write_string(worksheet, writingLine, 1, "Image", format)
        worksheet_write_string(worksheet, writingLine, 2, "Name", format)
        worksheet_write_string(worksheet, writingLine, 3, "Price", format)
        worksheet_write_string(worksheet, writingLine, 4, "Stock", format)
        worksheet_write_string(worksheet, writingLine, 5, "Status", format)
        worksheet_write_string(worksheet, writingLine, 6, "Location", format)
        
        for weapon in weapons {
            writingLine += 1
            
            worksheet_write_string(worksheet, writingLine, 0, "\(writingLine - 1)", nil)
            worksheet_write_string(worksheet, writingLine, 2, weapon.name, nil)
            worksheet_write_number(worksheet, writingLine, 3, weapon.price, nil)
            worksheet_write_number(worksheet, writingLine, 4, Double(weapon.stock), nil)
            worksheet_write_string(worksheet, writingLine, 5, weapon.status, nil)
            worksheet_write_string(worksheet, writingLine, 6, weapon.location, nil)
            
        }
        
        for (index, weapon) in weapons.enumerated() {
            let row = UInt32(index + 1)
            worksheet_set_row(worksheet, row, Double(cell_height), nil)
            let image = Helper.getImage(imageUrl: weapon.imageUrl)
            var options = lxw_image_options()
            
            // Pixel size is Point size x image scale
            let imageScale = image.scale
            let uiimageSizeInPixel = (Double(image.size.width * imageScale), Double(image.size.height * imageScale))
            let scale = Helper.minRatio(left: (cell_width, cell_height),
                                        right: uiimageSizeInPixel )
            options.x_offset = 10
            options.y_offset = 1
            options.x_scale = scale
            options.y_scale = scale
            options.object_position = 1
            
            if let nsdata = image.jpegData(compressionQuality: 0.9) as NSData? {
                let buffer = Helper.getArrayOfBytesFromImage(imageData: nsdata)
                worksheet_insert_image_buffer_opt(worksheet, row, 1, buffer, buffer.count, &options)
            }
            
        }
        workbook_close(workbook)
        
        let docURL = URL(fileURLWithPath: destination_path)
        self.documentItemsExport = [docURL as Any]
    }
    
}
