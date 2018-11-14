# Changelog

## v1.5
- Add link to user's mail and phone number, thanks @kissadamfkut
- Add redirect for old style VIR id links
- Add group history
- Change room number to string
- Fix login date update
- Under the hood:
  - Remove ES6 syntax to avoid failing asset building
  - Refactor membership related stuff
  - Fix seeder

## v1.4
- Adjust uploaded picture quality
- Add view settings for list/grid, pagination and show pictures
- Updated styles
- Fix null error in point details
- Add point history calculation
- Under the hood:
  - Refactor semester class

## v1.3.1
- Fix point details sum on judgement page
- Add evaluation messaging for group leader
- Fix missing date of birth field and validation on SVIE application
- Fix evaluation editing
- Add group parent info to group page

## v1.3
- Show evaluations for RVT members includin point request, entry requests, principles and connecting messages
- Add ability to create evaluation judgement
- Add share button for profile page
- Add redirecting to opened url after login
- Add more clear description for group explanation for evaluation
- Add ability to modify evaluation after deny
- Add ability for submitting evaluation and remove auto submission logic
- Fix evaluation's group explanation to justification
- Add validations for point details (between 0 and principle's max)
- Update point request sum (20/30 rule, rounding)

## v1.2.1
- Fix entry request justification editing, add redirect back, when no entry request given
- Fix point table, all group member can get point, not only SVIE members
- Fix entry request's justification, remove them when type is 'KDO' at season change
- Fix principle editing, add description input
- Add principle summary popup to evaluation table

## v1.2
- Add creation for evaluation description
- Add creation for principles
- Add creation for evaluation
- Add creation for justification
- Fix SVIE contraction text
- Fix archived member listing
- Add info for group leaders about archiving
- Remove archived members from authsch
- Add fallback location to redirect back, when no referrer provided
- Fix user point history nil error

## v1.1
- Fix group membership check
- Add separated listing for active groups
- Rename SVIE member types to: 'Rendes tag', 'Külső tag', 'Öreg tag'
- Fix contradiction between SVIE application and primary group select
- Update registration page, add explanation for screen_name
- Fix screen name validation, disallow slashes
- Fix new post type creation, post types belong to groups, won't be globals
- Add group name to user's post editing page
- Add validation for post types, restrict empty name
- Fix broken cropped photo path
