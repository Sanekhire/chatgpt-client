# frozen_string_literal: true

require_relative "chatgpt/version"
require_relative "chatgpt/api_request"

module Chatgpt
  class Client
    # URL API, используемый для отправки запросов к ChatGPT
    API_URL = "https://api.openai.com/v1/chat/completions"

    class << self
      # Настройки клиента (задаются глобально)
      # model - Определяет используемую модель, например, "gpt-4o-mini".
      # temperature - Контролирует степень случайности ответов модели (диапазон 0.0 - 1.0).
      # system_message - Специальное сообщение, которое задает контекст модели.
      # prompt_prefix - Префикс для запросов, полезен при массовых однотипных запросах.
      # proxy - Прокси-сервер, указывается в формате <protocol>://<login>:<password>@<host>:<port>
      attr_accessor :model, :temperature, :system_message, :prompt_prefix, :proxy
    end

    # Устанавливаем значения по умолчанию для класса
    self.model = "gpt-4o-mini"
    self.temperature = 0.7

    # Конструктор класса
    # @param api_key [String] API-ключ для аутентификации запросов к OpenAI
    def initialize(api_key)
      @chat_api_key = api_key
      @model = self.class.model
      @temperature =  self.class.temperature
      @system_message = self.class.system_message
      @prompt_prefix = self.class.prompt_prefix
    end

    # Отправляет запрос в API ChatGPT
    # @param prompt [String] Текст запроса
    # @param proxy [String, nil] Опционально: прокси-сервер для запроса
    # @return [Hash] Ответ API или ошибка
    def send_request(prompt, proxy = nil)
      request_data = build_request_data(prompt)
      response = ApiRequest.new(
        url: API_URL,
        headers: request_headers,
        data: request_data,
        proxy: proxy || self.class.proxy
      ).post

      parse_response(response)
    rescue StandardError => e
      { "error" => "Ошибка запроса: #{e.message}" }
    end

    # Формирует тело запроса для API
    # @param prompt [String] Входной текст
    # @return [String] JSON-представление данных запроса
    def build_request_data(prompt)
      messages = []
      messages << { role: "user", content: @prompt_prefix.to_s + prompt }
      messages << { role: "system", content: @system_message } if @system_message

      {
        "model" => @model,
        "messages" => messages,
        "temperature" => @temperature
      }.to_json
    end

    # Генерирует заголовки для HTTP-запроса
    # @return [Hash] Заголовки запроса
    def request_headers
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@chat_api_key}"
      }
    end

    # Обрабатывает ответ API
    # @param response [Object] HTTP-ответ от API
    # @return [Hash] Распарсенный JSON-ответ или сообщение об ошибке
    def parse_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      { "error" => "Ошибка парсинга JSON" }
    end
  end
end
