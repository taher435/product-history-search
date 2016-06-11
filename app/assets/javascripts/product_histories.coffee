ProductHistorApp = angular.module("ProductHistorApp", [])

ProductHistorApp.directive "fileUpload", () ->
  (scope, elem, attrs) ->
    elem.bind "change", (event) ->
      files = event.target.files
      scope.$emit("fileUploaded", {file: event.target.files[0]}) #since we support only single file upload right now

ProductHistoryController = ($scope, $http) ->
  pc = this

  pc.init = () ->
    pc.csvFile = ""
    pc.fileName = ""
    pc.fileHeaders = ""
    pc.acceptedColumns = ["product_id", "product_type", "timestamp", "attribute_changes"]
    pc.totalExpectedColumnCount = pc.acceptedColumns.length
    pc.invalidFile = null
    pc.products = []
    pc.product = null;
    pc.searchFormInvalid = false
    pc.results = null;

  pc.storeHistory = (authToken) ->
    if(!pc.isFormValid())
      pc.invalidFile = true
      return

    fd = new FormData()
    fd.append("authenticity_token", authToken)
    fd.append("csv_file", pc.csvFile)

    $http.post("/product-history", fd, {
      headers: {
        "Content-Type": undefined
      },
      transformRequest: angular.identity
    }).then((response) ->
      console.log("success")
      if(response.data && response.data.length > 0)
        pc.products = []
        pc.product_ids = []
        pc.product_types = []
        for i in [0...response.data.length]
          pc.products.push(response.data[i])

          product_id = response.data[i].product_id
          product_type = response.data[i].product_type

          if pc.product_ids.indexOf(product_id) == -1
            pc.product_ids.push(product_id)

          if pc.product_types.indexOf(product_type) == -1
            pc.product_types.push(product_type)

        return
    ,
      (response) ->
        console.log("error")
        console.log(response)
    )

  pc.searchProduct = () ->
    dateTime = $("#searchDateTime").val()

    if(dateTime == "" || dateTime == undefined)
      pc.searchFormInvalid = true

    timestamp = moment(new Date(dateTime)).unix();
    debugger
    $http.get("/product-history/search?id=" + pc.product.id + "&type=" + pc.product.type + "&timestamp=" + timestamp)
    .then((response) ->
      pc.results = []
      product = response.data

      pc.results.push({
        id: product.product_id,
        type: product.product_type,
        timestamp: product.unix_ts,
        pretty_datetime: moment.unix(product.unix_ts).format("DD MMM, YYYY hh:mm a (Z)"),
        attributes: JSON.stringify(product.attribute_changes)
      })

    ,
      (response) ->
        console.log("failure")
        console.log(response)
    )

  pc.headerCountLimit = (prop, index) ->
    (item, index) ->
      index < pc.totalExpectedColumnCount

  pc.isFormValid = () ->
    valid = $scope.productHistorUploadForm.$valid
    for i in [0...pc.totalExpectedColumnCount]
      valid = valid && pc.fileHeaders[i] == pc.acceptedColumns[i]
      if(!valid)
        break
    valid

  $scope.$on "fileUploaded", (event, args) ->
    $scope.$apply () ->
      reader = new FileReader();
      reader.onload = (event) ->
        $scope.$apply () ->
          try
            fileData = event.target.result
            rows = fileData.split(/\r\n|\n/) ##splitting by carriage return and new line
            pc.fileHeaders = rows[0].split(",") #assuming the file will have headers
            pc.invalidFile = false
          catch
            console.log(error)
            pc.invalidFile = true

      try
        pc.fileName = args.file.name
        pc.csvFile = args.file
      catch
        pc.invalidFile = true

      console.log(pc)

      reader.readAsText(args.file);

    return

  pc.init()

  return


ProductHistorApp.controller('ProductHistoryController', ["$scope", "$http", ProductHistoryController])

(($) ->
  $ ->
    flatpickr('.flatpickr-input', []);
    return
) jQuery