require 'rails_helper'

feature 'Admin legislation draft versions' do

  background do
    admin = create(:administrator)
    login_as(admin.user)
  end

  context "Feature flag" do

    scenario 'Disabled with a feature flag' do
      Setting['feature.legislation'] = nil
      process = create(:legislation_process)
      expect{ visit admin_legislation_process_draft_versions_path(process) }.to raise_exception(FeatureFlags::FeatureDisabled)
    end

  end

  context "Index" do

    scenario 'Displaying legislation process draft versions' do
      process = create(:legislation_process, title: 'An example legislation process')
      draft_version = create(:legislation_draft_version, process: process, title: 'Version 1')

      visit admin_legislation_processes_path(filter: 'all')

      click_link 'An example legislation process'
      click_link 'Text'
      click_link 'Version 1'

      expect(page).to have_content(draft_version.title)
      expect(page).to have_content(draft_version.changelog)
    end
  end

  context 'Create' do
    scenario 'Valid legislation draft_version' do
      process = create(:legislation_process, title: 'An example legislation process')

      visit admin_root_path

      within('#side_menu') do
        click_link "Collaborative Legislation"
      end

      click_link "All"

      expect(page).to have_content 'An example legislation process'

      click_link 'An example legislation process'
      click_link 'Text'

      click_link 'Create version'

      fill_in 'legislation_draft_version_title', with: 'Version 3'
      fill_in 'legislation_draft_version_changelog', with: 'Version 3 changes'
      fill_in 'legislation_draft_version_body', with: 'Version 3 body'

      click_button 'Create version'

      expect(page).to have_content 'An example legislation process'
      expect(page).to have_content 'Version 3'
    end
  end
end
