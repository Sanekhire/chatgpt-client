# frozen_string_literal: true

require "curb"
require "json"

module Chatgpt
  # Класс для выполнения HTTP-запросов к API OpenAI
  class ApiRequest
    attr_reader :url, :headers, :data, :proxy

    # @param url [String] URL, к которому будет выполняться запрос
    # @param data [String] Данные запроса в формате JSON
    # @param headers [Hash] HTTP-заголовки запроса
    # @param proxy [String, nil] Опциональный параметр для прокси-сервера
    def initialize(url:, data:, headers:, proxy: nil)
      @url = url
      @headers = headers
      @data = data
      @proxy = proxy
    end

    # Выполняет POST-запрос к API
    # @return [Curl::Easy, Hash] Ответ сервера или ошибка в виде хэша
    def post
      Curl::Easy.http_post(url, data) do |curl|
        headers.each { |key, value| curl.headers[key] = value }
        configure_proxy(curl, proxy) if proxy
      end
    rescue StandardError => e
      { "error" => "Ошибка запроса: #{e.message}" }
    end

    private

    # Конфигурирует параметры прокси-сервера для запроса
    # @param curl [Curl::Easy] Объект запроса
    # @param proxy [String] URL прокси в формате <protocol>://<login>:<password>@<host>:<port>
    def configure_proxy(curl, proxy)
      proxy_type, rest = proxy.split('://', 2)

      if rest.include?('@')
        user_pass, host = rest.split('@', 2)
        curl.proxypwd = user_pass # Логин и пароль для прокси
      else
        host = rest # Только хост
      end

      curl.proxy_url = "#{proxy_type}://#{host}"

      curl.proxy_type = case proxy_type
                        when "socks5"
                          Curl::CURLPROXY_SOCKS5
                        when "http"
                          Curl::CURLPROXY_HTTP
                        when "https"
                          curl.proxy_tunnel = true # HTTPS-прокси требует туннеля
                          Curl::CURLPROXY_HTTPS
                        else
                          raise "Неизвестный тип прокси: #{proxy_type}"
                        end
    end
  end
end
