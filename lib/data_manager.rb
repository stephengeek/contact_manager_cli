# this class handles all the database transaction
class DataManager
  require 'rubygems'
  require 'sqlite3'

  def connect_db
    if @db.is_a?(NilClass)
      @db = SQLite3::Database.new('bootcamp_contacts_app.db')
    end
    prepare_contact_table
    prepare_message_table
  end

  def look_up_data(name)
    query = 'SELECT * FROM contacts_data where  contact_name '
    query += "LIKE '%" + name + "%' ORDER BY contact_name "
    returned_data = @db.execute(query)
    returned_data
  end

  def get_user_name_from_id(user_idx)
    # query=q%(SELECT * FROM contacts_data where  message_idx = user_idx )
    query = "SELECT * FROM contacts_data where  contact_idx = #{user_idx.to_i}"
    @db.execute(query)
  end

  def bring_all_contacts
    query = 'SELECT * FROM contacts_data ORDER BY contact_name '
    returned_data = @db.execute(query)
    returned_data
  end

  def bring_all_message
    returned_data = @db.execute('SELECT * FROM contacts_message_data ')
    returned_data
  end

  def delete_contact_from_db(contact_idx)
    query = "DELETE FROM contacts_data WHERE contact_idx = #{contact_idx.to_i}"
    @db.execute(query)
  end

  def self.look_up_user
    if @db.is_a?(NilClass)
      @db = SQLite3::Database.new('bootcamp_contacts_app.db')
    end
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'user_data(user_name TEXT NOT NULL, '
    create_data_table += 'phone_number CHAR(50))'
    @db.execute(create_data_table)
    @db.execute('SELECT * FROM user_data')
  end

  private

  def format_query_hash(data_hash)
    returned_hash = {}
    query_columns = ''
    query_values = ''
    data_hash.each do |key, value|
      query_columns << key + ', '
      query_values << "'" + value.to_s + "',"
    end
    returned_hash['columns'] = query_columns.strip.gsub!(/.{1}$/, '')
    returned_hash['values'] = query_values.gsub!(/.{1}$/, '')
    returned_hash
  end

  def save_into_db(table_name, data_hash)
    query_colums_and_value = format_query_hash(data_hash)
    query = "INSERT INTO #{table_name} (#{query_colums_and_value['columns']}) "
    query += "VALUES(#{query_colums_and_value['values']})"
    @db.execute(query)
  end

  def brings_user_number
    returned_data = @db.execute('SELECT * FROM user_data ')
    returned_data
  end

  def prepare_contact_table
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'contacts_data(contact_idx INTEGER PRIMARY KEY '
    create_data_table += 'AUTOINCREMENT, contact_name TEXT NOT NULL, '
    create_data_table += 'contact_phoneNumber CHAR(50))'
    @db.execute(create_data_table)
  end

  def prepare_user_table
    if @db.is_a?(NilClass)
      @db = SQLite3::Database.new('bootcamp_contacts_app.db')
    end
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'user_data(user_name TEXT NOT NULL, phone_number '
    create_data_table += 'CHAR(50))'
    @db.execute(create_data_table)
  end

  def prepare_message_table
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'contacts_message_data(message_idx INTEGER PRIMARY KEY'
    create_data_table += ' AUTOINCREMENT, contact_idx TEXT NOT NULL, message '
    create_data_table += 'TEXT NOT NULL, time_sent CHAR(50))'
    @db.execute(create_data_table)
  end

  def quote_string(text_value)
    text_value = text_value.to_s.gsub(/\\/, '\&\&').gsub(/'/, "''")
    text_value
  end
end
