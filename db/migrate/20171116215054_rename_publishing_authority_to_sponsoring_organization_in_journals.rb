class RenamePublishingAuthorityToSponsoringOrganizationInJournals < ActiveRecord::Migration[5.1]
  def change
    rename_column :journals, :publishing_authority, :sponsoring_organization
  end
end
