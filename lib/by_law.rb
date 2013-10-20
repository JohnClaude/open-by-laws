require 'act'

module AkomaNtoso
  # Wraps an AkomaNtoso XML document describing an Act classed as a By-Law
  class ByLaw < Act

    attr_accessor :region, :name

    def extract_id
      # /za/by-law/cape-town/2010/public-parks

      @id_uri = @meta.at_xpath('./a:identification/a:FRBRWork/a:FRBRuri', a: NS)['value']
      empty, @country, type, @region, date, @name = @id_uri.split('/')

      # yyyy[-mm-dd]
      @year = date.split('-', 2)[0]
    end

    # ByLaws don't have numbers, use their short-name instead
    def num
      name
    end

    def short_title
      unless @short_title
        node = @meta.at_xpath('./a:identification/a:FRBRWork/a:FRBRalias', a: NS)
        if node
          @short_title = node['value']
        else
          @short_title = "(Unknown)"
        end
      end

      @short_title
    end

    def url_path
      "/#{@country}/by-law/#{@region}/#{@year}/#{@name}/"
    end

    def url_file
      @name
    end
    
    def nature
      "by-law"
    end
  end
end
