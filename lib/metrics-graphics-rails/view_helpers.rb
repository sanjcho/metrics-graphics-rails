require 'json'

module MetricsGraphicsRails
  module ViewHelpers
    # TODO: generalize for extra options
    def metrics_graphic_for(data, options = {})
      json_data   = data.to_json
      target      = options.fetch(:target)
      x_accessor  = options.fetch(:x_accessor)  { :date }
      y_accessor  = options.fetch(:y_accessor)  { :value }
      title       = options.fetch(:title)
      description = options.fetch(:description) { '' }
      width       = options.fetch(:width)       { 600 }
      height      = options.fetch(:height)      { 250 }
      time_format = options.fetch(:time_format) { '%Y-%m-%d' }
      is_multiple = data.first.is_a?(Array)

      javascript_tag <<-SCRIPT
        var data = #{json_data};

        #{convert_data_js(data, time_format, is_multiple)}

        MG.data_graphic({
          title: "#{title}",
          description: "#{description}",
          data: data,
          width: #{width},
          height: #{height},
          target: '#{target}',
          x_accessor: '#{x_accessor}',
          y_accessor: '#{y_accessor}'
        });
      SCRIPT
    end

    private

    def convert_data_js(data, time_format, is_multiple)
      if is_multiple
        <<-CONVERT
          for (var i = 0; i < data.length; i++) {
            data[i] = MG.convert.date(data[i], 'date', '#{time_format}');
          }
        CONVERT
      else
        "MG.convert.date(data, 'date', '#{time_format}');"
      end
    end
  end
end


