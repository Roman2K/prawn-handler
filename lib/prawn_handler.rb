module ActionView
  module TemplateHandlers
    class Prawn < TemplateHandler
      include Compilable
      
      def compile(template)
        %(extend #{DocumentProxy}; #{template.source}; pdf.render)
      end
      
      module DocumentProxy
        def pdf
          @pdf ||= ::Prawn::Document.new
        end
        
      private
      
        def method_missing(method, *args, &block)
          pdf.respond_to?(method) ? pdf.send(method, *args, &block) : super
        end
      end
    end
  end
end

ActionView::Template.register_template_handler :prawn, ActionView::TemplateHandlers::Prawn
