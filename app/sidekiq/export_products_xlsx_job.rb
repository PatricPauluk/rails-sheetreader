require "rubyXL"
require "fileutils"

class ExportProductsXlsxJob
  include Sidekiq::Job

  def perform
    workbook = RubyXL::Workbook.new
    sheet = workbook[0]
    sheet.sheet_name = "Products"

    header = [ "ID", "Nome", "Preço", "Quantidade" ]
    sheet.add_cell(0, 0, header[0])
    sheet.add_cell(0, 1, header[1])
    sheet.add_cell(0, 2, header[2])
    sheet.add_cell(0, 3, header[3])

    index = 1
    Product.in_batches(of: 1000).each do |batch|
      batch.each do |product|
        puts "Exportando produto ID #{product.id}, Nome: #{product.name}, Preço: #{product.price}, Quantidade: #{product.quantity}"
        sheet.add_cell(index, 0, product.id)
        sheet.add_cell(index, 1, product.name)
        sheet.add_cell(index, 2, product.price)
        sheet.add_cell(index, 3, product.quantity)
        index += 1
      end
    end

    filename = "products_#{Time.now.to_i}.xlsx"
    filepath = Rails.root.join("public", "exports", filename)
    FileUtils.mkdir_p(File.dirname(filepath)) unless Dir.exist?(File.dirname(filepath))
    workbook.write(filepath)

    puts "Exportação concluída. Arquivo salvo em #{filepath}"
  rescue => e
    puts "Erro durante a exportação: #{e.message}"
  end
end
