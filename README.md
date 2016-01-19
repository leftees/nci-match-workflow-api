# nci-match-workflow-api
This repository contains the Matchbox workflow rest services.

Start with 'bundle exec rackup'

Change request example usage
1. Upload file:
* curl -v -F "data=@/Users/pumphreyjj/git/nci-match-workflow-api/test.txt" http://localhost:9292/changerequest/123
2. File list per patient:
* curl https://localhost:9292/changerequest/123
3. Download file:
* curl https://localhost:9292/changerequest/123/test.txt

[![Code Climate](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/gpa.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api)
[![Issue Count](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/issue_count.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api)
[![Test Coverage](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/coverage.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/coverage)
