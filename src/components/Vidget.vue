<template>
  <div id="main" class="body">
    <h1>Packaged Product: {{ state.packName }}</h1>
    <div class="main-background">
      <strong style="font-size: 15px"
        >Email address where order notifications will be sent.
      </strong>
      <div class="spacer" style="margin-left: 0">
        <span
          class="twitter-typeahead"
          style="position: relative; display: inline-block"
        >
          <input
            class="tt-hint tt-back"
            type="text"
            autocomplete="off"
            spellcheck="off"
            disabled=""
          />
          <input
            type="text"
            class="bc-geocoder typeahead tt-query"
            autocomplete="off"
            placeholder="someone@gov.bc.ca"
            x-webkit-speech=""
            spellcheck="false"
            dir="auto"
            style="
              position: relative;
              vertical-align: top;
              background-color: transparent;
            "
            v-model="state.emailAddress"
          />
          <div style="margin-top: 40px">
            <input type="checkbox" v-model="state.condChecked" />
            <strong style="font-size: 15px; margin-left: 10px">
              I agree to the</strong
            >
            <a class="term-cond" @click="clickCond">Terms and Conditions</a>
          </div>
          <div
            v-if="state.showCond"
            class="bc-geocoder typeahead tt-query cond-text"
          >
            <div style="margin-top: 10px">
              By downloading these data products, I agree to the license terms
              and conditions as set out in each BC Data Catalogue metadata
              record.
            </div>
            <div style="margin-top: 10px">Collection Notice</div>
            <div style="margin-top: 10px">
              The personal information you post may be collected by the Ministry
              under s. 26(c) of the Freedom of Information and Protection of
              Privacy Act for the purposes of engaging and consulting with the
              public. Please be aware that any information collected may be
              stored and/or accessed outside of Canada on servers not belonging
              to the government.
            </div>
            <div style="margin-top: 10px; margin-bottom: 10px">
              Should you have any questions about the collection of your email
              address, please contact BCGov Data Distribution (DWDS) CONTACT at
              Data@gov.bc.ca, PO BOX 9864 STN PROV GOVT, Victoria BC V8W 9T5
            </div>
          </div>
          <!-- <div>{{state.emailAddress}}</div> -->
          <div style="margin-top: 40px">
            <a class="myButton" @click="clickSubmit">Submit Order</a>
          </div>
        </span>
      </div>
    </div>
  </div>
</template>


<script>
import axios from "axios";
import config from "../../vue.config";

export default {
  name: "Vidget",
  data: function () {
    var state = {
      packName: "Default Package",
      showCond: false,
      condChecked: true,
      emailAddress: "gary.sun@gov.bc.ca",
    };
    const urlParams = new URLSearchParams(window.location.search);
    var urlPackageName = urlParams.get("PackageName");
    if (urlPackageName != null && urlPackageName != "") {
      state.packName = urlPackageName;
    }

    return { state };
  },
  methods: {
    clickCond: function () {
      this.state.showCond = !this.state.showCond;
    },

    isEmailValid: function () {
      const reg = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
      return this.state.emailAddress == ""
        ? false
        : reg.test(this.state.emailAddress);
    },

    clickSubmit: function () {
      if (!this.state.condChecked) {
        alert("You must agree to the conditions.");
      } else if (!this.isEmailValid()) {
        alert("Email is not valid.");
      } else {
        this.createOrderFilteredSM(this.emailAddress);
      }
    },

    createOrderFilteredSM: function (email) {
      let OFI_Url = config.pluginOptions.API_OFI_ROOT;
      let CreateOrderFilteredSM = config.pluginOptions.CreateOrderFilteredSM;

      return axios
        .post(OFI_Url + CreateOrderFilteredSM, {
          body: email,
        })
        .then((response) =>
          alert(
            "Well done. data:" +
              response.data +
              ", stauts: " +
              response.statusText
          )
        )
        .catch((error) => alert("Oops, " + error));
    },
  },
};
</script>


