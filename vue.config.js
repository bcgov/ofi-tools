  // vue.config.js
  let ofiroot = (process.env.VUE_APP_OFI_ROOT) ? process.env.VUE_APP_OFI_ROOT : "https://delivery.apps.gov.bc.ca/pub/dwds-ofi/";
  module.exports = {
    pluginOptions: {
      API_OFI_ROOT: ofiroot,
      CreateOrderFilteredSM: "order/createOrderFilteredSM/",
      CreateOrderFiltered: "secure/order/createOrderFiltered/"
     }
   }
  