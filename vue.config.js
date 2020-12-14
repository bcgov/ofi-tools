  // vue.config.js
  module.exports = {
      pluginOptions: {
          API_OFI_ROOT: process.env.VUE_APP_OFI_ROOT,
          CreateOrderFilteredSM: "order/createOrderFilteredSM/",
          CreateOrderFiltered: "secure/order/createOrderFiltered/"
      }
  }