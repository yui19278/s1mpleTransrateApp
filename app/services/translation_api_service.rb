require "faraday"
require "faraday/retry"

class TranslationApiService
    ENDPOINT = "https://translation.googleapis.com/language/translate/v2"
    USER_AGENT = "translateApp1.0/wisteria"
    def initialize(text)
        @text = text
        # APIキーはRails Credentials優先。ENVは統一名 `TRANSLATE_API_KEY` のみ許可。
        @api_key = begin
            if defined?(Rails)
                creds = Rails.application.credentials
                (creds.dig(:translate_api, :key).presence || creds[:translate_api_key].presence)
            end
        end
        @api_key ||= ENV["TRANSLATE_API_KEY"].presence
        @connection = Faraday.new(url: ENDPOINT, headers: { "User-Agent" => USER_AGENT }) do |f|
            f.request :retry, max: 2, interval: 0.2, backoff_factor: 2
            # Google returns e.g. "application/json; charset=UTF-8"; match any json content type
            f.response :json, content_type: /json/i
        end
    end

    def call
        # Explicit mock mode only (for local testing)
        if ENV["TRANSLATE_API_MODE"].to_s.downcase == "mock"
            return "[MOCK EN] #{@text}"
        end
        if @api_key.blank?
            Rails.logger.error("APIキーが設定されていません。Rails.credentials または ENV['TRANSLATE_API_KEY'] を設定してください。")
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
