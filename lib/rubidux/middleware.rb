module Rubidux
  class Middleware
    def self.init(&block)
      -> (**middleware_api) {
        -> (_next) {
          -> (action) {
            block.call(_next, action, **middleware_api)
          }
        }
      }
    end

    def self.apply(*middlewares)
      -> (get_state, dispatch) {
        middleware_api = {
          get_state: get_state,
          dispatch: -> (action) { dispatch.(action) }
        }
        chain = middlewares.map { |middleware| middleware.(middleware_api) }
        new_dispatch = Rebidux::Util.compose(*chain).(dispatch)
      }
    end
  end
end
