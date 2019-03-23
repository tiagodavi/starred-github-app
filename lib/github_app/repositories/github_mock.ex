defmodule GithubApp.Repositories.GithubMock do
  @moduledoc """
  Use this module to connect to a fake github api.
  """
  @behaviour GithubApp.Repositories.GithubBehaviour

  alias GithubApp.Repositories.{Repository, Tag}

  @impl GithubApp.Repositories.GithubBehaviour
  def list_starred(username) do
    if username == "tiagodavi" do
      [
        %Repository{
          clone_url: "https://github.com/tiagodavi/form_de_contato.git",
          description:
            "Formulário de contato padrão para win e linux com validação e envio de anexo",
          id: 54,
          inserted_at: ~N[2019-03-22 19:53:04],
          language: "PHP",
          name: "form_de_contato",
          git_repo_id: 2_620_546,
          updated_at: ~N[2019-03-22 19:53:04],
          tags: [
            %Tag{
              id: 163,
              name: "react",
              repository_id: 54
            }
          ]
        },
        %Repository{
          clone_url: "https://github.com/tiagodavi/assando-sites.com.br.git",
          description: "Versão nova do Assando Sites",
          id: 55,
          inserted_at: ~N[2019-03-22 19:53:04],
          language: "PHP",
          name: "assando-sites.com.br",
          git_repo_id: 2_569_964,
          updated_at: ~N[2019-03-22 19:53:04],
          tags: [
            %Tag{
              id: 163,
              name: "react",
              repository_id: 54
            }
          ]
        },
        %Repository{
          clone_url: "https://github.com/danielvlopes/ruby-unix.git",
          description: "Step by Step guides to install Ruby on Unix SO's",
          id: 56,
          inserted_at: ~N[2019-03-22 19:53:04],
          language: nil,
          name: "ruby-unix",
          git_repo_id: 1_500_772,
          updated_at: ~N[2019-03-22 19:53:04],
          tags: [
            %Tag{
              id: 163,
              name: "react",
              repository_id: 54
            }
          ]
        }
      ]
    else
      []
    end
  end
end
