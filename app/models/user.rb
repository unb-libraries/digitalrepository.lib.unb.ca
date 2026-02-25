class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[saml]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def self.from_omniauth(auth)
    uid = auth.extra.raw_info.attributes["eduPersonPrincipalName"][0]
    first_name = auth.extra.raw_info.attributes["givenName"][0]
    last_name = auth.extra.raw_info.attributes["sn"][0]
    display_name = "#{first_name} #{last_name}"
    department = auth.extra.raw_info.attributes["l"][0]
    title = auth.extra.raw_info.attributes["title"][0]
    telephone = auth.extra.raw_info.attributes["telephoneNumber"][0]

    find_or_create_by(provider: auth.provider, uid: uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = first_name
      user.last_name = last_name
      user.display_name = display_name
      user.department = department
      user.title = title
      user.telephone = telephone
    end
  end
end
