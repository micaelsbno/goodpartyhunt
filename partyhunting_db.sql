CREATE DATABASE partyhunting_db;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  profile_pic VARCHAR(400),
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  radius INTEGER,
  fb_id BIGINT
);

CREATE TABLE user_events (
  id SERIAL4 PRIMARY KEY,
  event_id INTEGER,
  user_id INTEGER,
  rsvp VARCHAR(10)
);

CREATE TABLE places (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(100),
  street VARCHAR(100),
  country VARCHAR(100),
  zip INTEGER,
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  fb_id BIGINT,
  logo VARCHAR(400)
);

CREATE TABLE events (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100),
  image_url VARCHAR(400),
  place_id INTEGER,
  fb_id BIGINT,
  description VARCHAR(5000)
);

CREATE TABLE event_times (
  id SERIAL4 PRIMARY KEY,
  event_id INTEGER,
  start_time TIMESTAMPTZ,
  end_time TIMESTAMPTZ
);

CREATE TABLE categories (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR
);

CREATE TABLE event_categories (
  id SERIAL4 PRIMARY KEY,
  event_id INTEGER,
  user_id INTEGER,
  category_id INTEGER
);

CREATE TABLE event_categories (
  id SERIAL4 PRIMARY KEY,
  event_id INTEGER,
  user_id INTEGER,
  category_id INTEGER
);

CREATE TABLE users_friends (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  friend_id INTEGER
);

CREATE TABLE users_sessions (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER
);
