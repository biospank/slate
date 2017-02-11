require "middleman-core"

::Middleman::Extensions.register :pdfmaker do
  require "middleman-pdfmaker/extension"
  ::Middleman::PdfMaker
end
