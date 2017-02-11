# Require core library
require 'middleman-core'

# Extension namespace
module Middleman
  class PdfMaker < Extension
    # option :my_option, 'default', 'An example option'

    def initialize(app, options_hash={}, &block)
      # Call super to build options from the options_hash
      super

      require 'pdfkit'
      # Require libraries only when activated
      # require 'necessary/library'

      # set up your extension
      # puts options.my_option
    end

    def after_configuration
      # Do something
    end

    def after_build(builder)
      begin
        kit = PDFKit.new(File.new('build/pdf.html'),
                         :page_size => 'A4',
                         :margin_top => 10,
                         :margin_bottom => 10,
                         :margin_left => 10,
                         :margin_right => 10,
                         :disable_smart_shrinking => false,
                         :print_media_type => true,
                         :dpi => 96
        )

        file = kit.to_file('build/api.pdf')

      rescue Exception => e
        puts "Error: #{e.message}"
        # builder.say_status "PDF Maker",  "Error: #{e.message}", Thor::Shell::Color::RED
        raise
      end
      # builder.say_status "PDF Maker",  "PDF file available at build/api.pdf"
    end
    # A Sitemap Manipulator
    # def manipulate_resource_list(resources)
    # end

    # helpers do
    #   def a_helper
    #   end
    # end
  end
end
