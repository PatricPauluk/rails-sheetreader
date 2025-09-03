require "csv"

class ExportProductsCsvJob
  include Sidekiq::Job

  def perform
    puts "Iniciando a exportação para CSV"

    filename = "products_#{Time.now.to_i}.csv"
    filepath = Rails.root.join("public", "exports", "products_#{Time.now.to_i}.csv")

    CSV.open(filepath, "wb") do |csv|
      csv << [ "ID", "Nome", "Preço", "Quantidade" ]


      Product.in_batches(of: 1000).each do |batch|
        batch.each do |product|
          puts "Exportando produto ID #{product.id}, Nome: #{product.name}, Preço: #{product.price}, Quantidade: #{product.quantity}"
          csv << [ product.id, product.name, product.price, product.quantity ]
        end
      end
    end

    puts "Exportação para CSV concluída. Arquivo salvo em #{filename}"
  end
end
