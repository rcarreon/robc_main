Ad Platform sqlcopy templates
=============================

## How to run (for non-DBAs)
`time sudo sqlcopy --nothrottle <sqlcopy-template.ap>`

## Available templates


- dev-to-martini.ap
  - Copy data from the "dev" instance of pubops-martini to production, only as an initial seed
- prd-to-backup.ap
  - Re-seed the production backup box
- prd-to-dev-and-reports.ap
  - Re-seed the dev adops and tags boxes, along with reports-qa
- prd-to-dev.ap
  - Re-seed the dev adops and tags boxes
- prd-to-prd.ap
  - Re-seed sql1v-adops and both tags boxes from sql2v-adops
- prd-to-qa.ap
- prd-to-reports.ap
  - Re-seed reports-qa by itself
- prd-to-stg.ap
  - Re-seed ALL stage boxes
- prd-to-tags.ap
  - Re-seed both tags boxes
- prd-to-uid1.ap
- prd-to-uid2.ap
- prd-to-uid.ap
- stg-to-stg.ap
  - Re-seed stage from sql1v-adops stg
