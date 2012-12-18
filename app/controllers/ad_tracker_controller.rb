require 'librato/metrics'

class AdTrackerController < ApplicationController
  def start
    puts '$$$ got an ad start'
    ad_counter.increment :fired, params[:provider]
    render nothing: true
  end

  def status
    puts '$$$ got ad status'
    ad_counter.increment :status, "#{params[:provider]}-#{params[:result]}"
    render nothing: true
  end

  def ad_counter
    AddCounter
  end
end

class AddCounter
  Librato::Metrics.authenticate 'brian-com@thevanloos.com', ENV['LIBRATO_KEY']
  # Librato::Metrics.faraday_adapter = :em_http
  puts Librato::Metrics.faraday_adapter.to_yaml

  def self.aggregator
    @@aggregator ||= Librato::Metrics::Aggregator.new source: :test_app1, autosubmit_interval: 30
  end

  def self.increment event, provider
    self.aggregator.add "#{event}-#{provider}" => 1
  end
end
