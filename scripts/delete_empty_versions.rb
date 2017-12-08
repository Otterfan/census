sql = 'DELETE FROM versions WHERE versions.whodunnit IS NULL'
results = ActiveRecord::Base.connection.execute(sql)