class ProcessSpreadsheetJob
  include Sidekiq::Job

  def perform(filepath)
    puts "Iniciando o processamento da planilha em #{filepath}"

    workbook = Creek::Book.new(filepath)
    sheet = workbook.sheets[0] # Pega a primeira aba da planilha

    # O Creek itera linha por linha
    sheet.rows.each do |row|
      puts "Processando linha: #{row.inspect}"
    end

    puts "Processamento concluído."
  end
end
