module Docurest
  class Login < Docurest::Base
    def self.information(api_password: false, guid: true, settings: :none)
      result = Docurest.client.get '/login_information',
        {api_password: api_password,  include_account_id_guid: guid, login_settings: settings},
        use_base_url: false

      {
        api_password: result['apiPassword'],
        accounts: result['loginAccounts'].map { |login| new login }
      }
    end

    field :id, :accountId
    field :guid, :accountIdGuid
    field :user_id, :userId
    field :name
    field :username, :userName
    field :email
    field :description, :siteDescription
    field :url, :baseUrl
    field :default, :isDefault, :boolean
  end
end
