require "cgi"
require_relative "../base"

module LinkedData
  module Client
    module Models
      class Class < LinkedData::Client::Base
        require 'cgi'
        HTTP = LinkedData::Client::HTTP
        @media_type = "http://www.w3.org/2002/07/owl#Class"
        @include_attrs = "prefLabel,definition,synonym,obsolete,childrenCount"
        @include_attrs_full = "prefLabel,definition,synonym,obsolete,properties,childrenCount,children"
        @attrs_always_present = :prefLabel, :definition, :synonym, :obsolete, :properties, :childrenCount, :children

        alias :fullId :id

        # triple store predicate is <http://www.w3.org/2002/07/owl#deprecated>
        def obsolete?
          self.obsolete
        end

        def prefLabel(options = {})
          if options['use_html']
            if self.obsolete
              return "<span class='obsolete_class' title='obsolete class'>#{self.prefLabel}</span>"
            else
              return "<span class='prefLabel'>#{self.prefLabel}</span>"
            end
          else
            return self.prefLabel
          end
        end

        # TODO: Implement properly
        def relation_icon; ""; end

        def purl
          return "" if self.links.nil?
          ont = self.explore.ontology
          "#{LinkedData::Client.settings.purl_prefix}/#{ont.acronym}/#{CGI.escape(self.id)}"
        end

        def self.find(id, ontology, params = {})
          ontology = HTTP.get(ontology, params)
          ontology.explore.class(CGI.escape(id))
        end

        def self.search(*args)
          query = args.shift
          params = args.shift || {}
          params[:q] = query
          raise ArgumentError, "You must provide a search query: Class.search(query: 'melanoma')" if query.nil? || !query.is_a?(String)
          HTTP.post("/search", params)
        end

        def expanded?
          !self.children.nil? && self.children.length > 0
        end

      end
    end
  end
end
