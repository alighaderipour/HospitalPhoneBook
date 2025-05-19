create database vueflaskpractice1


use vueflaskpractice1
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),  -- ✅ AUTO INCREMENT
    name NVARCHAR(50) NOT NULL,
    family NVARCHAR(50) NOT NULL
);
