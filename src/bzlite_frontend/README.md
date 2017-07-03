# BzLite - a lite frontend for Bugzilla written in Elm

Where BzLite is different then bugzilla

- Instead of a word bug we should use the work issue.

- Instead of being general be very tailored to project.


# Ideas

- every page should redirect to login if not logged in

- login page should redirect to bugzilla where user needs to allow us to do
  requests in their name

- once logged in we redirect to a page we came from

- when logged in there should be a logout link which logs our app our from
  bugzilla

- home page ("/") is a dasboard for a user
    - an advanced search box (github style)
    - searches can be saved and listed somewhere on homepage

- "team" page - a page with team specific view
    - "/team/release-enineering"
    - show activity of a group (some nice graphs)
    - show list of things this team can be contacted about. this is custom "new
      issue" page (eg. "/team/release-engineering/new")

- "project" page - a project specific page
    - "/project/kinto", "/project/firefox"
    - usually projects are organized within teams, but maybe we can go around
      this and have cross team projects
    - has a custom "new issue" page (eg. "/project/kinto/new")

- "new issue" page(s) ("/new")

