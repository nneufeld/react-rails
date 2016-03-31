require 'babel/transpiler'
module React
  module JSX
    class BabelTransformer
      DEPRECATED_OPTIONS = [:harmony, :strip_types, :asset_path]
      DEFAULT_TRANSFORM_OPTIONS = { blacklist: ['spec.functionName', 'validation.react', 'strict'] }
      def initialize(options)
        if (options.keys & DEPRECATED_OPTIONS).any?
          ActiveSupport::Deprecation.warn("Setting config.react.jsx_transform_options for :harmony, :strip_types, and :asset_path keys is now deprecated and has no effect with the default Babel Transformer."+
                                              "Please use new Babel Transformer options :whitelist, :plugin instead.")
        end

        debugger
        Babel::Transpiler.script_path

        @relay_transform_code = "transformRelayCode = function(relayCode) { return babel.transform(relayCode, {plugins: [babelRelayPlugin]}); }"

        debugger
        @plugin = File.read(File.expand_path("../../../assets/react-source/development/babel-relay-plugin.js", __FILE__))
        @babelRelayContext = ExecJS.compile(@plugin)
        schema = File.read(File.expand_path("../../../../react-builds/schema.json", __FILE__))
        relayPlugin = @babelRelayContext.call('getBabelRelayPlugin', { data: 1 })
        debugger
        # context.eval(relay_transform_code)
        context.call("transformRelayCode", 'a=1')
        @transform_options = DEFAULT_TRANSFORM_OPTIONS.merge(options).merge(plugins: ["babelRelayPlugin"])
        #debugger
        a=1
      end

      def context
        @context ||= ExecJS.compile("var self = this; " + @plugin)
      end

      def transform(code)
        debugger
        context.eval("babel.transform(#{code}, {plugins: [babelRelayPlugin]})")
      end
    end
  end
end
