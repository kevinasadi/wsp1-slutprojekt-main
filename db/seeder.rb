require 'sqlite3'
require_relative '../config'

class Seeder
  def self.seed!
    puts "Using db file: #{DB_PATH}"
    puts "🧹 Dropping old tables..."
    drop_tables
    puts "🧱 Creating tables..."
    create_tables
    puts "🍎 Populating tables..."
    populate_tables
    puts "✅ Done seeding the database!"
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS order_items')
    db.execute('DROP TABLE IF EXISTS orders')
    db.execute('DROP TABLE IF EXISTS cookies')
    db.execute('DROP TABLE IF EXISTS customers')
  end

  def self.create_tables
    db.execute <<-SQL
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    SQL

    db.execute <<-SQL
      CREATE TABLE cookies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flavor TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL,
        price INTEGER NOT NULL
      );
    SQL

    db.execute <<-SQL
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers(id)
      );
    SQL

    db.execute <<-SQL
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        cookie_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (order_id) REFERENCES orders(id),
        FOREIGN KEY (cookie_id) REFERENCES cookies(id)
      );
    SQL
  end

  def self.populate_tables
    db.execute("INSERT INTO cookies (flavor, description, image, price) VALUES ('Choklad', 'chocochip', 'Vår klassiska smak!', 25)")
    db.execute("INSERT INTO cookies (flavor, description, image, price) VALUES ('Pepparkaka', 'gingerbread', 'Julspecial!', 25)")
    db.execute("INSERT INTO cookies (flavor, description, image, price) VALUES ('Salted Caramel', 'saltedcaramel' 'Söt men saltig kaka.', 30)")

  end

  private

  def self.db
    @db ||= begin
      db = SQLite3::Database.new(DB_PATH)
      db.results_as_hash = true
      db
    end
  end

end

Seeder.seed!