# name: discourse-github-docs
# about: A plugin to embed GitHub documentation in Discourse
# version: 0.1
# authors: Your Name
# url: https://github.com/yourusername/discourse-github-docs

enabled_site_setting :github_docs_enabled

after_initialize do
  Discourse::Application.routes.append do
    get "/github-docs" => "github_docs#show"
  end

  require_dependency "application_controller"
  class ::GithubDocsController < ::ApplicationController
    requires_plugin GithubDocs

    def show
      url = params[:url]
      response = Excon.get(url)
      if response.status == 200
        render plain: response.body
      else
        render plain: "Failed to fetch GitHub file", status: 422
      end
    end
  end
end
