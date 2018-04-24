require "application_system_test_case"

class MembersTest < ApplicationSystemTestCase
  setup do
    @member = members(:one)
  end

  test "visiting the index" do
    visit members_url
    assert_selector "h1", text: "Members"
  end

  test "creating a Member" do
    visit members_url
    click_on "New Member"

    fill_in "Bio", with: @member.bio
    fill_in "Birthday", with: @member.birthday
    fill_in "Open", with: @member.open_id
    fill_in "Password", with: 'secret'
    fill_in "Password Confirmation", with: 'secret'
    fill_in "Union", with: @member.union_id
    fill_in "Username", with: @member.username
    click_on "Create Member"

    assert_text "Member was successfully created"
    click_on "Back"
  end

  test "updating a Member" do
    visit members_url
    click_on "Edit", match: :first

    fill_in "Bio", with: @member.bio
    fill_in "Birthday", with: @member.birthday
    fill_in "Open", with: @member.open_id
    fill_in "Password", with: 'secret'
    fill_in "Password Confirmation", with: 'secret'
    fill_in "Union", with: @member.union_id
    fill_in "Username", with: @member.username
    click_on "Update Member"

    assert_text "Member was successfully updated"
    click_on "Back"
  end

  test "destroying a Member" do
    visit members_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Member was successfully destroyed"
  end
end
