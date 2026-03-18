PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS servers;

CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  loyalty_tier TEXT NOT NULL,
  created_date TEXT NOT NULL
);

CREATE TABLE servers (
  server_id INTEGER PRIMARY KEY,
  server_name TEXT NOT NULL,
  role TEXT NOT NULL,
  hire_date TEXT NOT NULL
);

CREATE TABLE menu_items (
  menu_item_id INTEGER PRIMARY KEY,
  item_name TEXT NOT NULL,
  category TEXT NOT NULL,
  base_price REAL NOT NULL,
  is_vegan INTEGER NOT NULL DEFAULT 0,
  is_gluten_free INTEGER NOT NULL DEFAULT 0,
  is_alcohol INTEGER NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  order_timestamp TEXT NOT NULL,
  channel TEXT NOT NULL CHECK (channel IN ('Dine-In','Takeout','Delivery')),
  customer_id INTEGER NULL,
  server_id INTEGER NULL,
  party_size INTEGER NULL,
  table_no INTEGER NULL,
  promo_code TEXT NULL,
  discount_amount REAL NOT NULL DEFAULT 0,
  subtotal REAL NOT NULL,
  tax REAL NOT NULL,
  tip REAL NOT NULL DEFAULT 0,
  delivery_fee REAL NOT NULL DEFAULT 0,
  total REAL NOT NULL,
  payment_method TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (server_id) REFERENCES servers(server_id)
);

CREATE TABLE order_items (
  order_item_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  menu_item_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL,
  line_total REAL NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);

CREATE INDEX idx_orders_timestamp ON orders(order_timestamp);
CREATE INDEX idx_orders_channel ON orders(channel);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_menu ON order_items(menu_item_id);
