local lapis = require("lapis")
local json_parser = require 'lunajson'
local json_params = require("lapis.application").json_params
local to_json = require("lapis.util").to_json
local app= lapis.Application()

app:get("/", json_params(function(self)
  return "Oppenium shop"
end))

local shop_categories ={}
local shop_products  = {}

shop_categories[1]={["name"]="Laptops"}
shop_categories[2]={["name"]="Smartphones"}
shop_categories[3]={["name"]="Gamming"}
shop_categories[4]={["name"]="Computer components"}
shop_categories[5]={["name"]="TV"}
shop_categories[6]={["name"]="Accessories"}

shop_products[1] = {
  ["name"]="HP Pavilion 15 Ryzen 7-5700/16GB/512/Win11 White",
  ["category"]="Laptops",
  ["price"]=3249,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2021/11/pr_2021_11_12_9_3_24_918_00.jpg",
}

shop_products[2] = {
  ["name"]="Samsung Galaxy S21 G991B 8/128 Dual SIM Grey 5G",
  ["category"]="Smartphones",
  ["price"]=2799,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2021/1/pr_2021_1_13_7_55_1_133_00.jpg",
}

shop_products[3] = {
  ["name"]="Nintendo Switch Joy-Con",
  ["category"]="Gamming",
  ["price"]=1349,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2019/8/pr_2019_8_28_14_59_52_23_01.jpg",
}

shop_products[4] = {
  ["name"]="Samsung Portable SSD T5 1TB USB 3.2 Gen. 2",
  ["category"]="Computer components",
  ["price"]=519,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2021/8/pr_2021_8_27_15_44_3_177_00.jpg",
}

shop_products[5] = {
  ["name"]="TCL 43P615",
  ["category"]="TV",
  ["price"]=1349,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2021/1/pr_2021_1_29_15_20_15_962_00.jpg",
}

shop_products[6] = {
  ["name"]="Logitech M185",
  ["category"]="Accessories",
  ["price"]=55,
  ["images"]="https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2020/4/pr_2020_4_22_8_24_40_110_00.jpg",
}

-- Display all products
app:get("/products/show", json_params(function(self)
  local json_products=json_parser.encode(shop_products)
  return json_products
end))

-- Display all categories
app:get("/categories/show", json_params(function(self)
  local json_categories = json_parser.encode(shop_categories)
  return json_categories
end))

-- Create new product
app:post("/products/create", json_params(function(self)
  shop_products[#shop_products+1]={
    ["name"]=self.params.name,
    ["price"]=self.params.price,
    ["images"]=self.params.images,
    ["category"]=self.params.category
  }
  return json_parser.encode(shop_products[#shop_products]).." added"
end))

-- Create new category
app:post("/categories/create", json_params(function(self)
  shop_categories[#shop_categories+1]={["name"]=self.params.name}
  return json_parser.encode(shop_categories[#shop_categories]).." added"
end))

-- Get single product
app:get("/products/show/:id", json_params(function(self)
  return json_parser.encode(shop_products[tonumber(self.params.id)])
end))

-- Display single category
app:get("/categories/show/:id", json_params(function(self)
  return json_parser.encode(shop_categories[tonumber(self.params.id)])
end))

-- Update single product
app:put("/products/update/:id", json_params(function(self)
  shop_products[tonumber(self.params.id)]={
    ["name"]=self.params.name,
    ["price"]=self.params.price,
    ["images"]=self.params.images,
    ["category"]=self.params.category
  }
  return "product "..self.params.id.." is now "..json_parser.encode(shop_products[tonumber(self.params.id)])
end))

-- Update single category
app:put("/categories/update/:id", json_params(function(self)
  shop_categories[tonumber(self.params.id)]={["name"]=self.params.name}
  return "category "..self.params.id.." is now "..json_parser.encode(shop_categories[tonumber(self.params.id)])
end))

-- Delete single product
app:delete("/products/delete/:id", json_params(function(self)
  table.remove(shop_products, tonumber(self.params.id))
  local json_products=json_parser.encode(shop_products)
  return json_products
end))

-- Delete single category
app:delete("/categories/delete/:id", json_params(function(self)
  table.remove(shop_categories,tonumber(self.params.id))
  local json_categories=json_parser.encode(shop_categories)
  return json_categories
end))

return app