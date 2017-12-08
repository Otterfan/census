sql = 'UPDATE TEXTS SET seen_in_person=TRUE'
results = ActiveRecord::Base.connection.execute(sql)