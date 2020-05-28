# frozen_string_literal: true

require 'octokit'
require 'meilisearch'
require 'logger'

logger = Logger.new(STDOUT)

MeiliDocument = Struct.new(
  :content,
  :lvl2,
  :lvl1,
  :lvl0,
  :objectID,
  keyword_init: true
)

documents_to_index = []

logger.info 'Connecting to GitHub'
gh_client = Octokit::Client.new(login: ENV['GH_LOGIN'], password: ENV['GH_TOKEN'])
gh_client.auto_paginate = true

meili_client = MeiliSearch::Client.new(ENV['MEILISEARCH_URL'], ENV['MEILISEARCH_API_KEY'])

logger.info "Getting issues of #{ENV['GH_REPOSITORY']}"
issues = gh_client.issues(ENV['GH_REPOSITORY'])

logger.info 'Transform GitHub issues to documents for MeiliSearch'
issues.each do |issue|
  documents_to_index << MeiliDocument.new(
    lvl0: 'GitHub',
    lvl1: 'Issue',
    lvl2: issue.title,
    content: issue.body,
    objectID: issue.body.hash
  )

  issue_comments = gh_client.issue_comments(ENV['GH_REPOSITORY'], issue.number)
  issue_comments.each do |comment|
    documents_to_index << MeiliDocument.new(
      lvl0: 'GitHub',
      lvl1: 'Issue',
      lvl2: issue.title,
      content: comment.body,
      objectID: comment.body.hash
    )
  end
end

logger.info "Getting pull requests of #{ENV['GH_REPOSITORY']}"
pull_requests = gh_client.pull_requests(ENV['GH_REPOSITORY'])

logger.info 'Transform GitHub pull requests to documents for MeiliSearch'
pull_requests.each do |pr|
  documents_to_index << MeiliDocument.new(
    lvl0: 'GitHub',
    lvl1: 'Pull request',
    lvl2: pr.title,
    content: pr.body,
    objectID: pr.body.hash
  )
end

logger.info 'Exporting documents to MeiliSearch'
meili_index = meili_client.create_index(uid: 'docs')
meili_index.add_documents(documents_to_index.map(&:to_h))

logger.info 'kthxbye'
