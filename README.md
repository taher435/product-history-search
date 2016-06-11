### Product History Search
Upload a product CSV file with product attributes value at different time and use the search tool to see attribute value at given time

#### Set up

##### Prerequisite
1. PostreSql - Make sure you have a running instance of postresql on your machine.

##### Steps

1. Clone this repository 

```
$ git clone https://github.com/taher435/product-history-search.git
```

2. Run bundle install

```
$ bundle install
```

3. Add your PG database configuration to `config/database.yml`

**NOTE:** For simplicity (as this is a test application), I have kept secrets.yml in the respository with keys hard coded. So no need to change that.

4. Start Rails server

```
$ rails s
```

#### Application

1. Upload a valid product CSV file using the uploader. Check out the sample CSV file
2. If valid file uploaded then click on "Add History" to add your csv records to database
3. Once you add data to history, you will see a search control that will allow you to search your product history by giving id, type and a specific time
4. Hit "Go" and you see the results below

#### To Do

1. Write Jasmine tests for JS
2. Add more validation for uploaded file
3. Write Rspec tests for controller action methods
