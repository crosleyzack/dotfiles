{:user {:plugins
        [[lein-localrepo "0.5.3"]]

        :dependencies
        [[com.cemerick/pomegranate "0.4.0"]]

        :injections
        [(defn add-dependency [dep-vec]
           (require 'cemerick.pomegranate)
           ((resolve 'cemerick.pomegranate/add-dependencies)
            :coordinates [dep-vec]
            :repositories (merge @(resolve 'cemerick.pomegranate.aether/maven-central)
                                 {"clojars" "https://clojars.org/repo"})))]}}
