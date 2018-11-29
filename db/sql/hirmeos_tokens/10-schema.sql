CREATE TABLE authority(
  authority varchar(255) PRIMARY KEY NOT NULL
);

CREATE TABLE account(
  account_id uuid PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  surname varchar(255) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  password varchar(255) NOT NULL,
  authority varchar(255) NOT NULL REFERENCES authority(authority) ON UPDATE CASCADE
);
