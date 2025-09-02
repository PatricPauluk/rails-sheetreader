class ProcessSpreadsheetJob
  include Sidekiq::Job

  def perform(filepath)
    puts "Iniciando o processamento da planilha em #{filepath}"

    workbook = Creek::Book.new(filepath)
    sheet = workbook.sheets[0] # Pega a primeira aba da planilha

    # A primeira linha geralmente é o cabeçalho
    header = sheet.rows.first.values
    puts "Cabeçalho da planilha: #{header.inspect}"

    data_rows = sheet.rows.drop(1) # Pula o cabeçalho

    data_rows.each_slice(1000).each do |batch| # Processa em lotes de 1000 linhas
      batch.each do |row|
        row_data = row.values # Extrai os valores da linha atual
        puts "Processando linha: #{row_data.inspect}"

        product_data = Hash[header.zip(row_data)] # Mapeia os dados com o cabeçalho

        # Ajusta os tipos de dados conforme o seu modelo
        product_data["price"] = product_data["price"].to_f
        product_data["quantity"] = product_data["quantity"].to_i

        # Cria o produto no banco de dados
        Product.create!(product_data)
        puts "Produto criado: #{product_data.inspect}"
      end
    end
    puts "Processamento concluído."
  end
end
