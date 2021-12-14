module Polaris
  class AutocompleteComponent < NewComponent
    renders_one :text_field, ->(**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, %w[
        click->polaris-autocomplete#toggle
        click@window->polaris-popover#hide
      ])

      system_arguments[:input_options] ||= {}
      system_arguments[:input_options][:data] ||= {}
      system_arguments[:input_options][:data][:polaris_autocomplete_target] = "input"

      TextFieldComponent.new(**system_arguments)
    end
    renders_many :sections, ->(**system_arguments) do
      Autocomplete::SectionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_many :options, ->(**system_arguments) do
      Autocomplete::OptionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_one :empty_state

    def initialize(multiple: false, url: nil, **system_arguments)
      @multiple = multiple
      @url = url
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        opts[:data][:controller] = "polaris-autocomplete"
        if @url.present?
          opts[:data][:polaris_autocomplete_url_value] = @url
        end
      end
    end

    def popover_arguments
      {
        alignment: :left,
        full_width: true,
        inline: false,
        wrapper_arguments: {
          data: {polaris_autocomplete_target: "popover"}
        }
      }
    end

    def option_list_arguments
      {
        data: {polaris_autocomplete_target: "results"}
      }
    end
  end
end
