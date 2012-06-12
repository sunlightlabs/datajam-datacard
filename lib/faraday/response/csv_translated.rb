require 'faraday'

class CsvPreview
  attr_accessor :rows, :headers

  def initialize
    @rows, @headers = [], []
  end
end

module Faraday
  # Public: Faraday's middleware which translates decoded response 
  # body into a cvs table.
  class Response::CsvTranslated < Response::Middleware
    def call(env)
      @app.call(env).on_complete do |finished_env|
        if finished_env[:data].kind_of?(Array)
          finished_env[:csv] = translate_data_to_csv(env[:data])
        end
      end
    end

    private

    def translate_data_to_csv(data)
      csv = CsvPreview.new
      data.each { |row| csv.headers |= row.keys }
      csv.headers.sort!

      data.each do |row|
        csv.rows << csv.headers.inject([]) { |vals,h| vals << row[h] }
      end

      csv
    end
  end
end

Faraday::Response.register_middleware :csv_translated => Faraday::Response::CsvTranslated
