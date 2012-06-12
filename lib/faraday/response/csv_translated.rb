require 'faraday'

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
      columns = {}
      row_num = 0

      data.each do |row|
        row.keys.sort.each do |k|
          columns[k] ||= []
          columns[k][row_num] = row[k]
        end

        row_num += 1
      end

      columns
    end
  end
end

Faraday::Response.register_middleware :csv_translated => Faraday::Response::CsvTranslated
