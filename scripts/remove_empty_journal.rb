sql = 'UPDATE texts SET journal_id=null WHERE journal_id=84'
results = ActiveRecord::Base.connection.execute(sql)

sql = 'DELETE FROM journals WHERE id=84'
results = ActiveRecord::Base.connection.execute(sql)