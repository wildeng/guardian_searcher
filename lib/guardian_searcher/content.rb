# frozen_string_literal: true
require 'date'

module GuardianSearcher
  class Content
    attr_reader :article_id, :pillar_id, :pillar_name, :pub_date, :section_id, :section_name,  :title, :web_url
    def initialize(
      article_id: nil,
      pillar_id: nil,
      pillar_name: nil,
      pub_date: nil,
      section_id: nil,
      section_name: nil,
      title: nil,
      web_url: nil
    )
    def self.get_content(results)
      content = []
      results.each do |result|
        content << GuardianSearcher::Content.new(
          article_id: result['id'],
          pillar_id: result['pillarId'],
          pillar_name: result['pillarName'],
          pub_date: DateTime.parse(result['webPublicationDate']),
          section_id: result['sectionId'],
          section_name: result['sectionName'],
          title: result['webTitle'],
          web_url: result['webUrl']
        )
      end
      content
    end
  end
end