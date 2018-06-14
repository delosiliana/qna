class Search
  
  CONTEXTS = %w(Questions Answers Comments Users Anything)

  def self.query(query, context)
    return [] unless CONTEXTS.include?(context)
    escaped_query = Riddle::Query.escape(query)
    if context == 'Anything'
      ThinkingSphinx.search escaped_query
    else
      ThinkingSphinx.search escaped_query, classes: [context.singularize.classify.constantize]
    end
  end
end
