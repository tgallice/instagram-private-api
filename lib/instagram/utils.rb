require 'erb'

include ERB::Util

module Instagram
  class Utils
    def self.encode(data)
      url_encode(data)
    end

    def self.hash_encode(hash)
      hash.reduce([]) do |acc, (k, v)|
        acc << "#{self.encode(k)}=#{self.encode(v)}"
      end.join('&')
    end
  end
end
