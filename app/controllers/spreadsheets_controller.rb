class SpreadsheetsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    uploaded_file = params[:file]

    # Salva o arquivo temporariamente
    temp_file_path = Rails.root.join("tmp", uploaded_file.original_filename)
    File.open(temp_file_path, "wb") do |file|
      file.write(uploaded_file.read)
    end

    # Chama o job para processar em segundo plano
    ProcessSpreadsheetJob.perform_async(temp_file_path.to_s)

    flash[:notice] = "Sua planilha está sendo processada em segundo plano. Atualize a página em alguns instantes."
    redirect_to new_spreadsheet_path
  end

  def export_xlsx
    # Aciona o job para exportar em XLSX
    ExportProductsXlsxJob.perform_async
    flash[:notice] = "A exportação para XLSX está sendo processada em segundo plano."
    redirect_to new_spreadsheet_path
  end

  def export_csv
    # Aciona o job para exportar em CSV
    ExportProductsCsvJob.perform_async
    flash[:notice] = "A exportação para CSV está sendo processada em segundo plano."
    redirect_to new_spreadsheet_path
  end
end
