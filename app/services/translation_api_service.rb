require "faraday"
require "faraday/retry"

class TranslationApiService
    ENDPOINT = "https://translation.googleapis.com/language/translate/v2"
    USER_AGENT = "translateApp1.0/wisteria"
    def initialize(text)
        @text = text
        @api_key = ENV["translate_api"]
        @connection = Faraday.new(url: ENDPOINT, headers: { "user_agent" => USER_AGENT }) do |f|
            f.request :retry, max: 2, interval: 0.2, backoff_factor: 2
            f.response :json, content_type: /\bjson$/
        end
    end

    def call
        if @api_key.blank?
            Rails.logger.error("APIキーが設定されていません。ENV['translate_api'] を確認してください。")
            return nil
        end
        response = @connection.get("", { key: @api_key, q: @text, target: "en", source: "ja" })
        if response.success?
            response.body.dig("data", "translations", 0, "translatedText")
        else
            Rails.logger.error("API ERROR")
        end
    end
end
